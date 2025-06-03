# 🏆 SubastaKipu - Smart Contract in Solidity

Smart contract for an auction with the following features:
- 📈 Minimum 5% increase per bid
- ⏳ Automatic extension if a bid is placed in the last 10 minutes
- 💸 Automatic refunds to losing bidders with a 2% fee
- 🎁 Configurable prize for the winner

## 📜 License
[MIT](https://opensource.org/licenses/MIT)

## ⚙️ Version
Solidity `^0.8.0`

---

## 🚀 How It Works

### 🔧 Constructor
Initializes the auction with:
- `initialPrice`: Base price
- `extensionTime`: Extra time if a bid is placed near the end
- `duration`: Total auction time

### 💰 Function `pujar()`
Participants place bids. To be valid, a bid must exceed the current highest bid by **at least 5%**.

- If less than 10 minutes remain, the auction time is automatically extended.
- The bid is stored in a mapping and the highest bidder is updated.

### 🎯 Function `definirPremio(string)`
Allows the owner to define a description of the prize.

### 🎁 Function `transferirPremioAlGanador()`
Marks the prize as claimed. Can only be executed by the owner after the auction ends.

### 🛑 Function `finalizarSubasta()`
Ends the auction if the time has expired:
- Transfers the funds to the owner
- Refunds losing bidders their bids minus a **2%** fee

### 💳 Function `retirarExceso()`
Allows bidders to withdraw excess funds in case they overbid (not applicable to the winner).

---

## 📊 Query Functions

| Function | Description |
|---------|-------------|
| `obtenerGanador()` | Returns the address and bid amount of the winner |
| `mostrarOferta(address)` | Displays how much a specific address bid |
| `verTodasLasOfertas()` | Returns arrays of participants and their bid amounts |

---

## 👮 Roles and Security

- 👑 `owner`: The deployer of the contract. Only they can:
  - Set the prize
  - Deliver the prize
  - End the auction

- ⛔ Validations:
  - No one can bid after the auction has ended
  - The winner cannot withdraw excess funds
  - No one can claim the prize more than once

---

## 📦 Emitted Events

- `NuevaOferta(address bidder, uint amount)`
- `SubastaFinalizada(address winner, uint amount)`
- `DepositoDevuelto(address bidder, uint amount)`
- `ExcesoRetirado(address bidder, uint amount)`

---

## 🔗 Deployed Contract

You can view the contract on Sepolia Etherscan:
👉 [0xCE842D92afBd5149Ce552d541E4F8DA6DA42B395](https://sepolia.etherscan.io/address/0xCE842D92afBd5149Ce552d541E4F8DA6DA42B395#code)

---

## 🧪 Testing Recommendations

You can test this contract using [Remix IDE](https://remix.ethereum.org):
1. Paste the code into a new `.sol` file
2. Compile with Solidity 0.8.x
3. Deploy with values: `initialPrice`, `extensionTime`, `duration`
4. Simulate different accounts to place bids and observe refunds

---

## ✨ Author

Developed by Walter Liendo – Educational project for demonstration purposes in blockchain.
