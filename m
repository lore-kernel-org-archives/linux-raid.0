From: "Anton A. Nesterov" <dj_bandit@mail.ru>
Subject: Raid 5 trouble, need help
Date: Tue, 10 Jan 2006 00:09:21 +0600
Message-ID: <E1Ew1SI-000PkF-00.dj_bandit-mail-ru@mx3.mail.ru>
Reply-To: <dj_bandit@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="koi8-r"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!
Sorry for my bad english...
I use:
software: debian Sarge, kernel 2.4.27-2-686, mdadm - v1.9.0 (install from
packages).
hardware: Microstar MS-6315 i815 mainboard , PIII 1100, 200Gb HDD x 10
different manufactures + 2Gb HDD for system, Promise Ultra100 TX2 x 2

HDD list:
/dev/hda: ST32122A
/dev/hdc: WDC WD2000LB-00EDA0
/dev/hdd: ST3200826A
/dev/hde: ST3200826A
/dev/hdf: WDC WD2000BB-55GUA0
/dev/hdg: WDC WD2000LB-00EDA0
/dev/hdh: WDC WD2000JB-00FUA0
/dev/hdi: WDC WD2000LB-00EDA0
/dev/hdj: WDC WD2000JB-00GVA0
/dev/hdk: WDC WD2000BB-00GUC0
/dev/hdl: WDC WD2000BB-00GUC0

I have made the following:
Create RAID5:
# mdadm --create --verbose /dev/md0 --level=5 --raid-devices=10
--spare-devices=0 -c256 /dev/hd{c,d,e,f,g,h,i,j,k,l}1 Create a file system:
# mke2fs -b 4096 -j -R stride=64 /dev/md0 And mount it in /dev/hdd Then, I
copy many files (>150Gb) on /dev/hdd and have next trouble:

1. Power disapired. md start automatically, but in degrated mode
	In kern.log:
Jan  6 20:54:05 FileServer kernel: md0: former device hdh1 is unavailable,
removing from array!
.
.
Jan  6 20:54:05 FileServer kernel: md0: no spare disk to reconstruct array!
-- continuing in degraded mode Jan  6 20:54:05 FileServer kernel: md:
recovery thread finished ...
I attempt add disk to array manually: 
# mdadm --manage /dev/md0 --add /dev/hdh1
Result: hot add failed, no space left on device
	In kern.log:
Jan  6 21:45:20 FileServer kernel: md: trying to hot-add
ide/host2/bus1/target1/lun0/part1 to md0 ...
Jan  6 21:45:20 FileServer kernel: md0: disk size 195358208 blocks < array
size 195358336 Jan  6 21:45:20 FileServer kernel: md:
export_rdev(ide/host2/bus1/target1/lun0/part1)

But I did not change drive and partition table.
I make: dd if=/dev/zero of=/dev/hdh1 bs=32768 count=4, test and write zeros
with a WD Diagnostics, re create partition table...
Without results, md say: no space left on device...
# cat /proc/partitions |grep host2/bus1/target1/lun0/part1
  34    65  195358401 ide/host2/bus1/target1/lun0/part1 1 11 24 20 0 0 0 0 0
20 20
Why md define 195358208 blocks???
How could it be?
This is the first question.

I continued in degraded mode...
Array configurations:
Number   Major   Minor   RaidDevice State
       0      22        1        0      active sync   /dev/hdc1
       1      22       65        1      active sync   /dev/hdd1
       2      33        1        2      active sync   /dev/hde1
       3      33       65        3      active sync   /dev/hdf1
       4      34        1        4      active sync   /dev/hdg1
       5       0        0        5      faulty removed
       6      56        1        6      active sync   /dev/hdi1
       7      56       65        7      active sync   /dev/hdj1
       8      57        1        8      active sync   /dev/hdk1
       9      57       65        9      active sync   /dev/hdl1

