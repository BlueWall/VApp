<?php

/*
   Copyright 2012 BlueWall Information Technologies, LLC

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

 */

defined('_XAP') or die ('Restricted');

require_once 'tpconfig.inc';

function menu_categories ($args) {
  global $Driver, $Host, $User, $Password, $Name;

	try {

		$conn = new PDO($Driver.":host=".$Host.";dbname=".$Name, $User, $Password);

	} catch (PDOException $e) {

		die("Error!: " . $e->getMessage() . "<br/>");

	}

	try {

    $query = 'SELECT DISTINCT Category Category FROM Destinations';
		$stmt = $conn->prepare($query);
		$stmt->execute();

	} catch (PDOException $e) {

		 die ("Error!: " . $e->getMessage() . "<br/>");

	}

	$rows = $stmt->rowCount();
  $return = "category|".$args['#user_id']."|";

	while ($row = $stmt->fetch(PDO::FETCH_ASSOC))
	{
    $rows--;
    if ($rows > 0) 
    	$return .= $row['Category']."|";
    else
        $return .= $row['Category'];
  }
 
  print $return;

}

function menu_destinations($args) {
  global $Driver, $Host, $User, $Password, $Name;

	try {

		$conn = new PDO($Driver.":host=".$Host.";dbname=".$Name, $User, $Password);

	} catch (PDOException $e) {

		die("Error!: " . $e->getMessage() . "<br/>");

	}

  $category = $args['category'];
  $query = "SELECT Name FROM Destinations WHERE Category ='$category'";

	try {

		$stmt = $conn->prepare($query);
		$stmt->execute();

	} catch (PDOException $e) {

		 die ("Error!: " . $e->getMessage() . "<br/>");

	}

	$rows = $stmt->rowCount();
  $return = "destination|".$args['#user_id']."|";

	while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {

    $rows--;
    if ($rows > 0) 
    	$return .= $row['Name']."|";
    else
        $return .= $row['Name'];

  }
  print $return;
}

function menu_teleport($args) {
  global $Driver, $Host, $User, $Password, $Name;

	try {

		$conn = new PDO($Driver.":host=".$Host.";dbname=".$Name, $User, $Password);

	} catch (PDOException $e) {

		die("Error!: " . $e->getMessage() . "<br/>");

	}

  $destination = $args['destination'];
  $query = "SELECT Name, TargetRegion, TargetLanding, TargetLookat FROM Destinations WHERE Name ='$destination'";

	try {

		$stmt = $conn->prepare($query);
		$stmt->execute();

	} catch (PDOException $e) {

		 die ("Error!: " . $e->getMessage() . "<br/>");

	}

  $return = "teleport|".$args['#user_id']."|";
  $row = $stmt->fetch(PDO::FETCH_ASSOC);
	$return .= $row['Name']."|";
  $return .= $row['TargetRegion']."|";
  $return .= $row['TargetLanding']."|";
  $return .= $row['TargetLookat'];

  print $return;
}

function menu_clear($args) {
  global $Driver, $Host, $User, $Password, $Name;

	try {

		$conn = new PDO($Driver.":host=".$Host.";dbname=".$Name, $User, $Password);

	} catch (PDOException $e) {

		die("Error!: " . $e->getMessage() . "<br/>");

	}

  $query = "DELETE FROM Destinations";
	$result = $conn->query($query)
		or die('ERROR '.$query);

  print 'dbreset';

}

function menu_program($args) {
  global $Driver, $Host, $User, $Password, $Name;

	try {

		$conn = new PDO($Driver.":host=".$Host.";dbname=".$Name, $User, $Password);

	} catch (PDOException $e) {

		die("Error!: " . $e->getMessage() . "<br/>");

	}

  $query = "INSERT INTO Destinations (Category,Name,TargetRegion,TargetLanding,TargetLookat) VALUES (:category,:name,:region,:target,:lookat)";
	try {

		$stmt = $conn->prepare($query);
		$stmt->bindValue(':category',$args['#category']);
		$stmt->bindValue(':name',$args['#name']);
		$stmt->bindValue(':region',$args['#region']);
		$stmt->bindValue(':target',$args['#target']);
		$stmt->bindValue(':lookat',$args['#lookat']);
		$stmt->execute();

	} catch (PDOException $e) {

		 die ("Error!: " . $e->getMessage() . "<br/>");

	}

  print "program";

}


?>
