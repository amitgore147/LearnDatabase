(function executeAction() {

    // Create a new Problem Task record
    var task = new GlideRecord('problem_task');
    task.initialize();

    // Set fields in the Problem Task record
    task.problem_id = current.sys_id; // Link it to the current problem
    task.short_description = 'Problem Task for ' + current.number;
    task.state = 1; // Set the state to Open (or any initial state)

    // Insert the Problem Task record
    var taskID = task.insert();

    // Add a message to indicate that the Problem Task was created
    gs.addInfoMessage('Problem Task ' + task.getDisplayValue('number') + ' created successfully.');

    // Redirect the user to the new Problem Task (optional)
    action.setRedirectURL(task);

})(current);
