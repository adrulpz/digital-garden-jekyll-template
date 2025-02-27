### Optimizing My Raspberry Pi Before Installing ROS2  

After deciding to leave the connection issue aside, the next step before installing ROS2 was to improve the overall performance of my Raspberry Pi 3. Initially, the system was extremely slow—to the point that even simple tasks like moving the mouse would cause noticeable lag or momentary freezes. Running ROS2 in this state wouldn’t have been practical, so I focused on optimizing the setup.  

The first major change was switching to **LXQt** (again), a lighter desktop environment. The default Ubuntu interface was too resource-heavy for the Pi 3’s limited hardware, so replacing it with LXQt made navigation much smoother. While it didn’t completely eliminate slowdowns, it was a noticeable improvement.  

Next, I looked for a better browser. Firefox and Chromium were both too demanding, making web browsing sluggish and unresponsive. To fix this, I installed **Falkon**, a lightweight alternative that runs more efficiently on low-power devices. This made a difference in general usability, allowing me to browse without overloading the system.  

Even with these changes, performance was still inconsistent. The system would struggle when opening multiple applications, and I noticed that memory limitations were a significant bottleneck. Since the Raspberry Pi 3 only has 1GB of RAM, I decided to expand the **swap space**, effectively giving the system more virtual memory. This helped reduce freezing and improved multitasking, making the system much more stable.  

To create a larger swap file (8GB in this case), I followed these steps:

1. **Turn Off the Current Swap:** 
```bash 
sudo swapoff -a
```
2. **Resize the Swap File to 8GB:
```bash 
sudo rm /swapfile #Delete the old swap file
sudo fallocate -l 8G /swapfile #Create a new 8GB swap file:
```
3. **Set the correct permissions**
```bash 
sudo chmod 600 /swapfile
```
4. **Format the file as swap space**
```bash 
sudo mkswap /swapfile
```
5. **Enable the new swap**
```bash 
sudo swapon /swapfile
```

While it’s still not the fastest setup, these optimizations have made a significant difference. The Raspberry Pi now runs smoothly enough to start experimenting, and I was finally able to install ROS2. I haven’t tested it yet, but at least now I have a working system ready to go. The next step will be running some actual ROS2 processes and evaluating its performance.


**Previous Post :** [[Reviving My Raspberry Pi]] 
**Next Post:** [[When Optimizing Isn’t Enough]]



