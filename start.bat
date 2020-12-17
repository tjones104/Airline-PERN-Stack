@ECHO off
START autoresetdatabase.bat
SLEEP 3
START server.bat
START client.bat
EXIT