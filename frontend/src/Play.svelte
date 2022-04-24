<script lang="ts">
import { contracts, signerAddress  } from 'svelte-ethers-store';
import { degenBarAddy } from '../lib';
import { fmtBounty } from './store';

let leaveBox = false;

function handleLeaveBox() {
	leaveBox=true;
	setTimeout(()=>{leaveBox=false}, 5000);
}


async function steal() {
	if($contracts.degenBox && $contracts.erc20) {
		console.log('boxxxx');
		let allowance = await $contracts.erc20.allowance($signerAddress, degenBarAddy);

		console.log('allowance');
		if (allowance.gt(0)) {
			console.log('can steal');
			$contracts.degenBox.steal();
		} else {
			$contracts.erc20.approve(degenBarAddy, '100000000000000000000');
		}
	}
	console.log($contracts.degenBox);
	console.log($contracts.erc20);
}
</script>

<style>

img {
	max-width: 100%;
	height: auto;
}

.oval {
	width: 10rem;
	height: 5rem;
	border-radius: 50%;
	font-size: 1.5rem;
}

.green {
	color: green;
}

</style>
<h2 class="green">Box amount: {$fmtBounty} DAI</h2>
{#if !leaveBox}
	<img src="steal.png" alt="fellow degen in the process of stealing the box"/>
{:else}
	<img src="angrydog.png" alt="fellow degen in the process of stealing the box"/> 
{/if} 
<h2>Price: 5 DAI</h2> 

<button on:click={()=>steal()} class="oval green">> Steal it </button>

<button on:click={handleLeaveBox} class="oval">
	> Leave it
</button>
