import Moralis from 'moralis'
import { v4 as uuidv4 } from 'uuid'
// Ez fog kelleni majd a create Posthoz mert kell egy metadata rész, ami majd
// a post descriptiont fogja tartalmazni ( vagy a képet )
export default async function createIPFS (content) {
  const metadataId = uuidv4()
  const metadataFile = new Moralis.File('metadata.json', {
    base64: btoa(JSON.stringify({
      version: '1.0.0',
      metadata_id: metadataId,
      description: 'A social network to connect web3 users and their communities.',
      content,
      external_url: 'valami.com',
      name: 'Rome',
      atrributes: [],
      //  media, // Ez nem kell ha van content
      appId: 'RomeLens'
    }))
  })

  await metadataFile.saveIPFS()
  const metadataURI = metadataFile.ipfs()
  // console.log(metadataFile)
  // console.log(metadataURI)

  return metadataURI
}

// itt egy példa hogyan nézzen ki az Object:

// const object = JSON.stringify ({
//   version: "1.0.0",
//   metadata_id,
//   description: "A social network to connect web3 users and their communities.",
//   content: message,
//   external_url: "https://zilly.social",
//   name: "Zilly",
//   attributes: [],
//   media,
//   appId: "zilly"
// })
