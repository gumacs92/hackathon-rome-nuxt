<template>
  <div class="px-4 lg:px-28 bg-base bg-cover bg-fixed min-h-screen py-32">
    <div v-if="addEvent" class="w-full pb-28 ">
      <h2>Add event </h2>
      <div class="bg-black shadow-box rounded-lg p-9 mt-10 lg:w-1/2 mx-auto">
        <div class="flex flex-col pt-16 gap-x-4">
          <MyInput v-model="form.title" placeholder="Name" class="w-full lg:w-2/3 mx-auto" has-errors :validation-errors="errors['title']" />
          <MyInput v-model="form.description" placeholder="Description" class="w-full lg:w-2/3  mx-auto" has-errors :validation-errors="errors['description']" />
          <p class="text-primary w-full lg:w-2/3  mx-auto">
            Choose category
          </p>
          <div class="grid grid-cols-2 gap-4 text-sm font-bold  lg:grid-cols-5  lg:w-fit lg:mx-auto my-4">
            <div v-for="(category,index) in categories" :key="index" class="text-center transition-all bg-black shadow-box rounded-lg p-4 cursor-pointer" :class="{'!bg-primary !shadow-active':form.categoryId === category.id}" @click="form.categoryId = category.id">
              <img class="w-[25px] block mx-auto" :src="form.categoryId === category.id ? category.active : category.icon" :title="category.name"><br>
              <p class="text-primary" :class="{'!text-black':form.categoryId === category.id}">
                {{ category.name }}
              </p>
            </div>
          </div>
        </div>
        <div class="flex flex-col lg:flex-row gap-4 justify-center">
          <button class="btn-primary" @click="addEvent =false">
            Send
          </button>
          <button class="text-white" @click="addEvent =false">
            Cancel
          </button>
        </div>
      </div>
    </div>
    <div class="w-full flex flex-row justify-between">
      <h2>Events</h2>
      <button class="btn-primary" @click="addEvent = true">
        Add
      </button>
    </div>
    <div class="grid grid-cols-2 gap-4 text-sm font-bold  lg:grid-cols-5  lg:gap-16  lg:w-fit lg:mx-auto my-16">
      <div v-for="(category,index) in categories" :key="index" class="text-center bg-black shadow-box rounded-lg p-9 cursor-pointer" :class="{'!bg-primary !shadow-active':selectedCategoryId === category.id}" @click="selectedCategoryId = category.id">
        <img class="w-[50px] block mx-auto" :src="selectedCategoryId === category.id ? category.active : category.icon" :title="category.name"><br>
        <p class="text-primary" :class="{'!text-black':selectedCategoryId === category.id}">
          {{ category.name }}
        </p>
      </div>
    </div>
    <div class="w-full mt-10">
      <div v-for="(event,index) in events" :key="index" class="rounded-xl flex flex-col lg:flex-row 2xl:px-24 my-10">
        <div class="w-full lg:w-2/3 lg:ml-16">
          <img :src="getImage(event.category, 'img')" class="rounded-2xl h-60 lg:h-full " style="width:fit-content;" alt="">
        </div>
        <div class="w-full lg:w-1/3 lg:-ml-36 p-12 bg-glassy backdrop-blur-md rounded-2xl my-auto">
          <div class="text-center bg-black shadow-box rounded-xl h-16 w-16 p-4 mb-3">
            <img :src="getImage(event.category, 'icon')" class="rounded-xl  ">
          </div>
          <h3 class="text-primary text-4xl">
            {{ event.title }}
          </h3>
          <p class="text-lg my-5 text-white ">
            {{ event.description }}
          </p>
          <div class="flex flex-row justify-between">
            <div class="my-auto">
              <button class="btn-primary">
                Join
              </button>
            </div>

            <div class="flex">
              <p class="text-sm text-primary my-auto pr-4">
                powered by
              </p>
              <img :src="'/img/'+event.powered+'.png'" alt="">
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
      addEvent: false,
      form: {
        title: '',
        description: '',
        categoryId: ''
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
        { name: 'Solar panel', icon: '/img/icons/solar-panel.svg', active: '/img/icons/solar-panel.png', img: '/img/solar.jpg', id: '0' },
        { name: 'Recycle', icon: '/img/icons/recycle.svg', active: '/img/icons/recycle.png', img: '/img/recycle.jpg', id: '1' },
        { name: 'Plugin', icon: '/img/icons/plugin.svg', active: '/img/icons/plugin.png', img: '/img/car.jpg', id: '2' },
        { name: 'Tools', icon: '/img/icons/tools.svg', active: '/img/icons/tools.png', img: '/img/tools.jpg', id: '3' },
        { name: 'Renovation', icon: '/img/icons/artist.svg', active: '/img/icons/artist.png', img: '/img/renovation.jpg', id: '4' }
      ],
      selectedCategoryId: '',
      events: [
        {
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
  methods: {
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
