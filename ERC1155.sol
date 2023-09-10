// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
import "./IERC1155.sol";

contract multipleToken is IERC1155 {
    mapping(uint256 => mapping(address => uint256)) _balances;

    // Mapping from account to operator approvals
    mapping(address => mapping(address => bool)) _operatorApprovals;

    // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
    string private _uri;

    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] _ids,
        uint256[] _values
    ) external {
        //The caller must be approved to spend the tokens for the _from address or the caller must equal _from
        require(
            _operatorApprovals[_operatorApprovals][msg.sender] == true ||
                _from == msg.sender,
            "you are not authorized to tranfer tokens"
        );
        require(_to != addess(0), "you cant tranfer to zero address");
        require(
            _ids.length == _values.length,
            "length of id is not equal to length of value"
        );

        for (uint256 x = 0; x < _values.length; x++) {
            require(
                _balances[_ids[x]][_from] >= _values[x],
                "not sufficient balance in address" + _from + "of id" + _ids[x]
            );

            _balances[_ids[x]][_from] += _values[x];
        }
    }

    function balanceOf(address _owner, uint256 _id)
        external
        view
        returns (uint256)
    {
        require(_balances[_id][_owner], "account not found");

        return _balances[_id][_owner];
    }

    function balanceOfBatch(address[] _owners, uint256[] _ids)
        external
        view
        returns (uint256[] memory)
    {
        require(
            _ids.length == _values.length,
            "length of id is not equal to length of value"
        );

        for (uint256 x = 0; x < _values.length; x++) {
            require(
                _balances[_ids[x]][_owners[x]],
                "account not found of address" + _from + "with id" + _ids[x]
            );

            return _balances[_ids[x]][_owners[x]];
        }
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        require(
            _operator != addess(0),
            "you cant give approval to zero address"
        );
        _operatorApprovals[msg.sender][_operator] = true;
    }

    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool)
    {
        require(_operatorApprovals[msg.sender][_operator], "invalid data");
        return _operatorApprovals[msg.sender][_operator];
    }
}
