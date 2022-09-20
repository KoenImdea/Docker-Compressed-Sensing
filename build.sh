docker build -t python-slim --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) --secret id=passwd,src=passwd.txt .
