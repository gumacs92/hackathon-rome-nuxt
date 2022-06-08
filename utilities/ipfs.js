import Moralis from 'moralis'
// Ez fog kelleni majd a create Posthoz mert kell egy metadata rész, ami majd
// a post descriptiont fogja tartalmazni ( vagy a képet )
export default async function createIPFS (description) {
  const metadataFile = new Moralis.File('metadata.json', {
    base64: btoa(JSON.stringify({ description }))
  })

  await metadataFile.saveIPFS()
  const metadataURI = metadataFile.ipfs()
  // console.log(metadataFile)
  // console.log(metadataURI)

  return metadataURI
}
