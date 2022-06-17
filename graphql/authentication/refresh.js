import { gql } from '@apollo/client'

export default gql`
mutation($request: RefreshRequest!) { 
    refresh(request: $request) {
      accessToken
      refreshToken
    }
 }
`
