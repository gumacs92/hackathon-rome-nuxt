import Moralis from 'moralis'
// Ez fog kelleni majd a create Posthoz mert kell egy metadata rész, ami majd
// a post descriptiont fogja tartalmazni ( vagy a képet )
export default async function createIPFS () {
  const metadata = {
    // Ide majd szerintem egy inputot kell rakni hogy amit ír valaki a szövegdobozba az ide jöjjön
    description: 'Hello, this is a post with Lens-Protocol'
  }

  const metadataFile = new Moralis.File('metadata.json', {
    base64: btoa(JSON.stringify(metadata))
  })

  await metadataFile.saveIPFS()
  const metadataURI = metadataFile.ipfs()
  console.log(metadata)
  console.log(metadataFile)
  console.log(metadataURI)
}
