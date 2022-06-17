import { gql } from '@apollo/client'

export default gql`
  mutation Authenticate($request: SignedAuthChallenge!) { 
    authenticate(request: $request) {
      accessToken
      refreshToken
    }
}
`
