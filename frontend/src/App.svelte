<script lang="ts">
import Header from './Header.svelte';
import Slider from '@bulatdashiev/svelte-slider';
import { defaultEvmStores, signerAddress, connected, chainId, contracts, provider }  from 'svelte-ethers-store';
import { providers, utils } from 'ethers';
import DegenABI from '../abi/DegenBox.json';
import ERC20ABI from '../abi/ERC20.json';
import Landing from './Landing.svelte';
import { bounty, currentOwner, currPage, minAllowance, stealCount, allowance } from './store';
import Play from './Play.svelte';
import Rules from './Rules.svelte';
import {degenBarAddy} from '../lib';



let erc20Addy = "0x9c3c9283d3e44854697cd22d3faa240cfb032889";

defaultEvmStores.attachContract('degenBox', degenBarAddy, DegenABI)

defaultEvmStores.attachContract('erc20', erc20Addy, ERC20ABI);


async function fetchAll() {
	const degenBox = $contracts.degenBox;
	const erc20 = $contracts.erc20;

	if(erc20) {
		$allowance = await erc20.allowance($signerAddress, degenBarAddy);
	}
	if(degenBox) {
		$bounty = await degenBox.moneyInTheBox();
		$currentOwner = await degenBox.owner();
		$stealCount = await degenBox.stealCount();
	}

}

const getMinAllow = async () => { 
	$minAllowance = await $contracts.degenBox.fixedAmount();
}

$: if($contracts.degenBox) {
	getMinAllow();

}

$: if($contracts.degenBox && $provider) {
	fetchAll();
	$provider.on('block', (blockNumber: number) => {
			fetchAll();
	});
	/* $contracts.degenBox.on('BoxStolen', (stealer: string, address: string, _event: Event) => { */
	/* 			fetchAll(); */			
	/* }); */

}


</script>


<style>
	@import url('https://fonts.googleapis.com/css2?family=Comic+Neue:wght@400;700&display=swap');

	main {
		text-align: center;
		padding: 1em;
		max-width: 240px;
		margin: 0 auto;
		font-family: 'Comic Neue', cursive;	
	}


	.red {
		color: red;
	}

	@media (min-width: 640px) {
		main {
			max-width: none;
		}
	}

	.red {
		color: red
	}


</style>


<main>
	{#if $connected && $chainId !== 80001}
		<p class="red">Please change to mumbai network</p>
		{$chainId}
	{:else if !$connected}
		<p class="red">Pls connect</p>
	{/if}

	<Header/>
	
	{#if $currPage === "landing"}
		<Landing/>
	{:else if $currPage === "play"}
		<Play/>
	{:else if $currPage === "rules"}
		<Rules/>
	{/if}
</main>

