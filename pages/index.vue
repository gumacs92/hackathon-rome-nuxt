<template>
  <button @click="authenticate()">
    click me
  </button>
</template>

<script>
// import PING from '~/graphql/ping.js'
import Moralis from 'moralis'
import CHALLENGE from '~/graphql/challenge.js'
// import AUTHENTICATION from '~/graphql/authenticate.js'

export default {
  data () {
    return {
      user: null // Amelyik változóra this-el hivatkozunk az mind itt található a data-ban
    }
  },
  async beforeMount () {
    try {
      this.user = await Moralis.authenticate({
        signingMessage: 'Log in using Moralis'
      })
      if (this.user) {
        console.log(this.user.get('ethAddress'))
      }
    } catch (e) {
      console.log(e)
    }
  },

  methods: {
    async authenticate () {
      const response = await this.$apollo.query({
        query: CHALLENGE,
        variables: {
          request: {
          // Metamask account az address data-ja
            address: this.user.get('ethAddress')
          }
        }
      })

      console.log(window.ethersProvider.signMessage(response.data.challenge.text))
      // const signature = await this.$apollo.query({
      //   mutation: AUTHENTICATION,
      //   variables: {
      //     request: {
      //       address: this.user.get('ethAddress'),
      //       signature: response.data.challenge.text
      //     }
      //   }
      // })

      console.log('Lens example data: ', response)
      // console.log('Signature is: ', signature)
    }
  }

}
</script>
