From: Nicolas Nicolaou <nicolaoun@gmail.com>
Subject: Problems with a RAID5 array
Date: Tue, 25 Oct 2016 10:45:12 +0300
Message-ID: <5C95474C-8A2A-4472-9629-2DD6B2143D28@GMAIL.COM>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I am a newbie in the RAID field but i encountered some problems=20
with my RAID5 configuration on a QNAP NAS machine.=20

In particular i added a 3TB drive and the array seemed to be rebuilt=20
automatically. Originally i had 3 3TB drives on it.=20
The rebuilt finished and i was able to access my data. For some weird =
reason
one of the drives was not added and i tried to expand the RAID capacity.=20=

The expand failed but still no problems...

When i rebooted the system however the RAID became inactive and=20
now i cannot access any of the data.=20

Below you can see the mdadm =E2=80=94examine information for the 4 =
drives.=20

I saw a thread that recreating the RAID may solve the issue=20
(https://raid.wiki.kernel.org/index.php/RAID_Recovery).=20
Before going to that path though i wanted to see your take.=20

Thanks,
Nicolas

/dev/sda3:
Magic : a92b4efc
Version : 1.0
Feature Map : 0x0
Array UUID : 11d32674:4247f385:74ee352b:5e4c22c7
Name : 0
Creation Time : Wed Jan 9 02:29:02 2013
Raid Level : raid5
Raid Devices : 4

Used Dev Size : 5857395112 (2793.02 GiB 2998.99 GB)
Array Size : 17572185216 (8379.07 GiB 8996.96 GB)
Used Size : 5857395072 (2793.02 GiB 2998.99 GB)
Super Offset : 5857395368 sectors
State : clean
Device UUID : 650aa6e2:c725d7f0:b6c8a5fb:8f0ed37f

Update Time : Thu Oct 20 08:33:37 2016
Checksum : bb791848 - correct
Events : 175176

Layout : left-symmetric
Chunk Size : 64K

Array Slot : 2 (0, failed, 2, failed, 3, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed)
Array State : u_Uu 381 failed
/dev/sdb3:
Magic : a92b4efc
Version : 00.90.00
UUID : 3fe6d5d4:5b9d61f2:4f7ddb81:e4ae2138
Creation Time : Thu Jun 7 19:50:56 2012
Raid Level : raid5
Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
Array Size : 5855836800 (5584.56 GiB 5996.38 GB)
Raid Devices : 4
Total Devices : 4
Preferred Minor : 0

Update Time : Sun Oct 23 21:05:33 2016
State : clean
Active Devices : 4
Working Devices : 4
Failed Devices : 0
Spare Devices : 0
Checksum : 968897f8 - correct
Events : 0.12252139

Layout : left-symmetric
Chunk Size : 64K

Number Major Minor RaidDevice State
this 2 8 19 2 active sync /dev/sdb3

0 0 8 3 0 active sync /dev/sda3
1 1 8 35 1 active sync /dev/sdc3
2 2 8 19 2 active sync /dev/sdb3
3 3 8 51 3 active sync /dev/sdd3
/dev/sdc3:
Magic : a92b4efc
Version : 00.90.00
UUID : 3fe6d5d4:5b9d61f2:4f7ddb81:e4ae2138
Creation Time : Thu Jun 7 19:50:56 2012
Raid Level : raid5
Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
Array Size : 5855836800 (5584.56 GiB 5996.38 GB)
Raid Devices : 4
Total Devices : 4
Preferred Minor : 0

Update Time : Sun Oct 23 21:05:33 2016
State : clean
Active Devices : 4
Working Devices : 4
Failed Devices : 0
Spare Devices : 0
Checksum : 96889806 - correct
Events : 0.12252139

Layout : left-symmetric
Chunk Size : 64K

Number Major Minor RaidDevice State
this 1 8 35 1 active sync /dev/sdc3

0 0 8 3 0 active sync /dev/sda3
1 1 8 35 1 active sync /dev/sdc3
2 2 8 19 2 active sync /dev/sdb3
3 3 8 51 3 active sync /dev/sdd3
/dev/sdd3:
Magic : a92b4efc
Version : 1.0
Feature Map : 0x0
Array UUID : 11d32674:4247f385:74ee352b:5e4c22c7
Name : 0
Creation Time : Wed Jan 9 02:29:02 2013
Raid Level : raid5
Raid Devices : 4

Used Dev Size : 5857395112 (2793.02 GiB 2998.99 GB)
Array Size : 17572185216 (8379.07 GiB 8996.96 GB)
Used Size : 5857395072 (2793.02 GiB 2998.99 GB)
Super Offset : 5857395368 sectors
State : clean
Device UUID : 0b3406a9:15fd802f:e9e3ed19:1c684e54

Update Time : Thu Oct 20 09:45:06 2016
Checksum : b3469ebd - correct
Events : 175176

Layout : left-symmetric
Chunk Size : 64K

Array Slot : 4 (0, failed, 2, failed, 3, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed, failed, failed, failed, =
failed, failed, failed, failed, failed, failed)
Array State : u_uU 381 failed
