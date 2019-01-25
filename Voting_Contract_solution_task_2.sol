pragma solidity >=0.4.22 <0.6.0;

contract Poll {

    // object with properties of a voter
    struct Voter {
        bool blocked;
        bool voted;
        uint vote;
    }

    // object with properties of a proposal
    struct Proposal {
        string name;
        uint voteCount;
        address creator;
    }

    // Ethereum address of the poll creator
    address public chairperson;

    // maps an arbitrary Ethereum address on the voter-Object
    mapping(address => Voter) public voters;
    
    // creates a list for all added proposalso
    Proposal[] public proposals;

    // constructor function gets called when the contract is deployed
    constructor() public {
        chairperson = msg.sender;
    }
    
    // function to add a proposal others can vote for
    function addProposal(string memory proposalName) public {
        proposals.push(
            Proposal(proposalName, 0, msg.sender)
        );
    }
    
    function blockAddress(address _blockedAddress) public {
        require(msg.sender == chairperson, "You do not have the permission to block addresses!");
        voters[_blockedAddress].blocked = true;
    }
    
    // function to vote for a proposal
    function vote(uint proposalNumber) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "Already voted.");
        require(!sender.blocked, "You do not have permissions to vote.");
        sender.voted = true;
        sender.vote = proposalNumber;
        proposals[proposalNumber].voteCount += 1;
    }

    // function to count out the votes and determine a winner
    function winningProposal() public view returns (uint winningProposalNumber) {
        uint winningVoteCount = 0;
        
        // iterate the array to determine the winner
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposalNumber = p;
            }
        }
    }

    // function to print out the name of the winning proposal
    function winnerName() public view returns (string memory winnerName_) {
        require(proposals.length!=0, "There is no proposal in the list!");
        winnerName_ = proposals[winningProposal()].name;
    }

}