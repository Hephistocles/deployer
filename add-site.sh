#!/bin/bash 

# loop through lines of our config file
while read p; do
  
  # load any variables in by executing (shut up it's dangerous)
  # when we come across a blank line - that's the end of the section and we should setup a deployment
  # NB file must end with a blank line!
  
  if [ -n "$p" ]; then
     eval $p;
  else
	  if [ -z "$NAME" ] || [ -z "$PORT" ] || [ -z "$COMD" ] || [ -z "$SLUG" ]; then
		echo "Some variable is missing: $NAME $SLUG $PORT $COMD";
		exit 1;
	  fi

  	  # check upstart has not already seen this configuration
  	  if [ ! -f /etc/init/$SLUG.conf ]; then
	  	  sed "s#{NAME}#$NAME#" upstart.template |
	  	  sed "s#{PORT}#$PORT#" | 
	  	  sed "s#{COMD}#$COMD#" | 
	  	  sed "s@{SLUG}@$SLUG@"  > upstart.conf

	  	  if init-checkconf upstart.conf ; then
	  	  	  mv upstart.conf /etc/init/$SLUG.conf
	  	  else
		  	  echo "Failed upstart init-checkconf upstart.conf"
	  	  fi
  	  else 
  	  	echo "Refused to replace upstart config for $SLUG"
  	  fi


  	  if [ ! -f /etc/nginx/sites-available/$SLUG ]; then
	  	  sed "s#{PORT}#$PORT#" nginx.template |
	  	  sed "s#{DOMS}#$DOMS#" > nginx.conf

	  	  echo "http {" > wrapper.conf
	  	  cat nginx.conf >> wrapper.conf
	  	  echo "}events {worker_connections 768;}" >> wrapper.conf

	  	  if nginx -t -c $(pwd)/wrapper.conf; then
	  	  	mv nginx.conf /etc/nginx/sites-available/$SLUG

	  	  	if [ ! -e /etc/nginx/sites-enabled/$SLUG ]; then
		  	  sudo ln -s /etc/nginx/sites-available/$SLUG /etc/nginx/sites-enabled/$SLUG
	  	  	else
		  	  echo "Refused to replace nginx symlink for $SLUG"
	  	  	fi
	  	  	
	  	  else 
	  	  	echo "Failed nginx -t -c $(pwd)/wrapper.conf"
	  	  fi
  	  else
  	  	echo "Refused to replace nginx config for $SLUG"
  	  fi

	  # RESET variables for next time
	  NAME=""
	  PORT=""
	  COMD=""
	  SLUG=""
  fi   
done <apps.config
