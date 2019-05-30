<?php

    function sanitize_input($input_data) {

        $output_data = trim($input_data);

        return $output_data;
    }

    function check_password($username, $password_md5, $conn) {

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

    if (isset($_COOKIE['username']) && isset($_COOKIE['password'])) {

        $username = sanitize_input($_COOKIE['username']);
        $password_md5 = sanitize_input($_COOKIE['password']);

        $conn = new mysqli($host, $user, $pass, $db);

        if ($conn->connect_error) {
            die(); //kill the script if there is a connection issue with the db
        }

        if (!check_password($username, $password_md5, $conn)) {
            // details incorrect
            header("Location: login.php");
            die();
        }
        
    } else {
        // login not set
        header("Location: login.php");
        die();
    }

?>