import { writable, derived } from 'svelte/store';
import { utils } from 'ethers';

export const bounty = writable(utils.parseUnits('0'));
export const fmtBounty = derived(bounty, $bounty => $bounty ? utils.formatEther($bounty) : '...');

export const stealCount = writable(0);

export const currentOwner = writable("...");

export const currPage = writable("landing");
