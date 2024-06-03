// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Proposal {
        string name;
        string image; // Ajout du champ d'image
        uint voteCount;
    }

    mapping(address => bool) public voters;
    Proposal[] public proposals;

    event ProposalAdded(string proposalName, string proposalImage);
    event ProposalDeleted(uint proposalIndex);
    function addProposal(string memory proposalName, string memory proposalImage) public {
        proposals.push(Proposal({
        name: proposalName,
        image: proposalImage,
        voteCount: 0
        }));
        emit ProposalAdded(proposalName, proposalImage);
    }

    function vote(uint256 _candidateIndex) public {
        require(!voters[msg.sender], "You have already voted.");
        require(_candidateIndex < proposals.length, "Invalid candidate index.");

        proposals[_candidateIndex].voteCount++;
        voters[msg.sender] = true;
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

    function getProposals() public view returns (string[] memory names, string[] memory images, uint[] memory voteCounts) {
        names = new string[](proposals.length);
        images = new string[](proposals.length);
        voteCounts = new uint[](proposals.length);

        for (uint i = 0; i < proposals.length; i++) {
            Proposal storage proposal = proposals[i];
            names[i] = proposal.name;
            images[i] = proposal.image;
            voteCounts[i] = proposal.voteCount;
        }
    }
    function deleteProposal(uint _proposalIndex) public {
        require(_proposalIndex < proposals.length, "Invalid proposal index");

        uint lastIndex = proposals.length - 1;
        proposals[_proposalIndex] = proposals[lastIndex];

        proposals.pop();

        emit ProposalDeleted(_proposalIndex);
    }

}
