pragma solidity^0.4.21;

/*
    "Event","032418",1,20
*/

contract TicketBooth {
    address public _ticketMaster;
    string public _eventName;
    string public _eventDate;
    uint public _eventCost;
    uint public _ticketsLeft;
    
    struct TicketData{
        bool _hasPaid;
        uint _pricePaid;
    }
    
    mapping(address => TicketData) public _ticketHolders;
    
    function TicketBooth (string eventName, string eventDate, uint eventCost, uint ticketsLeft) public {
        _ticketMaster   = msg.sender;
        _eventName      = eventName;
        _eventDate      = eventDate;
        _eventCost      = eventCost;
        _ticketsLeft    = ticketsLeft;
    }
    
    modifier stillTicketsLeft() {
        require(_ticketsLeft > 0);
        _;
    }
    
    modifier onlyTicketMaster() {
        require(_ticketMaster == msg.sender);
        _;
    }
        
    modifier notTicketHolder() {
        require(_ticketHolders[msg.sender]._hasPaid == false);
        _;
    }
    
    function updateTicketsLeft(uint ticketsLeft) public onlyTicketMaster {
        if(_ticketsLeft > 0)
            _ticketsLeft += ticketsLeft;
        else
            _ticketsLeft = ticketsLeft;
    }
    
    function updateEventCost(uint eventCost) public onlyTicketMaster {
        _eventCost = eventCost;
    }
    
    function buyTicket() public payable stillTicketsLeft notTicketHolder{
        require(msg.value >= _eventCost);
        _ticketsLeft--;
        _ticketHolders[msg.sender] = TicketData(true, _eventCost);
        msg.sender.transfer(msg.value - _eventCost);
    }
    
    function refundTicket() public{
        require(_ticketHolders[msg.sender]._hasPaid);
        uint pricePaid = _ticketHolders[msg.sender]._pricePaid;
        delete _ticketHolders[msg.sender];
        msg.sender.transfer(pricePaid);
        _ticketsLeft++; 
    }

}