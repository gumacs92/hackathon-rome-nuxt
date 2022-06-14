<template>
  <div
    class="group flex flex-row place-items-center h-12"
    @click="onInput()"
  >
    <div
      :id="id"
      :class="{ 'ring-primary bg-white':isBlue, 'ring-white bg-secondary': !isBlue, '!bg-white': !isBlue && inputValue }"
      class="h-[24]px p-3 w-[24px] ring-1 group-hover:ring-gray rounded-2xl  transition-all flex place-items-center cursor-pointer"
    >
      <img
        v-if="inputValue"
        src="/img/icons/akwit-check-blue.svg"
        class="h-4 w-4 -ml-2 absolute"
      >
    </div>
    <div class="ml-3 my-auto">
      <label
        :for="id"
        class="cursor-pointer"
        :class="{'text-primary':isBlue, 'text-white':!isBlue}"
      ><slot /></label>
      <div
        :class="{ '!h-[32px]': validationErrors.length }"
        class="font-df-text text-sm text-[#ff0000] transition-all h-[0px] duration-1000"
      >
        {{ validationErrors ? validationErrors[0] : "" }}
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    value: {
    // eslint-disable-next-line
      validation: prop => {
        return prop instanceof Boolean || prop === undefined
      },
      required: true
    },
    label: {
      type: String,
      default: ''
    },
    isBlue: {
      type: Boolean,
      default: true
    },
    id: {
      type: String,
      default: ''
    },
    validationErrors: {
      type: Array,
      default: () => {
        return []
      }
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
      isFocus: false,
      data: false,
      inputValue: false
    }
  },
  watch: {
    value (newValue) {
      this.inputValue = newValue
      // this.$emit("input", this.inputValue);
    }
  },
  beforeMount () {
    this.inputValue = this.value
  },
  methods: {
    onInput () {
      if (!this.disabled) {
        this.inputValue = !this.inputValue
        this.$emit('input', this.inputValue)
      }
    }
  }
}
</script>
