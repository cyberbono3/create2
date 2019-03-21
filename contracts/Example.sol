pragma solidity >0.4.99 <0.6.0;

contract Example {

  event OwnerChanged(address owner);
  event DepositReceived(address sender, uint256 value);
  event WithdrawalInitiated(address sender, uint256 value);


  address payable owner;

  modifier validAddress(address add) {
        require(add != address(0) && add != address(this));
        _;
    }

  modifier validAmount(uint256 amount) {
        require(amount > 0 );
        _;
    }

  modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

   // ask question about Create in ethereum stackexchange
   // and about aprity
  constructor() public {
    owner = msg.sender;
  }

  function getOwner() public view returns (address) {
    return owner;
  }

  function transferOwnership(address payable _owner) public validAddress(_owner){
    owner = _owner;
    emit OwnerChanged(owner);
  }

  function destroy() public {
    selfdestruct(owner);
  }

  function() payable external {
    require(msg.value > 0);
    emit DepositReceived(msg.sender, msg.value);
  }

  //Factory contract pays for a gas
  function withdraw(address payable _to, uint256 _value) external validAddress(_to) validAmount(_value) onlyOwner  {
    require(_value >= address(this).balance);
    _to.transfer(_value);
    emit WithdrawalInitiated(_to, _value);
}  


}
