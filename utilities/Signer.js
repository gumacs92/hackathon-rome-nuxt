
// singleton class Signer
import Moralis from 'moralis'
import { utils } from 'ethers'
import omitDeep from 'omit-deep'

const Signer = (function () {
  function SignerConstructor () {
    const ethers = Moralis.web3Library
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    const signer = provider.getSigner()
    return {
      /// ////////////////////////////////////////////////////////////////////////////////////
      getSigner () {
        return signer
      },
      async sign (textToSign) {
        return await signer.signMessage(textToSign)
      },
      async signedTypeData  (domain, types, value) {
        // remove the __typedname from the signature!
        console.log(omitDeep(domain, '__typename'))
        console.log(omitDeep(types, '__typename'))
        console.log(omitDeep(value, '__typename'))
        return await signer._signTypedData(
          omitDeep(domain, '__typename'),
          omitDeep(types, '__typename'),
          omitDeep(value, '__typename')
        )
      },

      splitSignature  (signature) {
        return utils.splitSignature(signature)
      }
      /// ////////////////////////////////////////////////////////////////////////////////////
    }
  }
  let instance = null
  return {
    instance () {
      if (instance == null) {
        instance = new SignerConstructor()
        // Hide the constructor so the returned object can't be new'd...
        instance.constructor = null
      }
      return instance
    }
  }
})()

export default Signer

/*
const Cat = (function(){
  const CatConstructor = function() { //constructor function
    this.name = 'Cat';
    this.age = 5;

    const walk = function() {

    }
    return {
      meow: function() {
        walk()
        return 'meow';
      }
    }
  }

  let kitty = null
  return {
    instance () {
      if (kitty == null) {
        kitty = new CatConstructor()
        // Hide the constructor so the returned object can't be new'd...
        kitty.constructor = null
      }
      kitty.meow()
      kitty.walk()//ERROR
      return kitty
    }
  }
})()

// Cat {
//   instance: function()
// }

//new Cat() //ERROR

console.log(kitty.meow()) //hello

// valahol valami masik fajlban
import Cat from '....'

const bubaTheCat = Cat.instance()

bubaTheCat.meow()
bubaTheCat.walk() //error
// result.instance() === result.instance()

*/
