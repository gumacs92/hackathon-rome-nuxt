<template>
  <div>
    <button style="border:solid" @click="authenticate()">
      Lens Authentication
    </button>
    <button style="border:solid" @click="createProfile()">
      Lens - Create Profile
    </button>
    <button style="border:solid" @click="setDefaultProfile()">
      Lens - Set Default Profile
    </button>
    <button style="border:solid" @click="getDefaultProfile()">
      Lens - Get Default Profile
    </button>
    <button style="border:solid" @click="getProfiles()">
      Lens - Get Profiles
    </button>
    <button style="border:solid" @click="createPost()">
      Lens - Create Post
    </button>
    <button style="border:solid" @click="uploadToIpfs()">
      Moralis - UploadtoIPFS
    </button>
    <button style="border:solid" @click="getPublications()">
      Lens - Get Publications
    </button>
    <button style="border:solid" @click="comment()">
      Lens - Comment
    </button>
    <button style="border:solid" @click="follow()">
      Lens - Follow
    </button>
  </div>
</template>

<script>
import Cookies from 'js-cookie'
import CHALLENGE from '~/graphql/challenge.js'
import Signer from '~/utilities/Signer'
import AUTHENTICATION from '~/graphql/authenticate.js'
import CREATE_PROFILE from '~/graphql/create-profile.js'
import GET_DEFAULT_PROFILES from '~/graphql/get-default-profile.js'
import CREATE_SET_DEFAULT_PROFILE_TYPED_DATA from '~/graphql/set-default-profile.js'
import GET_PROFILES from '~/graphql/get-profiles.js'
import CREATE_POST_TYPED_DATA from '~/graphql/create-post-typed-data.js'
import createIPFS from '~/utilities/ipfs.js'
import GET_PUBLICATIONS from '~/graphql/get-publications.js'
import CREATE_COMMENT_TYPED_DATA from '~/graphql/create-comment-typed-data.js'
import CREATE_FOLLOW_TYPED_DATA from '~/graphql/create-follow-typed-data.js'

export default {
  data () {
    return {
      accessToken: null
    }
  },
  computed: {
    address () {
      return this.$store.state.connectedAddress
    }
  },
  methods: {
    async authenticate () {
      const challengeResponse = await this.$apollo.query({
        query: CHALLENGE,
        variables: {
          request: {
          // Metamask account az address data-ja
            address: this.address
          }
        }
      })
      console.log('Lens challenge data: ', challengeResponse)

      const signature = await Signer.instance().sign(challengeResponse.data.challenge.text)

      console.log('Lens signature data: ', signature)

      const authenticateResponse = await this.$apollo.mutate({
        mutation: AUTHENTICATION,
        variables: {
          request: {
            address: this.address,
            signature
          }
        }
      })
      console.log('Lens authenticate data: ', authenticateResponse)
      this.accessToken = authenticateResponse.data.authenticate.accessToken
      Cookies.set('access_token', this.accessToken)
    },
    async createProfile () {
      // validáció 5 tól 31-ig karakter, csak kisbetű és szám
      console.log(this.accessToken)
      // this.$apollo.headers.authorization = `Bearer ${this.accessToken}`
      const request = {
        handle: 'follower'
        // profilePictureUri: null,
        // followNFTURI: null,
        // followModule: null
      }
      const createProfileResponse = await this.$apollo.mutate({
        mutation: CREATE_PROFILE,
        variables: {
          request
        }
      })
      console.log('Create Profile transaction is', createProfileResponse)
    },
    async getDefaultProfile () {
      const getDefaultProfileResponse = await this.$apollo.query({
        query: GET_DEFAULT_PROFILES,
        variables: {
          request: {
            ethereumAddress: this.address
          }
        }
      })
      console.log('Default Profile Respone is: ', getDefaultProfileResponse)
    },
    async setDefaultProfile () {
      const setDefaultProfileResponse = await this.$apollo.mutate({
        mutation: CREATE_SET_DEFAULT_PROFILE_TYPED_DATA,
        variables: {
          request: {
            profileId: '0x03fd'
          }
        }
      })
      console.log('Create Profile Respone is:', setDefaultProfileResponse)
    },
    async getProfiles () {
      const getProfiles = await this.$apollo.query({
        query: GET_PROFILES,
        variables: {
          request: {
            ownedBy: [this.address],
            limit: 1
          }
        }
      })
      console.log('Get Profile Response is: ', getProfiles)
      console.log('Your Profile Id is: ', getProfiles.data.profiles.items[0].id)
    },
    async createPost () {
      const createPostRequest = {
        profileId: '0x03fd',
        contentURI: 'https://ipfs.moralis.io:2053/ipfs/QmYs85PXvnMs1vpF4rXAj9TYFuvkXrFwyEETgzzPNjNPQP',
        collectModule: {
          freeCollectModule: {
            followerOnly: true
          }
        },
        referenceModule: {
          followerOnlyReferenceModule: false
        }
      }
      const createPostResponse = await this.$apollo.mutate({
        mutation: CREATE_POST_TYPED_DATA,
        variables: {
          request: createPostRequest
        }
      })
      console.log('Lens Post Response is:', createPostResponse)
    },
    async uploadToIpfs () {
      await createIPFS()
    },
    async getPublications () {
      const getPublicationsResponse = await this.$apollo.query({
        query: GET_PUBLICATIONS,
        variables: {
          request: {
            profileId: '0x03fd',
            publicationTypes: ['POST'],
            limit: 10
          }
        }
      })
      console.log('Get Publication Response is: ', getPublicationsResponse)
    },
    async comment () {
      // Itt még nem találja a publicationt, arra errorozik
      const createCommentResponse = await this.$apollo.mutate({
        mutation: CREATE_COMMENT_TYPED_DATA,
        variables: {
          request: {
            profileId: '0x03fd',
            publicationId: '07b7546e-ad23-4d72-8341-53199227c0de',
            contentURI: 'https://ipfs.moralis.io:2053/ipfs/QmYs85PXvnMs1vpF4rXAj9TYFuvkXrFwyEETgzzPNjNPQP',
            collectModule: {
              freeCollectModule: {
                followerOnly: true
              }
            },
            referenceModule: {
              followerOnlyReferenceModule: false
            }
          }
        }
      })
      console.log('Create comment Lens Response is: ', createCommentResponse)
    },
    async follow () {
      // Itt csinálni kell egy másik profilt amihez új profile Id lesz rendelve hogy tudjunk followolni
      const followRequest = [
        {
          profile: '0x03fd'
        },
        {
          profile: '0x03fd',
          followModule: {
            freeFollowModule: {
            }
          }
        }
      ]
      const followResponse = await this.$apollo.mutate({
        mutation: CREATE_FOLLOW_TYPED_DATA,
        variables: {
          request: followRequest
        }
      })
      console.log('Follow Lens Response is: ', followResponse)
    }

  }
}
</script>
