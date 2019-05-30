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
		<script src="scripts/apply.js"></script>
		<script src="scripts/enhancements.js"></script>
        <title>ZenStreet</title>
    </head>
    <body>
		<?php include "header.inc"; ?>
		<?php include "navbar.inc"; ?>
        <div id="content-container">
            <article id="content">
				<h1 class="family-font">Apply for Position</h1>
                <div class="center-left">
					<h2>Job Application</h2>
					<form id="applyform" action="processEOI.php" method="post" novalidate="novalidate">
						<label for="jobrefno">Job Reference Number:</label><br>
						<input type="text" id="jobrefno" name="jobrefno" size="5" placeholder="1234A" pattern="[0-9a-zA-Z]{5}" required readonly="readonly"><br><br>
						<label for="fname">First name:</label><br>
						<input type="text" id="fname" name="firstname" size="20" placeholder="John" pattern="[a-zA-Z]{1,20}" required><br><br>
						<label for="lname">Last name:</label><br>
						<input type="text" id="lname" name="lastname" size="20" placeholder="Smith" pattern="[a-zA-Z]{1,20}" required><br><br>
						<label for="address">Address:</label><br>
						<input type="text" id="address" name="address" size="40" placeholder="29 Fredrick Avenue, Melbourne, Victoria" pattern="[0-9a-zA-Z, ]{1,40}" required><br><br>
						<label for="postcode">Postcode:</label><br>
						<input type="text" id="postcode" name="postcode" size="4" placeholder="3109" pattern="[0-9]{4,4}" required><br><br>
						<label for="email">Email:</label><br>
						<input type="email" id="email" name="email" size="40" placeholder="email@example.com" required><br><br>
						<label for="phonenumber">Phone Number:</label><br>
						<input type="text" id="phonenumber" name="phonenumber" size="12" placeholder="0452347575" pattern="[0-9]{8,12}" required><br><br>
						<label for="dateofbirth">Date of Birth:</label><br>
						<input type="text" id="dateofbirth" name="dateofbirth" size="10" placeholder="04/04/2000" pattern="[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]" required><br><br>
						<fieldset>
							<legend>Gender:</legend><br>
							<label for="male">Male:</label>
							<input type="radio" id="male" name="gender" value="male" required>
							<label for="female">Female:</label>
							<input type="radio" id="female" name="gender" value="female">
							<label for="other">Other:</label>
							<input type="radio" id="other" name="gender" value="other"><br><br>
						</fieldset><br>
						<label for="state">State:</label><br>
						<select id="state" name="state" required>
							<option value="">select state</option>
							<option value="act">Australian Capital Territory</option>
							<option value="nsw">New South Wales</option>
							<option value="nt">Northern Territory</option>
							<option value="qld">Queensland</option>
							<option value="sa">South Australia</option>
							<option value="tas">Tasmania</option>
							<option value="vic">Victoria</option>
							<option value="wa">Western Australia</option>
						</select><br /><br />
						<p>Skills:</p>
						<label for="php">PHP:</label>
						<input type="checkbox" id="php" value="php" name="skills[]">
						<label for="js">JavaScript:</label>
						<input type="checkbox" id="js" value="js" name="skills[]">
						<label for="html">HTML:</label>
						<input type="checkbox" id="html" value="html" name="skills[]">
						<label for="ruby">Ruby:</label>
						<input type="checkbox" id="ruby" value="ruby" name="skills[]">
						<label for="python">Python:</label>
						<input type="checkbox" id="python" value="python" name="skills[]">
						<label for="c">C:</label>
						<input type="checkbox" id="c" value="c" name="skills[]">
						<label for="csharp">C#:</label>
						<input type="checkbox" id="csharp" value="csharp" name="skills[]">
						<label for="cpp">C++:</label>
						<input type="checkbox" id="cpp" value="cpp" name="skills[]">
						<label for="java">Java:</label>
						<input type="checkbox" id="java" value="java" name="skills[]">
						<label for="otherskills">Other Skills:</label>
						<input type="checkbox" id="otherskills" value="Other Skills" name="otherskills"><br><br>
						<label for="otherskillsarea">Other Skills:</label><br>
						<textarea rows=10 cols=50 id="otherskillsarea" name="otherskillsarea" placeholder="Additional Skills..."></textarea><br /><br />
						<span id="errfield"></span><br />
						<input type="submit" value="Submit"/>
						<input type="reset" value="Reset"/>
					</form>
                </div>
            </article>
        </div>
        <?php include "footer.inc"; ?>
    </body>
</html>