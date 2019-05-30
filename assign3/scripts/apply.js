/*
filename: apply.js
author: Jordan Richards
created: 1/05/2019
last modified: 29/05/2019
description: jobs.php, apply.php
*/

"use strict";

function storeData(fieldname, fieldvalue) {
	sessionStorage.setItem(fieldname, fieldvalue);
}

function getData(fieldname) {
	var fieldvalue = sessionStorage.getItem(fieldname);

	return fieldvalue;
}

function fillField(fieldid, fieldvalue) {	

	var fieldelement = document.getElementById(fieldid);
	if (fieldelement != null) {
		var field_element_name = fieldelement.nodeName.toLowerCase();
		if (field_element_name != "textarea") {
			var fieldtype = fieldelement.type;
		} else {
			var fieldtype = "textarea";
		}
		
		if (fieldtype !== "radio" && fieldtype !== "checkbox") {
			fieldelement.value = fieldvalue;
		} else {
			if (fieldvalue == "true") {
				fieldvalue = true;
			} else {
				fieldvalue = false;
			}
			
			fieldelement.checked = fieldvalue;
		}
	}
}

function prefillForm() {
	var fieldids = getFieldIds();
	
	for (var fieldidindex in fieldids) {
		var fieldid = fieldids[fieldidindex];
		var fieldvalue = getData(fieldid);
		if (fieldvalue != null && typeof fieldvalue != "undefined" && fieldvalue != "") {
			fillField(fieldid, fieldvalue);
		}
	}
}

function getValueFromId(fieldid) {

	var fieldelement = document.getElementById(fieldid);
	if (fieldelement != null) {
		var field_element_name = fieldelement.nodeName.toLowerCase();
		
		if (field_element_name != "textarea") {
			var fieldtype = fieldelement.type;
		} else {
			var fieldtype = "textarea";
		}

		if (fieldtype == "radio" || fieldtype == "checkbox") {
			fieldvalue = document.getElementById(fieldid).checked; // the element might have been a checkbox or radio selection
		} else {
			var fieldvalue = fieldelement.value;
		}
		
		return fieldvalue;
	}
}

function getFieldIds() {
	var applyForm = document.getElementById("applyform");
	
	var children = applyform.querySelectorAll('*');;
	
	var fieldids = [];
	
	for (var index in children) {
		var child = children[index];
		var child_type = child.type;
		var child_element_name = child.nodeName;
		if (child_element_name != null) {
			child_element_name = child_element_name.toLowerCase();
			if (child_element_name == "input" || child_element_name == "select" || child_element_name == "textarea") {
				if (child.id != null && typeof child.id != "undefined" && child.id != "") {
					fieldids.push(child.id);
				}
			}
		}
	}
	
	return fieldids;
}

function ageCheck(dateofbirth) {
	var age_result = true;
	
	var date_array = dateofbirth.split("/");
	
	var day = date_array[0];
	var month = date_array[1];
	var year = date_array[2];
	
	
	var birth_time = new Date(year+" "+month+" "+day);
	var birth_year = birth_time.getFullYear();
	
	
	var current_time = new Date();
	var current_year = current_time.getFullYear();
	
	var age = current_year - birth_year;
	
	var current_month = current_time.getMonth();
	var birth_month = birth_time.getMonth();
	
	var months = current_month - birth_month;
	
	if (months < 0 || (months == 0 && current_time.getDate() < birth_time.getDate())) {
        age -= 1;
    }
	
	if (age < 15 || age > 80) {
		age_result = false;
	}
	
	return age_result;
}

function checkState(postcode, state) {
	
	var postcode_result = false;
	
	var states = {"vic":["3", "8"],
			  "nsw":["1", "2"],
			  "qld":["4", "9"],
			  "nt":["0"],
			  "wa":["6"],
			  "sa":["5"],
			  "tas":["7"],
			  "act":["0"]};
	
	var state_values = states[state];
	
	for (var stateindex in state_values) {
		var postcode_first_number = state_values[stateindex];
		if (postcode[0] == postcode_first_number) {
			postcode_result = true;
		}
	}
	
	return postcode_result;
}

function otherSkillsCheck(otherskillstoggle, otherskills) {
	var otherskills_result = true;
	otherskills = otherskills.trim();
	
	if (otherskillstoggle == true && otherskills == "") {
		otherskills_result = false;
	}
	
	return otherskills_result;
}

function validate() {
	var result = true;
	var errmessage = "";
	
	var fieldvalues = {};
	
	var fieldids = getFieldIds();
	
	for (var fieldidindex in fieldids) {
		var fieldid = fieldids[fieldidindex];
		var fieldvalue = getValueFromId(fieldid);
		
		storeData(fieldid, fieldvalue);
		fieldvalues[fieldid] = fieldvalue;
	}
	
	var postcode = fieldvalues["postcode"];
	var state = fieldvalues["state"];
	var otherskillstoggle = fieldvalues["otherskills"];
	var otherskills = fieldvalues["otherskillsarea"];
	var dateofbirth = fieldvalues["dateofbirth"];
	
	if (!ageCheck(dateofbirth)) {
		errmessage += "You must be between 15 and 80 years of age.<br />"
		result = false;
	}
	
	if (!checkState(postcode, state)) {
		errmessage += "Your postcode does not match your state.<br />"
		result = false;
	}
	
	if (!otherSkillsCheck(otherskillstoggle, otherskills)) {
		errmessage += "Your other skills section is empty.<br />"
		result = false;
	}
	
	if (debug) {
		result = true;		
	} else {
		if (!result || errmessage !== "") {
			document.getElementById("errfield").innerHTML = errmessage;
			result = false;
		}
	}

	if (result == true) {
		for (var fieldid in fieldvalues) {
			var fieldvalue = fieldvalues[fieldid];
			
			storeData(fieldid, fieldvalue); // only store data on a successful application
		}
	}
	
	return result;
}

function determinePage() {	
	var apply_form = document.getElementById("applyform");
	
	var page;
	
	if (apply_form == null) {
		page = "jobs";
	} else {
		page = "apply";
	}
	
	return page;
}

function storeJobRefNo(formid) {
	var job_ref_no = document.getElementById("jobrefno"+formid).value;
	
	localStorage.setItem("jobrefno",job_ref_no);
	return true;
}

function processJobRefNo() {
	var form1 = document.getElementById("job1");
	var form2 = document.getElementById("job2");
	form1.onsubmit = function(){storeJobRefNo("1")};
	form2.onsubmit = function(){storeJobRefNo("2")};
}

function applyJobRefNo() {
	var job_ref_no = localStorage.getItem("jobrefno");
	if (job_ref_no !== null) {
		var job_ref_no_field = document.getElementById("jobrefno");
		job_ref_no_field.value = job_ref_no;
		localStorage.removeItem("jobrefno"); //remove the job ref number from local storage after use
	} else {
		window.location.href = "jobs.php";
	}
}

var debug = true;

function init() {
	var page = determinePage();
	if (page == "apply") {
		// apply page code
		prefillForm();		
		applyJobRefNo();
		var applyForm = document.getElementById("applyform");
		applyForm.onsubmit = validate;
	} else if (page == "jobs") {
		// jobs page code
		processJobRefNo();
	}
}

window.onload = init;