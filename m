From: andy liebman <andyliebman@aol.com>
Subject: Conflicting Size Numbers -- Bug in mdadm, md, df?
Date: Mon, 27 Mar 2006 12:36:14 -0500
Message-ID: <4428228E.8080909@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

I'm hoping someone on this list might have some information that could 
explain a huge and strange discrepancy we are seeing when we use 
different techniques for creating large Software RAID-0 arrays. There 
seems to be a bug somewhere -- in df, in mdadm, in Linux md, or 
someplace else.

Here's a quick background on the situation. We are using Seagate 500 GB 
SATA drives. We create Hardware RAID-5 Arrays with 3ware 9550SX 12-port 
cards and then stripe the resulting devices together with "md" to create 
one or more very large RAID-0 Arrays.

Case 1: When we stripe together TWO RAW 3ware RAID-5 devices (i.e., 
/dev/sdc + /dev/sdd = /dev/md2), "df -h" tells us that the device is 11 
TB in size. "df -k" tells us that the device is 10741827072 blocks in 
size and "cat /proc/partitions" tells us the md device is 10741958144 
blocks in size (a little larger)

Case 2: When we create a SINGLE partition on each 3ware device using 
parted, the partitions /dev/sdb1 and /dev/sdc1 are each reported to be 
34 blocks smaller than the RAW 3ware devices mentioned above in Case 1. 
Yet, when we stripe together /dev/sdb1 + /dev/sdc1, we get a Linux md 
device that is IDENTICAL in size to the "Linux md" device mentioned 
above -- 10741958144 blocks. We don't understand why the resulting 
"Linux md" device isn't 68 blocks smaller than when we use the raw 3ware 
device. In the SINGLE partition case, "df -h" also tells us that the 
device is 11 TB in size.

Case 3: When we create TWO partitions on each 3ware device using parted, 
the sum of the size of the partitions on each device (i.e., /dev/sdb1 + 
/dev/sdb2) is the SAME as the size reported in Case 2 above for 
/dev/sdb1, that is, 34 blocks smaller than the RAW 3ware device 
"/dev/sdb". However, when we use mdadm to stripe together the first 
partition on each device and also to stripe together the second 
partition on each device (/dev/sdb1 + /dev/sdc1 = /dev/md1 AND /dev/sdb2 
+ /dev/sdc2 = /dev/md2), "df -h reports that the total size of the two 
Linux RAID-0 arrays is 0.8 TB LESS than when we stripe together the RAW 
3ware devices or when we only have ONE partition.  And "df -k" reports 
that the total block size of the two mdX arrays is 10741694464 blocks, 
which is 114532 blocks smaller than size reported for the "md" device 
when we have NO partitions and 132072 blocks smaller than when we have a 
SINGLE partition.

We are wondering what these discrepencies mean and whether they could 
lead to filesystem corruption issues? (BTW, "mdadm -E" seems to be 
totally whacky with these devices. Whereas the raw devices are 
approximately 5.5 TB, "mdadm -E" reports that they are just a little 
over 1000 GB. But mdadm --query --detail seems correct. Maybe this is a 
different mdadm bug that already got fixed (however, we are on version 
1.12.0 -- which seems to be the latest version)

Somewhere along the line, various Linux tools seem to be confused about 
the space on these devices.

I hope somebody can shed some light here!

Thanks in advance,
Andy Liebman


Below is some raw data about each system:

xfs_info

Device with SINGLE partition:

[root@localhost admin]# xfs_info /RAIDS/RAID_1
meta-data=/RAIDS/RAID_1          isize=256    agcount=32, agsize=83921600
blks
        =                       sectsz=512
data     =                       bsize=4096   blocks=2685489536, imaxpct=25
        =                       sunit=64     swidth=128 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
        =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=524288 blocks=0, rtextents=0


Device with NO partitions:
 
root@localhost admin]# xfs_info /RAIDS/RAID_2
meta-data=/RAIDS/RAID_2          isize=256    agcount=32, agsize=83921600
blks
        =                       sectsz=512
data     =                       bsize=4096   blocks=2685489536, imaxpct=25
        =                       sunit=64     swidth=128 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
        =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=524288 blocks=0, rtextents=0



Device with TWO partitions:

[root@localhost admin]# xfs_info /RAIDS/RAID_1
meta-data=/RAIDS/RAID_1          isize=256    agcount=32, agsize=41961664
blks
        =                       sectsz=512
data     =                       bsize=4096   blocks=1342773248, imaxpct=25
        =                       sunit=64     swidth=128 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
        =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=524288 blocks=0, rtextents=0

[root@localhost admin]# xfs_info /RAIDS/RAID_2
meta-data=/RAIDS/RAID_2          isize=256    agcount=32, agsize=41959872
blks
        =                       sectsz=512
data     =                       bsize=4096   blocks=1342715904, imaxpct=25
        =                       sunit=64     swidth=128 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
        =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=524288 blocks=0, rtextents=0



mdadm --query --detail

Device with SINGLE partition

