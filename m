From: Christopher Hoover <ch@murgatroid.com>
Subject: unable to assemble (mostly?) clean array
Date: Sun, 8 Dec 2013 15:32:42 -0800
Message-ID: <CACw0PsYr+u=YqXQJtUBLDzoppXPWCoRRLUqvgPLE4_L+V68iZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi folks,

what's the safest way to get this array back into r/o mode?

thanks,
-ch
ch@murgatroid.com


ch@snaggle:~$ sudo mdadm --examine /dev/sd[defg]1 | egrep 'Event|^/dev/sd'

/dev/sdd1:

         Events : 286024

/dev/sde1:

         Events : 286011

/dev/sdf1:

         Events : 286024

/dev/sdg1:

         Events : 286024

ch@snaggle:~$ sudo mdadm --assemble --force  /dev/md0 /dev/sdd1
/dev/sde1 /sdg1

mdadm: cannot open device /sdg1: No such file or directory

mdadm: /sdg1 has no superblock - assembly aborted

ch@snaggle:~$ sudo mdadm --assemble --force  /dev/md0 /dev/sdd1 /dev/sde1

mdadm: ignoring /dev/sde1 as it reports /dev/sdd1 as failed

mdadm: /dev/md0 assembled from 0 drives and 1 spare - not enough to
start the array.

ch@snaggle:~$ sudo mdadm -E /dev/sd[defg]1

/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 48af1ed4:8978e992:f8a6b934:875c877f (local to host snaggle)
  Creation Time : Mon May 23 00:02:10 2011
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 2930271872 (2794.53 GiB 3000.60 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Dec  3 21:19:31 2013
          State : clean
 Active Devices : 1
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 2
       Checksum : f32d49b0 - correct
         Events : 286024

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       33        4      spare

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       65        2      active sync   /dev/sde1
   3     3       0        0        3      faulty removed
   4     4       8       33        4      spare
   5     5       8       81        5      spare   /dev/sdf1
/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 48af1ed4:8978e992:f8a6b934:875c877f (local to host snaggle)
  Creation Time : Mon May 23 00:02:10 2011
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 2930271872 (2794.53 GiB 3000.60 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Dec  1 18:03:17 2013
          State : clean
 Active Devices : 2
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 2
       Checksum : f32a7899 - correct
         Events : 286011

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync   /dev/sdd1

   0     0       0        0        0      removed
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       0        0        3      faulty removed
   4     4       8       33        4      spare
   5     5       8       81        5      spare   /dev/sdf1
/dev/sdf1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 48af1ed4:8978e992:f8a6b934:875c877f (local to host snaggle)
  Creation Time : Mon May 23 00:02:10 2011
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 2930271872 (2794.53 GiB 3000.60 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Dec  3 21:19:31 2013
          State : clean
 Active Devices : 1
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 2
       Checksum : f32d49d2 - correct
         Events : 286024

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       65        2      active sync   /dev/sde1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       65        2      active sync   /dev/sde1
   3     3       0        0        3      faulty removed
   4     4       8       33        4      spare
   5     5       8       81        5      spare   /dev/sdf1
/dev/sdg1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 48af1ed4:8978e992:f8a6b934:875c877f (local to host snaggle)
  Creation Time : Mon May 23 00:02:10 2011
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 2930271872 (2794.53 GiB 3000.60 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Dec  3 21:19:31 2013
          State : clean
 Active Devices : 1
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 2
       Checksum : f32d49e2 - correct
         Events : 286024

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       81        5      spare   /dev/sdf1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       65        2      active sync   /dev/sde1
   3     3       0        0        3      faulty removed
   4     4       8       33        4      spare
   5     5       8       81        5      spare   /dev/sdf1
