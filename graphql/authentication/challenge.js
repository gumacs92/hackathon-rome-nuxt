import { gql } from '@apollo/client'

export default gql`
query Challenge ($request: ChallengeRequest!) { # Ez olyan mint egy függvény fejléce
  challenge(request: $request) { # függvény definíció ( 5-től 12 sorig)
    text
  }
}
`
