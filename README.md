// Check if the incident is resolved and priority is P1 or P2
if (current.state == 6 && (current.priority == 1 || current.priority == 2)) {
    
    // Create a new Problem record
    var problemRecord = new GlideRecord('problem');
    problemRecord.newRecord();
    
    // Set Problem attributes
    problemRecord.short_description = "Problem generated from Incident: " + current.number;
    problemRecord.description = "Problem automatically created from Incident: " + current.number + ". Incident details: " + current.short_description;
    problemRecord.incident_reference = current.sys_id;  // Assuming there's an incident reference field in the Problem table
    problemRecord.priority = current.priority;
    problemRecord.state = 1; // Set state to New
    
    // Insert the problem record
    var problemSysId = problemRecord.insert();

    // Add a comment to the incident
    current.work_notes = "A Problem ticket (" + problemRecord.number + ") has been automatically created for this incident.";
}
