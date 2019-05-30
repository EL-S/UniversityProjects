<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
		<meta name="description" content="Assignment Part 1 - WebApps">
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
				<h1 class="family-font">Login</h1>
                <div class="left-left">
					<h2>Management Login</h2>
                    <form method="post" action="processLogin.php">
                        Username: <input type="text" name="username"><br />
                        Password: <input type="password" name="password"><br /><br />

                        <input type="submit" value="Login">
                    </form>
                </div>
            </article>
        </div>
        <?php include "footer.inc"; ?>
    </body>
</html>