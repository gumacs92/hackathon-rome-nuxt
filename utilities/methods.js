export function normalize (input) {
  let normalized = {}
  if (input instanceof Array) {
    let objectArray = false
    Object.getOwnPropertyNames(input).forEach((key) => {
      if (isNaN(key) && key !== 'length') { objectArray = true }
    })
    // it is an object concieled as array
    if (objectArray) {
      Object.getOwnPropertyNames(input).forEach((key) => {
        if (isNaN(key) && key !== 'length') { normalized[key] = normalize(input[key]) }
      })
    } else {
      // it is really an array
      normalized = input.map(i => normalize(i))
    }
  } else if (input instanceof Object) {
    if ('_hex' in input) {
      return parseInt(input._hex, 16)
    } else {
      Object.keys(input).keys((k) => {
        normalized[k] = normalize(input[k])
      })
    }
  } else {
    return input
  }
  return normalized
}

// function normalize (input) {
//   const normalized = {}
//   Object.getOwnPropertyNames(input).forEach((key) => {
//     if (isNaN(key)) {
//       if (!(input[key] instanceof Array)) {
//         if (input[key] instanceof BigNumber) {
//           normalized[key] = parseInt(input[key]._hex, 16)
//         } else if (input[key] instanceof Object) {
//           Object.getOwnPropertyNames(input[key]).forEach((k) => {
//             normalized[key][k] = normalizeContractOutput(k)
//           })
//         } else {
//           normalized[key] = input[key]
//         }
//       } else {
//         normalized[key] = normalizeContractOutput(input[key])
//       }
//     }
//   })
//   return normalized
// }
