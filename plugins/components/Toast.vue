<template>
  <div
    class="fixed w-60 z-50 rounded-3xl shadow-md"
    :style="'top: ' + (120 + offset) + 'px; right: 10px;'"
  >
    <div class="flex flex-col">
      <h2 class="p-3 bg-primary text-lg text-black" style="border-top-left-radius: 0.5rem; border-top-right-radius: 0.5rem">
        {{ title }}
      </h2>
      <p class="p-3  bg-glassy text-primary text-sm" style="border-bottom-left-radius: 0.5rem; border-bottom-right-radius: 0.5rem">
        {{ message }}
      </p>
    </div>
  </div>
</template>
<script>
export default {
  name: 'ComponentToast',
  props: {
    title: {
      required: true,
      type: String
    },
    message: {
      required: true,
      type: String
    },
    offset: {
      type: Number
    }
  }
}
</script>
