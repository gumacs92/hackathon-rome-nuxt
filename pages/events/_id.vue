<template>
  <div class="px-4 lg:px-28 bg-base bg-cover bg-fixed min-h-screen py-32">
    <div class="w-full flex flex-row justify-between">
      <h2> {{ selectedObject.title }}</h2>
      <button class="btn-primary ">
        Join
      </button>
    </div>
    <div class="w-full mt-10">
      <img :src="getImage(selectedObject.category, 'img')" class="rounded-2xl h-60 lg:h-full " style="width:fit-content;" alt="">
    </div>
    <div class="w-full  lg:-mt-36 p-12 bg-glassy backdrop-blur-md rounded-2xl my-auto z-50 relative">
      <div class="text-center bg-black shadow-box rounded-xl h-16 w-16 p-4 mb-3">
        <img :src="getImage(selectedObject.category, 'icon')" class="rounded-xl  ">
      </div>
      <p class="text-lg my-5 text-white ">
        {{ selectedObject.description }}
      </p>
    </div>
    <div class="w-full">
      <h2> Comments</h2>
    </div>
    <div class="w-full">
      <h2> Members</h2>
      <div class="grid grid-cols-1 text-sm font-bold  lg:grid-cols-2  lg:gap-10  lg:w-fit lg:mx-auto mt-10">
        <div v-for="(member,index) in selectedObject.members" :key="index" class="flex flex-row bg-black shadow-box justify-between rounded-xl p-4">
          <h3 class="text-white">
            {{ member.name }}
          </h3>
          <img src="/img/check.svg" class="h-8" alt="">
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  data () {
    return {
      categories: [
        { name: 'Solar panel', icon: '/img/icons/solar-panel.svg', img: '/img/solar.jpg', id: '0' },
        { name: 'Recycle', icon: '/img/icons/recycle.svg', img: '/img/recycle.jpg', id: '1' },
        { name: 'Plugin', icon: '/img/icons/plugin.svg', img: '/img/car.jpg', id: '2' },
        { name: 'Tools', icon: '/img/icons/tools.svg', img: '/img/tools.jpg', id: '3' },
        { name: 'Renovation', icon: '/img/icons/artist.svg', img: '/img/renovation.jpg', id: '4' }
      ],
      events: [
        {
          id: '1',
          title: 'Electric car sharing',
          category: '2',
          description: 'The Governor is managed by a global community of ROME token holders and delegates.',
          powered: 'John',
          members: [
            {
              id: 1,
              name: 'Red Apple'
            },
            {
              id: 2,
              name: 'Greem Apple'
            },
            {
              id: 3,
              name: 'Yellow Apple'
            },
            {
              id: 4,
              name: 'Pink Apple'
            }, {
              id: 5,
              name: 'Black Apple'
            }
          ]
        },
        {
          id: '2',
          title: 'Recycle',
          category: '1',
          description: 'The Governor is managed by a global community of ROME token holders and delegates.',
          powered: 'John',
          members: [
            {
              id: 1,
              name: 'Red Apple'
            },
            {
              id: 2,
              name: 'Greem Apple'
            },
            {
              id: 3,
              name: 'Yellow Apple'
            },
            {
              id: 4,
              name: 'Pink Apple'
            }, {
              id: 5,
              name: 'Black Apple'
            }
          ]
        },
        {
          id: '3',
          title: 'Solar panel',
          category: '0',
          description: 'The Governor is managed by a global community of ROME token holders and delegates.',
          powered: 'John',
          members: [
            {
              id: 1,
              name: 'Red Apple'
            },
            {
              id: 2,
              name: 'Greem Apple'
            },
            {
              id: 3,
              name: 'Yellow Apple'
            },
            {
              id: 4,
              name: 'Pink Apple'
            }, {
              id: 5,
              name: 'Black Apple'
            }
          ]
        }
      ]
    }
  },
  computed: {
    selectedObject () {
      let tmp = -1
      for (let i = 0; i < this.events.length; i++) {
        if (this.events[i].id === this.$route.params.id) {
          tmp = i
        }
        console.log(i)
      }
      return this.events[tmp]
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
