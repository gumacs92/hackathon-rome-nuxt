
// singleton class Signer
import Moralis from 'moralis'

const Signer = (function () {
  function SignerConstructor () {
    return {
      /// ////////////////////////////////////////////////////////////////////////////////////
      async sign (textToSign) {
        const ethers = Moralis.web3Library
        const provider = new ethers.providers.Web3Provider(window.ethereum)
        const signer = provider.getSigner(this.address)
        return await signer.signMessage(textToSign)
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
