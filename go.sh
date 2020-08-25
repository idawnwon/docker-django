sw_vers=$(which sw_vers)
if [ -n "$sw_vers" ]; then
  if_is_mac=$(sw_vers -productName | grep Mac)
fi


echo -n "Work directory (hit ENTER directly to accept default: ~/Documents/django ): "
read workdir
if [[ -z "$workdir" ]]; then
  workdir=~/Documents/django
fi

echo

echo -n "Project name: "
read project

echo

echo -n "Database name (hit ENTER directly to accept default: djangodb ): "
read DB_NAME
if [[ -z "$DB_NAME" ]]; then
  DB_NAME=djangodb
fi

echo

echo -n "Database user name (hit ENTER directly to accept default: admin ): "
read DB_USR
if [[ -z "$DB_USR" ]]; then
  DB_USR=admin
fi

echo

echo -n "Database user password (hit ENTER directly to accept default: admin1234 ): "
read DB_PASS
if [[ -z "$DB_PASS" ]]; then
  DB_PASS=admin1234
fi

echo

docker_engine=$(which docker)

if [[ -z "$docker_engine" ]]; then
  bash <(curl -s https://raw.githubusercontent.com/killDevils/PublicSource/master/install_docker_and_compose.sh)
fi

if [[ ! -d "$workdir" ]]; then
  mkdir -p $workdir
  echo "Work directory established: $workdir"
fi
cd $workdir

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

docker-compose run web django-admin startproject $project .

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

echo "Go to 'http://localhost:8000' your django starter site!"
docker-compose up
