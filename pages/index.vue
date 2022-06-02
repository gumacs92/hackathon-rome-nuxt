<template>
  <div>
    <button style="border:solid" @click="authenticate()">
      Lens Authentication
    </button>
    <button style="border:solid" @click="createProfile()">
      Lens - Create Profile
    </button>
  </div>
</template>

<script>
import Cookies from 'js-cookie'
import CHALLENGE from '~/graphql/challenge.js'
import Signer from '~/utilities/Signer'
import AUTHENTICATION from '~/graphql/authenticate.js'
import CREATE_PROFILE from '~/graphql/create-profile.js'

export default {
  data () {
    return {
      accessToken: null
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
      this.accessToken = authenticateResponse.data.authenticate.accessToken
      Cookies.set('access_token', this.accessToken)
    },
    async createProfile () {
      // validáció 5 tól 31-ig karakter, csak kisbetű és szám
      console.log(this.accessToken)
      // this.$apollo.headers.authorization = `Bearer ${this.accessToken}`
      const request = {
        handle: 'rikibartaaa'
        // profilePictureUri: null,
        // followNFTURI: null,
        // followModule: null
      }
      const createProfileResponse = await this.$apollo.mutate({
        mutation: CREATE_PROFILE,
        variables: {
          request
        }
      })
      console.log('Create Profile transaction is', createProfileResponse)
    }
  }
}
</script>
