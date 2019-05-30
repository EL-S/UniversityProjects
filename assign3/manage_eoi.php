<?php
require_once ("check_login.php");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // POST

    require_once ("settings.php");

    $conn = new mysqli($host, $user, $pass, $db);

    if ($conn->connect_error) {
        die(); //kill the script if there is a connection issue with the db
    }

    if (isset($_POST['jobrefnodel'])) {
        $del_jobrefno = $_POST['jobrefnodel'];
        // delete all EOIs that have that jobrefno
        $stmt = $conn->prepare('DELETE FROM eoi WHERE jobrefnum = ?');
        $stmt->bind_param('s', $del_jobrefno);
        $stmt->execute();
        $stmt->close();
        $conn->close();

        header("Location: manage.php");
        die();
    } else if (isset($_POST['change_status'])) {
        if (isset($_POST['EOInum'])) {
            $eoinum = $_POST['EOInum'];
            $new_status = $_POST['change_status'];
            if (in_array($new_status, array("New", "Current", "Final"))) { // Prevent incorrect values
                // change the status of EOInum
                $stmt = $conn->prepare('UPDATE eoi SET status = ? WHERE EOInum = ?');
                $stmt->bind_param('si', $new_status, $eoinum);
                $stmt->execute();
                $stmt->close();
                $conn->close();
            }
        }

        header("Location: manage.php");
        die();
    } else {
        header("Location: index.php");
        die();
    }
} else {
    header("Location: index.php");
    die();
}

?>