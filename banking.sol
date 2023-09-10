// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Bank {
    uint256 public loanLimit;

    struct User {
        uint256 amountDeposited;
        uint256 timeStamp;
    }

    struct Loan {
        string Type;
        uint256 loanAmount;
        uint256 noOfEmiPending;
        uint256 EmiAmount;
        uint256 EMItimestamp;
    }

    mapping(address => User) public UserAddress;

    mapping(string => mapping(address => Loan)) private LoanType;
    event amountDeposited(address sender, string message, uint256 value);
    event amountWithdrawn(address sender, string message, uint256 value);
    event carLoanProcessed(
        address account,
        string message,
        uint256 value,
        uint256 forTime
    );
    event homeLoanProcessed(
        address account,
        string message,
        uint256 value,
        uint256 forTime
    );
    event personalLoanProcessed(
        address account,
        string message,
        uint256 value,
        uint256 forTime
    );
    event EMIPaid(address account, string message, string Type, uint256 value);

    function getTotalBankBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function AddLoanLimit() public payable {
        require(msg.value > 0, "Plzz deposite some amount");
        loanLimit += msg.value;
    }

    function deposit() public payable {
        require(msg.value > 0, "Plzz deposite some amount");

        UserAddress[msg.sender].amountDeposited += msg.value;

        UserAddress[msg.sender].timeStamp = block.timestamp;

        emit amountDeposited(msg.sender, "has deposited", msg.value);
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "Plzz withdraw some amount");
        require(UserAddress[msg.sender].amountDeposited != 0, "No data exist");
        require(
            block.timestamp - UserAddress[msg.sender].timeStamp > 1 minutes,
            "Need to wait 1 minutes before withdraw"
        );
        require(amount <= UserAddress[msg.sender].amountDeposited);

        UserAddress[msg.sender].amountDeposited -= amount;

        payable(msg.sender).transfer(amount);

        emit amountWithdrawn(msg.sender, "has withdrawn", amount);
    }

    function getCarLoan(uint256 loanAmount, uint256 timeInMonths)
        public
        payable
    {
        loanValidator(msg.sender, loanAmount, timeInMonths);

        uint256 rate = 12;

        uint256 EMI = calculateEmi(rate, loanAmount, timeInMonths);

        LoanType["Car"][msg.sender].Type = "Car";

        LoanType["Car"][msg.sender].EmiAmount += EMI;

        LoanType["Car"][msg.sender].noOfEmiPending += timeInMonths;

        LoanType["Car"][msg.sender].loanAmount += loanAmount;

        UserAddress[msg.sender].amountDeposited += loanAmount;

        loanLimit -= loanAmount;
        emit carLoanProcessed(
            msg.sender,
            "has got car loan of",
            loanAmount,
            timeInMonths
        );
    }

    function getHomeLoan(uint256 loanAmount, uint256 timeInMonths)
        public
        payable
    {
        loanValidator(msg.sender, loanAmount, timeInMonths);

        uint256 rate = 16;

        uint256 EMI = calculateEmi(rate, loanAmount, timeInMonths);

        LoanType["Home"][msg.sender].Type = "Home";

        LoanType["Home"][msg.sender].EmiAmount += EMI;

        LoanType["Home"][msg.sender].noOfEmiPending += timeInMonths;

        LoanType["Home"][msg.sender].loanAmount += loanAmount;

        UserAddress[msg.sender].amountDeposited += loanAmount;

        loanLimit -= loanAmount;
        emit homeLoanProcessed(
            msg.sender,
            "has got home loan of",
            loanAmount,
            timeInMonths
        );
    }

    function getPersonalLoan(uint256 loanAmount, uint256 timeInMonths)
        public
        payable
    {
        loanValidator(msg.sender, loanAmount, timeInMonths);

        uint256 rate = 20;

        uint256 EMI = calculateEmi(rate, loanAmount, timeInMonths);

        LoanType["Personal"][msg.sender].Type = "Personal";

        LoanType["Personal"][msg.sender].EmiAmount += EMI;

        LoanType["Personal"][msg.sender].noOfEmiPending += timeInMonths;

        LoanType["Personal"][msg.sender].loanAmount += loanAmount;

        UserAddress[msg.sender].amountDeposited += loanAmount;

        loanLimit -= loanAmount;
        emit personalLoanProcessed(
            msg.sender,
            "has got personal loan of",
            loanAmount,
            timeInMonths
        );
    }

    function loanValidator(
        address sender,
        uint256 Amount,
        uint256 time
    ) private view returns (bool) {
        require(UserAddress[sender].amountDeposited != 0, "No data exist");

        require(
            Amount <= loanLimit && Amount >= 1000,
            "Amount should be greater than 1000 and less then loan Limit"
        );

        require(time > 1 && time < 120, "time should be in range 1 to 120");

        return true;
    }

    function calculateEmi(
        uint256 rate,
        uint256 loanAmount,
        uint256 timeInMonths
    ) private pure returns (uint256) {
        uint256 perMonth = 1200;
        uint256 interest = (((loanAmount * rate) / perMonth) *
            (((perMonth + rate) / perMonth) ^ timeInMonths)) /
            ((((perMonth + rate) / perMonth) ^ timeInMonths) - 1);

        uint256 EMI = (interest + loanAmount) / timeInMonths;
        return EMI;
    }

    function getCarLoanDetails()
        public
        view
        returns (
            string memory Type,
            uint256 loanAmount,
            uint256 noOfEmiPending,
            uint256 EmiAmount
        )
    {
        string memory _type = "Car";
        return loanDetails(_type, msg.sender);
    }

    function getHomeLoanDetails()
        public
        view
        returns (
            string memory Type,
            uint256 loanAmount,
            uint256 noOfEmiPending,
            uint256 EmiAmount
        )
    {
        string memory _type = "Home";
        return loanDetails(_type, msg.sender);
    }

    function getPersonalLoanDetails()
        public
        view
        returns (
            string memory Type,
            uint256 loanAmount,
            uint256 noOfEmiPending,
            uint256 EmiAmount
        )
    {
        string memory _type = "Personal";
        return loanDetails(_type, msg.sender);
    }

    function loanDetails(string memory _type, address add)
        private
        view
        returns (
            string memory Type,
            uint256 loanAmount,
            uint256 noOfEmiPending,
            uint256 EmiAmount
        )
    {
        return (
            LoanType[_type][add].Type,
            LoanType[_type][add].loanAmount,
            LoanType[_type][add].noOfEmiPending,
            LoanType[_type][add].EmiAmount
        );
    }

    function payEMI(string memory Type) public payable {
        require(
            keccak256(abi.encode(Type)) == keccak256(abi.encode("Car")) ||
                keccak256(abi.encode(Type)) == keccak256(abi.encode("Home")) ||
                keccak256(abi.encode(Type)) ==
                keccak256(abi.encode("Personal")),
            "please enter valid loan type i.e Car or Personal or Home"
        );
        require(
            LoanType[Type][msg.sender].noOfEmiPending != 0,
            "No EMI pending"
        );
        require(
            msg.value == LoanType[Type][msg.sender].EmiAmount,
            "Please send valid amount of Emi"
        );
        require(
            block.timestamp - LoanType[Type][msg.sender].EMItimestamp > 30 days,
            "Need to wait 1 month after paying last EMI"
        );

        UserAddress[msg.sender].amountDeposited -= LoanType[Type][msg.sender]
            .EmiAmount;

        LoanType[Type][msg.sender].noOfEmiPending -= 1;

        LoanType[Type][msg.sender].loanAmount -= LoanType[Type][msg.sender]
            .EmiAmount;

        LoanType[Type][msg.sender].EMItimestamp = block.timestamp;

        loanLimit += LoanType[Type][msg.sender].EmiAmount;

        emit EMIPaid(msg.sender, "has paid his emi of", Type, msg.value);
    }
}
