source <(curl -s https://raw.githubusercontent.com/idawnwon/docker-django/master/bin/shell_functions.sh)



divider
workdir=~/django
project='local_django'
DB_NAME='djangodb'
DB_USR='admin'
DB_PASS='admin1234'
sw_vers=$(which sw_vers)
if [[ -n "$sw_vers" ]]; then
  if_is_mac=$(sw_vers -productName | grep Mac)
fi
divider
cecho purple "Here are 5 questions to answer:"
divider

cstr yellow "(1/5) Work directory $(cstr green "[hit ENTER directly to accept default: $(cstr white "\"$workdir\"")$(cstr green "]")"): "
read workdir
if [[ -z "$workdir" ]]; then
  workdir=~/django
fi

divider

cstr yellow "(2/5) Project name $(cstr green "[hit ENTER directly to accept default: $(cstr white "\"$project\"")$(cstr green "]")"): "
read project
if [[ -z "$project" ]]; then
  project='local_django'
fi

divider

cstr yellow "(3/5) Database name $(cstr green "[hit ENTER directly to accept default: $(cstr white "\"$DB_NAME\"")$(cstr green "]")"): "
read DB_NAME
if [[ -z "$DB_NAME" ]]; then
  DB_NAME='djangodb'
fi

divider

cstr yellow "(4/5) Database USER name $(cstr green "[hit ENTER directly to accept default: $(cstr white "\"$DB_USR\"")$(cstr green "]")"): "
read DB_USR
if [[ -z "$DB_USR" ]]; then
  DB_USR='admin'
fi

divider

cstr yellow "(5/5) Database PASSWORD $(cstr green "[hit ENTER directly to accept default: $(cstr white "\"$DB_PASS\"")$(cstr green "]")"): "
read DB_PASS
if [[ -z "$DB_PASS" ]]; then
  DB_PASS='admin1234'
fi

divider

echo "
Work directory: $(cstr red "$workdir")
Project name: $(cstr purple "$project")
Database name: $(cstr cyan "$DB_NAME")
Database user name: $(cstr green "$DB_USR")
Database password: $(cstr yellow "$DB_PASS")
"
divider

YesNo

divider

docker_engine=$(which docker)
if [[ -z "$docker_engine" ]] && [[ -n "$if_is_mac" ]]; then
    cecho whiteRed "
    It seems that you didn't have Docker Desktop installed on your mac. 
    Please install it and start over. 
    Download a stable version:
    https://download.docker.com/mac/stable/Docker.dmg  "
    exit 1
elif [[ -z "$docker_engine" ]]; then
    cstr purple "
    It seems that you didn't have Docker and Docker Compose installed.
    Do you wanna install them automatically right now?
    "
    YesNo
    source <(curl -s https://raw.githubusercontent.com/idawnwon/docker-django/master/bin/install_docker_and_compose.sh)
fi

divider

if [[ ! -d "$workdir" ]]; then
  mkdir -p $workdir
  echo "Work directory established: $workdir"
fi

cd $workdir
git clone https://github.com/idawnwon/docker-django.git
mv docker-django/* ./
rm -fR docker-django
sudo chmod -R +x ./


cat << EOF > docker-compose.yml
version: '3'

services:
  db:
    image: postgres
    environment:
      - POSTGRES_DB=$DB_NAME
      - POSTGRES_USER=$DB_USR
      - POSTGRES_PASSWORD=$DB_PASS
  web:
    build: .
    command: python manage.py runserver 0.0.0.0:8000
    volumes:
      - .:/code
    ports:
      - "8000:8000"
    depends_on:
      - db
EOF

if [[ -n "$if_is_mac" ]]; then
  docker-compose run web django-admin startproject $project .
else
  sudo docker-compose run web django-admin startproject $project .
fi

anchor_line=$(awk '/# Database/{ print NR; exit }' $project/settings.py)
start_line=$((anchor_line+2))
end_line=$((start_line+6))

cat > HereFile << EOF
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': '$DB_NAME',
        'USER': '$DB_USR',
        'PASSWORD': '$DB_PASS',
        'HOST': 'db',
        'PORT': 5432,
    }
}
EOF


if [[ -n "$if_is_mac" ]]; then
  echo "Going to change ownership of $workdir: $USER:admin, maybe need ${USER}'s password... "
  sudo chown -R ${USER}:admin $workdir
  sed -i "" "$start_line,${end_line}d" $project/settings.py
  sed -i "" "$start_line r HereFile" $project/settings.py
else
  sudo chown -R $USER:$USER .
  sed -i "$start_line,${end_line}d" $project/settings.py
  sed -i "$start_line r /tmp/HereFile" $project/settings.py
fi


rm HereFile
divider 2
echo "################################################################"
cecho red "
CONGRATULATIONS!
Your local django environment is ready!

Go to 'http://localhost:8000' to view your django welcome page!
"
echo "################################################################"
divider 2

if [[ -n "$if_is_mac" ]]; then
  docker-compose up > /dev/null
else
  sudo docker-compose up > /dev/null
fi
