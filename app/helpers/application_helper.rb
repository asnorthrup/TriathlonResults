module ApplicationHelper
#format secs to H:MM:SS
def format_hours secs
	Time.at(secs).utc.strftime("%k:%M:%S") if secs
end
#formats MM:SS
def format_minutes secs
	Time.at(secs).utc.strftime("%M:%S") if secs
end
#round mph decimal places down
def format_mph mph
	mph.round(1) if mph
end

end
