<template>
  <OverlayLoader :loading="loading">
    <nav class="fixed  lg:py-4 lg:px-28  w-screen  flex flex-col xl:flex-row xl:justify-between z-50" :class="{'bg-black':isScrolled}">
      <div class="mx-4 py-2 w-full xl:w-1/6 self-center flex flex-row xl:block content-around lg:py-0  lg:mx-0">
        <nuxt-link to="/">
          <img src="/img/logo.png" class="h-[45px] my-auto  w-auto xl:mx-auto object-center object-contain py-2 px-4 lg:h-[75px] lg:px-0">
        </nuxt-link>
        <div class="xl:hidden flex flex-1  justify-end w-1/8 text-white px-4">
          <div class="relative top-3 w-[40px] text-center group" @click="menuOpened = !menuOpened">
            <span class="absolute block h-[3px] w-[40px] bg-primary  transition-all transform duration-700" :class="{ '!top-3 rotate-45': menuOpened}" />
            <span class="absolute top-2 block h-[3px] w-[40px] bg-primary  transition-all transform duration-700 opacity-100 left-0" :class="{ '!-left-full !opacity-0': menuOpened}" />
            <span class="absolute top-4 block h-[3px] w-[40px] bg-primary  transition-all transform duration-700" :class="{ '!top-3 -rotate-45': menuOpened}" />
          </div>
        </div>
      </div>
      <div class="mx-4 flex items-center xl:block w-full bg-navbar-gradient bg-cover lg:mx-0 lg:bg-none  xl:w-5/6 xl:text-right  self-center text-4xl md:text-4xl xl:text-lg tracking-tight xl:h-auto h-0 transition-all duration-700 max-h-[max-content]" :class="{ '!h-screen': menuOpened}">
        <ul class="mx-auto flex flex-col xl:flex-row gap-x-6 justify-end xl:opacity-100 opacity-0 pointer-events-none xl:pointer-events-auto transition-all duration-700" :class="{ '!opacity-100 pointer-events-auto': menuOpened}">
          <li
            v-for="(item, index) in menuItems"
            :key="index"
            class="min-w-[70px] text-center mt-[8px] md:mt-[16px] text-4xl lg:text-base hover:text-primary"
            :class="{
              'text-primary': $route.path === item.url, 'text-white': $route.path !== item.url
            }"
          >
            <nuxt-link :to="item.url" class="group" @click="menuOpened = !menuOpened">
              {{ item.name }}
            </nuxt-link>
          </li>
          <li v-if="user" class="min-w-[70px] text-center mt-[8px] md:mt-[16px] text-4xl lg:text-base hover:text-primary">
            <button v-if="!accessToken" class="btn-primary" @click="authenticateLens()">
              Authenticate Lens
            </button>
            <button v-else-if="!profile" class="btn-primary" @click="showLensModal = true">
              Create profile
            </button>
            <button v-else class="btn-primary pointer-events-none">
              Welcome: {{ profile.handle }}
            </button>
          </li>
          <li class="min-w-[70px] text-center mt-[8px] md:mt-[16px] text-4xl lg:text-base hover:text-primary">
            <button v-if="!accessToken" class="btn-primary" @click="showDonateModal">
              Donate
            </button>
          </li>
        </ul>
      </div>
    </nav>

    <Modal :show="showDonateModal">
      <h2>Thank you for considering donation</h2>
      <MyInput
        v-model="form.donation"
        placeholder="Name"
        type="number"
        class="w-full lg:w-2/3 mx-auto mt-10 "
        has-errors
        :validation-errors="errors['handle']"
      />
      <div class="text-center mt-10 flex flex-row gap-3 mx-auto w-auto">
        <button class="btn-primary" @click="donateToVault()">
          Donate profile
        </button>
        <button class="btn-primary" @click="showDonateModal = false">
          Cancel
        </button>
      </div>
    </Modal>

    <Modal :show="showLensModal">
      <h2>Create RomeLens profile </h2>
      <MyInput v-model="form.handle" placeholder="Name" class="w-full lg:w-2/3 mx-auto mt-10 " has-errors :validation-errors="errors['handle']" />
      <div class="text-center mt-10 flex flex-row gap-3 mx-auto w-auto">
        <button class="btn-primary" @click="createLensProfile()">
          Create profile
        </button>
        <button class="btn-primary" @click="showLensModal = false">
          Cancel
        </button>
      </div>
    </Modal>
  </OverlayLoader>
</template>
<script>
import Moralis from 'moralis'

import StoreComputed from '~/mixins/storeComputed'
import MyInput from '~/components/form/Input'
import OverlayLoader from '~/components/OverlayLoader'

import ProposalElection from '~/build/contracts/ProposalElection.json'

import Signer from '~/utilities/Signer'

import CHALLENGE from '~/graphql/authentication/challenge'
import AUTHENTICATE from '~/graphql/authentication/authenticate'

import CREATE_PROFILE from '~/graphql/profile/create-profile.js'
import GET_PROFILES from '~/graphql/profile/get-profiles.js'

