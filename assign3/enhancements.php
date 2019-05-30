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
				<h1 class="family-font">Enhancements</h1>
                <div class="left-left">
					<h2>Enhancement 1</h2>
                    <h3>Transitions/Animations</h3>
					<p>Beyond Lectures:</p>
					<p>We were not taught anything about animations/transitions in any lecture so far, they are a part of CSS3.</p>
					<p>Where:</p>
					<p>Every section on every page, the gray elements fade to a lighter gray (as does the font), the apply buttons on the <a href="jobs.php">Jobs</a> page, the photo on the <a href="about.php">About</a> page.</p>
					<p>Explanation/Code:</p>
					<p>"transition: all 0.3s ease" is applied to hover events, causing a smooth transition to any new css rules set.</p>
					<p>Source: <a href="https://stackoverflow.com/questions/10604389/how-do-i-apply-css3-transition-to-all-properties-except-background-position">StackOverflow</a></p>
                </div>
                <div class="right-left">
					<h2>Enhancement 2</h2>
                    <h3>Sticky Nav Bar</h3>
					<p>Beyond Lectures:</p>
					<p>We were not taught about sticky positions in any lecture.</p>
					<p>Where:</p>
					<p>Every navbar on every page. Simply scroll down to see the nav bar go from a relative position to a sticky position. However, the <a href="jobs.php">Jobs</a> page is the longest page and would as such show the effect the best when scrolling down the page.</p>
					<p>Explanation/Code:</p>
					<p>"position: sticky; top: 0px;" applied to the nav bar and/or any parent objects on the navbar.</p>
					<p>Source: <a href="https://www.w3schools.com/css/css_navbar.asp">W3Schools</a></p>
                </div>
            </article>
        </div>
        <?php include "footer.inc"; ?>
    </body>
</html>