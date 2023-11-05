vncserver :1 -geometry 1920x1080
vpid=`cat $HOME/.vnc/*pid`
while ps -p $vpid >/dev/null ; do
   sleep 5
done