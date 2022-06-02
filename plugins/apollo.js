
import { ApolloClient, InMemoryCache, HttpLink, ApolloLink } from '@apollo/client'
import Cookies from 'js-cookie'

const httpLink = new HttpLink({ uri: 'https://api-mumbai.lens.dev/' })

const authLink = new ApolloLink((operation, forward) => {
  if (Cookies.get('access_token')) {
    const token = Cookies.get('access_token')
    console.log('token', token)
    operation.setContext({
      headers: {
        Authorization: token ? `Bearer ${token}` : ''
      }
    })
  }

  // Call the next link in the middleware chain.
  return forward(operation)
})

export const apolloClient = new ApolloClient({
  link: authLink.concat(httpLink),
  cache: new InMemoryCache()
})

export default (_, inject) => {
  inject('apollo', apolloClient)
}
