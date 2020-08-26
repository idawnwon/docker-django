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
## 3. 5 questions would be prompted, answer each one. Or just hit enter to accept the default value.
``` shell
Here are 5 questions to answer: 

(1/5) Work directory [hit ENTER directly to accept default: "/Users/dawnwon/django"]: 

(2/5) Project name [hit ENTER directly to accept default: "local_django"]: 

(3/5) Database name [hit ENTER directly to accept default: "djangodb"]: 

(4/5) Database USER name [hit ENTER directly to accept default: "admin"]: 

(5/5) Database PASSWORD [hit ENTER directly to accept default: "admin1234"]: 

```
