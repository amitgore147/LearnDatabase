(function executeRule(current, previous /*null when async*/) {
    // Check if the incident was newly assigned
    if (current.assigned_to != previous.assigned_to && current.assigned_to != '') {
        var grUserRole = new GlideRecord('sys_user_has_role');
        grUserRole.addQuery('role.name', 'incident_support');
        grUserRole.addQuery('user', current.assigned_to);
        grUserRole.query();

        // If the user doesn't already have the role, assign it
        if (!grUserRole.next()) {
            var role = new GlideRecord('sys_user_has_role');
            role.initialize();
            role.user = current.assigned_to;
            role.role = 'incident_support';
            role.insert();
        }
    }
})(current, previous);




(function executeRule() {
    // Query all users who have the incident_support role
    var grUserHasRole = new GlideRecord('sys_user_has_role');
    grUserHasRole.addQuery('role.name', 'incident_support');
    grUserHasRole.query();

    while (grUserHasRole.next()) {
        var userId = grUserHasRole.user;

        // Check if the user has any active incidents assigned
        var grIncident = new GlideRecord('incident');
        grIncident.addActiveQuery(); // Only check active incidents
        grIncident.addQuery('assigned_to', userId);
        grIncident.query();

        // If no incidents are assigned to the user, remove the role
        if (!grIncident.hasNext()) {
            grUserHasRole.deleteRecord(); // Remove the role
        }
    }
})();
