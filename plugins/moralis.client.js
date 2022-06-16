import Moralis from 'moralis'
// import Web3 from 'web3'
import Web3 from 'web3'
// import { ethers } from 'ethers'
export default async function ({ $config }) {
  console.log('hello')
  await Moralis.start({ appId: $config.moralisAppId, serverUrl: $config.moralisServerUrl })
  await Moralis.enableWeb3()
  await Moralis.initPlugins()
}

// const init = async () => {
//   const covalent = Moralis.Plugins.covalent
//   const vaultBalance = await covalent.getTokenBalancesForAddress({
//     chainId: 80001,
//     address: vaultAddress,
//     quoteCurrency: 'MATIC'
//   })
//   console.log('MATIC Balance for Vault is: ', vaultBalance.data.items[0].balance)
// }
// Ide kelleni fog a contract address majd az env-be,
// Meg ezt akkor valoszinüleg azon a pagen kell meghívni, ahol Lesz majd a Vault Balance megadva
