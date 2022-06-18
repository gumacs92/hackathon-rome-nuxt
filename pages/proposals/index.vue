<template>
  <OverlayLoader :loading="loading">
    <div class="px-4 lg:px-28 bg-base bg-cover bg-fixed min-h-screen py-32">
      <div v-if="isOffering" class="w-full pb-28 ">
        <h2>Create a new proposal</h2>
        <div class="bg-black shadow-box rounded-lg p-9 mt-10 lg:w-1/2 mx-auto">
          <div class="flex flex-col pt-16 gap-x-4">
            <MySelect
              v-model="form.eventId"
              :items="availableEvents"
              placeholder="Event to support"
              class="w-full lg:w-2/3 mx-auto"
              has-errors
              :validation-errors="errors['title']"
            />
            <MyInput v-model="form.title" placeholder="Name" class="w-full lg:w-2/3 mx-auto" has-errors :validation-errors="errors['title']" />
            <MyInput v-model="form.description" placeholder="Description" class="w-full lg:w-2/3  mx-auto" has-errors :validation-errors="errors['description']" />
            <!-- <MyInput v-model="form.targetAddress" placeholder="Address" class="w-full lg:w-2/3  mx-auto" has-errors :validation-errors="errors['address']" /> -->
            <MyInput
              v-model="form.donationInEth"
              placeholder="Donation in ETH"
              type="number"
              class="w-full lg:w-2/3  mx-auto"
              has-errors
              :validation-errors="errors['donation']"
            />
          </div>
          <div class="flex flex-col lg:flex-row gap-4 justify-center">
            <button class="btn-primary" @click="createProposal()">
              Send
            </button>
            <button class="text-white" @click="isOffering =false">
              Cancel
            </button>
          </div>
        </div>
      </div>
      <div class="w-full flex flex-row justify-between">
        <h2>
          Current governors
        </h2>
      </div>
      <div v-if="governors.length" class="grid grid-cols-1 text-sm font-bold gap-y-28  lg:grid-cols-3  lg:gap-x-16 lg:gap-y-28  lg:w-fit lg:mx-auto my-24">
        <div v-for="(governer,index) in governors" :key="index" class="text-center bg-black shadow-box rounded-lg p-9">
          <img class="w-[135px] block mx-auto -mt-24" :src="governer.icon" :title="governer.name"><br>
          <h3 class="font-primary-light text-primary text-3xl">
            {{ governer.id > 0 || (governer.name && governer.description) ? governer.name : 'None' }}
          </h3>
          <p class="text-white text-lg py-5">
            {{ governer.id > 0 || (governer.name && governer.description) ? governer.description : 'Not elected' }}
          </p>
        </div>
      </div>
      <div v-else class="text-sm font-bold gap-y-28  text-center lg:mx-auto my-24">
        <h3 class="font-primary-light text-primary text-3xl">
          No governor has been elected yet
        </h3>
      </div>
      <div class="w-full flex flex-row justify-between">
        <h2>Proposals</h2>
        <button v-if="isGovernor() && !isOffering" class="btn-primary " @click="isOffering =true">
          Create proposal
        </button>
      </div>
      <div v-if="proposals.length" class="w-full mt-10 grid grid-cols-1 gap-y-12 text-sm font-bold  lg:grid-cols-3  lg:gap-x-16 lg:gap-y-28  lg:w-fit lg:mx-auto my-24">
        <div v-for="(proposal,index) in proposals" :key="index">
          <div class="w-full  p-12 bg-glassy backdrop-blur-md rounded-2xl my-auto">
            <div class="text-center bg-black shadow-box rounded-xl h-16 w-16 p-4 mb-3">
              <img :src="getImage(getProposalCategoryId(proposal), 'icon')" class="rounded-xl  ">
            </div>
            <h3 class="text-primary text-4xl">
              {{ proposal.title }}
            </h3>
            <p class="text-lg mt-5 text-white ">
              {{ proposal.description }}
            </p>
            <p class="text-lg mt-2 mb-5 text-white ">
              {{ proposal.targetAddress.slice(0, 4) + '...' + proposal.targetAddress.slice(-4) }}
            </p>
            <div class="flex flex-row justify-between">
              <div class="my-auto">
                <button class="btn-primary">
                  Vote
                </button>
              </div>

              <div class="flex">
                <p class="text-sm text-primary my-auto pr-4">
                  Donation: <span class="text-white"> {{ proposal.donationInEth }} ETH </span>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div v-else class="text-sm font-bold gap-y-28  text-center lg:mx-auto my-24">
        <h3 class="font-primary-light text-primary text-3xl">
          No proposal has been listed yet
        </h3>
      </div>
    </div>
  </OverlayLoader>
</template>
<script>
import Moralis from 'moralis'
import MyInput from '~/components/form/input.vue'
import MySelect from '~/components/form/Select.vue'
import { normalize } from '~/utilities/methods'
import GovernorElection from '~/build/contracts/GovernorElection'
import ProposalElection from '~/build/contracts/ProposalElection'
import StoreComputed from '~/mixins/storeComputed'

import EXPLORE_PUBLICATIONS from '~/graphql/publication/explore-publications.js'