export default {
  components: {
    MyInput,
    OverlayLoader
  },
  mixins: [StoreComputed],
  data () {
    return {
      loading: false,
      showLensModal: false,
      showDonateModal: false,
      menuOpened: false,
      isScrolled: false,
      form: {
        handle: '',
        donation: ''
      },
      errors: {
        handle: [],
        donation: []
      },
      menuItems: [
        { name: 'home', url: '/' },
        { name: 'events', url: '/events' },
        { name: 'governors', url: '/governors' },
        { name: 'proposals', url: '/proposals' }
      ]
    }
  },

  beforeMount () {
    if (process.browser) {
      window.addEventListener('click', this.close)
      window.addEventListener('scroll', this.handleScroll)
    }
  },
  beforeDestroy () {
    if (process.browser) {
      window.removeEventListener('click', this.close)
      window.removeEventListener('scroll', this.handleScroll)
    }
  },
  methods: {
    async donateToVault () {
      this.loading = true
      if (!this.user) {
        this.loading = false
        this.$rxt.toast('Error', 'Please connect your wallet before donating')
      }

      const tx = await Moralis.executeFunction({
        contractAddress: ProposalElection.networks[this.$config.networkId].address,
        abi: ProposalElection.abi,
        functionName: 'donate',
        msgValue: Moralis.Units.ETH(this.form.donation)
      })

      await tx.wait()

      this.$rxt.toast('Success', 'Than you for your generous donation')
      this.showDonateModal = false
      this.loading = false
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
    async createLensProfile () {
      if (!this.user) {
        this.$rxt.toast('Error', 'Please connect your wallet before connecting to Lens.')
      }
      const eth = Moralis.web3Library
      const defaultProvider = await eth.getDefaultProvider({
        name: 'matic-mumbai',
        chainId: 80001,
        _defaultProvider: providers => new providers.JsonRpcProvider('https://matic-mumbai.chainstacklabs.com')
      }, {
        alchemy: this.$config.alchemyApiKey
      })

      this.loading = true

      // create lens profile
      try {
        const createProfileResponse = await this.$apollo.mutate({
          mutation: CREATE_PROFILE,
          variables: {
            request: {
              handle: this.form.handle
            }
          }
        })
        console.log('createProfileResponse', createProfileResponse)

        const response = await defaultProvider._waitForTransaction(createProfileResponse.data.createProfile.txHash)
        console.log('waitForTransaction', response)
      } catch (e) {
        console.error(e)
        this.$rxt.toast('Error', 'Profile name already exists, or too short.')
        this.loading = false
        return
      }

      // get lens profiles
      const getProfilesResponse = await this.$apollo.query({
        query: GET_PROFILES,
        variables: {
          request: {
            ownedBy: [this.address],
            limit: 50
          }
        }
      })
      this.$store.commit('setUserProfile', getProfilesResponse.data.profiles.items[0])
      // TODO default profile part
      // console.log('getProfilesResponse', getProfilesResponse)
      // // filter out the profile we just created
      // const theProfile = getProfilesResponse.data.profiles.items.find(i => i.handle.search(this.form.handle) !== -1)
      // console.log('theProfile', theProfile)

      // // set the profile we just created as the default profile
      // const setDefaultProfileResponse = await this.$apollo.mutate({
      //   mutation: CREATE_SET_DEFAULT_PROFILE_TYPED_DATA,
      //   variables: {
      //     request: {
      //       profileId: theProfile.id
      //     }
      //   }
      // })
      // console.log('setDefaultProfileResponse', setDefaultProfileResponse)

      // const typedData = setDefaultProfileResponse.data.createSetDefaultProfileTypedData.typedData

      // const signature = await Signer.instance().signedTypeData(typedData.domain, typedData.types, typedData.value)
      // const { v, r, s } = Signer.instance().splitSignature(signature)

      // const tx = await LensHubFactory(this.$config).setDefaultProfileWithSig({
      //   profileId: typedData.value.profileId,
      //   wallet: typedData.value.wallet,
      //   sig: {
      //     v,
      //     r,
      //     s,
      //     deadline: typedData.value.deadline
      //   }
      // })
      // await defaultProvider._waitForTransaction(tx)

      this.$rxt.toast('Success', 'Succesfuly created Lens profile')

      this.loading = false
      this.showLensModal = false
    },
    close (e) {
      // if (!this.$el.contains(e.target) || e.target.tagName !== 'A') {
      //   this.menuOpen = false
      // } else
      if (this.$el.contains(e.target) && (e.target.tagName === 'A' || e.target.tagName === 'IMG')) {
        this.menuOpened = false
      }
    },
    handleScroll () {
      if (window.scrollY > 200) {
        this.isScrolled = true
      } else {
        this.isScrolled = false
      }
    }
  }
}
</script>
<style scoped>
  .nuxt-link-exact-active{
        font-weight: 700;
        color:#0EFB0E;
    }
</style>
