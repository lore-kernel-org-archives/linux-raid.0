From: =?UTF-8?Q?Thomas_B=C3=BCschgens?= <sledge@seconet.de>
Subject: Help: RAID5 - Disk failure during upgrade
Date: Tue, 29 Nov 2016 23:22:45 +0100
Message-ID: <CAPqb7wrkYKVMKoje7rpZmhd+3BFautqmhugFTbMvsuHxVoazSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,


kind of "cry for help" mail to the list.


I am running a Thecus N7510 NAS with 7 * 4TB diskd (Western Digital)
in a RAID5 setup. This config was running "smoothly" for about 3 years
now. Couple of days ago I decided to upgrade to 8TB disks instead.


Following the recommended Thecus procedure I did the following:


1. Check SMART on all disks. Fine
2. Pull Disk No. 1
3. Re-assemble HD-Case with new 8TB disk
4. Put new Disk into slot 1


So far, so good. The array immediatly started the rebuild... and a
couple of minutes later disk No. 5 failed.


Hiere the excerpt from the Thecus log:

2016-11-28 23:13:09 [N7510] : User admin logged in from 192.168.7.29
2016-11-28 22:30:36 [N7510] : The RAID [RAID] on system [N7510] change
to degrade mode.
2016-11-28 22:29:57 [N7510] : Disk 5 on [N7510] has failed.
2016-11-28 22:29:56 [N7510] : Disk 5 on [N7510] has failed.
2016-11-28 22:29:56 [N7510] : Disk 5 on [N7510] has failed.
2016-11-28 22:23:52 [N7510] : The RAID [RAID] on system [N7510] is
recovering the RAID and rebuilding is in progress.
2016-11-28 22:23:43 [N7510] : Disk 1 on [N7510] has been added.
2016-11-28 22:17:06 [N7510] : The RAID [RAID] on system [N7510] change
to degrade mode.
2016-11-28 22:17:05 [N7510] : Disk 1 on [N7510] has been removed.


Disk No. 5 is now marked as a potential spare. The output from "mdadm
--examine" is attached to the email.


My basic question is the following: How to proceed.


Currently I am considering the following options:


1. Change back to Disk No. 1 (4TB) - the original one. The disk was
running smoothly when I changed it
2. Option No. 1 - but shutting the system down while doing this
3. Pull/Plug Disk No. 5 and see what happens
4. Reboot?


I don't think this is a Thecus specific question - rather a
mdraid-related issue - in terms of finding the correct procedure.


Any advice / guidance will be appreciated. In case someone needs more
detailed information I am happy to provide this.


Thx,


Tom



/dev/sda1:
Magic : a92b4efc
Version : 1.2
Feature Map : 0x0
Array UUID : 59723730:2db46102:6225ddd5:5f0e4781
Name : N7510:10 (local to host N7510)
Creation Time : Fri Jan 3 09:55:12 2014
Raid Level : raid1
Raid Devices : 7


