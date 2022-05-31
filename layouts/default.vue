<template>
  <section>
    <div class="cursor-pointer">
      <div v-if="!address" @click="showConnectWalletModal = true">
        Connect to with Metamask
      </div>
      <!-- TODO show only first and last 4 characters= 0x04...abcd-->
      <div v-else class="" @click="logOut()">
        {{ address }}
      </div>
    </div>
    <!-- The actual page will be inserted here -->
    <div class="2xl:mx-40 qhd:mx-96 mt-10">
      <Nuxt />
    </div>

    <Modal :show="showConnectWalletModal">
      <h2 class="wTitle text-deco-900 mb-10">
        Choose your wallet or create a new wallet
      </h2>
      <div class="grid grid-cols-3 text-center xl:px-10">
        <div class="wButton cursor-pointer">
          <img src="/img/metamask.png" class="p-5 w-32 h-32 mx-auto" @click="connectWithMoralis()">
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
  </section>
</template>
<script>
import Moralis from 'moralis'
import Modal from '~/components/Modal.vue'

export default {
  components: {
    Modal
  },
  data () {
    return {
      showConnectWalletModal: false,
      user: null // Amelyik változóra this-el hivatkozunk az mind itt található a data-ban

      // coinbaseWallet: null,
      // walletConnector: null,
    }
  },
  computed: {
    address () {
      return this.$store.state.connectedAddress
    }
  },
  beforeMount () {
    this.initMoralisUser()
  },
  methods: {
    initMoralisUser () {
      this.user = Moralis.User.current()
      if (this.user) { this.$store.commit('setConnectedAddress', this.user.get('ethAddress')) }
    },
    async connectWithMoralis () {
      if (!this.user) {
        try {
          this.user = await Moralis.authenticate({
            signingMessage: 'Log in using Moralis'
          })
          if (this.user) { this.$store.commit('setConnectedAddress', this.user.get('ethAddress')) }
        } catch (e) {
          console.log(e)
        }
      }
      this.showConnectWalletModal = false
    },
    async logOut () {
      await Moralis.User.logOut()
      this.user = null
      this.$store.commit('setConnectedAddress', null)
    }
  }
}
</script>
