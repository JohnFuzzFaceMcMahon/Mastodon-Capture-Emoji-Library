BEGIN {
	# A quick and dirty hack by John McMahon
	
	# Uses gawk is a good idea
	# Uses curl
	# Uses jq
	
	# What instance?
	if (ARGV[1] != "") {
		Instance = ARGV[1]
	} else {
		print "What Instance?"
		exit 1
	}
	# Init
	shortcode = "BLANK"
	url = "BLANK"
	category = "BLANK"
	# Pull the index and "pretty print" it
	cmd = "curl --silent https://" Instance "/api/v1/custom_emojis | jq ."
	for (; (cmd | getline inp) > 0; ) {
		# Sample Entry
		# {
		#	"shortcode": "110",
		#	"url": "https://cdn.mastodon.technology/custom_emojis/images/000/000/011/original/b57214e1385b1a4e.png",
		#	"static_url": "https://cdn.mastodon.technology/custom_emojis/images/000/000/011/static/b57214e1385b1a4e.png",
		#	"visible_in_picker": true,
		#	"category": "Memes"
		# },
		
		# get rid of pesky quotes and commas
		gsub("\"", "", inp)
		gsub(",", "", inp)
		# break the line into individual array elements
		split(inp, items, FS)
		if (items[1] == "{") {
			# start a new entry
			shortcode = "EMPTY"
			url = "EMPTY"
			static_url = "EMPTY"
			category = "EMPTY"
		}
		if (items[1] == "shortcode:") {
			shortcode = items[2]
		}
		if (items[1] == "url:") {
			url = items[2]
		}
		if (items[1] == "static_url:") {
			static_url = items[2]
		}
		if (items[1] == "category:") {
			category = items[2]
		}
		if (items[1] == "}") {
			# end of entry, get the file listed in url!
			# calculate the file type
			filetype = url
			gsub("^.*[.]", "", filetype)
			# calculate the full filename
			filename = category "___" shortcode "." filetype
			# get the file
			print "Downloading (" ++DownloadCount ")" filename " from " url
			cmd2 = "curl --silent " url " >" filename
			system(cmd2)
			close(cmd2)

			# This may be unneeded.
			if (url != static_url) {
				# end of entry, get the file listed in static url!
				# calculate the file type
				filetype = static_url
				gsub("^.*[.]", "", filetype)
				# calculate the full filename
				filename = category "___" shortcode "___static." filetype
				# get the file
				print "Downloading (" ++DownloadCount ")" filename " from " static_url " (static)"
				cmd2 = "curl --silent " static_url " >" filename
				system(cmd2)
				close(cmd2)
			} else {
				print "Skipping " filename " from " static_url " (static)"
			}
			
		}
	}
	close(cmd)
}

