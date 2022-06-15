<template>
  <div class="px-4 lg:px-28 bg-base bg-cover bg-fixed min-h-screen py-32">
    <div v-if="isOffering" class="w-full pb-28 ">
      <h2>Apply for governor</h2>
      <div class="bg-black shadow-box rounded-lg p-9 mt-10 lg:w-1/2 mx-auto">
        <div class="flex flex-col pt-16 gap-x-4">
          <MyInput v-model="form.title" placeholder="Name" class="w-full lg:w-2/3 mx-auto" has-errors :validation-errors="errors['title']" />
          <MyInput v-model="form.description" placeholder="Description" class="w-full lg:w-2/3  mx-auto" has-errors :validation-errors="errors['description']" />
          <MyInput v-model="form.address" placeholder="Address" class="w-full lg:w-2/3  mx-auto" has-errors :validation-errors="errors['address']" />
          <MyInput v-model="form.donation" placeholder="Donation" class="w-full lg:w-2/3  mx-auto" has-errors :validation-errors="errors['donation']" />
        </div>
        <div class="flex flex-col lg:flex-row gap-4 justify-center">
          <button class="btn-primary" @click="isOffering =false">
            Send
          </button>
          <button class="text-white" @click="isOffering =false">
            Cancel
          </button>
        </div>
      </div>
    </div>
    <div class="w-full flex flex-row justify-between">
      <h2>Proposals</h2>
      <button v-if="!isOffering" class="btn-primary " @click="isOffering =true">
        Create suggestion
      </button>
    </div>
    <div class="w-full mt-10 grid grid-cols-1 gap-y-12 text-sm font-bold  lg:grid-cols-3  lg:gap-x-16 lg:gap-y-28  lg:w-fit lg:mx-auto my-24">
      <div v-for="(offer,index) in proposals" :key="index">
        <div class="w-full  p-12 bg-glassy backdrop-blur-md rounded-2xl my-auto">
          <div class="text-center bg-black shadow-box rounded-xl h-16 w-16 p-4 mb-3">
            <img :src="getImage(offer.category, 'icon')" class="rounded-xl  ">
          </div>
          <h3 class="text-primary text-4xl">
            {{ offer.title }}
          </h3>
          <p class="text-lg mt-5 text-white ">
            {{ offer.description }}
          </p>
          <p class="text-lg mt-2 mb-5 text-white ">
            {{ offer.address }}
          </p>
          <div class="flex flex-row justify-between">
            <div class="my-auto">
              <button class="btn-primary">
                Vote
              </button>
            </div>

            <div class="flex">
              <p class="text-sm text-primary my-auto pr-4">
                Donation: <span class="text-white"> {{ offer.donation }}  </span>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import MyInput from '~/components/form/input.vue'

export default {
  components: { MyInput },

  data () {
    return {
      isOffering: false,
      form: {
        title: '',
        description: '',
        address: '',
        donation: '',
        category: ''
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
      proposals: [
        {
          title: 'Electric car sharing',
          category: '2',
          description: 'The Governor is managed by a global community of ROME token holders and delegates.',
          powered: 'John',
          address: 'address lorem ipsum',
          donation: '2 eth'
        },
        {
          title: 'Recycle',
          category: '1',
          description: 'The Governor is managed by a global community of ROME token holders and delegates.',
          powered: 'John',
          address: 'address lorem ipsum',
          donation: '6 eth'
        },
        {
          title: 'Solar panel',
          category: '0',
          description: 'The Governor is managed by a global community of ROME token holders and delegates.',
          powered: 'John',
          address: 'address lorem ipsum',
          donation: '4 bnb'
        }
      ]
    }
  },
  methods: {
    getImage (categoryId, type) {
      let tmp = ''
      for (let i = 0; i < this.categories.length; i++) {
        console.log('beleptem')
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
