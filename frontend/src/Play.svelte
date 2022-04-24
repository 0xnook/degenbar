<script lang="ts">
import { contracts, signerAddress  } from 'svelte-ethers-store';
import { degenBarAddy } from '../lib';
import { fmtBounty, allowance, minAllowance, currentOwner } from './store';
import { utils } from 'ethers';

let leaveBox = false;

function handleLeaveBox() {
	leaveBox=true;
	setTimeout(()=>{leaveBox=false}, 5000);
}


async function steal() {
	$contracts.degenBox.steal();
}

async function approve() {
	$contracts.erc20.approve(degenBarAddy, '100000000000000000000');
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
{#if $currentOwner == $signerAddress }
	<img src="povholder.png" alt="magical box"/> 
{:else if !leaveBox}
	<img src="steal.png" alt="fellow degen in the process of stealing the box"/>
{:else}
	<img src="angrydog.png" alt="fellow degen in the process of stealing the box"/> 
{/if} 
<h2>Price: 5 DAI</h2> 
	<button on:click={()=>approve()} class="oval green">> Approve </button>
	<button on:click={()=>steal()} class="oval green">> Steal it </button>

<button on:click={handleLeaveBox} class="oval">
	> Leave it
</button>
