// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Logger {
    struct Log {
        uint256 time;
        string msg;
    }

    Log public lastLog;
    Log[] public logStack;

    event LogEvent(uint256 time, string msg, address caller, address sender);

    function log(
        string memory _msg,
        address caller,
        address sender
    ) public {
        lastLog = Log({msg: _msg, time: block.timestamp});
        logStack.push(lastLog);
        emit LogEvent(block.timestamp, _msg, caller, sender);
    }

    /*
  function toAsciiString(address x) public pure returns (string memory) {
    bytes memory s = new bytes(40);
    for (uint i = 0; i < 20; i++) {
        bytes1 b = bytes1(uint8(uint(uint160(x)) / (2 ** (8 * (19 - i)))));
        bytes1 hi = bytes1(uint8(b) / 16);
        bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
        s[2 * i] = char(hi);
        s[2 * i + 1] = char(lo);
    }
    return string(s);
  }
  
  function char(bytes1 b) private pure returns (bytes1 c) {
    if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
    else return bytes1(uint8(b) + 0x57);
  }
  */
}
