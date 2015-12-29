# twonkyserver

This is a Dockerfile setup for Twonkyserver - http://Twonky.com/

To run:

```
docker run -d --net=host --name=Twonkyserver -v /path/to/config:/config:rw -v /path/to/data:/data:ro -v /etc/localtime:/etc/localtime:ro dlaventu/twonkyserver
```

After install go to:

http://server:9000/webconfig
