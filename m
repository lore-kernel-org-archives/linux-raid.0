From: Wichert Akkerman <wichert@wiggy.net>
Subject: lock failure when creating raid on 2.6.0-test9
Date: Mon, 3 Nov 2003 14:35:26 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031103133526.GC24627@wiggy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am trying to setup RAID 1 array on two SCSI disks on a 2.6.0-test9
kernel but I am hitting the following:

vortex:~# mkraid /dev/md0
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/hda2, 35077927kB, raid superblock at 35077824kB
disk 1: /dev/hdc2, 35077927kB, raid superblock at 35077824kB
md: bind<hda2>
md: could not lock hdc2.
md: error, md_import_device() returned -16
mkraid: aborted.
(In addition to the above messages, see the syslog and /proc/mdstat as well
 for potential clues.)

-16 is EBUSY, which is unepexted since nothing else is using that disk.
At this stage /proc/mdstat contains:

Personalities : [raid1] 
md0 : inactive hda2[0]
      35077824 blocks
unused devices: <none>

Wichert.

-- 
Wichert Akkerman <wichert@wiggy.net>    It is simple to make things.
http://www.wiggy.net/                   It is hard to make things simple.

