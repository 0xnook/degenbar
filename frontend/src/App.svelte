<script lang="ts">

import Header from './Header.svelte';
import Slider from '@bulatdashiev/svelte-slider';
import { defaultEvmStores, signerAddress, connected, chainId, contracts, provider }  from 'svelte-ethers-store';
import { providers, utils } from 'ethers';
import DegenABI from '../abi/DegenBox.json';
import ERC20ABI from '../abi/ERC20.json';
import Landing from './Landing.svelte';
import { bounty, currentOwner, currPage } from './store';
import Play from './Play.svelte';
import Rules from './Rules.svelte';

let stealCount = 69;
let helthFactorRange = [50, 100];


let previousOwners = ["vitalik.eth", "0xNGMI", "oops.eth", "nook.eth", "0x42cAb07f3D4B2eBb805BD063Aa4866A80796D0Aa"];
let degenBarAddy = '0x864B80657b62FE55B1650374bCBa77d814901ED1';

defaultEvmStores.attachContract('degenBox', degenBarAddy, DegenABI)

defaultEvmStores.attachContract('erc20', '0x9c3c9283d3e44854697cd22d3faa240cfb032889', ERC20ABI);


async function fetchAll() {
	const degenBox = $contracts.degenBox;
	if(degenBox) {
		$bounty = await degenBox.moneyInTheBox();
		$currentOwner = await degenBox.owner();
	}
}

$: if($contracts.degenBox && $provider) {
	fetchAll();
	$provider.on('block', (blockNumber: number) => {
			fetchAll();
	});


	/* $contracts.degenBox.on('BoxStolen', (stealer: string, address: string, _event: Event) => { */
	/* 			fetchAll(); */			
	/* }); */

	/* $contracts.degenBox.on('Reset', (src: string, guy: string, _event: Event) => { */
	/* 			fetchAll(); */			
	/* }); */
}


/* $currPage = 'play'; */
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
	{:else if !$connected }
		
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