Next day:
Jan  7 12:08:49 FileServer kernel: attempt to access beyond end of device
Jan  7 12:08:49 FileServer kernel: 16:01: rw=0, want=195358404,
limit=195358401 Jan  7 12:08:49 FileServer kernel: md: updating md0 RAID
superblock on device Jan  7 12:08:49 FileServer kernel: md: (skipping faulty
ide/host0/bus1/target0/lun0/part1 ) Jan  7 12:08:49 FileServer kernel: md:
(skipping faulty ide/host4/bus1/target1/lun0/part1 ) Jan  7 12:08:49
FileServer kernel: md: (skipping faulty ide/host4/bus1/target0/lun0/part1 )
Jan  7 12:08:49 FileServer kernel: md: (skipping faulty
ide/host4/bus0/target1/lun0/part1 ) Jan  7 12:08:49 FileServer kernel: md:
(skipping faulty ide/host4/bus0/target0/lun0/part1 ) Jan  7 12:08:49
FileServer kernel: md: ide/host2/bus1/target0/lun0/part1 [events:
00000039]<6>(write
) ide/host2/bus1/target0/lun0/part1's sb offset: 195358336 Jan  7 12:08:49
FileServer kernel: md: recovery thread got woken up ...
Jan  7 12:08:49 FileServer kernel: md: recovery thread finished ...
Jan  7 12:08:49 FileServer kernel: md: ide/host2/bus0/target1/lun0/part1
[events: 00000039]<6>(write
) ide/host2/bus0/target1/lun0/part1's sb offset: 195358336 Jan  7 12:08:49
FileServer kernel: md: ide/host2/bus0/target0/lun0/part1 [events:
00000039]<6>(write
) ide/host2/bus0/target0/lun0/part1's sb offset: 195358336 Jan  7 12:08:49
FileServer kernel: md: ide/host0/bus1/target1/lun0/part1 [events:
00000039]<6>(write
) ide/host0/bus1/target1/lun0/part1's sb offset: 195358336 I am a panic....
I make:
# mdadm -S /dev/md0
# mdadm --assemble --force /dev/md0
It has helped...
Array has returned to active mode.

Number   Major   Minor   RaidDevice State
       0      22        1        0      active sync   /dev/hdc1
       1      22       65        1      active sync   /dev/hdd1
       2      33        1        2      active sync   /dev/hde1
       3      33       65        3      active sync   /dev/hdf1
       4      34        1        4      active sync   /dev/hdg1
       5       0        0        5      faulty removed
       6      56        1        6      active sync   /dev/hdi1
       7      56       65        7      active sync   /dev/hdj1
       8      57        1        8      active sync   /dev/hdk1
       9      57       65        9      active sync   /dev/hdl1

