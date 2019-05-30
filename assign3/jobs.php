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
				<h1 class="family-font">Job Applications</h1>
                <section class="left-left">
					<form id="job1" action="apply.php" method="post">
						<input type="hidden" name="jobrefno1" id="jobrefno1" value="">
						<input type="submit" value="Apply" class="apply-btn">
					</form>
                </section>
                <section class="right-left">
					<form id="job2" action="apply.php" method="post">
						<input type="hidden" name="jobrefno2" id="jobrefno2" value="">
						<input type="submit" value="Apply" class="apply-btn">
					</form>
                </section>
				<section class="right">
					<h3>Servers</h3>
					<aside id="job-aside">
						<img id="aside-img" src="images/jobs.jpg" alt="Servers" />
						<p>Source: <a href="https://www.joinkumo.com/solutions/servers/">JoinKumo</a></p>
					</aside>
				</section>
            </article>
        </div>
        <?php include "footer.inc"; ?>
    </body>
</html>