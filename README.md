# Start Server
For starting server inside the Container user this command:
```bash
docker run -p 27015:27015/udp -v l4d2:/steamcmd -it [imagename] bash
```
## Permission Error
Because the user of the image is steam they can't change any directory in the home directory so if you want to use 
binding volume change the target directory permission with 
```bash
chmod 777 /path/to/directory/games
```
