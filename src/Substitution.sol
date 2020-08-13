// SPDX-License-Identifier: GPL V3
pragma solidity ^0.6.7;

import './Logic.sol';

library Substitution {
	using Logic for Term;

	struct Info {
		mapping (uint => mapping (bytes32 => Term)) frames;
		uint[][] usedKeys;
	}

	function set(Info storage _info, Term memory _term1, Term memory _term2) internal {
		set(_info, _term1.hashMemory(), _term2);
	}

	function set(Info storage _info, bytes32 _hash, Term memory _term) internal {
		require(_info.usedKeys.length > 0);

		uint frame = _info.usedKeys.length - 1;
		set(_info.frames[frame][_hash], _term);
		_info.usedKeys[frame].push(uint(_hash));
	}

	function set(Term storage _to, Term memory _from) internal {
		_to.fromMemory(_from);
	}

	function get(Info storage _info, bytes32 _hash) internal view returns (Term memory) {
		require(_info.usedKeys.length > 0);

		uint frame = _info.usedKeys.length - 1;
		return _info.frames[frame][_hash];
	}

	function get(Info storage _info, Term memory _term) internal view returns (Term memory) {
		return get(_info, _term.hashMemory());
	}

	function push(Info storage _info) internal {
		_info.usedKeys.push();
	}

	function pop(Info storage _info) internal {
		require(_info.usedKeys.length > 0);

		uint frame = _info.usedKeys.length - 1;
		for (uint i = 0; i < _info.usedKeys[frame].length; ++i)
			delete _info.frames[frame][bytes32(_info.usedKeys[frame][i])];
		_info.usedKeys.pop();
	}
}
