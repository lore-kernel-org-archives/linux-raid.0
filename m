From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Trying to start dirty, degraded RAID6 array
Date: Thu, 27 Apr 2006 09:37:29 +1000
Message-ID: <44500439.1020108@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The short version:

I have a 12-disk RAID6 array that has lost a device and now whenever I 
try to start it with:

mdadm -Af /dev/md0 /dev/sd[abcdefgijkl]1

I get:

mdadm: failed to RUN_ARRAY /dev/md0: Input/output error

And in dmesg:

md: bind<sdk1>
md: bind<sdi1>
md: bind<sdj1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sdg1>
md: bind<sdb1>
md: bind<sdd1>
md: bind<sda1>
md: bind<sdc1>
md: bind<sdl1>
md: md0: raid array is not clean -- starting background reconstruction
raid6: device sdl1 operational as raid disk 0
raid6: device sdc1 operational as raid disk 11
raid6: device sda1 operational as raid disk 10
raid6: device sdd1 operational as raid disk 9
raid6: device sdb1 operational as raid disk 8
raid6: device sdg1 operational as raid disk 6
raid6: device sdf1 operational as raid disk 5
raid6: device sde1 operational as raid disk 4
raid6: device sdj1 operational as raid disk 3
raid6: device sdi1 operational as raid disk 2
raid6: device sdk1 operational as raid disk 1
raid6: cannot start dirty degraded array for md0
RAID6 conf printout:
  --- rd:12 wd:11 fd:1
  disk 0, o:1, dev:sdl1
  disk 1, o:1, dev:sdk1
  disk 2, o:1, dev:sdi1
  disk 3, o:1, dev:sdj1
  disk 4, o:1, dev:sde1
  disk 5, o:1, dev:sdf1
  disk 6, o:1, dev:sdg1
  disk 8, o:1, dev:sdb1
  disk 9, o:1, dev:sdd1
  disk 10, o:1, dev:sda1
  disk 11, o:1, dev:sdc1
raid6: failed to run raid set md0
md: pers->run() failed ...


I'm 99% sure the data is ok and I'd like to know how to force the array 
online.



Longer version:

A couple of days ago I started having troubles with my fileserver 
mysteriously hanging during boot (I was messing with trying to get Xen 
running at the time, so lots of reboots were involved).  I finally 
nailed it down to the autostarting of the RAID array.

