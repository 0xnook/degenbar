<script lang="ts">
import { utils } from 'ethers';
import { fmtBounty, stealCount, currentOwner, bounty, currPage } from './store';
import { onMount, onDestroy } from 'svelte';


let m = { x: 0, y: 0 };

let moveCount = 0;

let ruleButton;

function handleMousemove(event) {
	m.x = event.clientX;
	m.y = event.clientY;
}

function noRules(event) {
	let randX = event.clientX;
	let randY = event.clientX;
	if(moveCount<4) {
		randX = Math.floor(Math.random()/2 * (window.innerWidth - 100));
		randY = Math.floor(Math.random()/2 * (window.innerHeight - 100));
		ruleButton.style.position = "absolute";
		ruleButton.style.left = randX+'px';
		ruleButton.style.top = randY+'px';
		moveCount++;
	}
}

</script>

<style>

img {
	max-width: 100%;
	height: auto;
}

.story  {
	font-size: 2rem;
}


.inline {
	display: inline;
}


.oval {
	width: 10rem;
	height: 5rem;
	border-radius: 50%;
	font-size: 1.5rem;
}


.red {
	color: red;
}


.green {
	color: green;
}

.rules {
	z-index: 100;
}


/* Container holding the image and the text */
.textInImageContainer {
	position: relative;
	text-align: center;
	font-size: 7rem;
	/* color: white; */
}


/* Centered text in front of box */
.boxText {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
}

</style>

<div class="story">
	<div>You walk into a degen bar and see a box with 
		<div class="green inline">
			{$fmtBounty}
				</div> inside. 
		</div>
&nbsp;
	<div>The box is a bit worn and from its wear, you can deduce it was stolen <div class="red inline">{$stealCount} </div> times already.</div>
</div>


<div class="textInImageContainer">
	<img src="420box.png" alt="very cool box"/>
		<div class="boxText green">{$fmtBounty}</div>
		<div>
		<div style="height:24px;width:50%"></div>
	</div> 
</div>
	
<button on:click={()=>{$currPage='rules'}} bind:this={ruleButton} on:focus on:mouseover={noRules} class="oval red rules">> Rules</button>

<button on:click={()=>{$currPage='play'}} class="oval green">> Play</button>


