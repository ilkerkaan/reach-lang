pragma abicoder v2;

pragma solidity ^0.8.0;

struct T6 {
  uint256 v79;
  }
struct T7 {
  uint256 time;
  T6 msg;
  }

contract LogAttack2  {
  constructor () payable {
  }

  event e2(T7 _a);
  function m2() external payable {
    T7 memory a;
    a.time = 0;
    a.msg.v79 = 1337;
    emit e2(a);
  }
}
