pragma solidity ^0.8.0;

contract Types {
    // created a dynamic array whwere we are inserting element dynamically
    uint256[] public data;

    function length_array() public view returns (uint256) {
        return data.length;
    }

    function insert_array(uint256 element) public {
        data.push(element);
    }

    //deleting an element using its index
    function delet_using_index(uint256 index) public {
        for (uint256 x = index; x < data.length - 1; x++) {
            data[x] = data[x + 1];
        }
        data.pop();
    }

    //deleting an element using its value

    function delet_using_element(uint256 element) public {
        for (uint256 index = 0; index < data.length; index++) {
            if (data[index] == element) {
                for (uint256 x = index; x < data.length - 1; x++) {
                    data[x] = data[x + 1];
                }
                data.pop();
            }
        }
    }

    //creating a fixed size array of length 3
    uint8[3] public data1 = [100, 120, 130];

    function getter(uint256 position) public view returns (uint256) {
        return data1[position];
    }
}
