export default {
  computed: {
    user () {
      return this.$store.state.auth.user
    },
    username () {
      return this.$store.state.auth.username
    },
    address () {
      return this.$store.state.auth.address
    },
    profile () {
      return this.$store.state.profile
    },
    accessToken () {
      return this.$store.state.auth.accessToken
    }
  }
}
