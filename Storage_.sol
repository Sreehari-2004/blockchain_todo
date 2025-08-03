// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleTodo {
    address public owner;

    struct Todo {
        string task;
        bool completed;
    }

    mapping(address => Todo[]) private userTodos;

    event TaskAdded(address indexed user, uint indexed taskId, string task);
    event TaskCompleted(address indexed user, uint indexed taskId);
    event TaskRemoved(address indexed user, uint indexed taskId);

    constructor() {
        owner = msg.sender;
    }

    // Add a new task
    function addTask(string memory _task) public {
        require(bytes(_task).length > 0, "Task cannot be empty.");
        userTodos[msg.sender].push(Todo(_task, false));
        emit TaskAdded(msg.sender, userTodos[msg.sender].length - 1, _task);
    }

    // Mark a task as completed
    function completeTask(uint _index) public {
        require(_index < userTodos[msg.sender].length, "Invalid task index.");
        userTodos[msg.sender][_index].completed = true;
        emit TaskCompleted(msg.sender, _index);
    }

    // Remove a task (by swapping with the last and popping)
    function removeTask(uint _index) public {
        require(_index < userTodos[msg.sender].length, "Invalid task index.");
        uint lastIndex = userTodos[msg.sender].length - 1;
        userTodos[msg.sender][_index] = userTodos[msg.sender][lastIndex];
        userTodos[msg.sender].pop();
        emit TaskRemoved(msg.sender, _index);
    }

    // Get all your tasks
    function getMyTasks() public view returns (Todo[] memory) {
        return userTodos[msg.sender];
    }

    // Get total number of your tasks
    function getMyTaskCount() public view returns (uint) {
        return userTodos[msg.sender].length;
    }
}
