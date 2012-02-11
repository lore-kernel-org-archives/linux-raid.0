From: Felipe Sanchez <izto@asic-linux.com.mx>
Subject: equal / larger size still not large enough (3.2.3)
Date: Sat, 11 Feb 2012 13:25:30 -0600 (CST)
Message-ID: <Pine.LNX.4.62.1202111259530.17781@iserv.asic-linux.com.mx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi, I just bumped into a problem every mailing list I checked said was 
fixed long ago, but doesn't seem to be.

I have this array:

md9 : active raid1 sda9[0]
       1416025216 blocks [2/1] [U_]


Which had these two members originally:

# sfdisk -s /dev/sda9
1416025296

# sfdisk -s /dev/sdb9
1455087343


/dev/sdb9 failed a while ago so I replaced it with a larger drive, 
partitioned it with sfdisk -d /dev/sda | sfdisk /dev/sdb (So all 
partitions where exactly the same size as before, and they were) and when 
I tried to add /dev/sdb9 to /dev/md9 mdadm said:

mdadm: /dev/sdb9 not large enough to join array

"But they're the same size!" I thought. So I googled the message and found 
some mailing list post about the internal bitmaps and a patch for mdadm 
2.6. I thought mmh.. I'm running mdadm 3.2, let me check. So I checked the 
patch and the source code for mdadm-3.2.3 and it does seem to be included 
in this release (I'd expect it to since the post above was from years 
ago).

So I deleted the sdb partition and tried creating a bigger one. And a 
bigger one. And it didn't seem to help. mdadm-3.2.3 still insists it isn't 
large enough.

Last resort: somewhere I read this was a bug introduced sometime along 
the 2.x release cycle. So I tried an old mdadm-1.9 I had lying around and 
it worked perfectly. The new (now even bigger than the original array) 
partition was hot-added without a hiccup.

The issue is perfectly reproducible. I can manually set faulty and remove 
sdb9 and mdadm-3.2.3 won't let me add it right back:

# mdadm -f /dev/md9 /dev/sdb9
mdadm: set /dev/sdb9 faulty in /dev/md9

# mdadm -r /dev/md9 /dev/sdb9
mdadm: hot removed /dev/sdb9 from /dev/md9

# mdadm -a /dev/md9 /dev/sdb9
mdadm: /dev/sdb9 not large enough to join array


But mdadm-1.9 has no problem doing it:

# ./mdadm-1.9 -a /dev/md9 /dev/sdb9
mdadm: hot added /dev/sdb9


The mdadm versions involved:

# mdadm -V
mdadm - v3.2.3 - 23rd December 2011

# ./mdadm-1.9 -V
mdadm - v1.9.0 - 04 February 2005



Here is the mdadm -E info for both partitions and the output of fdisk -l 
for both disks:

# mdadm -E /dev/sda9
/dev/sda9:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 7d2c173a:01c5f107:0c6fe4a4:710cf4f0 (local to host 
xxxxxxxx)
   Creation Time : Fri Feb 10 00:17:41 2012
      Raid Level : raid1
   Used Dev Size : 1416025216 (1350.43 GiB 1450.01 GB)
      Array Size : 1416025216 (1350.43 GiB 1450.01 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 9

     Update Time : Sat Feb 11 13:15:51 2012
           State : clean
  Active Devices : 1
Working Devices : 2
  Failed Devices : 1
   Spare Devices : 1
        Checksum : 9870263f - correct
          Events : 120218


       Number   Major   Minor   RaidDevice State
this     0       8        9        0      active sync   /dev/sda9

    0     0       8        9        0      active sync   /dev/sda9
    1     1       0        0        1      faulty removed
    2     2       8       25        2      spare   /dev/sdb9



# mdadm -E /dev/sdb9
/dev/sdb9:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 7d2c173a:01c5f107:0c6fe4a4:710cf4f0 (local to host 
xxxxxxxxxx)
   Creation Time : Fri Feb 10 00:17:41 2012
      Raid Level : raid1
   Used Dev Size : 1416025216 (1350.43 GiB 1450.01 GB)
      Array Size : 1416025216 (1350.43 GiB 1450.01 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 9

     Update Time : Sat Feb 11 13:15:51 2012
           State : clean
  Active Devices : 1
Working Devices : 2
  Failed Devices : 1
   Spare Devices : 1
        Checksum : 9870264d - correct
          Events : 120218


       Number   Major   Minor   RaidDevice State
this     2       8       25        2      spare   /dev/sdb9

    0     0       8        9        0      active sync   /dev/sda9
    1     1       0        0        1      faulty removed
    2     2       8       25        2      spare   /dev/sdb9


# fdisk -l /dev/sda /dev/sdb

Disk /dev/sda: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *          38         287     2008125   fd  Linux raid 
autodetect
/dev/sda2               6          37      257040   82  Linux swap / 
Solaris
/dev/sda3               1           5       40131   fd  Linux raid 
autodetect
/dev/sda4             288      182401  1462830705    5  Extended
/dev/sda5             288         350      506016   fd  Linux raid 
autodetect
/dev/sda6             351         413      506016   fd  Linux raid 
autodetect
/dev/sda7             414         912     4008186   fd  Linux raid 
autodetect
/dev/sda8             913        1037     1004031   fd  Linux raid 
autodetect
/dev/sda9            1038      177324  1416025296   fd  Linux raid 
autodetect

Partition table entries are not in disk order

Disk /dev/sdb: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *          38         287     2008125   fd  Linux raid 
autodetect
/dev/sdb2               6          37      257040   82  Linux swap / 
Solaris
/dev/sdb3               1           5       40131   fd  Linux raid 
autodetect
/dev/sdb4             288      182401  1462830705    5  Extended
/dev/sdb5             288         350      506016   fd  Linux raid 
autodetect
/dev/sdb6             351         413      506016   fd  Linux raid 
autodetect
/dev/sdb7             414         912     4008186   fd  Linux raid 
autodetect
/dev/sdb8             913        1037     1004031   fd  Linux raid 
autodetect
/dev/sdb9            1038      182187  1455087343+  fd  Linux raid 
autodetect

Partition table entries are not in disk order

