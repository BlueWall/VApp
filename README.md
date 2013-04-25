
This is a modular php application server for lsl scripts. Included is an example application that creates a programmable, networked teleport system. The server follows a syntax to allow modules to be added and called from the lsl scripts. Note the switch statement in the index.php and see the coresponding tags in the lsl script in the llHTTPRequest, then see the directory structure that follows the application and menu tags.

The values sent from lsl are assigned in the switch statement to form the command which is then executed...

    include $application.'/'.$module.'/module.php';
    $func = $module.'_'.$command;
    $func($args);



