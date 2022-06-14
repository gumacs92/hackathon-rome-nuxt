<template>
  <div
    class="h-20"
    :class="{ '!h-12': !hasErrors && !small, 'h-8': !hasErrors && small, 'h-16': hasErrors && small}"
  >
    <label
      v-if="placeholder"
      class="absolute -translate-y-5  translate-all duration-200 text-xs pointer-events-none"
      :class="[{
        'translate-y-3 text-base ': !inputValue && !isFocus
      }, labelClass]"
      :for="id"
    >{{ placeholder }}</label>
    <input
      :id="id"
      v-model="inputValue"
      :type="type"
      :disabled="disabled ? true : false"
      class="w-full text-sm outline-none focus:outline-none bg-glass-100  border rounded-xl "
      :class="inputClass"
      @input="onInput()"
      @focus="onFocus($event)"
      @blur="onBlur($event)"
    >
    <div
      v-if="hasErrors"
      :class="{ '!h-[32px]': validationErrors }"
      class="font-df-text text-sm text-[#ff0000] transition-all h-[0px] pl-8 duration-1000"
    >
      {{ validationErrors ? validationErrors[0] : "" }}
    </div>
  </div>
</template>

<script>
export default {
  props: {
    // eslint-disable-next-line
    value: {
      required: true,
      validation: (prop) => {
        return (
          prop instanceof String || prop instanceof Number || prop === null
        )
      }
    },
    placeholder: {
      type: String,
      default: ''
    },
    type: {
      type: String,
      default: ''
    },
    id: {
      type: [String, Number],
      default: null
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
    },
    afterText: {
      type: String,
      default: ''
    },
    hasErrors: {
      type: Boolean,
      default: true
    },
    small: {
      type: Boolean,
      default: false
    },
    inputClass: {
      type: String,
      default: 'p-3 pl-8 text-primary border-gray-800 focus:border-primary'
    },
    labelClass: {
      type: String,
      default: 'px-5 pl-8 text-primary'
    }
  },
  data () {
    return {
      isFocus: false,
      inputValue: ''
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
      this.$emit('input', this.inputValue)
    },
    onFocus (event) {
      this.isFocus = true
      this.$emit('focus', event)
    },
    onBlur (event) {
      this.isFocus = false
      this.$emit('blur', event)
    }
  }
}
</script>
