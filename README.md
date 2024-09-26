(function executeRule(current, previous /*null when async*/) {

    // Log the Incident number and short description
    gs.info('Incident Updated: ' + current.number + ' - ' + current.short_description);

})(current, previous);
