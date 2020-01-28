# Install OpenCV 4 on Raspberry Pi 4

There is a great tutorial made by Adrian Rosebrock, over on [Pyimagesearch](https://www.pyimagesearch.com/2019/09/16/install-opencv-4-on-raspberry-pi-4-and-raspbian-buster/). I used that to install OpenCV on my Pi and it worked great.<br/>
So all credits go to him, this is basically just an extraction of his work.<br/>
Check out the original [here](https://www.pyimagesearch.com/2019/09/16/install-opencv-4-on-raspberry-pi-4-and-raspbian-buster/).

I assume you have Raspberry Pi with Raspbian Buster installed on it.
If you haven't installed Raspbian yet, check out [this tutorial](https://github.com/sanyi0411/Tutorials/tree/master/Raspberry%20Pi/Raspberry%20Pi%204%20headless%20setup).

I am not going to go into details on what these commands do and why need that, for that see the original tutorial.<br/>
Run these commands in this order:<br/>

`$ sudo apt-get update && sudo apt-get upgrade`<br/>
`$ sudo apt-get install build-essential cmake pkg-config`<br/>
`$ sudo apt-get install libjpeg-dev libtiff5-dev libjasper-dev libpng-dev`<br/>
`$ sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev`<br/>
`$ sudo apt-get install libxvidcore-dev libx264-dev`<br/>
`$ sudo apt-get install libfontconfig1-dev libcairo2-dev`<br/>
`$ sudo apt-get install libgdk-pixbuf2.0-dev libpango1.0-dev`<br/>
`$ sudo apt-get install libgtk2.0-dev libgtk-3-dev`<br/>
`$ sudo apt-get install libatlas-base-dev gfortran`<br/>
`$ sudo apt-get install libhdf5-dev libhdf5-serial-dev libhdf5-103`<br/>
`$ sudo apt-get install libqtgui4 libqtwebkit4 libqt4-test python3-pyqt5`<br/>
<br/>
The python part:<br/>
`$ sudo apt-get install python3-dev`<br/>
`$ wget https://bootstrap.pypa.io/get-pip.py`<br/>
`$ sudo python get-pip.py`<br/>
`$ sudo python3 get-pip.py`<br/>
`$ sudo rm -rf ~/.cache/pip`<br/>
`$ sudo pip install virtualenv virtualenvwrapper`<br/>
<br/>
Open the `bashrc` file:<br/>
`$ nano ~/.bashrc`<br/>
<br/>
And append the following to the bottom of the file:<br/>
```
# virtualenv and virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
```
Save and exit<br/>
<br/>
`$ source ~/.bashrc`<br/>
`$ mkvirtualenv cv -p python3`<br/>
`$ pip install "picamera[array]"`<br/>
<br/>
The following is the fast method for installing OpenCV. To compile it from source check out the original tutorial.<br/>
`$ pip install opencv-contrib-python==4.1.0.25`

At the end you should get a **Successfully installed opencv-contrib-python...** message