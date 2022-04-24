import { writable, derived } from 'svelte/store';
import { utils } from 'ethers';

export const bounty = writable(utils.parseUnits('0'));
export const fmtBounty = derived(bounty, $bounty => $bounty ? utils.formatEther($bounty) : '...');


export const currentOwner = writable("...");

export const currPage = writable("landing");

export const minAllowance = writable(utils.parseUnits('0'));
export const allowance = writable(utils.parseUnits('0'));

export const stealCount = writable(utils.parseUnits('0'));
