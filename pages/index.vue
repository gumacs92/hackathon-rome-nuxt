
<template>
  <div class=" bg-index bg-fixed bg-cover bg-no-repeat ">
    <div class="bg-black transition-all duration-1000 bg-opacity-0 px-4 lg:px-28 " :class="{' bg-opacity-80':isScrolled}">
      <section id="hero">
        <div class="relative w-full  bg-bottom flex flex-col xl:flex-row h-screen">
          <div class="relative place-self-center pt-64 md:pt-36  xl:pt-0 mx-auto text-center lg:text-left   text-white w-full">
            <h1 class="text-primary text-5xl">
              Governed by the community
            </h1>
            <p class=" text-base my-11">
              The Governor is managed by the  <br> community of people who would like to do something for our planet.
            </p>
            <button class="btn-primary" @click="$router.push('/events')">
              Join us
            </button>
          </div>
        </div>
      </section>
      <section id="project" class="pb-32">
        <h1 class="text-primary text-3xl">
          About the project
        </h1>
        <div class="w-full mt-10 grid grid-cols-1 gap-y-12 text-sm font-bold  lg:grid-cols-3  lg:gap-x-16 lg:gap-y-28  lg:w-fit lg:mx-auto ">
          <div v-for="(item,index) in project" :key="index">
            <div class="w-full  p-12 bg-glassy backdrop-blur-md rounded-2xl my-auto">
              <div class="text-center bg-black shadow-box rounded-xl h-16 w-16 p-4 mb-3">
                <img :src="item.icon" class="rounded-xl  ">
              </div>
              <h3 class="text-primary text-2xl">
                {{ item.title }}
              </h3>
              <p class="text-base mt-5 text-white ">
                {{ item.description }}
              </p>
            </div>
          </div>
        </div>
      </section>
      <section id="technologies" class="pb-32">
        <h1 class="text-primary text-3xl">
          We use this technologies
        </h1>
        <div class="grid grid-cols-2 text-sm font-bold gap-x-8 gap-y-28 place-content-center  content-center lg:grid-cols-6  lg:gap-x-16 lg:gap-y-28  lg:w-fit lg:mx-auto my-24">
          <div>
            <img src="/img/logo/lens.png" alt="">
          </div>

          <div class="my-auto  mx-auto">
            <img src="/img/logo/covalent.png" alt="">
          </div>
          <div class="my-auto mx-auto">
            <img class="h-20" src="/img/logo/ipfs.png" alt="">
          </div>
          <div class="my-auto  mx-auto">
            <img class="h-12" src="/img/logo/solidity-white.svg" alt="">
          </div>
          <div class="my-auto  mx-auto">
            <img src="/img/logo/moralis.png" alt="">
          </div>
          <div class="my-auto mx-auto">
            <img src="/img/logo/nuxt.svg" alt="">
          </div>
        </div>
      </section>
      <section id="aboutus" class="pb-32">
        <h1 class="text-primary text-3xl">
          We are
        </h1>
        <div class="grid grid-cols-1 text-sm font-bold gap-y-36  lg:grid-cols-3  lg:gap-x-16 lg:gap-y-28  lg:w-fit lg:mx-auto my-24">
          <div v-for="(person,index) in team" :key="index" class="text-center bg-black shadow-box rounded-lg p-9">
            <img class="w-[135px] block mx-auto -mt-24" :src="person.icon" :title="person.name"><br>
            <h3 class="font-primary-light text-primary text-3xl">
              {{ person.name }}
            </h3>
            <p class="text-white text-lg py-5">
              {{ person.description }}
            </p>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>
<script>
export default {
  data () {
    return {
      project: [
        {
          title: 'Create events',
          icon: '/img/icons/create.svg',
          description: 'As registered user create or join local or global events for bettering tommorow. Hold events which catches the eyes of the elected governors.'
        },
        {
          title: 'Govern the system',
          icon: '/img/icons/vote.svg',
          description: 'Apply for government or just delegate your ideas with your vote to the party who wants the same. Elections are programmed into the smart contract, it cannot be rigged.'
        },
        {
          title: 'Proposals and donation',
          icon: '/img/icons/donation.svg',
          description: 'Donate and let the elected government decide who should be eligible for the common\'s vault. Everyone can be a decisionmaker just apply for governor, or vote for one, to make your dream come true.'
        }
      ],
      team: [
        {
          name: 'Gumacs92',
          icon: '/img/ch-2.svg',
          description: 'Full-stack'
        },
        {
          name: 'Riki',
          icon: '/img/ch-1.svg',
          description: 'Solidity / Lens'
        },
        {
          name: 'Tbr',
          icon: '/img/ch-3.svg',
          description: 'UX/UI, Frontend'
        }
      ],
      isScrolled: false
    }
  },
  beforeMount () {
    window.addEventListener('scroll', this.handleScroll)
  },
  beforeDestroy () {
    window.removeEventListener('scroll', this.handleScroll)
  },
  methods: {
    handleScroll () {
      if (window.scrollY > 300) {
        this.isScrolled = true
      } else {
        this.isScrolled = false
      }
    }
  }
}
</script>
