(function executeRule(current, previous /*null when async*/) {

    // Define Priority based on Impact and Urgency
    var impact = current.impact;     // Get the current Impact value
    var urgency = current.urgency;   // Get the current Urgency value
    var newPriority;

    // Logic to set priority based on Impact and Urgency
    if (impact == 1 && urgency == 1) {
        newPriority = 1; // Critical
    } else if (impact == 1 && urgency == 2 || impact == 2 && urgency == 1) {
        newPriority = 2; // High
    } else if (impact == 2 && urgency == 2) {
        newPriority = 3; // Medium
    } else if (impact == 3 || urgency == 3) {
        newPriority = 4; // Low
    }

    // Set the new priority if it has changed
    if (newPriority != current.priority) {
        current.priority = newPriority;
        gs.info('Priority set to ' + newPriority + ' for Incident ' + current.number);
    }

})(current, previous);
