
const hre = require("hardhat");
//Returns the ether balance of a given address
async function getBalance(address)
{
  const balanceBigInt = await hre.waffle.provider.getBalance(address);
  return hre.ethers.utils.formatEther(balanceBigInt);
}

async function printBalances(addresses)
{
  let idx =0;
  for(const address of addresses){
    console.log(`Address ${idx} balance: `, await getBalance(address));
    idx++;
  }
}

async function printMemos(memos)
{
  for(const memo of memos){
    const timestamp = memo.timestamp;
    const tipper = memo.name;
    const tipperAddress = memo.from;
    const message = memo.message;
    console.log(`At ${timestamp}, ${tipper} (${tipperAddress}) said: "${message}"`);
  }
}

async function main() {
//Get example accounts
const [owner, tipper, tipper2, tipper3] = await hre.ethers.getSigners();

//Get contract to deploy and deploy
const BuyMeACoffee = await hre.ethers.getContractFactory("BuyMeACoffee");
const buyMeACoffee = await BuyMeACoffee.deploy();
await buyMeACoffee.deployed();
console.log("BuyMeACoffee deployed to ", buyMeACoffee.address);

//Check Balances before coffee purchase
const addresses = [owner.address, tipper.address, buyMeACoffee.address];
console.log("== start ==");
await printBalances(addresses);
//Buy Some coffees
const tip = {value: hre.ethers.utils.parseEther("1")};
await buyMeACoffee.connect(tipper).buyCoffee("Connor","Good job my boi, we're gonna make it",tip);
await buyMeACoffee.connect(tipper2).buyCoffee("Esther","Omg I can't wait till we go to paris with this money",tip);
await buyMeACoffee.connect(tipper3).buyCoffee("James","Yo you should check out SnowDog DAO",tip);

//Check balances after coffee purchase
console.log("== bought coffee ==")
await printBalances(addresses);
//Withdraw funds
await buyMeACoffee.connect(owner).changeTipAddress(tipper.address);
await buyMeACoffee.connect(tipper).withdrawTips();
//await buyMeACoffee.connect(tipper).withdrawTips();
//Check balance after withdrawal
console.log("== withdrawTips ==");
await printBalances(addresses);

//read all the memos left for the owner
console.log(" == memos == ");
const memos = await buyMeACoffee.getMemos();
printMemos(memos);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
