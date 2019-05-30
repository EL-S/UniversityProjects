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
                    <h3>Javascript Active Nav</h3>
					<p>Interaction Required / Programming Required:</p>
					<p>Observe the nav bar on any page, it will select the current active page and change the colour, using JS. The programming required is a selection of the element by ID and then accessing the className attribute and then overriding it to the activenav class. A custom window.onload event was used to ensure that there was little delay, even on the index page which loads a video.</p>
					<p>Where:</p>
					<p>Every nav bar on <a href="index.php">every page</a>, the nav elements show which page is currently selected.</p>
					<p>Source: <a href="https://developer.mozilla.org/en-US/docs/Web/API/Document/readyState">Mozilla Developer</a></p>
                </div>
                <div class="right-left">
					<h2>Enhancement 2</h2>
                    <h3>Dynamic Job Page</h3>
					<p>Interaction Required / Programming Required:</p>
					<p>All job data including the hidden value for the apply page is dynamically added to the page using JS. Programming required includes multiline strings (templates) and a fast method of adding it to the page before the images/external dependencies are loaded. The fast loading approach was similarly used for changing the active navbar in the other enhancement.</p>
					<p>Where:</p>
					<p>The <a href="jobs.php">Jobs</a> page, view the HTML for it and you will see that there is no job data inside it. All the information is added through JS. Yet you can not see the information being added on runtime.</p>
					<p>Source: <a href="https://stackoverflow.com/questions/22260836/innerhtml-prepend-text-instead-of-appending">StackOverflow</a></p>
                </div>
            </article>
        </div>
        <?php include "footer.inc"; ?>
    </body>
</html>