pragma solidity ^0.5.16;

contract LifeInsurance{
    
    address SmartContractOwner;
    
    struct insured{
        bool authorised;
        string name;
        uint insuranceAmount;
    }
    
    mapping(address=>insured) public insuredmapping;
    mapping(address=>bool) public insurermapping;
    
    constructor() public{
        SmartContractOwner = msg.sender; 
    }
    
    modifier onlySmartContractOwner(){
        require(SmartContractOwner == msg.sender);
        _;
    }
    
    function  setinsurer(address _address) public onlySmartContractOwner{
        require(!insurermapping[_address]);
        insurermapping[_address] = true;
    }
    
    function setinsured(string memory _name,uint _insuranceAmount) public onlySmartContractOwner returns (address){
        address uid = address(bytes20(sha256(abi.encodePacked(msg.sender,block.timestamp))));
        require(!personmapping[uid].authorised);
        insuredmapping[uid].authorised = true;
        insuredmapping[uid].name = _name;
        insuredmapping[uid].insuranceAmount  = _insuranceAmount;
        
        return uid;
    }
    
    function claimInsurance(address _uid,uint _insuranceAmountUsed) public returns (string memory){
        require(!insurermapping[msg.sender]);
        if(personmapping[_uid].insuranceAmount < _insuranceAmountUsed){
            revert();
        }
        
        personmapping[_uid].insuranceAmount -= _insuranceAmountUsed;
        return "Amount debited from your insurance";
    }
}
