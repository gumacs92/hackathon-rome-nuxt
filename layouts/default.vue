<template>
  <section>
    <OverlayLoader :loading="loading">
      <div class="bg-primary text-black cursor-pointer fixed z-30 bottom-4 rounded-md translate-x-1/2 block py-2 px-4 w-1/2 opacity-80 transition-opacity">
        <div v-if="!address" @click="connectWallet()">
          Connect with Metamask and Authenticate Lens
        </div>
        <!-- TODO show only first and last 4 characters= 0x04...abcd-->
        <div v-else class="" @click="logOut()">
          Connected as: {{ address }}
        </div>
      </div>
      <div class="cursor-pointer" />
      <!-- The actual page will be inserted here -->
      <div>
        <Navbar />
        <Nuxt />
      </div>

      <Modal :show="showConnectWalletModal">
        <h2 class="wTitle text-deco-900 mb-10">
          Choose your wallet or create a new wallet
        </h2>
        <div class="grid grid-cols-3 text-center xl:px-10">
          <div class="wButton cursor-pointer">
            <img src="/img/metamask.png" class="p-5 w-32 h-32 mx-auto" @click="connectWallet()">
            Metamask
          </div>
        <!-- <div class="wButton">
          <img src="../static/img/wallet_connect.png" class="p-5 w-32 h-32 mx-auto" @click="connectWithConnectWallet()">
          Wallet Connect
        </div>
        <div class="wButton">
          <img src="../static/img/coinbase.png" class="p-5 w-32 h-32 mx-auto" @click="connectWithCoinbaseWallet()">
          Coinbase Wallet
        </div> -->
        </div>
        <div class="text-center mt-10">
          <button class="myVaultBT py-3 px-5 text-2xl font-exo" @click="showConnectWalletModal = false">
            Cancel
          </button>
        </div>
      </Modal>
    </OverlayLoader>
  </section>
</template>
<script>
import Moralis from 'moralis'
import Cookies from 'js-cookie'

import Modal from '~/components/Modal.vue'
import Navbar from '~/components/navbar.vue'
import OverlayLoader from '~/components/OverlayLoader.vue'
import StoreComputed from '~/mixins/storeComputed'

import Signer from '~/utilities/Signer'

import CHALLENGE from '~/graphql/authentication/challenge'
import AUTHENTICATE from '~/graphql/authentication/authenticate'
import REFRESH from '~/graphql/authentication/refresh'

import GET_PROFILES from '~/graphql/profile/get-profiles.js'

export default {
  components: {
    Modal,
    Navbar,
    OverlayLoader
  },
  mixins: [StoreComputed],
  data () {
    return {
      loading: false,

      showConnectWalletModal: false
    }
  },
  beforeMount () {
    this.checkLoginStatus()
  },
  methods: {
    async loadUserProfile () {
      const response = await this.$apollo.query({
        query: GET_PROFILES,
        variables: {
          request: {
            ownedBy: [this.address],
            limit: 50
          }
        }
      })
      console.log('defaultProfile: ', response)
      this.$store.commit('setUserProfile', response.data.profiles.items.length ? response.data.profiles.items[0] : null)
    },
    async checkLoginStatus () {
      this.loading = true
      const user = Moralis.User.current()
      // if we have a user
      if (user) {
        try {
          console.log('have user')
          // set user
          this.$store.commit('setUser', user)
          console.log('stored user')

          // then get cookies
          const refreshToken = Cookies.get('refreshToken')
          console.log('refresh token', refreshToken)

          if (refreshToken) {
            // try to refresh the Lens access token
            const result = await this.$apollo.mutate({
              mutation: REFRESH,
              variables: { request: { refreshToken } }
            })
            console.log('apollo refresh token result', result)

            // finally set tokens in the store
            const { accessToken, refreshToken: newRefresh } = result.data.refresh
            this.$store.commit('setAuthTokens', { accessToken, refreshToken: newRefresh })
          }

          this.$rxt.toast('Success', 'Welcome back')

          this.loadUserProfile()
        } catch (e) {
          console.log(e)
          // if for anything we run into error, then logout the user and tell him to connect again
          await this.logOut()
          this.$rxt.toast('Error', 'Please connect your wallet again')
        }
      }
      this.loading = false
    },
    async connectWallet () {
      this.loading = true
      if (!this.user) {
        try {
          // connect with metamask
          const user = await Moralis.authenticate({
            signingMessage: 'Log in using Moralis'
          })
          if (user) {
            console.log(user)
            // if we have a user, then try to authenticate lens too, then if connection is succesful then store data
            this.$store.commit('setUser', user)
            const { accessToken, refreshToken } = await this.authenticateLens()
            console.log('access token', accessToken)
            this.$store.commit('setAuthTokens', { accessToken, refreshToken })
            this.$rxt.toast('Success', 'Succesful login')

            this.loadUserProfile()
          } else {
            // if we dont have a user then tell him to accept the connection befor continueing
            this.$rxt.toast('Error', 'To continue please accept the connection')
          }
          this.loading = false
        } catch (e) {
          // if for anything we run into error, then logout the user and tell him to connect again
          await this.logOut()
          this.$rxt.toast('Error', 'Please try again, you have to connect your wallet, and authenticate Lens')
          this.loading = false
          console.error(e)
        }
      }
    },
    async authenticateLens () {
      console.log(this.address)
      const challengeResponse = await this.$apollo.query({
        query: CHALLENGE,
        variables: {
          request: {
            address: this.address
          }
        }
      })
      console.log(challengeResponse)

      const signature = await Signer.instance().sign(challengeResponse.data.challenge.text)

      console.log(signature)
      const authenticateResponse = await this.$apollo.mutate({
        mutation: AUTHENTICATE,
        variables: {
          request: {
            address: this.address,
            signature
          }
        }
      })
      // console.log('Lens authenticate data: ', authenticateResponse)
      console.log('res:', authenticateResponse)
      return authenticateResponse.data.authenticate
    },
    async logOut () {
      if (this.user) {
        await Moralis.User.logOut()
        this.$store.commit('setUser', null)
        this.$store.commit('setAuthTokens', null)
      }
    }
  }
}
</script>
