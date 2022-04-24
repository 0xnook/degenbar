<script lang="ts">
import { currPage } from './store';
</script>

<style>

img {
	max-width: 100%;
	height: auto;
}
.list {
	font-size: 2rem;

}

li {
	margin: 0.5rem;
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

<h1>How2Box</h1>

<img src="rules.png" alt="How 2 box"/>

<ul class="list">
  <li>Do not talk about the box</li>
  <li>Only one degen owns the Box at any given time</li>
  <li>A different degen plays by stealing the Box from the owner</li>
	<li>The thief can only steal by staking $$$ int the Box contract</li>
	<li>Thiefs steal from degens take over ownership of the Box</li>
	<li>On every steal attempt there is a chance that the thief messes up and opens the box for the previous owner</li>
</ul>


<button on:click={()=>{$currPage='play'}} class="oval green">> Play</button>
