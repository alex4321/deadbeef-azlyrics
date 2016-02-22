#!/bin/bash
ARTIST=$1
TITLE=$2
ALBUM=$3

ARTIST_CONVERTED=`echo $ARTIST | sed 's/[_ ()]//g' | awk '{print tolower($0)}'`
TITLE_CONVERTED=`echo $TITLE | sed 's/[_ ()]//g' | awk '{print tolower($0)}'`
ALBUM_CONVERTED=`echo $ALBUM | sed 's/[_ ()]//g' | awk '{print tolower($0)}'`

URL="http://www.azlyrics.com/lyrics/$ARTIST_CONVERTED/$TITLE_CONVERTED.html"
USER_AGENT="User-Agent: Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1535.3 Safari/537.36"
ANSWER=`curl -s $URL -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Host: www.azlyrics.com' -H "$USER_AGENT"`
if [ "$?" -ne "0" ]
then
	exit 1
fi

ANSWER_SEDABLE=`echo $ANSWER | tr -s '\r\n' ' '`
SUBTEXT=`echo "$ANSWER_SEDABLE" | sed "s/^.*<!-- Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that. -->//"`
TEXT_HTML=`echo "$SUBTEXT" | sed "s/<br><br> <form id=\"addsong\".*$//" | sed "s/<\/div>//"`
echo "$TEXT_HTML" | w3m -dump -T text/html
