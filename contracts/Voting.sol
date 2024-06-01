// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Proposal {
        string name;
        uint voteCount;
    }

    struct Voter {
        bool voted;
        uint vote;
        uint weight;
    }

    address public chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    event ProposalAdded(string proposalName);

    constructor() {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
    }

    function addProposal(string memory proposalName) public {
        require(msg.sender == chairperson, "Only chairperson can add proposals.");
        proposals.push(Proposal({
        name: proposalName,
        voteCount: 0
        }));
        emit ProposalAdded(proposalName);
    }

    function giveRightToVote(address voter) public {
        require(msg.sender == chairperson, "Only chairperson can give right to vote.");
        require(!voters[voter].voted, "The voter already voted.");
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote.");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }

    function winningProposal() public view returns (uint winningProposal_) {
        uint winningVoteCount = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }
        }
    }

    function winnerName() public view returns (string memory winnerName_) {
        winnerName_ = proposals[winningProposal()].name;
    }

    function getProposals() public view returns (string[] memory names, uint[] memory voteCounts) {
        names = new string[](proposals.length);
        voteCounts = new uint[](proposals.length);

        for (uint i = 0; i < proposals.length; i++) {
            Proposal storage proposal = proposals[i];
            names[i] = proposal.name;
            voteCounts[i] = proposal.voteCount;
        }
    }
}
