<template>
  <button class="m-10" @click="authenticate()">
    click me
  </button>
</template>

<script>
// import PING from '~/graphql/ping.js'
import CHALLENGE from '~/graphql/challenge.js'
import Signer from '~/utilities/Signer'
import AUTHENTICATION from '~/graphql/authenticate.js'

export default {
  data () {
    return {
    }
  },
  computed: {
    address () {
      return this.$store.state.connectedAddress
    }
  },
  methods: {
    async authenticate () {
      const challengeResponse = await this.$apollo.query({
        query: CHALLENGE,
        variables: {
          request: {
          // Metamask account az address data-ja
            address: this.address
          }
        }
      })
      console.log('Lens challenge data: ', challengeResponse)

      const signature = await Signer.instance().sign(challengeResponse.data.challenge.text)

      console.log('Lens signature data: ', signature)

      const authenticateResponse = await this.$apollo.mutate({
        mutation: AUTHENTICATION,
        variables: {
          request: {
            address: this.address,
            signature
          }
        }
      })
      console.log('Lens authenticate data: ', authenticateResponse)
    }
  }

}
</script>
