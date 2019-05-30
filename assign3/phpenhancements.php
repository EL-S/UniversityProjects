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
				<h1 class="family-font">Enhancements 2</h1>
                <div class="left-left">
					<h2>Enhancement 1</h2>
                    <h3>Login/Registration System</h3>
					<p>Interaction Required / Programming Required:</p>
					<p>When attempting to navigate to a page that should be secured, or a page where sensitive database commands can be executed, the browser cookies are checked for a username and a hashed password. If the password hash doesn't match the database hash it will redirect the user to the login page.</p>
					<p>Where:</p>
					<p>Every sensitive page, etc <a href="manage.php">Manage</a> and <a href="login.php">Login</a>. A new user can be registered <a href="register.php">here</a>. The username and password to login are <br />Username: admin <br />Password: password</p>
					<p>Source: <a href="about.php">Personal Experience</a></p>
                </div>
                <div class="right-left">
					<h2>Enhancement 2</h2>
                    <h3>Logout</h3>
					<p>Interaction Required / Programming Required:</p>
					<p>When the user is on the management page, there is a button with the wording 'Logout'. When the button is clicked, the cookies are cleared and then the user is promptly redirected to the homepage so that they can continue using the site</p>
					<p>Where:</p>
					<p>The <a href="manage.php">Manage</a> page, If the user is not logged in, they will first be directed to the userpage. The username and password is Admin and password respectively. Now, click on the log out button and visit the manage page after the redirect. The user will not be logged in again.</p>
					<p>Source: <a href="https://stackoverflow.com/questions/686155/remove-a-cookie">StackOverflow</a></p>
                </div>
            </article>
        </div>
        <?php include "footer.inc"; ?>
    </body>
</html>