Avail Dev Size : 4192256 (2047.34 MiB 2146.44 MB)
Array Size : 4192232 (2047.33 MiB 2146.42 MB)
Used Dev Size : 4192232 (2047.33 MiB 2146.42 MB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
State : clean
Device UUID : 9f7bf852:6cc2b78d:29b68d62:a3e0aea4


Update Time : Tue Nov 29 18:37:38 2016
Checksum : 27108c9a - correct
Events : 27744




Device Role : Active device 0
Array State : AAAA.AA ('A' == active, '.' == missing)
/dev/sdb1:
Magic : a92b4efc
Version : 1.2
Feature Map : 0x0
Array UUID : 59723730:2db46102:6225ddd5:5f0e4781
Name : N7510:10 (local to host N7510)
Creation Time : Fri Jan 3 09:55:12 2014
Raid Level : raid1
Raid Devices : 7


Avail Dev Size : 4192256 (2047.34 MiB 2146.44 MB)
Array Size : 4192232 (2047.33 MiB 2146.42 MB)
Used Dev Size : 4192232 (2047.33 MiB 2146.42 MB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
State : clean
Device UUID : 6463836f:3365a29f:2eff4a43:34ca4251


Update Time : Tue Nov 29 18:37:38 2016
Checksum : e2d749b1 - correct
Events : 27744




Device Role : Active device 1
Array State : AAAA.AA ('A' == active, '.' == missing)
/dev/sdc1:
Magic : a92b4efc
Version : 1.2
Feature Map : 0x0
Array UUID : 59723730:2db46102:6225ddd5:5f0e4781
Name : N7510:10 (local to host N7510)
Creation Time : Fri Jan 3 09:55:12 2014
Raid Level : raid1
Raid Devices : 7


Avail Dev Size : 4192256 (2047.34 MiB 2146.44 MB)
Array Size : 4192232 (2047.33 MiB 2146.42 MB)
Used Dev Size : 4192232 (2047.33 MiB 2146.42 MB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
State : clean
Device UUID : 980bdf39:0105d063:5e846eed:53e5cfb1


Update Time : Tue Nov 29 18:37:38 2016
Checksum : 7c113204 - correct
Events : 27744




Device Role : Active device 2
Array State : AAAA.AA ('A' == active, '.' == missing)
/dev/sdd1:
Magic : a92b4efc
Version : 1.2
Feature Map : 0x0
Array UUID : 59723730:2db46102:6225ddd5:5f0e4781
Name : N7510:10 (local to host N7510)
Creation Time : Fri Jan 3 09:55:12 2014
Raid Level : raid1
Raid Devices : 7


Avail Dev Size : 4192256 (2047.34 MiB 2146.44 MB)
Array Size : 4192232 (2047.33 MiB 2146.42 MB)
Used Dev Size : 4192232 (2047.33 MiB 2146.42 MB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
State : clean
Device UUID : b176c33f:09dd2c01:9b65da40:27615b03


Update Time : Tue Nov 29 18:37:38 2016
Checksum : c449d239 - correct
Events : 27744




Device Role : Active device 3
Array State : AAAA.AA ('A' == active, '.' == missing)
/dev/sde1:
Magic : a92b4efc
Version : 1.2
Feature Map : 0x0
Array UUID : 59723730:2db46102:6225ddd5:5f0e4781
Name : N7510:10 (local to host N7510)
Creation Time : Fri Jan 3 09:55:12 2014
Raid Level : raid1
Raid Devices : 7


Avail Dev Size : 4192256 (2047.34 MiB 2146.44 MB)
Array Size : 4192232 (2047.33 MiB 2146.42 MB)
Used Dev Size : 4192232 (2047.33 MiB 2146.42 MB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
State : clean
Device UUID : e1963582:a6a35363:88ab4994:5881ec66


Update Time : Mon Nov 28 22:23:50 2016
Checksum : 1fe1025c - correct
Events : 27659




Device Role : Active device 4
Array State : AAAAAAA ('A' == active, '.' == missing)
/dev/sdf1:
Magic : a92b4efc
Version : 1.2
Feature Map : 0x0
Array UUID : 59723730:2db46102:6225ddd5:5f0e4781
Name : N7510:10 (local to host N7510)
Creation Time : Fri Jan 3 09:55:12 2014
Raid Level : raid1
Raid Devices : 7


Avail Dev Size : 4192256 (2047.34 MiB 2146.44 MB)
Array Size : 4192232 (2047.33 MiB 2146.42 MB)
Used Dev Size : 4192232 (2047.33 MiB 2146.42 MB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
State : clean
Device UUID : 9d8b239f:4f85ab54:8acfbe55:aab1eb51


Update Time : Tue Nov 29 18:37:38 2016
Checksum : da9d49e0 - correct
Events : 27744




Device Role : Active device 6
Array State : AAAA.AA ('A' == active, '.' == missing)
/dev/sdg1:
Magic : a92b4efc
Version : 1.2
Feature Map : 0x0
Array UUID : 59723730:2db46102:6225ddd5:5f0e4781
Name : N7510:10 (local to host N7510)
Creation Time : Fri Jan 3 09:55:12 2014
Raid Level : raid1
Raid Devices : 7


Avail Dev Size : 4192256 (2047.34 MiB 2146.44 MB)
Array Size : 4192232 (2047.33 MiB 2146.42 MB)
Used Dev Size : 4192232 (2047.33 MiB 2146.42 MB)
Data Offset : 2048 sectors
Super Offset : 8 sectors
State : clean
Device UUID : 9bfe9659:f919f877:a7c93e6d:c748290a


Update Time : Tue Nov 29 18:37:38 2016
Checksum : 881ae2c3 - correct
Events : 27744




Device Role : Active device 5
Array State : AAAA.AA ('A' == active, '.' == missing)
