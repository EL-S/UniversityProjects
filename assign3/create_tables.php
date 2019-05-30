<?php

    require_once ("settings.php");

    function check_table_exists($conn, $table_name) {

        // https://stackoverflow.com/questions/6432178/how-can-i-check-if-a-mysql-table-exists-with-php/24623531

        $sql = "select 1 from '{$table_name}' LIMIT 1";

        $result = mysqli_query($conn, $sql);

        return $result;
    }

    function create_database($conn, $sql) {
        mysqli_query($conn, $sql);
    }

    $conn = new mysqli($host, $user, $pass, $db);

    if ($conn->connect_error) {
        die(); //kill the script if there is a connection issue with the db
    }

    if (!check_table_exists($conn, "users")) {
        create_database($conn, "CREATE TABLE users (
            ID int NOT NULL AUTO_INCREMENT,
            username varchar(255) NOT NULL,
            password varchar(255) NOT NULL,
            PRIMARY KEY (ID)
        )");
    }

    if (!check_table_exists($conn, "eoi")) {
        create_database($conn, "CREATE TABLE eoi (
            EOInum int NOT NULL AUTO_INCREMENT,
            jobrefnum varchar(5) NOT NULL,
            firstname varchar(20) NOT NULL,
            lastname varchar(20) NOT NULL,
            address varchar(255) NOT NULL,
            postcode int(4) NOT NULL,
            email varchar(255) NOT NULL,
            phonenumber varchar(12) NOT NULL,
            dateofbirth varchar(255) NOT NULL,
            gender varchar(255) NOT NULL,
            state varchar(3) NOT NULL,
            skills varchar(255) NOT NULL,
            otherskills int(1) NOT NULL,
            otherskillsarea varchar(1024) NOT NULL,
            status varchar(255) NOT NULL,
            PRIMARY KEY (EOInum)
        )");
    }
?>