From: "Magnus Naeslund(k)" <mag@kite.se>
Subject: Raid 1 (non) performance
Date: Wed, 15 Nov 2006 17:53:29 +0100
Message-ID: <455B4609.6090905@kite.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello I might have a strange raid setup that results in bad raid 1 
performance. I would be very happy if someone have any pointers about 
this so that I can get some decent performance out of my box...

This is an mailserver running postfix and dovecot (imap/pop). It's running Ubuntu Dapper amd64 with an 2.6.17.6 since the original dapper kernel doesn't support the sata controller.
The motherboard is some kind of HT1000 based thing with a single opteron 146 processor with 2gb ram, the sata driver I use is sata_svw. The two disks forming the raid1 set are Maxtor 6V250F0 sata disks.
The /var filesystem has some (+j) attributes set on the postfix directories.

I'm not sure what more information is needed, please point out if something is missing.

The raid setup:

# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 sda3[0] sdb3[1]
      236725696 blocks [2/2] [UU]

md1 : active raid1 sda2[0] sdb2[1]
      4192896 blocks [2/2] [UU]

md0 : active raid1 sda1[0] sdb1[1]
      4192832 blocks [2/2] [UU]

unused devices: <none>


Partitions:

# mount|grep ext
/dev/md1 on / type ext3 (rw,noatime,errors=remount-ro)
/dev/md2 on /var type ext3 (rw,noatime)

The tune2fs options and journal sizes on the filesystems:

/dev/md1: Journal size: 67108864 (64mb)
	ext_attr, resize_inode, dir_index, filetype, sparse_super, large_file

/dev/md2: Journal size: 402653184 (384mb)
	resize_inode, dir_index, filetype, sparse_super, large_file

Swaps:

# swapon -s
Filename                                Type            Size    Used 
Priority
/dev/md0                                partition       4192824 116     -1


I've tried to modify the queuing by doing this, to disable the write cache and enable CFQ. The CFQ choice is rather random.

for disk in sda sdb; do
  blktool /dev/$disk wcache off
  hdparm -q -W 0 /dev/$disk
  echo cfq > /sys/block/$disk/queue/scheduler
done

When I search a imap account having 5 gb (approx 500000 mail) worth of mail the box seems to block alot, somehow processes monopolize the IO bandwidth, not like the many other systems I'm running.
The raid1 should be an improvement over using the disks directly on the read side atleast.

Any ideas as of why the performance/fairness is out the window?
Do you need any more info?

Regards,
Magnus

