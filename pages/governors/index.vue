<template>
  <OverlayLoader :key="election.electionEndsAt" :loading="loading">
    <div class="px-4 lg:px-28 bg-base bg-cover bg-fixed min-h-screen py-32">
      <div v-if="isApplying" class="w-full pb-28 ">
        <h2>Apply for governor</h2>
        <div class="bg-black shadow-box rounded-lg p-9 mt-10">
          <div class="flex flex-col lg:flex-row pt-16 gap-x-4">
            <MyInput v-model="form.name" placeholder="Name" class="w-full lg:w-1/3 mx-auto" has-errors :validation-errors="errors['name']" />
            <MyInput v-model="form.description" placeholder="Description" class="w-full lg:w-2/3  mx-auto" has-errors :validation-errors="errors['description']" />
          </div>
          <div class="flex flex-col lg:flex-row gap-4">
            <button class="btn-primary" @click="isApplying =false; sendApplication()">
              Send
            </button>
            <button class="text-white" @click="isApplying =false">
              Cancel
            </button>
          </div>
        </div>
      </div>
      <div class="w-full flex flex-row justify-between">
        <h2 @click="forceEnableElection()">
          Vote for governors
        </h2>

        <h2>
          {{
            ((timestamp() > election.electionStartsAt) && (election.electionEndsAt > timestamp())) ?
              `Election in progress, ends at: ${timestampToDate(election.electionEndsAt)}` :
              `Election starts at: ${timestampToDate(election.electionStartsAt)}`
          }}
        </h2>

        <button v-if="!isApplying" class="btn-primary" @click="isApplying =true">
          Apply for governor
        </button>
      </div>
      <div v-if="election.candidates.length" class="grid grid-cols-1 text-sm font-bold gap-y-28  lg:grid-cols-3  lg:gap-x-16 lg:gap-y-28  lg:w-fit lg:mx-auto my-24">
        <div v-for="(governer,index) in election.candidates" :key="index" class="text-center bg-black shadow-box rounded-lg p-9">
          <img class="w-[135px] block mx-auto -mt-24" :src="governer.icon" :title="governer.name"><br>
          <h3 class="font-primary-light text-primary text-3xl">
            {{ governer.name }}
          </h3>
          <p class="text-white text-lg py-5">
            {{ governer.description }}
          </p>
          <div v-if="!hasVoted()" class="flex justify-between cursor-pointer text-center" @click="vote(governer.id)">
            <img class="h-8" src="/img/like.svg" alt="">
            <h3 class="font-primary-light text-primary text-3xl">
              Vote for governor
            </h3>
            <!-- <img class="h-8 cursor-pointer" src="/img/like-white.svg" alt="" @click="vote(governer.id, false)"> -->
          </div>
          <div v-else class="text-center">
            <h3 class="font-primary-light text-primary text-3xl">
              Already voted
            </h3>
            <!-- <img class="h-8 cursor-pointer" src="/img/like-white.svg" alt="" @click="vote(governer.id, false)"> -->
          </div>
        </div>
      </div>
      <div v-else class="text-sm font-bold gap-y-28  text-center lg:mx-auto my-24">
        <h3 class="font-primary-light text-primary text-3xl">
          No governor applicants in this election yet
        </h3>
      </div>
    </div>
  </OverlayLoader>
</template>
<script>
import Moralis from 'moralis'
import { DateTime } from 'luxon'
import OverlayLoader from '~/components/OverlayLoader.vue'
import MyInput from '~/components/form/input.vue'
import GovernorElection from '~/build/contracts/GovernorElection.json'
import { normalize } from '~/utilities/methods'
import StoreComputed from '~/mixins/storeComputed'
export default {
  components: { MyInput, OverlayLoader },
  mixins: [StoreComputed],
  data () {
    return {
      isApplying: false,
      form: {
        name: '',
        description: ''
      },
      validationRules: {
        name: 'required',
        description: 'required'
      },
      validationAttributeNames: {
        name: 'név',
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
      election: {
        candidates: []
      }
    }
  },
  beforeMount () {
    this.loadData()
  },
  methods: {
    timestamp () {
      return DateTime.now().toSeconds()
    },
    timestampToDate (ts) {
      return DateTime.fromSeconds(parseInt(ts)).toLocaleString(DateTime.DATETIME_SHORT)
    },
    hasVoted () {
      return this.election.alreadyVoted.map(v => v.toUpperCase()).includes(this.address.toUpperCase())
    },
    async loadData () {
      this.loading = true
      const options = {
        functionName: 'getCurrentElection',
        abi: GovernorElection.abi,
        contractAddress: GovernorElection.networks[this.$config.networkId].address
      }
      try {
        this.election = normalize(await Moralis.executeFunction(options))
        console.log(this.election)
        this.election.candidates.forEach((g) => {
          g.icon = `/img/ch-${Math.round(Math.random() * 5) + 1}.svg`
        })
        this.loading = false
      } catch (e) {
        this.loading = false
        throw e
      }
    },
    async sendApplication () {
      if (!this.user) {
        this.$rxt.toast('Unsuccessful!', 'Please login before aplying for governor')
        return
      }
      this.loading = true

      // TODO repalce forceApplyAsCandidate with simple
      const transaction = await Moralis.executeFunction({
        abi: GovernorElection.abi,
        contractAddress: GovernorElection.networks[this.$config.networkId].address,
        functionName: 'forceApplyAsCandidate',
        params: this.form
      })

      await transaction.wait()

      await this.loadData()

      this.loading = false
    },
    async vote (voteForId) {
      if (!this.user) {
        this.$rxt.toast('Unsuccessful!', 'Please login before voting')
        return
      }
      this.loading = true

      // TODO repalce force vote with simple vote
      const transaction = await Moralis.executeFunction({
        abi: GovernorElection.abi,
        contractAddress: GovernorElection.networks[this.$config.networkId].address,
        functionName: 'forceVote',
        params: {
          voteForId
        }
      })

      await transaction.wait()

      await this.loadData()

      this.loading = false
    },
    async forceEnableElection () {
      this.loading = true

      // TODO remove this altogether
      const tx = await Moralis.executeFunction({
        abi: GovernorElection.abi,
        contractAddress: GovernorElection.networks[this.$config.networkId].address,
        functionName: 'endCurrentElectionAndStartANewOne'
      })

      await tx.wait()

      await this.loadData()
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
