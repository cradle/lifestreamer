#! /bin/sh
erlc lifestreamer.erl
if [ $? -ne 0 ]; then exit; fi;
erl -yaws embedded true -s lifestreamer 
# -pa deps/yaws/ebin deps/erlyweb/ebin