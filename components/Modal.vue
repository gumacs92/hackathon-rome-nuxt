<template>
  <div v-if="show" class="fixed top-0 left-0 z-50 w-screen h-screen bg-glass-100">
    <div class="top-1/2 left-1/2 max-w-3xl w-auto bg-black shadow-box rounded-lg p-9 relative -translate-x-1/2 -translate-y-1/2">
      <slot />
    </div>
  </div>
</template>
<script>
export default {
  props: {
    show: {
      type: Boolean,
      required: true
    }
  }
}
</script>
