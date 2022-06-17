import { gql } from '@apollo/client'

export default gql`
query EnabledModuleCurrencies {
  enabledModuleCurrencies {
    name
    symbol
    decimals
    address
  }
}
`
