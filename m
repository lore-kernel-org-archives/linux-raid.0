From: Jeff Allison <jeff.allison@allygray.2y.net>
Subject: raid resync speed
Date: Thu, 20 Mar 2014 12:12:51 +1100
Message-ID: <CAPrpM6wLpRhMqqsXQ8Baqz4axxj6cvoB2Z1HAOiNm7gPv1FT=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The gist of my question is what kind of resync speed should I expect?

I have a HP N54L Microserver running centos 6.5.

In this box I have a 3x2TB disk raid 5 array, which I am in the
process of extending to a 4x2TB raid 5 array.

I've added the new disk --> mdadm --add /dev/md0 /dev/sdb

And grown the array --> mdadm --grow /dev/md0 --raid-devices=4

Now the problem the resync speed is v slow, it refuses to rise above
5MB, in general it sits at 4M.

from looking at glances it would appear that writing to the new disk
is the bottle neck, /dev/sdb is the new disk.

Disk I/O In/s Out/s
md0 0 0
sda1 0 0
sda2 0 1K
sdb1 3.92M 0
sdc1 24.2M 54.7M
sdd1 11.2M 54.7M
sde1 16.3M 54.7M

I partitiioned the disk with --> parted -a optimal /dev/sdb

[root@nas ~]# parted -a optimal /dev/sdb
GNU Parted 2.1
Using /dev/sdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) p
Model: ATA ST2000DM001-1E61 (scsi)
Disk /dev/sdb: 2000GB
Sector size (logical/physical): 512B/4096B
Partition Table: msdos

Number Start End Size Type File system Flags
1 1049kB 2000GB 2000GB primary ntfs raid

There is no ntfs filesystem on the disk, I've still not worked out how
to remove that flag.

I've followed the article here -->
http://www.cyberciti.biz/tips/linux-raid-increase-resync-rebuild-speed.html
to attempt to speed it up but no joy.

Any Ideas what I've done wrong?

parted output

[root@nas ~]# parted -l
Model: ATA ST31000528AS (scsi)
Disk /dev/sda: 1000GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number Start End Size Type File system Flags
1 1049kB 525MB 524MB primary ext4 boot
2 525MB 1000GB 1000GB primary lvm

Model: ATA ST2000DM001-1E61 (scsi)
Disk /dev/sdb: 2000GB
Sector size (logical/physical): 512B/4096B
Partition Table: msdos

Number Start End Size Type File system Flags
1 1049kB 2000GB 2000GB primary ntfs raid

Model: ATA ST2000DM001-9YN1 (scsi)
Disk /dev/sdc: 2000GB
Sector size (logical/physical): 512B/4096B
Partition Table: msdos

Number Start End Size Type File system Flags
1 1049kB 2000GB 2000GB primary raid

Model: ATA WDC WD25EZRS-00J (scsi)
Disk /dev/sdd: 2500GB
Sector size (logical/physical): 512B/4096B
Partition Table: msdos

Number Start End Size Type File system Flags
1 1049kB 2000GB 2000GB primary ntfs raid

Model: ATA ST2000DL001-9VT1 (scsi)
Disk /dev/sde: 2000GB
Sector size (logical/physical): 512B/4096B
Partition Table: msdos

Number Start End Size Type File system Flags
1 1049kB 2000GB 2000GB primary raid
