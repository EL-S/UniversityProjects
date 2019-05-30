/*
filename: enhancements.js
author: Jordan Richards
created: 1/05/2019
last modified: 2/05/2019
description: enhancements2.php
*/

"use strict";

function determinePage() {	
	var current_url = window.location.pathname;
	
	var file_name = current_url.split("/").splice(-1)[0].split(".")[0];
	
	return file_name;
}

function getNavLiElement(page) {
	var nav_li_element = document.getElementById(page);
	if (nav_li_element != null) {
		nav_li_element.className = "activenav";
	}
}

function setActiveNav() {
	var page = determinePage();
	var nav_element = getNavLiElement(page);
}

function updateJobListings() {
	if (determinePage() == "jobs") {
		
		var job_element1 = document.getElementsByClassName("left-left")[0];
		var job_element2 = document.getElementsByClassName("right-left")[0];
		
		var job_id1 = "1337A";
		var job_id2 = "1337B";
		
		var hidden_form1 = document.getElementById("jobrefno1");
		var hidden_form2 = document.getElementById("jobrefno2");
		
		var job1_content = `<h2>Network Engineer (1337A)</h2>
                    <p>Network Engineers are responsible for designing, implementing, monitoring and managing the local and wide area networks of an organisation to ensure maximum uptime for users. The role can include designing system configurations, documenting and managing the installation of a new network, and maintaining and upgrading existing systems as necessary.
					</p><p>Network Engineers will work in-house or be assigned to project management teams working with outside clients. As part of an organisation’s IT team, Network Engineers work closely with Business Analysts, Network Architects and IT Managers. A Network Engineer job description can therefore comprise of:
					</p>
					<h3>Network Engineer duties and responsibilities of the job
					</h3>
					<ul>
						<li>Designing and implementing new network solutions and/or improving the efficiency of current networks</li>
						<li>Installing, configuring and supporting network equipment including routers, proxy servers, switches, WAN accelerators, DNS and DHCP</li>
						<li>Procuring network equipment and managing subcontractors involved with network installation</li>
						<li>Configuring firewalls, routing and switching to maximise network efficiency and security</li>
						<li>Maximising network performance through ongoing monitoring and troubleshooting</li>
						<li>Arranging scheduled upgrades</li>
						<li>Investigating faults in the network</li>
						<li>Updating network equipment to the latest firmware releases for consumers</li>
						<li>Reporting network status to key stakeholders</li>
					</ul>
					
					<h3>Network Engineer job qualifications and requirements</h3>

					<p>Holding a degree and having a technical background will be required to gain a Network Engineer role. Degrees in the following subjects is preferred for this position:</p>

					<ul>
						<li>Computer science</li>
						<li>Computer software/computer systems engineering</li>
						<li>Computer systems and networks</li>
						<li>Electrical/electronic engineering</li>
						<li>Mathematics</li>
						<li>Network security management</li>
						<li>Physics</li>
					</ul>`;
		
		var job2_content = `<h2>Full Stack Developer (1337B)</h2>
                    <p>We are looking for a highly skilled computer programmer who is comfortable with both front and back end programming. Full Stack Developers are responsible for developing and designing front end web architecture, ensuring the responsiveness of applications and working alongside graphic designers for web design features, among other duties.
					</p><p>Full Stack Developers are computer programmers who are proficient in both front and back end coding. Their primary responsibilities include designing user interactions on websites, developing servers and databases for website functionality and coding for mobile platforms.
					</p><p>Full Stack Developers will be required to see out a project from conception to final product, requiring good organizational skills and attention to detail.
					</p><h3>Full Stack Developer Responsibilities:</h3>
					<ol>
						<li>Developing front end website architecture.</li>
						<li>Designing user interactions on web pages.</li>
						<li>Developing back end website applications.</li>
						<li>Creating servers and databases for functionality.</li>
						<li>Ensuring cross-platform optimization for mobile phones.</li>
						<li>Ensuring responsiveness of applications.</li>
						<li>Working alongside graphic designers for web design features.</li>
						<li>Seeing through a project from conception to finished product.</li>
						<li>Designing and developing APIs.</li>
						<li>Meeting both technical and consumer needs.</li>
						<li>Staying abreast of developments in web applications and programming languages.</li>
					</ol>
					<h3>Full Stack Developer Requirements:</h3>
					<ul>
						<li>Degree in Computer Science.</li>
						<li>Strong organizational and project management skills.</li>
						<li>Proficiency with fundamental front end languages such as HTML, CSS and JavaScript.</li>
						<li>Familiarity with JavaScript frameworks such as Angular JS, React and Amber.</li>
						<li>Proficiency with server side languages such as Python, Ruby, Java, PHP and .Net.</li>
						<li>Familiarity with database technology such as MySQL, Oracle and MongoDB.</li>
						<li>Excellent verbal communication skills.</li>
						<li>Good problem solving skills.</li>
						<li>Attention to detail.</li>
					</ul>`;
		var job1_content_after = '<p>Source: <a href="https://www.roberthalf.com.au/our-services/it-technology/network-engineer-jobs">Robert Half</a></p>'
		var job2_content_after = '<p>Source: <a href="https://www.betterteam.com/full-stack-developer-job-description">Better Team</a></p>'
		
		job_element1.insertAdjacentHTML("afterbegin", job1_content);
		job_element2.insertAdjacentHTML("afterbegin", job2_content);
		job_element1.insertAdjacentHTML("beforeend", job1_content_after);
		job_element2.insertAdjacentHTML("beforeend", job2_content_after);
		
		hidden_form1.value = job_id1;
		hidden_form2.value = job_id2;
	}
}

function init() {
	setActiveNav();
	updateJobListings();
}

document.onreadystatechange = function () {
  if (document.readyState == 'interactive') {
    init(); //call the initialise function before the page has finished loading images/external resources (otherwise the navbar and job data would appear laggy/slow to show up)
  }
}