<template>
  <Tutorial />
</template>

<script>
import PING from '~/graphql/ping.js'

export default {
  async beforeMount () {
    const response = await this.$apollo.query({
      query: PING
    })

    console.log('Lens example data: ', response)
  }

}
</script>
