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
    <input id="MoralisPost" v-model="form.content" type="text" placeholder="Moralis Post description" style="border:solid">
    <button style="border:solid" @click="explorePublications()">
      Lens - Explore Publications
    </button>
    <button style="border:solid" @click="exploreProfiles()">
      Lens - Explore Profiles
    </button>
  </div>
</template>

<script>
import Cookies from 'js-cookie'
import Signer from '~/utilities/Signer'
import createIPFS from '~/utilities/ipfs.js'
import LensHubFactory from '~/utilities/lens-hub.js'

import StoreComputed from '~/mixins/storeComputed'

import CHALLENGE from '~/graphql/authentication/challenge.js'
import AUTHENTICATION from '~/graphql/authentication/authenticate.js'

import CREATE_PROFILE from '~/graphql/profile/create-profile.js'
import CREATE_SET_DEFAULT_PROFILE_TYPED_DATA from '~/graphql/profile/set-default-profile.js'
import GET_PROFILES from '~/graphql/profile/get-profiles.js'
import GET_DEFAULT_PROFILES from '~/graphql/profile/get-default-profile.js'
import EXPLORE_PROFILES from '~/graphql/profile/explore-profiles.js'

import CREATE_POST_TYPED_DATA from '~/graphql/publication/create-post-typed-data.js'
import GET_PUBLICATIONS from '~/graphql/publication/get-publications.js'
import CREATE_COMMENT_TYPED_DATA from '~/graphql/publication/create-comment-typed-data.js'
import GET_PUBLICATION from '~/graphql/publication/get-publication.js'
import EXPLORE_PUBLICATIONS from '~/graphql/publication/explore-publications.js'

import CREATE_FOLLOW_TYPED_DATA from '~/graphql/other/create-follow-typed-data.js'
// import ENABLED_MODULES from '~/graphql/enabled-modules.js'
// import ENABLED_MODULE_CURRENCIES from '~/graphql/enabled-module-currencies.js'
// import HAS_TX_BEEN_INDEXED from '~/utilities/has-transaction-been-indexed.js'

export default {
  mixins: [StoreComputed],
  data () {
    return {
      accessToken: null,
      form: {
        description: 'A social network to connect web3 users and their communities',
        version: '1.0.0',
        // metadata_id, // ez elvileg lehet egy uuid
        content: '',
        external_url: 'https://zilly.social',
        name: 'Zilly',
        attributes: [],
        //    media,
        appId: 'zilly'
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
      Cookies.set('tokens', authenticateResponse.data.authenticate)
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
      const contentURI = await createIPFS(this.form.content)
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
            publicationId: '498cb979-9bb4-4b62-9e18-fbb06aa9367a'
          }
        }
      })
      console.log('get Publication Response is', getPublicationResponse)
    },
    async explorePublications () {
      const explorePublicationsResponse = await this.$apollo.query({
        query: EXPLORE_PUBLICATIONS,
        variables: {
          request: {
            sortCriteria: 'LATEST',
            publicationTypes: ['POST'],
            limit: 10,
            sources: ['RomeLens']
          }
        }
      })
      console.log('Explore Publications Response is:', explorePublicationsResponse)
    },
    async exploreProfiles () {
      const exploreProfilesResponse = await this.$apollo.query({
        query: EXPLORE_PROFILES,
        variables: {
          request: {
            sortCriteria: 'MOST_FOLLOWERS'
          }
        }
      })
      console.log('Explore Profiles Response is:', exploreProfilesResponse)
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
