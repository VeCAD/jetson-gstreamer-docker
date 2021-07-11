Jetson Nano Docker with Gstreamer
=================================

Running the CSI camera with OpenCV and GStreamer on the Nano is sometimes a tricky proposition. 
There are countless topics opened on the Nvidia forums regarding this. 

Running the camera in Docker is a trickier one. 

So putting here, a docker compose package that I managed to get some decent stability 
running the camera for extended period of time after scouring the NV forums and Github.

Got this running on Nano B01 model with single camera connected to camera 0 slot. 
Ensure docker and docker-compose installed on the host system.
L4T 32.4.4 used for both host system and image. 

```
docker-compose build
docker-compose run nano bash
```

TODO: Update capture.py with full capture function. 
