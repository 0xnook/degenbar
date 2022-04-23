<script lang="ts">
import Web3Modal from "web3modal";
import { defaultEvmStores, signerAddress, connected }  from 'svelte-ethers-store';
import { toShortAddress } from '../lib';
import WalletConnectProvider from '@walletconnect/web3-provider';
import { providers } from 'ethers';
import { currPage } from './store';

/* const Web3Modal = window.Web3Modal.default */
/* const WalletConnectProvider = window.WalletConnectProvider.default */


async function handleConnect() {
	/* console.log('tetete'); */
	/* defaultEvmStores.setProvider() */

	const providerOptions = {
		walletconnect: {
			package: WalletConnectProvider,
			options: {
				rpc: {
					80001: 'https://rpc-mumbai.maticvigil.com',
					/* 42: 'https://kovan.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161' */
					// ...
				}
			}
		}
	}

	const web3Modal = new Web3Modal({
		network: "rinkeby", // optional
		/* cacheProvider: true, // optional */
		disableInjectedProvider: false,
		providerOptions, // required
		/* const instance = await web3Modal.connect(); */
	});

	console.log('setting!!!');
	const provider = await web3Modal.connect()
	
	console.log('setting!!!');
	defaultEvmStores.setProvider(provider)
}

/* async function handleWalletConnect() { */
/* 	//  Enable session (triggers QR Code modal) */
/* 	const wcProvider = new WalletConnectProvider({ */
/* 		rpc: { */
/* 			80001: 'https://rpc-mumbai.maticvigil.com', */
/* 			42: 'https://kovan.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161' */
/* 			// ... */
/* 		}, */
/* 	}); */
/* 	//  Enable session (triggers QR Code modal) */
/* 	await wcProvider.enable(); */
/* 	//  Wrap with Web3Provider from ethers.js */
/* 	const web3Provider = new providers.Web3Provider(wcProvider); */
/* 	await defaultEvmStores.setProvider(web3Provider.provider); */
/* } */

function handleDisconnect() {
	defaultEvmStores.disconnect();
}

</script>

<style>

	.header {
		display: flex;
		justify-content: space-between;
	}

	h1 {
		font-size: 4rem;
	}


	h1:hover {
		font-size: 4rem;
		text-decoration: underline;
	}

	.oval {
		width: 10rem;
		height: 5rem;
		border-radius: 50%;
		font-size: 1.5rem;
	}
</style>

<div class="header">
		<div></div>
		<h1 on:click={()=>{$currPage='landing'}}>degen.bar/box</h1>
		{#if !$connected} <button on:click={()=>handleConnect()} class="oval">
			> Walletconneeeect 
			</button>
		{:else}
				<button on:click={()=>defaultEvmStores.disconnect()} class="oval">
				{toShortAddress($signerAddress)}
			</button>
		{/if}
</div>