export default {
  components: { MyInput, MySelect },
  mixins: [StoreComputed],

  data () {
    return {
      loading: false,
      isOffering: false,
      form: {
        eventId: '',
        title: '',
        description: '',
        governorId: 0,
        targetAddress: '',
        donationInEth: 0,
        donation: 0
      },
      validationRules: {
        title: 'required',
        description: 'required'
      },
      validationAttributeNames: {
        title: 'név',
        description: 'leirás'
      },
      validation: null,
      errors: {},
      isSuccessful: false,
      categories: [
        { name: 'Solar panel', icon: '/img/icons/solar-panel.svg', img: '/img/solar.jpg', id: '0' },
        { name: 'Recycle', icon: '/img/icons/recycle.svg', img: '/img/recycle.jpg', id: '1' },
        { name: 'Plugin', icon: '/img/icons/plugin.svg', img: '/img/car.jpg', id: '2' },
        { name: 'Tools', icon: '/img/icons/tools.svg', img: '/img/tools.jpg', id: '3' },
        { name: 'Renovation', icon: '/img/icons/artist.svg', img: '/img/renovation.jpg', id: '4' }
      ],
      events: [],
      governors: [],
      proposals: []
    }
  },
  computed: {
    availableEvents () {
      return this.events.map((e) => {
        return {
          key: e.id,
          value: e.id,
          text: `[${this.getCategoryNameById(e.metadata.content.categoryId)}] ${e.metadata.content.title}`
        }
      })
    }
  },
  beforeMount () {
    this.loadGovernors()
    this.explorePublications()
    this.loadProposals()
  },
  methods: {
    getProposalCategoryId (proposal) {
      const event = this.events.find(e => e.id === proposal.eventId)
      if (!event) {
        return '0'
      }
      return event.metadata.content.categoryId
    },
    getCategoryNameById (id) {
      return this.categories.find(c => c.id === id).name
    },
    getSelectedEvent (id) {
      return this.events.find(e => e.id === id)
    },
    async explorePublications () {
      this.loading = true
      const explorePublicationsResponse = await this.$apollo.query({
        query: EXPLORE_PUBLICATIONS,
        variables: {
          request: {
            sortCriteria: 'LATEST',
            publicationTypes: ['POST'],
            limit: 10,
            sources: ['RomeLens']
          }
        }
      })
      console.log('Explore Publications Response:', explorePublicationsResponse)
      // filter out only usable events
      this.events = explorePublicationsResponse.data.explorePublications.items.filter((i) => {
        return i && i.metadata && i.metadata.content instanceof Object
      })
      console.log('Filtered Publications:', this.events)
      this.loading = false
    },
    async loadProposals () {
      this.loading = true

      this.proposals = normalize(await Moralis.executeFunction({
        abi: ProposalElection.abi,
        contractAddress: ProposalElection.networks[this.$config.networkId].address,
        functionName: 'getProposals'
      }))

      console.log('Loaded proposals:', this.proposals)
      this.proposals.forEach((g) => {
        g.donationInEth = (g.donation / Math.pow(10, 18)).toFixed(2)
      })

      console.log('Loaded proposals:', this.proposals)

      this.loading = false
    },
    async loadGovernors () {
      this.loading = true

      this.governors = normalize(await Moralis.executeFunction({
        abi: GovernorElection.abi,
        contractAddress: GovernorElection.networks[this.$config.networkId].address,
        functionName: 'getLastElectionWinners'
      }))

      this.governors.forEach((g) => {
        g.icon = `/img/ch-${Math.round(Math.random() * 5) + 1}.svg`
      })

      console.log('Loaded governors:', this.governors)

      this.loading = false
    },
    isGovernor () {
      return !!this.governors.find(g => g.owner.toUpperCase() === this.address.toUpperCase())
    },
    async createProposal () {
      this.loading = true

      try {
        const governor = this.governors.find(g => g.owner.toUpperCase() === this.address.toUpperCase())

        if (!governor) {
          this.$rxt.notify({
            type: 'Error',
            message: 'You are not a governor, you cannot create proposal'
          })
          return
        }

        const ethers = Moralis.web3Library
        const params = {
          eventId: this.form.eventId,
          title: this.form.title,
          description: this.form.description,
          governorId: governor.id,
          targetAddress: this.getSelectedEvent(this.form.eventId).profile.ownedBy,
          donation: Moralis.Units.ETH(this.form.donationInEth)
        }
        console.log(params)

        const tx = await Moralis.executeFunction({
          abi: ProposalElection.abi,
          contractAddress: ProposalElection.networks[this.$config.networkId].address,
          functionName: 'createProposal',
          params
        })

        await tx.wait()
        await this.loadProposals()
        this.isOffering = false
      } catch (e) {
        console.error(e)
      }

      this.loading = false
    },
    getImage (categoryId, type) {
      let tmp = ''
      for (let i = 0; i < this.categories.length; i++) {
        if (this.categories[i].id === categoryId) {
          if (type === 'icon') {
            tmp = this.categories[i].icon
          } else if (type === 'img') {
            tmp = this.categories[i].img
          } else {
            tmp = ''
          }
        }
      }
      return tmp
    }
  }

}
</script>
