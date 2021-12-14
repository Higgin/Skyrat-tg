

/proc/send_ooc_to_other_server(exp_name, message)
	if(!CONFIG_GET(flag/enable_cross_server_ooc))
		return FALSE
	var/list/ooc_information = list()
	ooc_information["server_name"] = CONFIG_GET(string/cross_comms_name)
	ooc_information["expected_name"] = exp_name
	var/name_to_send = CONFIG_GET(string/cross_comms_name) ? CONFIG_GET(string/cross_comms_name) : station_name()
	send2otherserver(html_decode(name_to_send), message, "incoming_ooc_message", "all", additional_data = ooc_information)
	return TRUE

/datum/world_topic/incoming_ooc_message
	keyword = "incoming_ooc_message"
	require_comms_key = TRUE

/datum/world_topic/incoming_ooc_message/Run(list/input)
	var/server_name = input["server_name"]
	var/exp_name = ckey(input["expected_name"])
	var/message = input["message"]

	send_ooc_message("CROSS OOC: [server_name] - [exp_name]", message)

/proc/send_ooc_message(sender_name, message)
	if(!GLOB.ooc_allowed)
		return
	for(var/client/C in GLOB.clients)
		if(C.prefs.chat_toggles & CHAT_OOC)
			if(GLOB.OOC_COLOR)
				to_chat(C, span_oocplain("<font color='[GLOB.OOC_COLOR]'><b><span class='prefix'>OOC:</span> <EM>[sender_name]:</EM> <span class='message linkify'>[message]</span></b></font>"))
			else
				to_chat(C, span_ooc("<b><span class='prefix'>OOC:</span> <EM>[sender_name]:</EM> <span class='message linkify'>[message]</span></b>"))
