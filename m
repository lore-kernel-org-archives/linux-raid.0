From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Good news / bad news - The joys of RAID
Date: Fri, 19 Nov 2004 16:28:48 -0500
Message-ID: <200411192128.iAJLSrN12727@www.watkins-home.com>
References: <419E6060.8030000@robinbowes.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <419E6060.8030000@robinbowes.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Robin Bowes' <robin-lists@robinbowes.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Reminder....
Never buy Maxtor drives again!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Robin Bowes
Sent: Friday, November 19, 2004 4:07 PM
To: linux-raid@vger.kernel.org
Subject: Good news / bad news - The joys of RAID

The bad news is I lost another disk tonight. Remind me *never* to buy 
Maxtor drives again.

The good news is that my RAID5 array was configured as 5 + 1 spare. I 
powered down the server, used the Maxtor PowerMax utility to identify 
the bad disk, pulled it out and re-booted. My array is currently re-syncing.

[root@dude root]# mdadm --detail /dev/md5
/dev/md5:
         Version : 00.90.01
   Creation Time : Thu Jul 29 21:41:38 2004
      Raid Level : raid5
      Array Size : 974566400 (929.42 GiB 997.96 GB)
     Device Size : 243641600 (232.35 GiB 249.49 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 5
     Persistence : Superblock is persistent

     Update Time : Fri Nov 19 20:52:58 2004
           State : dirty, resyncing
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 128K

  Rebuild Status : 0% complete

            UUID : a4bbcd09:5e178c5b:3bf8bd45:8c31d2a1
          Events : 0.1765551

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2
        2       8       34        2      active sync   /dev/sdc2
        3       8       50        3      active sync   /dev/sdd2
        4       8       66        4      active sync   /dev/sde2


Thinking about what happened, I would have expected that the bad drive 
would just be removed from the array and spare activated and re-syncing 
started automatically.

What actually happened was that I rebooted to activate a new kernel and 
the box didn't come back up. As the machine runs headless, I had to 
power it off and take it to a monitor/keyboard to check it. In the new 
location it came up fine so I shut it down again and put it back in my 
"server room" (read: cellar). I still couldn't see it from the network 
so I dragged an old 14" CRT out of the shed and connected it up. The 
login prompt was there but there was an "ata2 timeout" error message and 
the console was dead. I power-cycled to reboot and as it booted I saw a 
message something like "postponing resync of md0 as it uses the same 
device as md5. waiting for md5 to resync. I then got a further ata 
timeout error. I had to physically disconnect the bad drive and reboot 
in order to re-start the re-sync.

Further md information:

[root@dude log]# mdadm --detail --scan
ARRAY /dev/md2 level=raid1 num-devices=2 
UUID=11caa547:1ba8d185:1f1f771f:d66368c9
    devices=/dev/sdc1
ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=be8ad31a:f13b6f4b:c39732fc:c84f32a8
    devices=/dev/sdb1,/dev/sde1
ARRAY /dev/md5 level=raid5 num-devices=5 
UUID=a4bbcd09:5e178c5b:3bf8bd45:8c31d2a1
    devices=/dev/sda2,/dev/sdb2,/dev/sdc2,/dev/sdd2,/dev/sde2
ARRAY /dev/md0 level=raid1 num-devices=2 
UUID=4b28338c:bf08d0bc:bb2899fc:e7f35eae
    devices=/dev/sda1,/dev/sdd1

It was /dev/sdf that failed which contained two partitions, one of them 
part of md2 (now running un-mirrored but still showing two devices) and 
the other part of md5 (now re-syncing but only showing five devices).

Is this normal behaviour?

R.
-- 
http://robinbowes.com
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

