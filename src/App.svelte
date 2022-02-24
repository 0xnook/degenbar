<script lang="ts">
	let chfPrice: number;
	import {ethers} from 'ethers';
	import { WrapperBuilder } from "redstone-evm-connector";

  const provider = new ethers.providers.Web3Provider(window.ethereum, "any");
 
	const contractAddress = '0xceEcd3aFb9A9392ccaa3312D1c8bcEE59873841f';

	const ABI = '[{"inputs":[],"name":"getMaxBlockTimestampDelay","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getMaxDataTimestampDelay","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_receviedSigner","type":"address"}],"name":"isSignerAuthorized","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_receivedTimestamp","type":"uint256"}],"name":"isTimestampValid","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"redstoneGetLastPrice","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"}]'

async function initContracts() {
	const contract = new ethers.Contract(contractAddress, ABI, provider.getSigner());
	const wrappedContract = WrapperBuilder.wrapLite(contract).usingPriceFeed('redstone', { asset: "CHF" });
	chfPrice = await wrappedContract.redstoneGetLastPrice();
}
ethereum.request({ method: 'eth_requestAccounts' });
</script>

<main>
	Please connect to kovan optimism
	<h1> CHF Price: {chfPrice ? ethers.utils.formatUnits(chfPrice, 8) : 'no value'} </h1>

	<button on:click={initContracts}>update price</button>
</main>

<style lang="scss">
	main {
		text-align: center;
		padding: 1em;
		max-width: 240px;
		margin: 0 auto;

		h1 {
			color: #ff3e00;
			text-transform: uppercase;
			font-size: 4em;
			font-weight: 100;
		}

		@media (min-width: 640px) {
			max-width: none;
		}
	}
</style>
