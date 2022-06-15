<template>
  <div class="">
    <nav class="fixed  lg:py-4 lg:px-28  w-screen  flex flex-col xl:flex-row xl:justify-between z-50">
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
        </ul>
      </div>
    </nav>
  </div>
</template>
<script>

export default {
  data () {
    return {
      menuOpened: false,
      menuItems: [
        { name: 'home', url: '/' },
        { name: 'events', url: '/events' },
        { name: 'governors', url: '/governors' },
        { name: 'proposals', url: '/proposals' },
        { name: 'login', url: '/' }
      ]
    }
  },
  beforeMount () {
    if (process.browser) {
      window.addEventListener('click', this.close)
    }
  },
  beforeDestroy () {
    if (process.browser) {
      window.removeEventListener('click', this.close)
    }
  },
  methods: {
    close (e) {
      // if (!this.$el.contains(e.target) || e.target.tagName !== 'A') {
      //   this.menuOpen = false
      // } else
      if (this.$el.contains(e.target) && (e.target.tagName === 'A' || e.target.tagName === 'IMG')) {
        this.menuOpened = false
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
