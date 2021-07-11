#!/usr/bin/env python3

    # refer https://forums.developer.nvidia.com/t/how-to-close-gstreamer-pipeline-in-python/74753/22
    # for additional appsink parameters "max-buffers=1 drop=True
    # to address camera getting disconnected after awhile
    # the original pipeline is from JetsonHacksNano github
    # https://github.com/JetsonHacksNano/CSI-Camera
    def gstreamer_pipeline(self,
        capture_width=640,
        capture_height=480,
        display_width=640,
        display_height=480,
        framerate=60,
        flip_method=0
        ):
        return (
        "nvarguscamerasrc ! "
        "video/x-raw(memory:NVMM), "
        "width=(int)%d, height=(int)%d, "
        "format=(string)NV12, framerate=(fraction)%d/1 ! "
        "nvvidconv flip-method=%d ! "
        "video/x-raw, width=(int)%d, height=(int)%d, format=(string)BGRx ! "
        "videoconvert ! "
        "video/x-raw, format=(string)BGR ! appsink max-buffers=1 drop=True "
        % (
            capture_width,
            capture_height,
            framerate,
            flip_method,
            display_width,
            display_height
        )
        )
