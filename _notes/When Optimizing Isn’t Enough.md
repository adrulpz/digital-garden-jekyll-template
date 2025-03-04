---
---

My Final Attempt at Installing ROS 2 on my Raspberry Pi 3

After optimizing my **Raspberry Pi 3**, I was finally ready to use **ROS 2**—or so I thought. I had switched to a **lighter desktop environment**, installed a **more efficient browser**, and expanded **swap space to 8GB**. The system felt noticeably smoother, and I was ready to take on the real challenge.

The installation appeared to complete successfully as I had left it running overnight—no warnings, no error messages—so I assumed everything was fine. But when I tried to run **ROS 2**, nothing happened. The issue wasn’t just with launching it; **the entire build process seemed to have failed**.

Determined to get it working, I started a fresh attempt by running a **full ROS 2 build**:

```bash 
colcon build --symlink-install
```

It didn’t work, but I wasn’t ready to give up. So, I tried reducing parallel jobs, installing in smaller batches, and even manually rebuilding key dependencies—but the crashes kept coming. Sometimes, progress was painfully slow; other times, it crashed without warning.

**Limited parallel jobs to avoid overloading RAM:**
```bash 
colcon build --symlink-install --parallel-workers 1
```

**Manually built key dependencies first**:
```bash 
colcon build --symlink-install --packages-select ament_cmake ament_cmake_gen_version_h
```

**Installed in smaller batches instead of one massive build:**
```bash 
colcon build --symlink-install --packages-select $(colcon list | awk 'NR>=1 && NR<=10 {print $1}')

```

I spent time debugging, installing missing dependencies, and skipping failed packages when necessary. But at some point, it became clear: **even if I got ROS 2 installed, the performance would likely be too slow to be useful.**

That doesn’t mean I’m giving up on ROS 2. I’ll probably give it another try on a **newer model with better specs**, or I might just use a **dedicated Ubuntu machine**. For now, it’s clear that the **Pi 3 isn’t the right tool for this job**.

Still, this was a valuable learning experience. I now have a much better understanding of what it takes to **compile large software projects on low-power hardware**.

If you’re considering running ROS 2 on a **Raspberry Pi 3**, I’d strongly recommend **against it**—it’ll save you a lot of time and frustration.

**Previous Post :** [[From Laggy to Usable]]



