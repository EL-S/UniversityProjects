<?php
    // https://stackoverflow.com/questions/686155/remove-a-cookie

    // check if the username cookie is set
    
    if (isset($_COOKIE['username'])) {
        
        // it is set so now we unset it

        unset($_COOKIE['username']);
        $res = setcookie('username', null, -1);
    }

    // now check the password cookie

    if (isset($_COOKIE['password'])) {

        // it is set, remove it

        unset($_COOKIE['password']);
        $res = setcookie('password', null, -1);
    }

    // finally, redirect to the homepage

    header("Location: index.php");
    die();
?>