From: Joe Bryant <tenminjoe@yahoo.com>
Subject: Spare drive won't spin down
Date: Thu, 6 May 2010 10:49:06 -0700 (PDT)
Message-ID: <922812.29139.qm@web31703.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello -

I hope some kind soul is able to help. I have configured a RAID1 array - two mirrored drives, one spare. My understanding is that the spare disk should  be allowed to spin down, but it won't. 

When I searched for troubleshooting information, I found talk of work that had been done specifically to allow the spare to spin down - to do with decrementing the event counter instead of incrementing it. So, I'm surprised this doesn't seem to be working in my case.

If I poll /proc/diskstats, I see writes to the spare drive (sdb1) every few seconds.

If I remove the drive from the RAID array, the writes stop and it is able to spin down.

If I do "mdadm --examine /dev/sdb1", I can see the event counter is increasing every two or three seconds.

The kernel is 2.6.32-21-generic - a new Ubuntu 10.04 install.

/proc/mdstat yields:

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : active raid1 sdb1[2](S) sda1[0](W) sdc1[1]
      29295552 blocks [2/2] [UU]
      
md1 : active raid1 sdb5[2](S) sda5[0](W) sdc5[1]
      1951680 blocks [2/2] [UU]
      
unused devices: <none>

Other facts that I don't think should be relevant but you may know better:

- You can see that in fact I have two RAID arrays - md0 is the 
troublesome one.

- md0 contains LVM, which contains ext4, which contains root filesystem.

- sdc is an SSD drive. sda and sdb are spinning disks.

- If I do "cat /sys/block/md0/md/safe_mode_delay" I get "0.210".

- I briefly had write-intent bitmaps set up for both md0 and md1, but I have since removed them.

This box is a fresh build and can be rebuilt if that's necessary to fix 
or diagnose the problem.

Thanks in advance for any help. Linux software RAID is just terrific - I report this minor issue largely because, as I said, it seems like this is something that is *supposed* to work.

--  
Joe Bryant



      