After several hours of pulling CPUs, SATA cards, RAM (not to mention 
some scary problems with memtest86+ that turned out to be because "USB 
Legacy" was enabled) I finally managed to figure out that one of my 
drives would simply stop transferring data after about the first gig 
(tested with dd, monitoring with iostat).  About 30 seconds after the 
drive "stops", the rest of the machine also hangs.

Interestingly, there are no error messages anywhere I could find 
indicating the drive was having problem.  Even its SMART test (smartctl 
-t long) says it's ok.  This made the problem substantially more 
difficult to figure out.

I then tried to start the array without the broken disk and had the 
problem mentioned in the short version above - the array wouldn't start, 
presumably because its rebuild had been started and (uncleanly) stopped 
about a dozen times since it last succeeeded.  I finally managed to get 
the array online by starting it with all the disks, then immediately 
knocking the one I knew to be bad offline with 'mdadm /dev/md0 -f 
/dev/sdh1' before it hit the point where it would hang.  After that the 
rebuild completed without error (I didn't touch the machine at all while 
it was rebuilding).

However, a few hours after the rebuild completed, a power failure killed 
the machine again and now I can't start the array, as outlined in the 
"short version" above.  I must admit I find it a bit weird that the 
array is "dirty and degraded" after it had successfully completed a rebuild.

Unfortunately the original failed drive (/dev/sdh) is no longer 
available, so I can't do my original trick again.  I'm pretty sure - 
based on the rebuild completing previously - that the data will be fine 
if I can just get the array back online, is there some sort of 
--really-force switch to mdadm ?  Can the array be brought back online 
*without* triggering a rebuild, so I can get as much data as possible 
off and then start from scratch again ?

CS

Here is the 'mdadm --examine /dev/sdX' output for each of the remaining 
drives, if it is helpful:

/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 78ddbb47:e4dfcf9e:5f24461a:19104298
  Creation Time : Wed Feb  1 01:09:11 2006
     Raid Level : raid6
    Device Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 2441959040 (2328.83 GiB 2500.57 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 0

    Update Time : Wed Apr 26 22:30:01 2006
          State : active
  Active Devices : 11
Working Devices : 11
  Failed Devices : 1
  Spare Devices : 0
       Checksum : 1685ebfc - correct
         Events : 0.11176511


      Number   Major   Minor   RaidDevice State
this    10       8        1       10      active sync   /dev/sda1

   0     0       8      177        0      active sync   /dev/sdl1
   1     1       8      161        1      active sync   /dev/sdk1
   2     2       8      129        2      active sync   /dev/sdi1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      active sync   /dev/sdb1
   9     9       8       49        9      active sync   /dev/sdd1
  10    10       8        1       10      active sync   /dev/sda1
  11    11       8       33       11      active sync   /dev/sdc1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 78ddbb47:e4dfcf9e:5f24461a:19104298
  Creation Time : Wed Feb  1 01:09:11 2006
     Raid Level : raid6
    Device Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 2441959040 (2328.83 GiB 2500.57 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 0

    Update Time : Wed Apr 26 22:30:01 2006
          State : active
  Active Devices : 11
Working Devices : 11
  Failed Devices : 1
  Spare Devices : 0
       Checksum : 1685ec08 - correct
         Events : 0.11176511


      Number   Major   Minor   RaidDevice State
this     8       8       17        8      active sync   /dev/sdb1

   0     0       8      177        0      active sync   /dev/sdl1
   1     1       8      161        1      active sync   /dev/sdk1
   2     2       8      129        2      active sync   /dev/sdi1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      active sync   /dev/sdb1
   9     9       8       49        9      active sync   /dev/sdd1
  10    10       8        1       10      active sync   /dev/sda1
  11    11       8       33       11      active sync   /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 78ddbb47:e4dfcf9e:5f24461a:19104298
  Creation Time : Wed Feb  1 01:09:11 2006
     Raid Level : raid6
    Device Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 2441959040 (2328.83 GiB 2500.57 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 0

    Update Time : Wed Apr 26 22:30:01 2006
          State : active
  Active Devices : 11
Working Devices : 11
  Failed Devices : 1
  Spare Devices : 0
       Checksum : 1685ec1e - correct
         Events : 0.11176511


      Number   Major   Minor   RaidDevice State
this    11       8       33       11      active sync   /dev/sdc1

   0     0       8      177        0      active sync   /dev/sdl1
   1     1       8      161        1      active sync   /dev/sdk1
   2     2       8      129        2      active sync   /dev/sdi1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      active sync   /dev/sdb1
   9     9       8       49        9      active sync   /dev/sdd1
  10    10       8        1       10      active sync   /dev/sda1
  11    11       8       33       11      active sync   /dev/sdc1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 78ddbb47:e4dfcf9e:5f24461a:19104298
  Creation Time : Wed Feb  1 01:09:11 2006
     Raid Level : raid6
    Device Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 2441959040 (2328.83 GiB 2500.57 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 0

    Update Time : Wed Apr 26 22:30:01 2006
          State : active
  Active Devices : 11
Working Devices : 11
  Failed Devices : 1
  Spare Devices : 0
       Checksum : 1685ec2a - correct
         Events : 0.11176511


      Number   Major   Minor   RaidDevice State
this     9       8       49        9      active sync   /dev/sdd1

   0     0       8      177        0      active sync   /dev/sdl1
   1     1       8      161        1      active sync   /dev/sdk1
   2     2       8      129        2      active sync   /dev/sdi1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      active sync   /dev/sdb1
   9     9       8       49        9      active sync   /dev/sdd1
  10    10       8        1       10      active sync   /dev/sda1
  11    11       8       33       11      active sync   /dev/sdc1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 78ddbb47:e4dfcf9e:5f24461a:19104298
  Creation Time : Wed Feb  1 01:09:11 2006
     Raid Level : raid6
    Device Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 2441959040 (2328.83 GiB 2500.57 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 0

    Update Time : Wed Apr 26 22:30:01 2006
          State : active
  Active Devices : 11
Working Devices : 11
  Failed Devices : 1
  Spare Devices : 0
       Checksum : 1685ec30 - correct
         Events : 0.11176511


      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

   0     0       8      177        0      active sync   /dev/sdl1
   1     1       8      161        1      active sync   /dev/sdk1
   2     2       8      129        2      active sync   /dev/sdi1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      active sync   /dev/sdb1
   9     9       8       49        9      active sync   /dev/sdd1
  10    10       8        1       10      active sync   /dev/sda1
  11    11       8       33       11      active sync   /dev/sdc1
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 78ddbb47:e4dfcf9e:5f24461a:19104298
  Creation Time : Wed Feb  1 01:09:11 2006
     Raid Level : raid6
    Device Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 2441959040 (2328.83 GiB 2500.57 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 0

    Update Time : Wed Apr 26 22:30:01 2006
          State : active
  Active Devices : 11
Working Devices : 11
  Failed Devices : 1
  Spare Devices : 0
       Checksum : 1685ec42 - correct
         Events : 0.11176511


      Number   Major   Minor   RaidDevice State
this     5       8       81        5      active sync   /dev/sdf1

   0     0       8      177        0      active sync   /dev/sdl1
   1     1       8      161        1      active sync   /dev/sdk1
   2     2       8      129        2      active sync   /dev/sdi1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      active sync   /dev/sdb1
   9     9       8       49        9      active sync   /dev/sdd1
  10    10       8        1       10      active sync   /dev/sda1
  11    11       8       33       11      active sync   /dev/sdc1
/dev/sdg1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 78ddbb47:e4dfcf9e:5f24461a:19104298
  Creation Time : Wed Feb  1 01:09:11 2006
     Raid Level : raid6
    Device Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 2441959040 (2328.83 GiB 2500.57 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 0

    Update Time : Wed Apr 26 22:30:01 2006
          State : active
  Active Devices : 11
Working Devices : 11
  Failed Devices : 1
  Spare Devices : 0
       Checksum : 1685ec54 - correct
         Events : 0.11176511


      Number   Major   Minor   RaidDevice State
this     6       8       97        6      active sync   /dev/sdg1

   0     0       8      177        0      active sync   /dev/sdl1
   1     1       8      161        1      active sync   /dev/sdk1
   2     2       8      129        2      active sync   /dev/sdi1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      active sync   /dev/sdb1
   9     9       8       49        9      active sync   /dev/sdd1
  10    10       8        1       10      active sync   /dev/sda1
  11    11       8       33       11      active sync   /dev/sdc1
/dev/sdi1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 78ddbb47:e4dfcf9e:5f24461a:19104298
  Creation Time : Wed Feb  1 01:09:11 2006
     Raid Level : raid6
    Device Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 2441959040 (2328.83 GiB 2500.57 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 0

    Update Time : Wed Apr 26 22:30:01 2006
          State : active
  Active Devices : 11
Working Devices : 11
  Failed Devices : 1
  Spare Devices : 0
       Checksum : 1685ec6c - correct
         Events : 0.11176511


      Number   Major   Minor   RaidDevice State
this     2       8      129        2      active sync   /dev/sdi1

   0     0       8      177        0      active sync   /dev/sdl1
   1     1       8      161        1      active sync   /dev/sdk1
   2     2       8      129        2      active sync   /dev/sdi1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      active sync   /dev/sdb1
   9     9       8       49        9      active sync   /dev/sdd1
  10    10       8        1       10      active sync   /dev/sda1
  11    11       8       33       11      active sync   /dev/sdc1
/dev/sdj1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 78ddbb47:e4dfcf9e:5f24461a:19104298
  Creation Time : Wed Feb  1 01:09:11 2006
     Raid Level : raid6
    Device Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 2441959040 (2328.83 GiB 2500.57 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 0

    Update Time : Wed Apr 26 22:30:01 2006
          State : active
  Active Devices : 11
Working Devices : 11
  Failed Devices : 1
  Spare Devices : 0
       Checksum : 1685ec7e - correct
         Events : 0.11176511


      Number   Major   Minor   RaidDevice State
this     3       8      145        3      active sync   /dev/sdj1

   0     0       8      177        0      active sync   /dev/sdl1
   1     1       8      161        1      active sync   /dev/sdk1
   2     2       8      129        2      active sync   /dev/sdi1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      active sync   /dev/sdb1
   9     9       8       49        9      active sync   /dev/sdd1
  10    10       8        1       10      active sync   /dev/sda1
  11    11       8       33       11      active sync   /dev/sdc1
/dev/sdk1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 78ddbb47:e4dfcf9e:5f24461a:19104298
  Creation Time : Wed Feb  1 01:09:11 2006
     Raid Level : raid6
    Device Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 2441959040 (2328.83 GiB 2500.57 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 0

    Update Time : Wed Apr 26 22:30:01 2006
          State : active
  Active Devices : 11
Working Devices : 11
  Failed Devices : 1
  Spare Devices : 0
       Checksum : 1685ec8a - correct
         Events : 0.11176511


      Number   Major   Minor   RaidDevice State
this     1       8      161        1      active sync   /dev/sdk1

   0     0       8      177        0      active sync   /dev/sdl1
   1     1       8      161        1      active sync   /dev/sdk1
   2     2       8      129        2      active sync   /dev/sdi1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      active sync   /dev/sdb1
   9     9       8       49        9      active sync   /dev/sdd1
  10    10       8        1       10      active sync   /dev/sda1
  11    11       8       33       11      active sync   /dev/sdc1
/dev/sdl1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 78ddbb47:e4dfcf9e:5f24461a:19104298
  Creation Time : Wed Feb  1 01:09:11 2006
     Raid Level : raid6
    Device Size : 244195904 (232.88 GiB 250.06 GB)
     Array Size : 2441959040 (2328.83 GiB 2500.57 GB)
   Raid Devices : 12
  Total Devices : 11
Preferred Minor : 0

    Update Time : Wed Apr 26 22:30:01 2006
          State : active
  Active Devices : 11
Working Devices : 11
  Failed Devices : 1
  Spare Devices : 0
       Checksum : 1685ec98 - correct
         Events : 0.11176511


      Number   Major   Minor   RaidDevice State
this     0       8      177        0      active sync   /dev/sdl1

   0     0       8      177        0      active sync   /dev/sdl1
   1     1       8      161        1      active sync   /dev/sdk1
   2     2       8      129        2      active sync   /dev/sdi1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8       97        6      active sync   /dev/sdg1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      active sync   /dev/sdb1
   9     9       8       49        9      active sync   /dev/sdd1
  10    10       8        1       10      active sync   /dev/sda1
  11    11       8       33       11      active sync   /dev/sdc1



Cheers,
CS
