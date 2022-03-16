// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/VRFConsumerBase.sol";
// import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/VRFConsumerBase.sol";
 


/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract Thelastwish  is Context, ERC165, IERC721, IERC721Metadata, Ownable,IERC721Enumerable,VRFConsumerBase {
    using Address for address;
    using Strings for uint256; 
    using Counters for Counters.Counter;

    

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    
    

    string public baseURI_ = "ipfs://Qmeq32eNkU28peHL7JiRMmx7U8jdgHB6ekxwLWy1eLotC8/";

    uint256 public maxMintAmount = 10;

    uint public maxSupply=10000;

    uint256 public cost = 0.3 ether;
     uint public secondrafflecounter=1;
      bytes32 internal keyHash;
    uint256 internal fee; 
    
    uint256 public winnerofthesecondraffleid; 

    Counters.Counter private _tokenIds;
   
    uint[] redeemednums;

    uint[] secondrafflenums;
    uint[] whitelistfornextdropnums;
    address[] listofallsecondraffleaddresses;
    address[] listofalladdressesforwhitelistspot;

    bool _updateredeemednumber;
    bool _updatesecondrafflenumber;
   
    bool public paused = false;
    bool   secondraffleexist;
    bool  _setifsecondraffleexist;
    bool  _setifwhitelistexist;
    bool  whitelistfornextdropexist;
    bool  _updatewhitelistfornextdropnumber;
    
    struct nftidandaddress {
            address holderaddress;
            uint    nftid;
           
           }
      struct nftidandaddress2 {
            address holderaddress;
            uint    nftid;
           
           }

    
    mapping (uint=>nftidandaddress2)  secondrafflewonaddresscheck; 
    mapping(uint=>nftidandaddress) redeemedidwontonftidandaddress;       
    
    address soliditydev= 0x9817C311F6897D30e372C119a888028baC879d1c;
         
    address communitywallet=0x0DBef23F605538E2145f29CadA0501E819A9BB5E;   

     

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;


    // Mapping from owner to list of owned token IDs
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // Array with all token ids, used for enumeration
    uint256[] private _allTokens;

    // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

     mapping(address => mapping(uint256 => uint256)) redeemlastwish;

     mapping (address=>uint[]) nftsredeemed;
     mapping (address=>mapping(uint256 => uint256)) secondrafleid;
    

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_)  VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709 // LINK Token
        )    { 
        _name = name_;
        _symbol = symbol_;
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18; // 0.1 LINK (Varies by network)
        
    } 



    /**
     * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
        require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[owner][index];
    }

   

    /**
     * @dev See {IERC721Enumerable-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _allTokens.length;
    }

    /**
     * @dev See {IERC721Enumerable-tokenByIndex}.
     */
    function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
        require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
        return _allTokens[index]; 
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal {
      

        if (from == address(0)) {
            _addTokenToAllTokensEnumeration(tokenId);
        } else if (from != to) {
            _removeTokenFromOwnerEnumeration(from, tokenId);
        }
        if (to == address(0)) {
            _removeTokenFromAllTokensEnumeration(tokenId);
        } else if (to != from) {
            _addTokenToOwnerEnumeration(to, tokenId);
        }
    }

    /**
     * @dev Private function to add a token to this extension's ownership-tracking data structures.
     * @param to address representing the new owner of the given token ID
     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        uint256 length = balanceOf(to);
        _ownedTokens[to][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
    }

    /**
     * @dev Private function to add a token to this extension's token tracking data structures.
     * @param tokenId uint256 ID of the token to be added to the tokens list
     */
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    /**
     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
     * @param from address representing the previous owner of the given token ID
     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = balanceOf(from) - 1;
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }

    /**
     * @dev Private function to remove a token from this extension's token tracking data structures.
     * This has O(1) time complexity, but alters the order of the _allTokens array.
     * @param tokenId uint256 ID of the token to be removed from the tokens list
     */
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        delete _allTokensIndex[tokenId];
        _allTokens.pop();
    }



    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return baseURI_;
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        ); 
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId);
    }

    function pause() public onlyOwner  {
        paused = !paused;

     }

    function checkPause() public view onlyOwner returns(bool) {
        return paused; 
    }

 
    function mint(
        
        uint256 _mintAmount
        
    ) public payable {
       
      
        require(_mintAmount > 0);
        require(_mintAmount <= maxMintAmount);
        require( totalSupply() + _mintAmount <= maxSupply);
        require(msg.value >= cost * _mintAmount);
         require(paused == false);
            
        


       if (_tokenIds.current()==0){
            _tokenIds.increment();
       }
        
        for (uint256 i = 1; i <= _mintAmount; i++) {
            uint256 newTokenID = _tokenIds.current();
            _safeMint(msg.sender, newTokenID); 
            _tokenIds.increment();
        }
    }

      function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    // set or update max number of mint per mint call
    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }

   

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI_ = _newBaseURI;
    }

    function walletofNFT(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function updateredeemednumber(uint[] memory _redeemednums)public onlyOwner{
       _updateredeemednumber=true;
       redeemednums=_redeemednums;
    }

    function setifsecondraffleexist(bool set)public onlyOwner{
        _setifsecondraffleexist=true;
         secondraffleexist=set;
    }

    function checkifsecondraffleexist()public view returns(bool){
            return  secondraffleexist;
    }
    
    function checksecondrafflenumberupdated()public view returns(uint[] memory){
        return secondrafflenums;
    }

     function checkwhitelistfornextdropupdated()public view returns(uint[] memory){
        return whitelistfornextdropnums;
    }

     function setifwhitelistfornextdropexist(bool set)public onlyOwner{
        _setifwhitelistexist=true;
          whitelistfornextdropexist=set;
    }

     function updatewhitelistfornextdropnumber(uint[] memory whitelistnum)public onlyOwner{
      _updatewhitelistfornextdropnumber=true;
       whitelistfornextdropnums=  whitelistnum; 
    }

    function checkallwhitelistedaddresses()public view returns(address[] memory){
        return  listofalladdressesforwhitelistspot;
    }
     function checkallsecondraffleaddresses()public view returns(address[] memory){
        return  listofallsecondraffleaddresses; 
    }

    function checkaddressandnftidthatwonredeemedid(uint redeemednumwon)public view returns(nftidandaddress memory){
        return redeemedidwontonftidandaddress[redeemednumwon];
    }

    function checkaddressthatwonredeemedid(uint redeemednumwon)public view returns(address){
        return redeemedidwontonftidandaddress[redeemednumwon].holderaddress; 
    }

    function checkaddressandnftidofsecondrafflenum(uint secondrafflenum)public view returns( nftidandaddress2 memory){
       return  secondrafflewonaddresscheck[secondrafflenum] ;  
    }

    function redeemLastWish(uint  nftId)public {
        require(ownerOf(nftId)==msg.sender);
        require(_updateredeemednumber==true, "please update redeemednumber");
        require(_setifsecondraffleexist==true,"please setifsecondraffleexist");
         require(_setifwhitelistexist==true,"please setifwhitelistfornextdropexist");
        redeemlastwish[msg.sender][nftId]=redeemednums[nftId-1];
        nftsredeemed[msg.sender].push(nftId);
        nftidandaddress storage _nftidandaddress=redeemedidwontonftidandaddress[redeemlastwish[msg.sender][nftId]];
        _nftidandaddress.holderaddress=msg.sender;
        _nftidandaddress.nftid= nftId;
           
         
        
        if ( secondraffleexist==true){
        require(_updatesecondrafflenumber==true,"please update second raffle number");
        for (uint i;i<secondrafflenums.length;i++){
            if (redeemlastwish[msg.sender][nftId]==secondrafflenums[i]){
                secondrafleid[msg.sender][nftId]=secondrafflecounter;
               nftidandaddress2 storage _nftidandaddress2= secondrafflewonaddresscheck[secondrafflecounter]; 
                 _nftidandaddress2.holderaddress=msg.sender;
                  _nftidandaddress2.nftid= nftId;
                listofallsecondraffleaddresses.push(msg.sender);
                secondrafflecounter++; 
                break;
            }
        }
        }

         if ( whitelistfornextdropexist==true){
        require(_updatewhitelistfornextdropnumber==true,"please update whitelist number");
        for (uint i;i< whitelistfornextdropnums.length;i++){
            if (redeemlastwish[msg.sender][nftId]== whitelistfornextdropnums[i]){
               listofalladdressesforwhitelistspot.push(msg.sender);
                break;
            }
        }
        }


        // // for the second rafle
        // nftredeemedid[redeemednums[nftId-1]]=msg.sender;
        // _nftid[nftId]=msg.sender;

        _burn(nftId);  
    }

    function checkwinnerofsecondraffle()public view returns(address){
        return  checkaddressandnftidofsecondrafflenum(winnerofthesecondraffleid).holderaddress;  
    }

    function generaterandomnumbertogetwinnerforsecondraffle()public onlyOwner{
          getRandomNumber();
    } 

    function checksecondraffleid(uint nftId)public view returns(uint){
           return secondrafleid[msg.sender][nftId];
    }

     function updatesecondrafflenumber(uint[] memory _secondraffle)public onlyOwner{
      _updatesecondrafflenumber=true;
     secondrafflenums=  _secondraffle; 
    }
    
    function claim() public onlyOwner {
        // get contract total balance
        uint256 balance = address(this).balance;
      
        // begin withdraw based on address percentage

         // 2.5%
        payable(soliditydev).transfer((balance / 1000) * 25);
       
        // 97.5%    
        payable(communitywallet).transfer((balance / 1000) * 975);
        
       
        
       
    }

    // function che()public view returns(uint,uint){
    //     return(soliditydev.balance,communitywallet.balance);
    // }

    //   function checkbalanceofcontract()public view returns(uint){
    //     return(address(this).balance);   
    // }


  
  function checkredeemedIdwon(uint nftId)public view returns(uint){
    

      return  redeemlastwish[msg.sender][nftId];
      
  }

  function checkredeemednftid()public view returns(uint[] memory ){
      return nftsredeemed[msg.sender];
  }

   function checkredeemednftid(address add)public view returns(uint[] memory ){
      return nftsredeemed[add];
  }
     
    

    

    // function checkclaimedwish()public view returns(uint[] memory) {

    // } 

   


    function _burn(uint256 tokenId) internal virtual {
        address owner = ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId);
    }

 
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId);
    }

  
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

  
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    } 

  
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }  

     function getRandomNumber() internal returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        uint _secondrafflecounter= secondrafflecounter-1;
        winnerofthesecondraffleid = (randomness % _secondrafflecounter ) + 1;  
    }

    
   

  
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}