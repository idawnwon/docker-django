# docker-django
The content of this repo strictly followed official guide of Docker.com, which aims to set up and run a simple Django/PostgreSQL app. It is suitable for quick deploy a local django development environment. (https://docs.docker.com/compose/django/)

# Prerequisites

This repo was tested on Mac OS X 10.15.6, and Ubuntu 20.04.1 LTS. But I think it would be good to run on some earlier versions of Mac and Ubuntu.
I believe it is not suitable for Windows.
If you are interests on modifying a better version capable for Windows, feel free to pull requests.


# Usage
## 1. Go to home folder, download `start.sh` , make it executable. Your administration password would be required.
``` shell
cd ~
curl -O https://raw.githubusercontent.com/idawnwon/docker-django/master/start.sh
sudo chmod +x start.sh
```
## 2. Run `start.sh`
### If you are on Mac:
``` shell
zsh start.sh
```
### If you are on Ubuntu:
``` shell
./start.sh
```
## 3. Five questions would be prompted, answer each one. Or just hit enter to accept the default value.
``` shell
Here are 5 questions to answer: 

(1/5) Work directory [hit ENTER directly to accept default: "/Users/dawnwon/django"]: 

(2/5) Project name [hit ENTER directly to accept default: "local_django"]: 

(3/5) Database name [hit ENTER directly to accept default: "djangodb"]: 

(4/5) Database USER name [hit ENTER directly to accept default: "admin"]: 

(5/5) Database PASSWORD [hit ENTER directly to accept default: "admin1234"]: 

```
## 4. If you didn't have Docker and Docker Composer installed:
### If you are on Mac, you will see:
```shell
It seems that you didn't have Docker Desktop installed on your mac. 
Please install it and start over. 
Download a stable version:
https://download.docker.com/mac/stable/Docker.dmg
```
Docker Desktop contains Docker and Docker Composer.
### If you are on Linux:
```shell
It seems that you didn't have Docker and Docker Compose installed.
Do you wanna install them automatically right now?
```
If you say no, the script would quit. 
Then, later on, you can choose to install them your self, or run `bash <(curl -s https://raw.githubusercontent.com/idawnwon/docker-django/master/bin/install_docker_and_compose.sh)` to install quickly. Come back and run `start.sh` again.
## 5. Final step
You would see:
```shell
################################################################
# CONGRATULATIONS!
# Your local django environment is ready!
# Go to 'http://localhost:8000' to view your django welcome page!
################################################################

Starting django_db_1 ... done
Starting django_web_1 ... done
```
This means the script reaches the end.
Do not close the current shell, use browser to visit http://localhost:8000 to see the welcome page.
