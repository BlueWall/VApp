<?php

  define ('_XAP','OK');

  $cfgDir = getcwd() . "/etc";
  $incDir = getcwd() . "/include";

  // It is good to place this outside of the htdocs area
  require_once $cfgDir.'/config.inc';

  static $args = array(); 
  static $module;

  foreach ($_POST as $key => $val ) {

    $i = 0;

    switch($key) {
        case 'module':
            $module = $val;
            break;

        case 'application':
            $application = $val;
            break;

        case 'command':
            $command = $val;
            break;

        default:
            $args[$key] = $val;
            $i++;
    }
  }

  include $application.'/'.$module.'/module.php';

  $func = $module.'_'.$command;

  $func($args);

?>
