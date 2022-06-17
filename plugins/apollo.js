
import { ApolloClient, InMemoryCache, HttpLink, ApolloLink } from '@apollo/client'
import Cookies from 'js-cookie'

const httpLink = new HttpLink({ uri: 'https://api-mumbai.lens.dev/' })

const authLink = new ApolloLink((operation, forward) => {
  if (Cookies.get('accessToken')) {
    const accessToken = Cookies.get('accessToken')
    console.log('token', accessToken)
    operation.setContext({
      headers: {
        Authorization: accessToken ? `Bearer ${accessToken}` : ''
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
