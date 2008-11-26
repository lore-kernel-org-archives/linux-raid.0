From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: raid6: cpu time vs. sync_speed_max / system interactivity
Date: Wed, 26 Nov 2008 11:56:27 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811261103530.18457@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

# cat /sys/devices/virtual/block/md3/md/sync_action
repair

I had the raid6 limited to 90000 kbytes/sec but my system was 
unresponsive, I dropped it down to 85000 kbytes/sec it was a bit better, I 
reduced to 75000 kbytes/sec:

   508  echo 85000 > /sys/block/md3/md/sync_speed_max
   509  echo 75000 > /sys/block/md3/md/sync_speed_max

And while my system was still a bit lagged, I could use it, it seems like 
something should go into the kernel so it does not monopolize the system, 
the raid6 processes:

   PID USER      PR  NI  VIRT SWAP  RES  SHR S %CPU %MEM   TIME P COMMAND
   676 root      15  -5     0    0    0    0 R  100  0.0 131:29 2 md3_raid5
23331 root      15  -5     0    0    0    0 D   36  0.0  17:26 0 md3_resync

The RAID1 (2 separate disks) should not be affected on a quad core system?

Justin.
