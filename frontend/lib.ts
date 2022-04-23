export const degenBarAddy = '0x864B80657b62FE55B1650374bCBa77d814901ED1';

// input: 0x50c57894c3b9bf022d10b94b9d940a48a93cd8c0
// output: 0x50...d8c0
export function toShortAddress(address: string): string {
	if(address) {
		return address.slice(0,4) + '...' + address.slice(-4);
	} else return '';
}


