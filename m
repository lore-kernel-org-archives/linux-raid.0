From: Maarten <maarten@ultratux.net>
Subject: re-assembling arrays after severe controller hardware issues...
Date: Fri, 25 Oct 2013 23:19:21 +0200
Message-ID: <526AE059.8020006@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi

I suffered a coupleof (subsequent) multi-disk raid failures caused by
hardware (not disk) issues. I now am reasonably confident the cause of
the hardware issues has been remedied. Looking at one of the arrays I
see differing event counters, but all close together. If I attempt
--assemble that doesn't work, mdadm insists on only taking two of the
six raid6 members into account.. Am I correct that an added --force will
rectify that, or is a different course of action necessary ?

mouse ~ # cat /proc/mdstat

md1 : inactive sdi1[0](S) sdh1[5](S) sdb1[4](S) sdg1[2](S) sdc1[1](S)
      4869638272 blocks

mouse ~ # mdadm --examine /dev/sd[ihgcb]1|grep -i uuid
           UUID : e1b1c874:1000f29b:d02b8c28:1a80597f
           UUID : e1b1c874:1000f29b:d02b8c28:1a80597f
           UUID : e1b1c874:1000f29b:d02b8c28:1a80597f
           UUID : e1b1c874:1000f29b:d02b8c28:1a80597f
           UUID : e1b1c874:1000f29b:d02b8c28:1a80597f
mouse ~ # mdadm --examine /dev/sd[ihgcb]1|grep -i events
         Events : 115315
         Events : 115308
         Events : 115312
         Events : 115311
         Events : 115315

It looks like it just takes the two 115315 ones, I figure. I need to
tell it to consider all five, regardless of events counter. Is
--assemble --force the right thing here?

(Yes, there was a sixth member too, but I suffered a crash (kernel
kicked a controller with 5 disks on it) during the re-adding of that one
disk, so I have therefore deemed it unsafe to use for --assemble, so
that one is marked and put away safely)

cheers,
Maarten

For the sake of completeness, here's the full --examine outputs:

/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : e1b1c874:1000f29b:d02b8c28:1a80597f
  Creation Time : Sun Jan 31 23:07:37 2010
     Raid Level : raid6
  Used Dev Size : 971932352 (926.91 GiB 995.26 GB)
     Array Size : 3887729408 (3707.63 GiB 3981.03 GB)
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 1

    Update Time : Fri Sep 27 22:56:30 2013
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 4
  Spare Devices : 0
       Checksum : 5d28eaa8 - correct
         Events : 115315

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       17        4      active sync   /dev/sdb1

   0     0       8      209        0      active sync
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8       17        4      active sync   /dev/sdb1
   5     5       0        0        5      faulty removed
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : e1b1c874:1000f29b:d02b8c28:1a80597f
  Creation Time : Sun Jan 31 23:07:37 2010
     Raid Level : raid6
  Used Dev Size : 971932352 (926.91 GiB 995.26 GB)
     Array Size : 3887729408 (3707.63 GiB 3981.03 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1

    Update Time : Wed Sep 25 12:42:47 2013
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 5d25b882 - correct
         Events : 115308

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8      129        1      active sync   /dev/sdi1

   0     0       8      209        0      active sync
   1     1       8      129        1      active sync   /dev/sdi1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       8       17        4      active sync   /dev/sdb1
   5     5       8       81        5      active sync   /dev/sdf1
/dev/sdg1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : e1b1c874:1000f29b:d02b8c28:1a80597f
  Creation Time : Sun Jan 31 23:07:37 2010
     Raid Level : raid6
  Used Dev Size : 971932352 (926.91 GiB 995.26 GB)
     Array Size : 3887729408 (3707.63 GiB 3981.03 GB)
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 1

    Update Time : Fri Sep 27 22:40:25 2013
          State : clean
 Active Devices : 3
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 1
       Checksum : 5d28e6f7 - correct
         Events : 115312

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       65        2      active sync   /dev/sde1

   0     0       8      209        0      active sync
   1     1       0        0        1      faulty removed
   2     2       8       65        2      active sync   /dev/sde1
   3     3       0        0        3      faulty removed
   4     4       8       17        4      active sync   /dev/sdb1
   5     5       0        0        5      faulty removed
   6     6       8      113        6      spare   /dev/sdh1
/dev/sdh1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : e1b1c874:1000f29b:d02b8c28:1a80597f
  Creation Time : Sun Jan 31 23:07:37 2010
     Raid Level : raid6
  Used Dev Size : 971932352 (926.91 GiB 995.26 GB)
     Array Size : 3887729408 (3707.63 GiB 3981.03 GB)
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 1

    Update Time : Fri Sep 27 22:23:09 2013
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 5d28e2ee - correct
         Events : 115311

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       81        5      active sync   /dev/sdf1

   0     0       8      209        0      active sync
   1     1       0        0        1      faulty removed
   2     2       8       65        2      active sync   /dev/sde1
   3     3       0        0        3      faulty removed
   4     4       8       17        4      active sync   /dev/sdb1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       8      113        6      spare   /dev/sdh1
/dev/sdi1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : e1b1c874:1000f29b:d02b8c28:1a80597f
  Creation Time : Sun Jan 31 23:07:37 2010
     Raid Level : raid6
  Used Dev Size : 971932352 (926.91 GiB 995.26 GB)
     Array Size : 3887729408 (3707.63 GiB 3981.03 GB)
   Raid Devices : 6
  Total Devices : 5
Preferred Minor : 1

    Update Time : Fri Sep 27 22:56:30 2013
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 4
  Spare Devices : 0
       Checksum : 5d28eb60 - correct
         Events : 115315

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8      209        0      active sync

   0     0       8      209        0      active sync
   1     1       0        0        1      faulty removed
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
   4     4       8       17        4      active sync   /dev/sdb1
   5     5       0        0        5      faulty removed

