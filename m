From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: raid1 reconfig failed to work! help!
Date: Wed, 2 Oct 2002 05:55:20 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D24D@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Alex' <devel@qnet.ro>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alex,

Oops, I believe you have two errors in your raidtab:
  You used /dev/sdb1 twice, when you probably meant /dev/sdd1.
  You need to use the next index (2) rather than 0 for the spare-disk.

Also, make sure you can "modprobe raid1" on your kernel.  

Andy

-----Original Message-----
From: Alex [mailto:devel@qnet.ro] 
Sent: Wednesday, October 02, 2002 8:42 AM
To: linux-raid@vger.kernel.org
Subject: raid1 reconfig failed to work! help!

Hello Raid experts,

I have already a working raid1-soft configured as you see below:

[root@server root]# cat /etc/raidtab
raiddev /dev/md0
        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  0
        chunk-size     32
        persistent-superblock 1
        device          /dev/sdb1
        raid-disk       0
        device          /dev/sdc1
        raid-disk       1

Now i tryed to add a spare hdd. For this, i edited a newraidtab file:
[root@server root]# cat /etc/newraidtab
raiddev /dev/md0
        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  1
        chunk-size     32
        persistent-superblock 1
        device          /dev/sdb1
        raid-disk       0
        device          /dev/sdc1
        raid-disk       1
	device	/dev/sdb1
	spare-disk	0

after that:
[root@server root]# raidstop /dev/md0
/dev/md0: device already stopped
[root@server root]# raidreconf -o /etc/raidtab -n /etc/newraidtab -m 
/dev/md0
Working with device /dev/md0
Parsing /etc/raidtab
Parsing /etc/newraidtab
Size of old array: 22532032 blocks,  Size of new array: 32774048 blocks
No source driver available for level 1
reconfiguration failed

What is wrong? I can`t understand why is not working!

Any suggestion will be appreciated.

Regards,
Alex




-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
