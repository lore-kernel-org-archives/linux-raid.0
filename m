From: Alex <devel@qnet.ro>
Subject: raid1 reconfig failed to work! help!
Date: Wed, 2 Oct 2002 15:41:53 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210021541.53688.devel@qnet.ro>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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




