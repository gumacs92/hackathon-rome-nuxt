<template>
  <div>
    <label
      v-if="placeholder"
      class="absolute px-5 pl-8 translate-all duration-200 text-xs pointer-events-none text-primary"
      :class="{
        'translate-y-3 text-base ': !innerValue && !isFocus
      }"
      :for="id"
    >{{ placeholder }}</label>
    <textarea
      v-model="innerValue"
      :rows="rows"
      :disabled="disabled"
      :class="{ '!bg-semigray': disabled}"
      class="w-full text-sm inline-block outline-none ring-white rounded-2xl text-primary focus:ring-primary p-3 pl-8 ring-1"
      @input="updateText()"
      @focus="isFocus = true"
      @blur="isFocus = false"
    />
    <div
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
    value: {
      validator: prop => typeof prop === 'string' || prop === null,
      required: true
    },
    disabled: {
      type: Boolean,
      default: false
    },
    placeholder: {
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
    rows: {
      type: Number,
      default: 8
    }
  },
  data () {
    return {
      innerValue: '',
      isFocus: false
    }
  },
  watch: {
    value (newValue) {
      this.innerValue = newValue
    }
  },
  beforeMount () {
    this.innerValue = this.value
  },
  methods: {
    updateText () {
      this.$emit('input', this.innerValue)
    }
  }
}
</script>
