From: Pol Hallen <raid1@fuckaround.org>
Subject: Re: standard performance (write speed ??Mb/s) - new raid5 array
Date: Thu, 21 Jul 2011 19:07:36 +0200
Message-ID: <201107211907.36864.raid1@fuckaround.org>
References: <201107162140.58883.raid1@fuckaround.org> <ac6850f9420970de26472b6a9dcc2a82.squirrel@fuckaround.org> <4E236A2D.3070307@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E236A2D.3070307@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello again :-)

I removed all partitions of my disks and do:

dd if=/dev/zero of=/dev/sdb bs=512 count=1 for all disks..

next, I created a new partition (non-fs data) starting of 64 like below (for 
every devices)

fdisk -lu /dev/sdb

Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xd2017c41

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1              64  3907029167  1953514552   da  Non-FS data

created a new raid5 array:

mdadm --create --verbose /dev/md0 --level=raid5 --raid-devices=5 /dev/sdb 
/dev/sdc /dev/sdd /dev/sde /dev/sdf

cat /proc/mdstat

md0 : active raid5 sdf[5] sde[3] sdd[2] sdc[1] sdb[0]
      7814051840 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] 
[UUUU_]
      [>....................]  recovery =  0.3% (6625324/1953512960) 
finish=971.1min speed=33411K/sec

Now, I've 5 identical disks (2Tb WD)

I've to wait rebuilding time after do new tests performance.

The procedure that I've done is correct?

thanks! :-)

Pol
