From: Jim Santos <iluvgadgets@gmail.com>
Subject: "Missing" RAID devices
Date: Tue, 21 May 2013 08:51:49 -0400
Message-ID: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I recently upgraded my 2 disk RAID-1 array from 1.5TB to 2TB disks.
When I started I had 10 MD devices. Since the last partition was
small, I removed the filesystems and deleted the associated RAID
device. The I created two new devices and split the extra 500 GB
between them. Everything was good until I rebooted. Now two of the
raid devices are 'gone'.

Here is what mdadm shows at the moment:

santos@bender:/etc/mdadm$ sudo mdadm --examine --scan

ARRAY /dev/md120 UUID=3fa7ec2e:7a19093c:34d348bd:5f81ddcb
ARRAY /dev/md119 UUID=302f5a8a:f963c76e:53433e04:4146b04d
ARRAY /dev/md125 UUID=a0535363:3799280a:1b1dd2b9:44680fa2
ARRAY /dev/md124 UUID=54742635:24ba2035:bcddc93e:73fc2c19
ARRAY /dev/md123 UUID=56613b81:36bc9bcd:fe538cc8:51817c6b
ARRAY /dev/md126 UUID=c5d4e3e5:ab520847:f5483f4e:4a7373f8
ARRAY /dev/md127 UUID=3983523a:740e09fa:84f2985e:c6521efa
ARRAY /dev/md121 UUID=35bd0dff:1fa423f5:f8fb6389:ecaefea8
ARRAY /dev/md122 UUID=ebbd009c:33fcc44c:8907793b:1d800ee1
ARRAY /dev/md/11 metadata=1.2 UUID=32bde3b1:b0475886:3ce4bba7:3bd12900
name=bender:11
ARRAY /dev/md/12 metadata=1.2 UUID=0257dbbd:42d8d666:2173709f:4dd0a1a6
name=bender:12

The last two devices are the new ones.


fstab:

UUID="57382674-3289-4cc8-a2d0-a57d44ea1458" /home ext3 defaults 2
UUID="478cca47-6f26-4550-9813-223d0d65b851" /mnt/part06 ext3 defaults 2
UUID="58c85e32-07d9-445d-b971-34d96c03a765" /mnt/part07 ext3 defaults 2
UUID="5d7d89cd-c04d-4916-bb9a-a28256d928a9" /mnt/part08 ext3 defaults 2
UUID="1da60cba-5f1d-4a8f-925a-6e3d80611b8d" /mnt/part09 ext3 defaults 2
UUID="241199c9-4b6a-49d6-a270-1db07691f99c" /mnt/part10 ext3 defaults
2 <-- Failed to mount
UUID="af7dc965-261b-4995-84ca-0ebb0c014efb" /mnt/part11 ext3 defaults
2 <-- Failed to mount
UUID="6a896a4e-aee0-41a8-8a29-2cb021f4149c" /mnt/part12 ext3 defaults 2
UUID="96379e3c-78f6-4cb4-984a-85be455263c3" /mnt/part13 ext3 defaults 2
UUID="2f8c7084-8610-4f11-97b8-5bc25ad9a7df" /mnt/part14 ext4 defaults 2
UUID="015fe797-e79c-4dd0-bbef-4c6c59287262" /mnt/part15 ext4 defaults 2

mount:

/dev/md120 on /home type ext3 (rw)
/dev/md119 on /mnt/part06 type ext3 (rw)
/dev/md125 on /mnt/part07 type ext3 (rw)
/dev/md124 on /mnt/part08 type ext3 (rw)
/dev/md123 on /mnt/part09 type ext3 (rw)
/dev/md121 on /mnt/part12 type ext3 (rw)
/dev/md122 on /mnt/part13 type ext3 (rw)
/dev/md126 on /mnt/part14 type ext4 (rw) <--- New
/dev/md127 on /mnt/part15 type ext4 (rw) <--- New


What seems to have happened is that /dev/md/11 and /dev/md/12 are now
named /dev/md126 and /dev/md127. If I examine a couple of the
partitions that should be part of /dev/md126 and /dev/md127, I see
this:

santos@bender:/etc/mdadm$ sudo mdadm --examine /dev/sda7

/dev/sda7:
Magic : a92b4efc
Version : 0.90.00
UUID : c5d4e3e5:ab520847:f5483f4e:4a7373f8
Creation Time : Fri Oct 30 12:30:04 2009
Raid Level : raid1
Used Dev Size : 157292288 (150.01 GiB 161.07 GB)
Array Size : 157292288 (150.01 GiB 161.07 GB)
Raid Devices : 2
Total Devices : 2
Preferred Minor : 126

Update Time : Mon May 20 15:00:19 2013
State : clean
Active Devices : 2
Working Devices : 2
Failed Devices : 0
Spare Devices : 0
Checksum : fff3c4a9 - correct
Events : 7003

Number Major Minor RaidDevice State
this 0 8 7 0 active sync /dev/sda7

0 0 8 7 0 active sync /dev/sda7
1 1 8 23 1 active sync /dev/sdb7

santos@bender:/etc/mdadm$ sudo mdadm --examine /dev/sda8

/dev/sda8:
Magic : a92b4efc
Version : 0.90.00
UUID : 3983523a:740e09fa:84f2985e:c6521efa
Creation Time : Fri Oct 30 12:30:21 2009
Raid Level : raid1
Used Dev Size : 157292288 (150.01 GiB 161.07 GB)
Array Size : 157292288 (150.01 GiB 161.07 GB)
Raid Devices : 2
Total Devices : 2
Preferred Minor : 127

Update Time : Mon May 20 15:00:19 2013
State : clean
Active Devices : 2
Working Devices : 2
Failed Devices : 0
Spare Devices : 0
Checksum : 47e70f24 - correct
Events : 1665

Number Major Minor RaidDevice State
this 0 8 8 0 active sync /dev/sda8

0 0 8 8 0 active sync /dev/sda8
1 1 8 24 1 active sync /dev/sdb8

Notice the Preferred Minor numbers. It looks like the two new RAID
devices took over the devices with the highest minor numbers.

I don't know what I did to get into this situation, but could really
use some help getting out of it.

TIA
