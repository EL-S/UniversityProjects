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
				<h1 class="family-font">Expression of Interest</h1>
                <div class="left-left">
					<h2>Your Application Result</h2>
<?php

    function sanitize_input($input_data) {

        $output_data = trim($input_data);

        return $output_data;
    }

    function validate_input($name, $error) {

        if (isset($_POST[$name])) {
            if ($name == "skills") {
                $input_data = implode(",", $_POST[$name]);
            } else {
                $input_data = $_POST[$name];
            }
        } else {
            $input_data = "";
            if ($name != "otherskills" && $name != "skills") {
                $error .= "<p>{$name} is empty!</p>";
            }
        }

        $output_data = sanitize_input($input_data);

        // https://www.w3schools.com/php7/php7_switch.asp
        // https://www.php.net/manual/en/function.preg-match.php
        
        switch ($name) {
            case "jobrefno":
                if (strlen($output_data) !== 5) {
                    $error .= "<p>Your Job Reference Number must be exactly 5 characters.</p>";
                }
                if (!preg_match('/^[a-zA-Z0-9]+$/', $output_data)) {
                    $error .= "<p>Your Job Reference Number must be alphanumeric.</p>";    
                }
                break;
            case "firstname":
                if (strlen($output_data) > 20) {
                    $error .= "<p>Your First Name must be less than 20 characters.</p>";
                }
                if (!preg_match('/^[a-zA-Z]+$/', $output_data)) {
                    $error .= "<p>Your First Name must only contain letters.</p>";    
                }
                break;
            case "lastname":
                if (strlen($output_data) > 20) {
                    $error .= "<p>Your Last Name must be less than 20 characters.</p>";
                }
                if (!preg_match('/^[a-zA-Z]+$/', $output_data)) {
                    $error .= "<p>Your Last Name must only contain letters.</p>";    
                }
                break;
            case "address":
                if (strlen($output_data) > 40) {
                    $error .= "<p>Your Address must be less than 40 characters.</p>";
                }
                break;
            case "postcode":
                if (strlen($output_data) !== 4) {
                    $error .= "<p>Your Postcode must be exactly 4 characters.</p>";
                }
                if (!preg_match('/^[0-9]+$/', $output_data)) {
                    $error .= "<p>Your Postcode must only contain numbers.</p>";
                }
                break;
            case "email":
                // https://www.w3schools.com/php/php_form_url_email.asp

                if (!filter_var($output_data, FILTER_VALIDATE_EMAIL)) {
                    $error .= "<p>Your email is invalid.</p>";
                }
                break;
            case "phonenumber":
                if (strlen($output_data) > 12 || strlen($output_data) < 8) {
                    $error .= "<p>Your Phone Number must be between 12 and 8 characters.</p>";
                }
                if (!preg_match('/^[0-9\s]+$/', $output_data)) {
                    $error .= "<p>Your Phone Number must only contain numbers and spaces.</p>";
                }
                break;
            case "dateofbirth":
                list($dd,$mm,$yyyy) = explode('/',$output_data);
                if (!checkdate($mm,$dd,$yyyy)) {
                        $error .= "<p>Your Date of Birth is invalid.</p>";
                }
                break;
            case "gender":
                if (strlen($output_data) === 0) {
                    $error .= "<p>Your gender must be selected</p>";
                }
                break;
            case "state":
                https://www.php.net/manual/en/function.in-array.php
                if (!in_array($output_data, array("vic", "nsw", "qld", "wa", "nt", "sa", "act", "tas"))) {
                    $error .= "<p>Your State is invalid.</p>";
                }
                break;
            case "skills":
                // nothing is required
                break;
            case "otherskills":
                if ($output_data != "") {
                    $output_data = true;
                } else {
                    $output_data = false;
                }
                break;
            case "otherskillsarea":
                // nothing to do here
                break;
        }

        // https://stackoverflow.com/questions/3451906/multiple-returns-from-function
        
        return array($error, $output_data);
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // POST
        // https://www.php.net/manual/en/language.exceptions.php

        $error = "";

        // parse all the input and validate easy stuff
        list($error, $jobrefno) = validate_input("jobrefno", $error);
        list($error, $firstname) = validate_input("firstname", $error);
        list($error, $lastname) = validate_input("lastname", $error);
        list($error, $address) = validate_input("address", $error);
        list($error, $postcode) = validate_input("postcode", $error);
        list($error, $email) = validate_input("email", $error);
        list($error, $phone_number) = validate_input("phonenumber", $error);
        list($error, $date_of_birth) = validate_input("dateofbirth", $error);
        list($error, $gender) = validate_input("gender", $error);
        list($error, $state) = validate_input("state", $error);
        list($error, $skills) = validate_input("skills", $error);
        list($error, $otherskills) = validate_input("otherskills", $error);
        list($error, $otherskillstextarea) = validate_input("otherskillsarea", $error);
        $status = "New";
        
        // check postcode
        switch ($state) {
            case "vic":
                if ($postcode[0] != 3 && $postcode[0] != 8) {
                    $error .= "<p>Your postcode does not match your state.</p>";
                }
                break;
            case "nsw":
                if ($postcode[0] != 1 && $postcode[0] != 2) {
                    $error .= "<p>Your postcode does not match your state.</p>";
                }
                break;
            case "qld":
                if ($postcode[0] != 4 && $postcode[0] != 9) {
                    $error .= "<p>Your postcode does not match your state.</p>";
                }
                break;
            case "nt":
                if ($postcode[0] != 0) {
                    $error .= "<p>Your postcode does not match your state.</p>";
                }
                break;
            case "wa":
                if ($postcode[0] != 6) {
                    $error .= "<p>Your postcode does not match your state.</p>";
                }
                break;
            case "act":
                if ($postcode[0] != 0) {
                    $error .= "<p>Your postcode does not match your state.</p>";
                }
                break;
            case "sa":
                if ($postcode[0] != 5) {
                    $error .= "<p>Your postcode does not match your state.</p>";
                }
                break;
            case "tas":
                if ($postcode[0] != 7) {
                    $error .= "<p>Your postcode does not match your state.</p>";
                }
                break;
            default:
                break;
        }

        // calculate age
        // https://stackoverflow.com/questions/3776682/php-calculate-age

        $birthDate = explode("/", $date_of_birth);
        $age = (date("md", date("U", mktime(0, 0, 0, $birthDate[0], $birthDate[1], $birthDate[2]))) > date("md") ? ((date("Y") - $birthDate[2]) - 1) : (date("Y") - $birthDate[2]));

        if ($age > 80 || $age < 15) {
            $error .= "<p>Your age is not appropriate.</p>";
        }

        if ($otherskills == true) {
            $otherskills = 1;
            if ($otherskillstextarea === "") {
                $error .= "<p>Your other skills is empty.</p>";
            }
        } else {
            $otherskills = 0;
        }

        // Now execute the query if there is no errors

        if ($error) {
            echo $error;
        } else {

            require_once ("settings.php");

            $conn = new mysqli($host, $user, $pass, $db);

            if ($conn->connect_error) {
                die(); //kill the script if there is a connection issue with the db
            }

            // https://bobby-tables.com/php

            $stmt = $conn->prepare('INSERT INTO eoi (jobrefnum, firstname, lastname, address, postcode, email, phonenumber, dateofbirth, gender, state, skills, otherskills, otherskillsarea, status)
                                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)');
            $stmt->bind_param('ssssissssssiss', $jobrefno, $firstname, $lastname, $address, $postcode, $email, $phone_number, $date_of_birth, $gender, $state, $skills, $otherskills, $otherskillstextarea, $status);
            $stmt->execute();
            // https://www.w3schools.com/php/php_mysql_insert_lastid.asp
            $EOINum = mysqli_insert_id($conn);
            echo "<p>Your Expression of Interest Number is: {$EOINum}.</p>";
            $stmt->close();
            $conn->close();
        }
    } else {
        // no direct URL access
        header("Location: jobs.php");
        die();
    }

?>
                </div>
            </article>
        </div>
        <?php include "footer.inc"; ?>
    </body>
</html>