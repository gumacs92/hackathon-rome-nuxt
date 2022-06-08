import Moralis from 'moralis'
import Signer from './Signer'
import LENS_HUB_ABI from '~/abis/lens-hub.json'

// lens contract info can all be found on the deployed
// contract address on polygon.
// not defining here as it will bloat the code example
export default function (env) {
  const ethers = Moralis.web3Library
  const lensHub = new ethers.Contract(
    env.lensHubContractAddress,
    LENS_HUB_ABI,
    Signer.instance().getSigner()
  )
  return lensHub
}
