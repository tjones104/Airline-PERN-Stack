@Echo off
cd server
call npm install
cd client
call npm install
cd..
cd..
START start.bat