#!/usr/bin/perl

##
# Autor: Giovane Boaviagem (copiado do script disponivel em: http://dev-sham.blogspot.com.br/2011/02/scrobble-to-lastfm-using-mpdncmpcpp.html)
# Licença: GPL
##

$TITLE = system('/usr/bin/ncmpcpp --now-playing "{%t}|{%f}"');
$ARTIST = system('/usr/bin/ncmpcpp --now-playing "{%a}|{<unknown>}"');
$ALBUM = system('/usr/bin/ncmpcpp --now-playing "{%b}|{<unknown>}"');
$LENGTH = system('/usr/bin/ncmpcpp --now-playing "%l"');
$TAIL = "by $ARTIST in $ALBUM ($LENGTH)";

system("/usr/bin/notify-send -u normal $TITLE $TAIL"); # send info to libnotify
system("/usr/lib/lastfmsubmitd/lastfmsubmit --artist $ARTIST --title $TITLE --length $LENGTH --album $ALBUM"); # send info to Last.FM

