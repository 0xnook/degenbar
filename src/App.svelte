<script lang="ts">
	import {ethers} from 'ethers';
	import { WrapperBuilder } from "redstone-evm-connector";

  const provider = new ethers.providers.Web3Provider(window.ethereum, "any");
	const houseOfReserveAddress = '0x62c4014a76e21C046fc5196D81E8cD7e04C5f122';
	const houseOfReserveABI = [
	'event CollateralRatioChanged(tuple(uint256 numerator, uint256 denominator) newFactor)',
	'event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)',
	'event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)',
	'event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)',
	'event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)',
	'event TrustedSignerChanged(address indexed newSigner)',
	'event UserDeposit(address indexed user, address indexed asset, uint256 amount)',
	'event UserWithdraw(address indexed user, address indexed asset, uint256 amount)',
	'function DEFAULT_ADMIN_ROLE() view returns (bytes32)',
	'function HOUSE_TYPE() view returns (bytes32)',
	'function assetsAccountant() view returns (address)',
	'function authorizeSigner(address _trustedSigner)',
	'function backedAsset() view returns (address)',
	'function backedTokenID() view returns (uint256)',
	'function checkMaxWithdrawal(address user) view returns (uint256 max)',
	'function collateralRatio() view returns (uint256 numerator, uint256 denominator)',
	'function deposit(uint256 amount)',
	'function getRoleAdmin(bytes32 role) view returns (bytes32)',
	'function grantRole(bytes32 role, address account)',
	'function hasRole(bytes32 role, address account) view returns (bool)',
	'function initialize(address _reserveAsset, address _backedAsset, address _assetsAccountant)',
	'function maxDelay() view returns (uint256)',
	'function owner() view returns (address)',
	'function redstoneGetLastPrice() view returns (uint256)',
	'function renounceOwnership()',
	'function renounceRole(bytes32 role, address account)',
	'function reserveAsset() view returns (address)',
	'function reserveTokenID() view returns (uint256)',
	'function revokeRole(bytes32 role, address account)',
	'function setCollateralRatio(uint256 numerator, uint256 denominator)',
	'function setMaxDelay(uint256 _maxDelay)',
	'function supportsInterface(bytes4 interfaceId) view returns (bool)',
	'function transferOwnership(address newOwner)',
	'function trustedSigner() view returns (address)',
	'function withdraw(uint256 amount)'
];
 
	const houseOfCoinAddress = '0xF3A1C091f110F7b931c02d3603ec8bC771182466';

	const houseOfCoinABI = [
	'event CoinMinted(address indexed user, uint256 indexed backedtokenID, uint256 amount)',
	'event CoinPayback(address indexed user, uint256 indexed backedtokenID, uint256 amount)',
	'event Liquidation(address indexed userLiquidated, address indexed liquidator, uint256 collateralAmount)',
	'event MarginCall(address indexed user, address indexed mintedAsset, address indexed reserveAsset)',
	'event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)',
	'event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)',
	'event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)',
	'event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)',
	'event TrustedSignerChanged(address indexed newSigner)',
	'function DEFAULT_ADMIN_ROLE() view returns (bytes32)',
	'function HOUSE_TYPE() view returns (bytes32)',
	'function _checkRemainingMintingPower(address user, uint256 reserveTokenID, uint256 backedTokenID, tuple(uint256 numerator, uint256 denominator) collatRatio, uint256 price) view returns (uint256)',
	'function assetsAccountant() view returns (address)',
	'function authorizeSigner(address _trustedSigner)',
	'function backedAsset() view returns (address)',
	'function checkRemainingMintingPower(address user, address reserveAsset) view returns (uint256)',
	'function computeCostOfLiquidation(address user, address reserveAsset) view returns (uint256, uint256)',
	'function computeUserHealthRatio(address user, address reserveAsset) view returns (uint256)',
	'function getBackedTokenID(address _reserveAsset) view returns (uint256)',
	'function getRoleAdmin(bytes32 role) view returns (bytes32)',
	'function grantRole(bytes32 role, address account)',
	'function hasRole(bytes32 role, address account) view returns (bool)',
	'function initialize(address _backedAsset, address _assetsAccountant)',
	'function liqParam() view returns (uint256 globalBase, uint256 marginCallThreshold, uint256 liquidationThreshold, uint256 liquidationPricePenaltyDiscount, uint256 collateralPenalty)',
	'function liquidateUser(address userToLiquidate, address reserveAsset)',
	'function maxDelay() view returns (uint256)',
	'function mintCoin(address reserveAsset, address houseOfReserve, uint256 amount)',
	'function owner() view returns (address)',
	'function paybackCoin(uint256 _backedTokenID, uint256 amount)',
	'function redstoneGetLastPrice() view returns (uint256)',
	'function renounceOwnership()',
	'function renounceRole(bytes32 role, address account)',
	'function revokeRole(bytes32 role, address account)',
	'function setMaxDelay(uint256 _maxDelay)',
	'function supportsInterface(bytes4 interfaceId) view returns (bool)',
	'function transferOwnership(address newOwner)',
	'function trustedSigner() view returns (address)'
]

function initContracts() {
	console.log('wrapping 2 contracts');
	const houseOfCoinContract = new ethers.Contract(houseOfCoinAddress, houseOfCoinABI, provider.getSigner());
	const wrappedHouseOfCoinContract = WrapperBuilder.wrapLite(houseOfCoinContract).usingPriceFeed('redstone-stocks');

	const houseOfReserveContract = new ethers.Contract(houseOfReserveAddress, houseOfReserveABI, provider.getSigner());
	const wrappedHouseOfReserveContract = WrapperBuilder.wrapLite(houseOfCoinContract).usingPriceFeed('redstone-stocks');
	console.log('done wrapping');
}

$: i = 0
setInterval(()=>i++, 1000);
</script>

<main>
	<h1> {i} </h1>

	<button on:click={initContracts}>wrapp contracts</button>
</main>

<style lang="scss">
	main {
		text-align: center;
		padding: 1em;
		max-width: 240px;
		margin: 0 auto;

		h1 {
			color: #ff3e00;
			text-transform: uppercase;
			font-size: 4em;
			font-weight: 100;
		}

		@media (min-width: 640px) {
			max-width: none;
		}
	}
</style>
