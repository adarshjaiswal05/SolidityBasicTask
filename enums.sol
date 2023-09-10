pragma solidity ^0.8.0;

contract Example {
    enum Car {
        OFF,
        ON
    }

    Car ignition;

    function ignitionOn() public {
        ignition = Car.ON;
    }

    function ignitionOff() public {
        ignition = Car.OFF;
    }

    function getignitionState() public view returns (Car) {
        return ignition ;
    }
}