[root@localhost admin]# mdadm --query --detail /dev/md1
/dev/md1:
       Version : 00.90.02
 Creation Time : Mon Mar 27 09:30:35 2006
    Raid Level : raid0
    Array Size : 10741958144 (10244.33 GiB 10999.77 GB)
  Raid Devices : 2
 Total Devices : 2
Preferred Minor : 1
   Persistence : Superblock is persistent

   Update Time : Mon Mar 27 09:30:35 2006
         State : clean
Active Devices : 2
Working Devices : 2
Failed Devices : 0
 Spare Devices : 0

    Chunk Size : 256K

          UUID : 6603dcff:7ce336a8:d4b5e0a6:0f0d7d16
        Events : 0.2

   Number   Major   Minor   RaidDevice State
      0       8       17        0      active sync   /dev/sdb1
      1       8       33        1      active sync   /dev/sdc1



Device with NO partitions:
 
[root@localhost admin]# mdadm --query --detail /dev/md2
/dev/md2:
       Version : 00.90.02
 Creation Time : Sun Jan 22 04:06:58 2006
    Raid Level : raid0
    Array Size : 10741958144 (10244.33 GiB 10999.77 GB)
  Raid Devices : 2
 Total Devices : 2
Preferred Minor : 2
   Persistence : Superblock is persistent

   Update Time : Sun Jan 22 04:06:58 2006
         State : clean
Active Devices : 2
Working Devices : 2
Failed Devices : 0
 Spare Devices : 0

    Chunk Size : 256K

          UUID : c0e066fe:656ff651:bd71f666:03378481
        Events : 0.1

   Number   Major   Minor   RaidDevice State
      0       8       32        0      active sync   /dev/sdc
      1       8       48        1      active sync   /dev/sdd

Device with TWO partitions:

[root@localhost admin]# mdadm --query --detail /dev/md1
/dev/md1:
       Version : 00.90.02
 Creation Time : Fri Mar 24 08:13:54 2006
    Raid Level : raid0
    Array Size : 5371093504 (5122.27 GiB 5500.00 GB)
  Raid Devices : 2
 Total Devices : 2
Preferred Minor : 1
   Persistence : Superblock is persistent

   Update Time : Fri Mar 24 08:13:54 2006
         State : clean
Active Devices : 2
Working Devices : 2
Failed Devices : 0
 Spare Devices : 0

    Chunk Size : 256K

          UUID : 40ea6266:ba1b3330:21674ca4:57a2aca7
        Events : 0.1

   Number   Major   Minor   RaidDevice State
      0       8       17        0      active sync   /dev/sdb1
      1       8       33        1      active sync   /dev/sdc1
[root@localhost admin]# mdadm --query --detail /dev/md2
/dev/md2:
       Version : 00.90.02
 Creation Time : Fri Mar 24 08:14:07 2006
    Raid Level : raid0
    Array Size : 5370864640 (5122.06 GiB 5499.77 GB)
  Raid Devices : 2
 Total Devices : 2
Preferred Minor : 2
   Persistence : Superblock is persistent

   Update Time : Fri Mar 24 08:14:07 2006
         State : clean
Active Devices : 2
Working Devices : 2
Failed Devices : 0
 Spare Devices : 0

    Chunk Size : 256K

          UUID : a8cc58ca:7a31b91a:c568d2ba:004d34b2
        Events : 0.1

   Number   Major   Minor   RaidDevice State
      0       8       18        0      active sync   /dev/sdb2
      1       8       34        1      active sync   /dev/sdc2



DF Results:
Boston device with SINGLE partition:
[root@localhost admin]# df
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda1             9.7G  4.3G  4.9G  47% /
/dev/sda6              44G  2.5G   42G   6% /home
/dev/md1               11T  536K   11T   1% /RAIDS/RAID_1

[root@localhost admin]# df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda1             10072456   4486028   5074760  47% /
/dev/sda6             45960116   2524524  43435592   6% /home
/dev/md1             10741827072       536 10741826536   1% /RAIDS/RAID_1



Device with NO partitions:
 
[root@localhost admin]# df
Filesystem            Size  Used Avail Use% Mounted on
/dev/hda1              13G  6.1G  6.2G  50% /
/dev/hda6              60G  3.6G   56G   6% /home
/dev/md2               11T   18M   11T   1% /RAIDS/RAID_2

[root@localhost admin]# df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/hda1             13505616   6378796   6440764  50% /
/dev/hda6             62411220   3739768  58671452   6% /home
/dev/md2             10741827072     18076 10741808996   1% /RAIDS/RAID_2


Device with TWO partitions:

[root@localhost ~]$ df
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda1             9.7G  4.3G  4.9G  47% /
/dev/sda6              44G  2.5G   42G   6% /home
/dev/md1              5.1T  1.1M  5.1T   1% /RAIDS/RAID_1
/dev/md2              5.1T  1.6M  5.1T   1% /RAIDS/RAID_2

[root@localhost ~]$ df -k
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sda1             10072456   4485836   5074952  47% /
/dev/sda6             45960116   2524516  43435600   6% /home
/dev/md1             5370961920      1064 5370960856   1% /RAIDS/RAID_1
/dev/md2             5370732544      1608 5370730936   1% /RAIDS/RAID_2




