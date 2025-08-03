// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// SimpleTodo contract allows users to manage their own personal task list on the blockchain
contract SimpleTodo {
    // The Sreehari(owner) of the contract
    address public owner;

    // Structure of a single Todo task
    struct Todo {
        string task;     
        bool completed;  // Status of the task (true if completed)
    }

    // Mapping from a user address to their array of Todo tasks
    mapping(address => Todo[]) private userTodos;

    // Events to notify off-chain apps of changes
    event TaskAdded(address indexed user, uint indexed taskId, string task);
    event TaskCompleted(address indexed user, uint indexed taskId);
    event TaskRemoved(address indexed user, uint indexed taskId);

    constructor() {
        owner = msg.sender;
    }

    // Function to add a new task 
    function addTask(string memory _task) public {
        require(bytes(_task).length > 0, "Task cannot be empty.");

        userTodos[msg.sender].push(Todo(_task, false));
        emit TaskAdded(msg.sender, userTodos[msg.sender].length - 1, _task);
    }

    // Function to mark a task as completed
    function completeTask(uint _index) public {
        require(_index < userTodos[msg.sender].length, "Invalid task index.");

        userTodos[msg.sender][_index].completed = true;
        emit TaskCompleted(msg.sender, _index);
    }

    // Function to remove a task from the user's list
    function removeTask(uint _index) public {
        require(_index < userTodos[msg.sender].length, "Invalid task index.");

        // Swap with the last task and pop to avoid leaving a gap
        uint lastIndex = userTodos[msg.sender].length - 1;
        userTodos[msg.sender][_index] = userTodos[msg.sender][lastIndex];
        userTodos[msg.sender].pop();

        // Emit event indicating which task was removed
        emit TaskRemoved(msg.sender, _index);
    }

    // View function to get all of the caller's tasks
    function getMyTasks() public view returns (Todo[] memory) {
        return userTodos[msg.sender];
    }

    // View function to get the number of tasks the caller has
    function getMyTaskCount() public view returns (uint) {
        return userTodos[msg.sender].length;
    }
}
