# Connecting to Raspberry Pi via bluetooth

Pairing to your Pi with your phone or laptop is the same as pairing a wireless headset for example.

- Go to your phone's bluetooth setting
- Search for available devices
- Select `Raspberry Pi`

But here comes the difference: After pairing you still won't be able to communicate with your Pi. This is because your Pi is "not paying attention" to the incoming data. 

To make the Pi listen to the incoming messages run this command from the terminal:

`sudo rfcomm watch /dev/rfcomm0 1 /sbin/agetty rfcomm0 linux 115200`

or

`sudo rfcomm listen hci0`

After this you can use a bluetooth serial controller app (like Blueterm) for communication. Just search for `bluetooth serial controller` in your phone's app store.
