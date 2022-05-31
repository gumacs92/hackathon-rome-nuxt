
export const state = {
  connectedAddress: null
}

export const getters = {
  getConnectedAddress: (state) => {
    return state.connectedAddress
  }
}

export const mutations = {
  setConnectedAddress: (state, payload) => {
    state.connectedAddress = payload
  }
}
