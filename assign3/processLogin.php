<?php

    function sanitize_input($input_data) {

        $output_data = trim($input_data);

        return $output_data;
    }

    function check_password($username, $password, $conn) {

        // https://www.w3schools.com/php/func_string_md5.asp

        $password_md5 = md5($password);

        // https://bobby-tables.com/php

        $stmt = $conn->prepare('SELECT password FROM users WHERE username = ?');
        $stmt->bind_param('s',$username);
        $stmt->execute();
        
        // https://www.php.net/manual/en/mysqli-stmt.fetch.php

        $stmt->bind_result($password_md5_valid);
        $stmt->fetch();
        $stmt->close();
        $conn->close();

        if ($password_md5_valid !== $password_md5) {
            // incorrect password
            $result = false;
        } else {
            $result = true;
        }

        return $result;
    }

    require_once ("settings.php");

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // POST request
        
        if (isset($_POST['username']) && isset($_POST['password'])) {
        
            $username = sanitize_input($_POST['username']);
            $password = sanitize_input($_POST['password']);

            $conn = new mysqli($host, $user, $pass, $db);

            if ($conn->connect_error) {
                die(); //kill the script if there is a connection issue with the db
            }

            if (!check_password($username, $password, $conn)) {
                // details incorrect
                header("Location: login.php");
                die();
            } else {
                // details correct
                // https://www.w3schools.com/php/func_string_md5.asp
            
                setcookie("username", $username);
                setcookie("password", md5($password)); 
                
                header("Location: manage.php");
                die();
            }

        } else {
            // login details not sent
            header("Location: login.php");
            die();
        }
    } else {
        // Not a POST request
        header("Location: login.php");
        die();
    }

?>