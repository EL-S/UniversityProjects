<?php require_once ("check_login.php"); ?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
		<meta name="description" content="Assignment Part 3 - WebApps">
		<meta name="keywords" content="ZenStreet,Consultation,Networking,Fullstack">
		<meta name="author" content="Jordan Richards">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="styles/main.css" rel="stylesheet" />
		<link rel="icon" href="favicon.ico" type="image/x-icon" />
		<script src="scripts/enhancements.js"></script>
        <title>ZenStreet</title>
    </head>
    <body>
		<?php include "header.inc"; ?>
		<?php include "navbar.inc"; ?>
        <div id="content-container">
            <article id="content">
				<h1 class="family-font">Manage</h1>
                <div class="left-left-table">
                    <h2>Management Form</h2>
                    <form method="GET" action="manage.php">
                        Job Ref No: <input type="text" name="search_jobrefno" value=""><br />
                        First Name: <input type="text" name="search_firstname" value=""><br />
                        Last Name: <input type="text" name="search_lastname" value="">
                        <input type="submit" value="Search"><br /><br />
                    </form>
                    <form method="POST" action="manage_eoi.php">
                        Delete All: <select name="jobrefnodel" id="jobrefnodel">
                            <option value="1337A">1337A</option>
                            <option value="1337B">1337B</option>
                        </select>
                        <input type="submit" value="Delete">
                    </form>
                    <?php 
                        require_once ("check_login.php");
                        require_once ("settings.php");

                        $conn = new mysqli($host, $user, $pass, $db);

                        if ($conn->connect_error) {
                            die();
                        }

                        // search for a specific set
                        if (isset($_GET['search_jobrefno']) && $_GET['search_jobrefno'] != "") {
                            // search by jobrefno
                            $sql = "SELECT * FROM eoi WHERE jobrefnum = '{$_GET['search_jobrefno']}'";
                        } else if (isset($_GET['search_firstname']) && $_GET['search_firstname'] != "") {
                            if (isset($_GET['search_lastname']) && $_GET['search_lastname'] != "") {
                                // search by both first and last name
                                $sql = "SELECT * FROM eoi WHERE firstname = '{$_GET['search_firstname']}' AND lastname = '{$_GET['search_lastname']}'";
                            } else {
                                // search only by first name
                                $sql = "SELECT * FROM eoi WHERE firstname = '{$_GET['search_firstname']}'";
                            }
                        } else if (isset($_GET['search_lastname']) && $_GET['search_lastname'] != "") {
                            // search only by last name
                            $sql = "SELECT * FROM eoi WHERE lastname = '{$_GET['search_lastname']}'";
                        } else {
                            // select everything
                            $sql = "SELECT * FROM eoi WHERE 1=1";
                        }

                        $result = $conn->query($sql);

                        if ($result->num_rows > 0) {
                            echo "<table><tr><th>EOInum</th><th>JobRefNo</th><th>FirstName</th><th>LastName</th><th>Address</th><th>Postcode</th><th>Email</th><th>PhoneNumber</th><th>DateofBirth</th><th>Gender</th><th>State</th><th>Skills</th><th>OtherSkills</th><th>OtherSkillsArea</th><th>Status</th><th>Change</th></tr>";
                            while($row = $result->fetch_assoc()) {
                                echo "<tr><td>".$row["EOInum"]."</td><td>".$row["jobrefnum"]."</td><td>".$row["firstname"]."</td><td>".$row["lastname"]."</td><td>".$row["address"]."</td><td>".$row["postcode"]."</td><td>".$row["email"]."</td><td>".$row["phonenumber"]."</td><td>".$row["dateofbirth"]."</td><td>".$row["gender"]."</td><td>".$row["state"]."</td><td>".$row["skills"]."</td><td>".$row["otherskills"]."</td><td>".$row["otherskillsarea"]."</td><td>".$row["status"]."</td><td><form method='POST' action='manage_eoi.php'><input type='hidden' name='EOInum' value='".$row["EOInum"]."'><select name='change_status'><option value='New'>New</option><option value='Current'>Current</option><option value='Final'>Final</option></select><input type='submit' value='Apply'></form></td></tr>";
                            }
                            echo "</table>";
                        } else {
                            echo "No results";
                        }
                        $conn->close();
                    ?>
                    <a href="logout.php" class="apply-btn">Logout</a>
                </div>
            </article>
        </div>
        <?php include "footer.inc"; ?>
    </body>
</html>