<template>
  <div class="px-4 lg:px-28 bg-base bg-cover bg-fixed min-h-screen py-32">
    <div v-if="isApplying" class="w-full pb-28 ">
      <h2>Apply for governor</h2>
      <div class="bg-black shadow-box rounded-lg p-9 mt-10">
        <div class="flex flex-col lg:flex-row pt-16 gap-x-4">
          <MyInput v-model="form.name" placeholder="Name" class="w-full lg:w-1/3 mx-auto" has-errors :validation-errors="errors['name']" />
          <MyInput v-model="form.description" placeholder="Description" class="w-full lg:w-2/3  mx-auto" has-errors :validation-errors="errors['description']" />
        </div>
        <div class="flex flex-col lg:flex-row gap-4">
          <button class="btn-primary" @click="isApplying =false">
            Send
          </button>
          <button class="text-white" @click="isApplying =false">
            Cancel
          </button>
        </div>
      </div>
    </div>
    <div class="w-full flex flex-row justify-between">
      <h2>Vote for governors</h2>

      <button v-if="!isApplying" class="btn-primary" @click="isApplying =true">
        Apply for governor
      </button>
    </div>
    <div class="grid grid-cols-1 text-sm font-bold gap-y-28  lg:grid-cols-3  lg:gap-x-16 lg:gap-y-28  lg:w-fit lg:mx-auto my-24">
      <div v-for="(governer,index) in governors" :key="index" class="text-center bg-black shadow-box rounded-lg p-9 cursor-pointer ">
        <img class="w-[135px] block mx-auto -mt-24" :src="governer.icon" :title="governer.name"><br>
        <h3 class="font-primary-light text-primary text-3xl">
          {{ governer.name }}
        </h3>
        <p class="text-white text-lg py-5">
          {{ governer.description }}
        </p>
        <div class="flex justify-between">
          <img class="h-8" src="/img/like.svg" alt="">
          <img class="h-8" src="/img/like-white.svg" alt="">
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
      governors: [
        {
          name: 'John Doe',
          description: 'The Governor is managed by a global community of ROME token holders and delegates.',
          icon: '/img/ch-1.svg'
        },
        {
          name: 'John Doe2',
          description: 'The Governor is managed by a global community of ROME token holders and delegates.',
          icon: '/img/ch-2.svg'
        },
        {
          name: 'John Doe3',
          description: 'The Governor is managed by a global community of ROME token holders and delegates.',
          icon: '/img/ch-3.svg'
        },
        {
          name: 'John Doe4',
          description: 'The Governor is managed by a global community of ROME token holders and delegates.',
          icon: '/img/ch-4.svg'
        },
        {
          name: 'John Doe5',
          description: 'The Governor is managed by a global community of ROME token holders and delegates.',
          icon: '/img/ch-5.svg'
        },
        {
          name: 'John Doe6',
          description: 'The Governor is managed by a global community of ROME token holders and delegates.',
          icon: '/img/ch-6.svg'
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
