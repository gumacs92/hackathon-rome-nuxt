import { gql } from '@apollo/client'

export default gql`
query CollectModules {
  enabledModules {
    collectModules {
      moduleName
      contractAddress
      inputParams {
        name
        type
      }
      redeemParams {
        name
        type
      }
      returnDataParms {
        name
        type
      }
    }
    followModules {
      moduleName
      contractAddress
      inputParams {
        name
        type
      }
      redeemParams {
        name
        type
      }
      returnDataParms {
        name
        type
      }
    }
    referenceModules {
      moduleName
      contractAddress
      inputParams {
        name
        type
      }
      redeemParams {
        name
        type
      }
      returnDataParms {
        name
        type
      }
    }
  }
}`
