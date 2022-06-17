
import Cookies from 'js-cookie'

export const state = {
  auth: {
    user: null,
    username: null,
    address: null,
    accessToken: null,
    refreshToken: null
  },
  profile: null
}

export const mutations = {
  setUser: (state, user) => {
    console.log(user)
    state.auth.user = user
    state.auth.address = user ? user.get('ethAddress') : null
    state.auth.username = user ? user.get('username') : null
  },
  setAuthTokens: (state, tokens) => {
    if (tokens) {
      state.auth.accessToken = tokens.accessToken
      state.auth.refreshToken = tokens.refreshToken
      Cookies.set('accessToken', tokens.accessToken)
      Cookies.set('refreshToken', tokens.refreshToken)
    } else {
      state.auth.accessToken = null
      state.auth.refreshToken = null
      Cookies.remove('tokens')
    }
  },
  setUserProfile: (state, profile) => {
    state.profile = profile
  }
}
