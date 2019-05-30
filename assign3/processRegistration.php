<?php

    function sanitize_input($input_data) {

        $output_data = trim($input_data);

        return $output_data;
    }

    function check_username($username, $conn) {

        // https://bobby-tables.com/php

        $stmt = $conn->prepare('SELECT username FROM users WHERE username = ?');
        $stmt->bind_param('s',$username);
        $stmt->execute();
        
        // https://www.php.net/manual/en/mysqli-stmt.fetch.php

        $stmt->bind_result($result);
        $stmt->fetch();

        if ($result) {
            // username already exists
            $result = false;
        } else {
            // unique username
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

            if (!check_username($username, $conn)) {
                // username already exists
                header("Location: register.php");
                die();
            } else {
                // unique username
                // https://www.w3schools.com/php/func_string_md5.asp
            
                $md5_password = md5($password);

                // https://bobby-tables.com/php

                $stmt = $conn->prepare('INSERT INTO users (username, password) VALUES (?, ?)');
                $stmt->bind_param('ss', $username, $md5_password);
                $stmt->execute();
                $stmt->close();
                $conn->close();

                header("Location: login.php");
                die();
            }

        } else {
            // registration details not sent
            header("Location: register.php");
            die();
        }
    } else {
        // Not a POST request
        header("Location: register.php");
        die();
    }

?>