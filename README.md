# ☑️Rome / Decentralized Democracy with green social platfrom elements
## Developed for [Encode x Polygon Hackathon 2022]  

## ❓ About
The project basically is a decentralized democracy system. It has a build in election system which is completly managed by the smart contracts, so it cannot be tempered with.
Around the base voting system we build a social platform in which people are able to create event to recruit people for their cause. It might be some simple things like
collection garbage in a local area, or something large, like transforming some aspect of our lifes to something greener and more environment friendly. After election the
elected governors can start proposals which might support event organizers with some money from the Rome vault.


## 💡 How it works
Every registered user can create events and start recruiting. Future plans include joining the events, and some proofing system, so event organizers are able to filter out 
event spammers from real helper people. Later on those people who participate in those events will be rewarded with the (soon to be implemented) project token (RomeToken)

On the governing side of the project currently everyone can apply for governor position, but in future plans it will be connected to user activity. If someone starts and finishes many events, then he/she will become eligible for applying for a governor position. When someone applies, then the person have to state their name and some description in which the main goal of the application must be stated (eg. I would like to support all future garbage collection actions.)

Everyone is eligible for voting (it is a democracy after all 😄). Election are held for a fixed amount of time after which it is followed by a governing time. Elections are automatically started after the governing time is over. Applicants can applicate during both. After the election time currently the top 3 voted applicants are elected as governors.

The elected governors can manage proposals. Everyone can see the proposals, but only governors are eligible to create and vote on them. Governors can start proposals with setting the following: the name of the proposal, the description, an event to support, and an amount with which the event is going to be supported from the Rome Vault.
After creation the elected governors might vote while the proposal is active. After the active time has passed the proposal voting is closed, and it will become succesful if 50%+1 of the governors have voted for it, and will be dismissed otherwise.

## 📚 Contracts

- ProposalElection
- GovernorElection
- LensProtocol contracts


## 🔨 Built with:

- Nuxt.js
- TailwindCSS
- IPFS
- Moralis
- Covalent
- Lens Protocol
- Solidity


# Dev Environment

We have been working with Mumbai test blockchain. We tested our contracts locally with Truffle and Ganache, and after local testing deployed them on Mumbai. 

### 1. Make `.env`

```shell
touch .env
```

### 2. Add environment variable

```text
LENS_HUB_CONTRACT_ADDRESS=0x60Ae865ee4C725cd04353b5AAb364553f56ceF82 # official lens hub contract addres on Mumbai

ALCHEMY_API_KEY=<your-alchemy-key-here>

MORALIS_APP_ID=<your-moralis-app-id-here>
MORALIS_SERVER_URL=<your-moralis-server-url-here>

NETWORK_ID=80001 # Mumbai network ID

ADDRESS_SECRET_MNEMONIC="<your-mnemonic-here>" # needed for deployment
ADDRESS_DEPLOY_FROM="<your-public-address-here>" # also needed for deployment
# the mnemonic which you have defined here, and the one which is behind the address for deployment must be the same  
```

### 3. Install dependencies

```bash
npm install
```


### 4. Deploy contracts on the Mumbai testnet

```bash
npm run deploy-mumbai
# for local deployment use this below
# npm run deploy
```

### 5. Start developmment

```bash
npm run dev
```

### 6. 📱 Open http://localhost:3000 to see the app