
export const state = {
  auth: {
    user: null,
    username: null,
    address: null
  }
}

export const mutations = {
  setUser: (state, user) => {
    console.log(user)
    state.auth.user = user
    state.auth.address = user ? user.get('ethAddress') : null
    state.auth.username = user ? user.get('username') : null
  }
}
