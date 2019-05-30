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
				<h1 class="family-font">Welcome</h1>
                <div class="left">
					<h2>About us</h2>
                    <p>ZenStreet® is a registered technology consultation company that is dedicated to giving consumers a high-end networking set-up for their office and business space.</p>
					<p>For business enquiries, please contact <a href="mailto:102560865@student.swin.edu.au">102560865@student.swin.edu.au</a></p>
					
                </div>
				<div class="right">
					<h2>Company Location</h2>
                    <p>ZenStreet® Tech Consultation Firm is located at 156 John Street, Hawthorn Victoria 3122. For a more personal experience, come into the firm during business hours, which are as follows:</p>
					<dl>
						<dt>Mon - Fri:</dt>
						<dd>8:00 AM - 9:00 PM<br /></dd>
						<dt>Sat - Sun:</dt>
						<dd>12:00 PM - 9:00 PM</dd>
					</dl>
                </div>
				<div class="left">
					<h2>Promotional Video</h2>
                    <!-- video from youtube -->
					<div class="vid-container">
						<embed src="https://www.youtube.com/embed/h-YgIY0g3Nk" frameborder="0" allowfullscreen class="vid" />
					</div>
					<p>Source: <a href="https://www.youtube.com/embed/h-YgIY0g3Nk">DSpacesTV</a></p>
				</div>
            </article>
        </div>
		<?php include "footer.inc"; ?>
    </body>
</html>