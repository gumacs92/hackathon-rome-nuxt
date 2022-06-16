<template>
  <div class="pt-32">
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
    <button style="border:solid" @click="getPublications()">
      Lens - Get Publications
    </button>
    <button style="border:solid" @click="comment()">
      Lens - Comment
    </button>
    <button style="border:solid" @click="follow()">
      Lens - Follow
    </button>
    <button style="border:solid" @click="getPublication()">
      Lens - Get Publication
    </button>
    <input id="ProfileHandle" type="text" placeholder="Pick handle for Creating Profile" style="border:solid">
    <input id="MoralisPost" v-model="form.description" type="text" placeholder="Moralis Post description" style="border:solid">
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
import GET_PUBLICATION from '~/graphql/get-publication.js'
// import ENABLED_MODULES from '~/graphql/enabled-modules.js'
// import ENABLED_MODULE_CURRENCIES from '~/graphql/enabled-module-currencies.js'
import LensHubFactory from '~/utilities/lens-hub.js'
// import HAS_TX_BEEN_INDEXED from '~/utilities/has-transaction-been-indexed.js'

import StoreComputed from '~/mixins/storeComputed'

export default {
  mixins: [StoreComputed],
  data () {
    return {
      accessToken: null,
      form: {
        description: ''
      }
    }
  },
  beforeMount () {
    // let result = await this.$apollo.query({
    //   query: ENABLED_MODULE_CURRENCIES
    // })
    // console.log('enabled currencies:', result)
    // result = await this.$apollo.query({
    //   query: ENABLED_MODULES
    // })
    // console.log('enabled modules:', result)
    console.log(LensHubFactory(this.$config))
  },
  methods: {
    async authenticate () {
      console.log(this.address)
      const challengeResponse = await this.$apollo.query({
        query: CHALLENGE,
        variables: {
          request: {
          // Metamask account az address data-ja
            address: this.address
          }
        }
      })
      // console.log('Lens challenge data: ', challengeResponse)

      const signature = await Signer.instance().sign(challengeResponse.data.challenge.text)

      // console.log('Lens signature data: ', signature)

      const authenticateResponse = await this.$apollo.mutate({
        mutation: AUTHENTICATION,
        variables: {
          request: {
            address: this.address,
            signature
          }
        }
      })
      // console.log('Lens authenticate data: ', authenticateResponse)
      this.accessToken = authenticateResponse.data.authenticate.accessToken
      Cookies.set('access_token', this.accessToken)
    },
    async createProfile () {
      // validáció 5 tól 31-ig karakter, csak kisbetű és szám
      console.log(this.accessToken)
      // this.$apollo.headers.authorization = `Bearer ${this.accessToken}`
      const request = {
        handle: document.getElementById('ProfileHandle').value // Ide kellene majd egy input create Profilhoz
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
            profileId: '0x03c9'
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
            limit: 10
          }
        }
      })
      console.log('Get Profile Response is: ', getProfiles)
      console.log('Your Profile Id is: ', getProfiles.data.profiles.items[0].id)
    },
    async createPost () {
      const contentURI = await createIPFS(this.form.description)
      const getProfiles = await this.$apollo.query({
        query: GET_PROFILES,
        variables: {
          request: {
            ownedBy: [this.address],
            limit: 10
          }
        }
      })
      const myProfile = getProfiles.data.profiles.items[0].id
      // console.log("the Profile Id you wanna post with is", myProfile)

      const createPostRequest = {
        profileId: myProfile,
        // profileId: '0x03c9',
        contentURI,
        collectModule: {
          freeCollectModule: {
            followerOnly: false
          }
        }
      }
      const createPostResponse = await this.$apollo.mutate({
        mutation: CREATE_POST_TYPED_DATA,
        variables: {
          request: createPostRequest
        }
      })
      console.log('Lens Post Response is:', createPostResponse)

      const typedData = createPostResponse.data.createPostTypedData.typedData
      // console.log(typedData)
      const signature = await Signer.instance().signedTypeData(typedData.domain, typedData.types, typedData.value)
      // console.log(signature)
      const { v, r, s } = Signer.instance().splitSignature(signature)

      console.log(v, r, s)

      const tx = await LensHubFactory(this.$config).postWithSig({
        profileId: typedData.value.profileId,
        contentURI: typedData.value.contentURI,
        collectModule: typedData.value.collectModule,
        collectModuleInitData: typedData.value.collectModuleInitData,
        referenceModule: typedData.value.referenceModule,
        referenceModuleInitData: typedData.value.referenceModuleInitData,
        sig: {
          v,
          r,
          s,
          deadline: typedData.value.deadline
        }
      })
      console.log(tx.hash)
    },

    async getPublications () {
      const getProfiles = await this.$apollo.query({
        query: GET_PROFILES,
        variables: {
          request: {
            ownedBy: [this.address],
            limit: 10
          }
        }
      })
      const myProfile = getProfiles.data.profiles.items[0].id
      console.log('my Profile Id is: ', myProfile)
      const getPublicationsResponse = await this.$apollo.query({
        query: GET_PUBLICATIONS,
        variables: {
          request: {
            profileId: myProfile,
            publicationTypes: ['POST', 'COMMENT', 'MIRROR'],
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
            profileId: '0x03c9',
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
          profile: '0x03c9'
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
    },

    async getPublication () {
      const getPublicationResponse = await this.$apollo.query({
        query: GET_PUBLICATION,
        variables: {
          request: {
            publicationId: 'a38e25aa-45b4-4c51-beac-05e946b5debe'
          }
        }
      })
      console.log('get Publication Response is', getPublicationResponse)
    }
    // async hasTransactionBeenIndexed () {
    //   const hasTransactionBeenIndexedResponse = await this.$apollo.query({
    //     query: HAS_TX_BEEN_INDEXED,
    //     variables: {
    //       request: {
    //         txHash
    //       }
    //     },
    //     fetchPolicy: 'network-only'
    //   })
    //   console.log(hasTransactionBeenIndexedResponse)

    //   const sleep = (milliseconds) => {
    //     return new Promise(resolve => setTimeout(resolve, milliseconds))
    //   }
    // }

    // async pollUntilIndexed (txHash) {
    //   // eslint-disable-next-line no-constant-condition
    //   while (true) {
    //     const result = await hasTxBeenIndexed(txHash)

    //     const response = result.data.hasTxHashBeenIndexed
    //     if (response.__typename === 'TransactionIndexedResult') {
    //       console.log('pool until indexed: indexed', response.indexed)

    //       if (response.metadataStatus) {
    //         if (response.metadataStatus.status === 'SUCCESS') {
    //           return response
    //         }

    //         if (response.metadataStatus.status === 'METADATA_VALIDATION_FAILED') {
    //           throw new Error(response.metadataStatus.reason)
    //         }
    //       } else if (response.indexed) {
    //         return response
    //       }

    //       // sleep for a second before trying again
    //       await sleep(1000)
    //     } else {
    //       // it got reverted and failed!
    //       throw new Error(response.reason)
    //     }
    //   }
    // }

  }
}
</script>