This situation repeated several times, but with different disks:
Jan  7 16:07:40 FileServer kernel: attempt to access beyond end of device
Jan  7 16:07:40 FileServer kernel: 16:01: rw=0, want=195358404,
limit=195358401 Jan  7 16:07:40 FileServer kernel: md: updating md0 RAID
superblock on device Jan  7 16:07:40 FileServer kernel: md: (skipping faulty
ide/host0/bus1/target0/lun0/part1 ) Jan  7 16:07:40 FileServer kernel: md:
(skipping faulty ide/host4/bus1/target1/lun0/part1 ) Jan  7 16:07:40
FileServer kernel: md: (skipping faulty ide/host4/bus1/target0/lun0/part1 )
Jan  7 16:07:40 FileServer kernel: md: (skipping faulty
ide/host4/bus0/target1/lun0/part1 ) Jan  7 16:07:40 FileServer kernel: md:
(skipping faulty ide/host4/bus0/target0/lun0/part1 ) Jan  7 16:07:40
FileServer kernel: md: ide/host2/bus1/target0/lun0/part1 [events:
00000040]<6>(write
) ide/host2/bus1/target0/lun0/part1's sb offset: 195358336 Jan  7 16:07:40
FileServer kernel: md: recovery thread got woken up ...
Jan  7 16:07:40 FileServer kernel: md: recovery thread finished ...
Jan  7 16:07:40 FileServer kernel: md: ide/host2/bus0/target1/lun0/part1
[events: 00000040]<6>(write
) ide/host2/bus0/target1/lun0/part1's sb offset: 195358336 Jan  7 16:07:40
FileServer kernel: md: ide/host2/bus0/target0/lun0/part1 [events:
00000040]<6>(write
) ide/host2/bus0/target0/lun0/part1's sb offset: 195358336 Jan  7 16:07:40
FileServer kernel: md: ide/host0/bus1/target1/lun0/part1 [events:
00000040]<6>(write
) ide/host0/bus1/target1/lun0/part1's sb offset: 195358336 .
Jan  7 16:33:43 FileServer kernel: attempt to access beyond end of device
Jan  7 16:33:43 FileServer kernel: 16:01: rw=0, want=195358404,
limit=195358401 Jan  7 16:33:43 FileServer kernel: md: updating md0 RAID
superblock on device Jan  7 16:33:43 FileServer kernel: md: (skipping faulty
ide/host0/bus1/target0/lun0/part1 ) Jan  7 16:33:43 FileServer kernel: md:
(skipping faulty ide/host4/bus1/target1/lun0/part1 ) Jan  7 16:33:43
FileServer kernel: md: (skipping faulty ide/host4/bus1/target0/lun0/part1 )
Jan  7 16:33:43 FileServer kernel: md: (skipping faulty
ide/host4/bus0/target1/lun0/part1 ) Jan  7 16:33:43 FileServer kernel: md:
(skipping faulty ide/host4/bus0/target0/lun0/part1 ) Jan  7 16:33:43
FileServer kernel: md: ide/host2/bus1/target0/lun0/part1 [events:
00000045]<6>(write
) ide/host2/bus1/target0/lun0/part1's sb offset: 195358336 Jan  7 16:33:43
FileServer kernel: md: recovery thread got woken up ...
Jan  7 16:33:43 FileServer kernel: md: recovery thread finished ...
Jan  7 16:33:43 FileServer kernel: md: ide/host2/bus0/target1/lun0/part1
[events: 00000045]<6>(write
) ide/host2/bus0/target1/lun0/part1's sb offset: 195358336 Jan  7 16:33:43
FileServer kernel: md: ide/host2/bus0/target0/lun0/part1 [events:
00000045]<6>(write
) ide/host2/bus0/target0/lun0/part1's sb offset: 195358336 Jan  7 16:33:43
FileServer kernel: md: ide/host0/bus1/target1/lun0/part1 [events:
00000045]<6>(write
) ide/host0/bus1/target1/lun0/part1's sb offset: 195358336 .
.
an  7 18:04:55 FileServer kernel: attempt to access beyond end of device Jan
7 18:04:55 FileServer kernel: 16:41: rw=0, want=195358452, limit=195358401
Jan  7 18:04:55 FileServer kernel: md: updating md0 RAID superblock on
device Jan  7 18:04:55 FileServer kernel: md:
ide/host0/bus1/target0/lun0/part1 [events: 0000004a]<6>(write
) ide/host0/bus1/target0/lun0/part1's sb offset: 195358336 Jan  7 18:04:55
FileServer kernel: md: recovery thread got woken up ...
Jan  7 18:04:55 FileServer kernel: md: recovery thread finished ...
Jan  7 18:04:55 FileServer kernel: md: ide/host4/bus1/target1/lun0/part1
[events: 0000004a]<6>(write
) ide/host4/bus1/target1/lun0/part1's sb offset: 195358336 Jan  7 18:04:55
FileServer kernel: md: ide/host4/bus1/target0/lun0/part1 [events:
0000004a]<6>(write
) ide/host4/bus1/target0/lun0/part1's sb offset: 195358336 Jan  7 18:04:55
FileServer kernel: md: ide/host4/bus0/target1/lun0/part1 [events:
0000004a]<6>(write
) ide/host4/bus0/target1/lun0/part1's sb offset: 195358336 Jan  7 18:04:55
FileServer kernel: md: ide/host4/bus0/target0/lun0/part1 [events:
0000004a]<6>(write
) ide/host4/bus0/target0/lun0/part1's sb offset: 195358336 Jan  7 18:04:55
FileServer kernel: md: ide/host2/bus1/target0/lun0/part1 [events:
0000004a]<6>(write
) ide/host2/bus1/target0/lun0/part1's sb offset: 195358336 Jan  7 18:04:55
FileServer kernel: md: (skipping faulty ide/host2/bus0/target1/lun0/part1 )
Jan  7 18:04:55 FileServer kernel: md: (skipping faulty
ide/host2/bus0/target0/lun0/part1 ) Jan  7 18:04:55 FileServer kernel: md:
(skipping faulty ide/host0/bus1/target1/lun0/part1 ) . 
.
Jan  7 20:55:32 FileServer kernel: attempt to access beyond end of device
Jan  7 20:55:32 FileServer kernel: 16:01: rw=0, want=195358404,
limit=195358401 Jan  7 20:55:32 FileServer kernel: md: updating md0 RAID
superblock on device Jan  7 20:55:32 FileServer kernel: md: (skipping faulty
ide/host0/bus1/target0/lun0/part1 ) Jan  7 20:55:32 FileServer kernel: md:
(skipping faulty ide/host4/bus1/target1/lun0/part1 ) Jan  7 20:55:32
FileServer kernel: md: (skipping faulty ide/host4/bus1/target0/lun0/part1 )
Jan  7 20:55:32 FileServer kernel: md: (skipping faulty
ide/host4/bus0/target1/lun0/part1 ) Jan  7 20:55:32 FileServer kernel: md:
(skipping faulty ide/host4/bus0/target0/lun0/part1 ) Jan  7 20:55:32
FileServer kernel: md: ide/host2/bus1/target0/lun0/part1 [events:
0000004e]<6>(write
) ide/host2/bus1/target0/lun0/part1's sb offset: 195358336 Jan  7 20:55:32
FileServer kernel: md: recovery thread got woken up ...
Jan  7 20:55:32 FileServer kernel: md: recovery thread finished ...
Jan  7 20:55:32 FileServer kernel: md: ide/host2/bus0/target1/lun0/part1
[events: 0000004e]<6>(write
) ide/host2/bus0/target1/lun0/part1's sb offset: 195358336 Jan  7 20:55:32
FileServer kernel: md: ide/host2/bus0/target0/lun0/part1 [events:
0000004e]<6>(write
) ide/host2/bus0/target0/lun0/part1's sb offset: 195358336 Jan  7 20:55:32
FileServer kernel: md: ide/host0/bus1/target1/lun0/part1 [events:
0000004e]<6>(write
) ide/host0/bus1/target1/lun0/part1's sb offset: 195358336 .
.
Jan  8 08:59:04 FileServer kernel: attempt to access beyond end of device
Jan  8 08:59:04 FileServer kernel: 16:41: rw=0, want=195358404,
limit=195358401 Jan  8 08:59:04 FileServer kernel: md: updating md0 RAID
superblock on device Jan  8 08:59:04 FileServer kernel: md:
ide/host0/bus1/target0/lun0/part1 [events: 00000057]<6>(write
) ide/host0/bus1/target0/lun0/part1's sb offset: 195358336 Jan  8 08:59:04
FileServer kernel: md: recovery thread got woken up ...
Jan  8 08:59:04 FileServer kernel: md: recovery thread finished ...
Jan  8 08:59:04 FileServer kernel: md: ide/host4/bus1/target1/lun0/part1
[events: 00000057]<6>(write
) ide/host4/bus1/target1/lun0/part1's sb offset: 195358336 Jan  8 08:59:04
FileServer kernel: md: ide/host4/bus1/target0/lun0/part1 [events:
00000057]<6>(write
) ide/host4/bus1/target0/lun0/part1's sb offset: 195358336 Jan  8 08:59:04
FileServer kernel: md: ide/host4/bus0/target1/lun0/part1 [events:
00000057]<6>(write
) ide/host4/bus0/target1/lun0/part1's sb offset: 195358336 Jan  8 08:59:04
FileServer kernel: md: ide/host4/bus0/target0/lun0/part1 [events:
00000057]<6>(write
) ide/host4/bus0/target0/lun0/part1's sb offset: 195358336 Jan  8 08:59:04
FileServer kernel: md: ide/host2/bus1/target0/lun0/part1 [events:
00000057]<6>(write
) ide/host2/bus1/target0/lun0/part1's sb offset: 195358336 Jan  8 08:59:04
FileServer kernel: md: ide/host2/bus0/target1/lun0/part1 [events:
00000057]<6>(write
) ide/host2/bus0/target1/lun0/part1's sb offset: 195358336 Jan  8 08:59:04
FileServer kernel: md: (skipping faulty ide/host2/bus0/target0/lun0/part1 )
Jan  8 08:59:04 FileServer kernel: md: (skipping faulty
ide/host0/bus1/target1/lun0/part1 ) Jan  8 09:03:45 FileServer kernel: md:
marking sb clean... 
Jan  8 09:03:45 FileServer kernel: md: updating md0 RAID superblock on
device Jan  8 09:03:45 FileServer kernel: md:
ide/host0/bus1/target0/lun0/part1 [events: 00000058]<6>(write
) ide/host0/bus1/target0/lun0/part1's sb offset: 195358336 Jan  8 09:03:45
FileServer kernel: md: ide/host4/bus1/target1/lun0/part1 [events:
00000058]<6>(write
) ide/host4/bus1/target1/lun0/part1's sb offset: 195358336 Jan  8 09:03:45
FileServer kernel: md: ide/host4/bus1/target0/lun0/part1 [events:
00000058]<6>(write
) ide/host4/bus1/target0/lun0/part1's sb offset: 195358336 Jan  8 09:03:45
FileServer kernel: md: ide/host4/bus0/target1/lun0/part1 [events:
00000058]<6>(write
) ide/host4/bus0/target1/lun0/part1's sb offset: 195358336 Jan  8 09:03:45
FileServer kernel: md: ide/host4/bus0/target0/lun0/part1 [events:
00000058]<6>(write
) ide/host4/bus0/target0/lun0/part1's sb offset: 195358336 Jan  8 09:03:45
FileServer kernel: md: ide/host2/bus1/target0/lun0/part1 [events:
00000058]<6>(write
) ide/host2/bus1/target0/lun0/part1's sb offset: 195358336 Jan  8 09:03:45
FileServer kernel: md: ide/host2/bus0/target1/lun0/part1 [events:
00000058]<6>(write
) ide/host2/bus0/target1/lun0/part1's sb offset: 195358336 Jan  8 09:03:45
FileServer kernel: md: (skipping faulty ide/host2/bus0/target0/lun0/part1 )
Jan  8 09:03:45 FileServer kernel: md: (skipping faulty
ide/host0/bus1/target1/lun0/part1 )

I make:
# mdadm --assemble --force /dev/md0      
mdadm: SET_ARRAY_INFO failed for /dev/md0: File exists # mdadm -S /dev/md0 #
mdadm --assemble --force /dev/md0
mdadm: /dev/md0 assembled from 7 drives - not enough to start the array.
# mdadm -E /dev/hdd1
mdadm: No super block found on /dev/hdd1 (Expected magic a92b4efc, got
db492716) # mdadm -E /dev/hde1
mdadm: No super block found on /dev/hde1 (Expected magic a92b4efc, got
db492716)

The second question: can I restore my data? Is it possible?
And last quiestion: What is the reason of such malfunction? What to do for
the stable work stable of RAID?
Thanks...
Anton A. Nesterov

