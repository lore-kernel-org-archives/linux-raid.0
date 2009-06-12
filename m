From: Jim Paris <jim@jtan.com>
Subject: Re: Assembly problems with kernel 2.6.30?
Date: Thu, 11 Jun 2009 22:33:44 -0400
Message-ID: <20090612023344.GA24806@psychosis.jim.sh>
References: <20090611072538.GA7841@psychosis.jim.sh> <18993.45142.80174.321434@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18993.45142.80174.321434@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> >   mdadm: superblock on /dev/sdc2 doesn't match others - assembly aborted
> 
> It looks at first like it might be an mdadm problem - I cannot imagine
> a kernel bug doing that.  But you say it only happened with an update
> to 2.6.30, which I cannot explain.
> Can you:
>  
>  for m in 0.90 1.0 1.1 1.2
>  do mdadm -E -e $m /dev/sd[cdef]2
>  done
> 
> and report the result?

Weird: /dev/sdc2 has both a 0.90 and 1.0 superblock.  I guess that's
the problem.  How would that have happened?  mdadm --create over an 
existing device without a --zero-superblock inbetween, I suppose?

I wonder why it was never a problem before.  For the root, only
/dev/sda2 and /dev/sdb2 are necessary.  Maybe 2.6.30 changed the disk
order, or the ordering of /proc/partitions, such that mdadm now
examines this bad disk before the array is fully assembled, whereas it
never needed to scan it before?

for d in /dev/sd{a,b,c,d,e,f}{1,2}; do
  for m in 0.90 1.0 1.1 1.2; do
     echo $m $d 
     mdadm -E -e $m $d 
  done
done

Output is below.

-jim

0.90 /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : dece84f3:a8f8be71:ea9d9fee:21fd5f90
  Creation Time : Fri Sep 22 06:18:01 2006
     Raid Level : raid1
  Used Dev Size : 128384 (125.40 MiB 131.47 MB)
     Array Size : 128384 (125.40 MiB 131.47 MB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Thu Jun 11 07:01:41 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ccd42dfc - correct
         Events : 1056


      Number   Major   Minor   RaidDevice State
this     1       8        1        1      active sync   /dev/sda1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
1.0 /dev/sda1
mdadm: No super block found on /dev/sda1 (Expected magic a92b4efc, got 00000000)
1.1 /dev/sda1
mdadm: No super block found on /dev/sda1 (Expected magic a92b4efc, got 00000000)
1.2 /dev/sda1
mdadm: No super block found on /dev/sda1 (Expected magic a92b4efc, got 00007fff)
0.90 /dev/sda2
/dev/sda2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0598d2ea:f6c0185f:614fa502:109d1a5d
  Creation Time : Fri Sep 22 06:18:16 2006
     Raid Level : raid1
  Used Dev Size : 976631424 (931.39 GiB 1000.07 GB)
     Array Size : 976631424 (931.39 GiB 1000.07 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Thu Jun 11 22:24:17 2009
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e0f457fc - correct
         Events : 252218


      Number   Major   Minor   RaidDevice State
this     1       8        2        1      active sync   /dev/sda2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8        2        1      active sync   /dev/sda2
1.0 /dev/sda2
mdadm: No super block found on /dev/sda2 (Expected magic a92b4efc, got 00000000)
1.1 /dev/sda2
mdadm: No super block found on /dev/sda2 (Expected magic a92b4efc, got 20554e47)
1.2 /dev/sda2
mdadm: No super block found on /dev/sda2 (Expected magic a92b4efc, got 6b8e963f)
0.90 /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : dece84f3:a8f8be71:ea9d9fee:21fd5f90
  Creation Time : Fri Sep 22 06:18:01 2006
     Raid Level : raid1
  Used Dev Size : 128384 (125.40 MiB 131.47 MB)
     Array Size : 128384 (125.40 MiB 131.47 MB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Thu Jun 11 07:01:41 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ccd42e0a - correct
         Events : 1056


      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
1.0 /dev/sdb1
mdadm: No super block found on /dev/sdb1 (Expected magic a92b4efc, got 00000000)
1.1 /dev/sdb1
mdadm: No super block found on /dev/sdb1 (Expected magic a92b4efc, got 00000000)
1.2 /dev/sdb1
mdadm: No super block found on /dev/sdb1 (Expected magic a92b4efc, got 00007fff)
0.90 /dev/sdb2
/dev/sdb2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0598d2ea:f6c0185f:614fa502:109d1a5d
  Creation Time : Fri Sep 22 06:18:16 2006
     Raid Level : raid1
  Used Dev Size : 976631424 (931.39 GiB 1000.07 GB)
     Array Size : 976631424 (931.39 GiB 1000.07 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Thu Jun 11 22:24:17 2009
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e0f4580a - correct
         Events : 252218


      Number   Major   Minor   RaidDevice State
this     0       8       18        0      active sync   /dev/sdb2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8        2        1      active sync   /dev/sda2
1.0 /dev/sdb2
mdadm: No super block found on /dev/sdb2 (Expected magic a92b4efc, got 00000000)
1.1 /dev/sdb2
mdadm: No super block found on /dev/sdb2 (Expected magic a92b4efc, got 20554e47)
1.2 /dev/sdb2
mdadm: No super block found on /dev/sdb2 (Expected magic a92b4efc, got 6b8e963f)
0.90 /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : dece84f3:a8f8be71:ea9d9fee:21fd5f90
  Creation Time : Fri Sep 22 06:18:01 2006
     Raid Level : raid1
  Used Dev Size : 128384 (125.40 MiB 131.47 MB)
     Array Size : 128384 (125.40 MiB 131.47 MB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Thu Jun 11 07:01:41 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ccd42e1e - correct
         Events : 1056


      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
1.0 /dev/sdc1
mdadm: No super block found on /dev/sdc1 (Expected magic a92b4efc, got 00000000)
1.1 /dev/sdc1
mdadm: No super block found on /dev/sdc1 (Expected magic a92b4efc, got 00000000)
1.2 /dev/sdc1
mdadm: No super block found on /dev/sdc1 (Expected magic a92b4efc, got 00007fff)
0.90 /dev/sdc2
/dev/sdc2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0598d2ea:f6c0185f:614fa502:109d1a5d
  Creation Time : Fri Sep 22 06:18:16 2006
     Raid Level : raid1
  Used Dev Size : 312440064 (297.97 GiB 319.94 GB)
     Array Size : 312440064 (297.97 GiB 319.94 GB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 1

    Update Time : Thu Oct  2 21:33:12 2008
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1
       Checksum : b80f58e0 - correct
         Events : 187714


      Number   Major   Minor   RaidDevice State
this     2       8       34        2      spare   /dev/sdc2

   0     0       8       18        0      active sync   /dev/sdb2
   1     1       8        2        1      active sync   /dev/sda2
   2     2       8       34        2      spare   /dev/sdc2
1.0 /dev/sdc2
/dev/sdc2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : eed65e38:78f4e6e0:55198bdc:fe77de48
           Name : 2
  Creation Time : Thu Feb 22 02:28:12 2007
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953262752 (931.39 GiB 1000.07 GB)
     Array Size : 5859788160 (2794.16 GiB 3000.21 GB)
  Used Dev Size : 1953262720 (931.39 GiB 1000.07 GB)
   Super Offset : 1953263008 sectors
          State : clean
    Device UUID : 407cf6b0:3d180e0b:e5be6dc0:e6bcf953

    Update Time : Thu Jun 11 22:24:17 2009
       Checksum : a59b300d - correct
         Events : 10784

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 5 (failed, failed, failed, failed, 3, 0, 1, 2)
   Array State : Uuuu 4 failed
1.1 /dev/sdc2
mdadm: No super block found on /dev/sdc2 (Expected magic a92b4efc, got 00000000)
1.2 /dev/sdc2
mdadm: No super block found on /dev/sdc2 (Expected magic a92b4efc, got 6f6dc87d)
0.90 /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : dece84f3:a8f8be71:ea9d9fee:21fd5f90
  Creation Time : Fri Sep 22 06:18:01 2006
     Raid Level : raid1
  Used Dev Size : 128384 (125.40 MiB 131.47 MB)
     Array Size : 128384 (125.40 MiB 131.47 MB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Thu Jun 11 07:01:41 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ccd42e30 - correct
         Events : 1056


      Number   Major   Minor   RaidDevice State
this     3       8       49        3      active sync   /dev/sdd1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
1.0 /dev/sdd1
mdadm: No super block found on /dev/sdd1 (Expected magic a92b4efc, got 104e0ec4)
1.1 /dev/sdd1
mdadm: No super block found on /dev/sdd1 (Expected magic a92b4efc, got 00000000)
1.2 /dev/sdd1
mdadm: No super block found on /dev/sdd1 (Expected magic a92b4efc, got 00007fff)
0.90 /dev/sdd2
mdadm: No super block found on /dev/sdd2 (Expected magic a92b4efc, got 1a3e2e0f)
1.0 /dev/sdd2
/dev/sdd2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : eed65e38:78f4e6e0:55198bdc:fe77de48
           Name : 2
  Creation Time : Thu Feb 22 02:28:12 2007
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953262752 (931.39 GiB 1000.07 GB)
     Array Size : 5859788160 (2794.16 GiB 3000.21 GB)
  Used Dev Size : 1953262720 (931.39 GiB 1000.07 GB)
   Super Offset : 1953263008 sectors
          State : clean
    Device UUID : df17e349:186715a7:3f7bd3f9:a53ce15d

    Update Time : Thu Jun 11 22:24:17 2009
       Checksum : 1ddc56a2 - correct
         Events : 10784

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 6 (failed, failed, failed, failed, 3, 0, 1, 2)
   Array State : uUuu 4 failed
1.1 /dev/sdd2
mdadm: No super block found on /dev/sdd2 (Expected magic a92b4efc, got 639740bf)
1.2 /dev/sdd2
mdadm: No super block found on /dev/sdd2 (Expected magic a92b4efc, got 18339908)
0.90 /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : dece84f3:a8f8be71:ea9d9fee:21fd5f90
  Creation Time : Fri Sep 22 06:18:01 2006
     Raid Level : raid1
  Used Dev Size : 128384 (125.40 MiB 131.47 MB)
     Array Size : 128384 (125.40 MiB 131.47 MB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Thu Jun 11 07:01:41 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ccd42e42 - correct
         Events : 1056


      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
1.0 /dev/sde1
mdadm: No super block found on /dev/sde1 (Expected magic a92b4efc, got 104e0ec4)
1.1 /dev/sde1
mdadm: No super block found on /dev/sde1 (Expected magic a92b4efc, got 00000000)
1.2 /dev/sde1
mdadm: No super block found on /dev/sde1 (Expected magic a92b4efc, got 00007fff)
0.90 /dev/sde2
mdadm: No super block found on /dev/sde2 (Expected magic a92b4efc, got 1a3e2e0f)
1.0 /dev/sde2
/dev/sde2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : eed65e38:78f4e6e0:55198bdc:fe77de48
           Name : 2
  Creation Time : Thu Feb 22 02:28:12 2007
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953262752 (931.39 GiB 1000.07 GB)
     Array Size : 5859788160 (2794.16 GiB 3000.21 GB)
  Used Dev Size : 1953262720 (931.39 GiB 1000.07 GB)
   Super Offset : 1953263008 sectors
          State : clean
    Device UUID : 324c496c:2a4a57c4:04a65638:0b9606c5

    Update Time : Thu Jun 11 22:24:17 2009
       Checksum : 32cf233 - correct
         Events : 10784

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 7 (failed, failed, failed, failed, 3, 0, 1, 2)
   Array State : uuUu 4 failed
1.1 /dev/sde2
mdadm: No super block found on /dev/sde2 (Expected magic a92b4efc, got 639740bf)
1.2 /dev/sde2
mdadm: No super block found on /dev/sde2 (Expected magic a92b4efc, got 18339908)
0.90 /dev/sdf1
/dev/sdf1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : dece84f3:a8f8be71:ea9d9fee:21fd5f90
  Creation Time : Fri Sep 22 06:18:01 2006
     Raid Level : raid1
  Used Dev Size : 128384 (125.40 MiB 131.47 MB)
     Array Size : 128384 (125.40 MiB 131.47 MB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Thu Jun 11 07:01:41 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ccd42e54 - correct
         Events : 1056


      Number   Major   Minor   RaidDevice State
this     5       8       81        5      active sync   /dev/sdf1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8        1        1      active sync   /dev/sda1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
1.0 /dev/sdf1
mdadm: No super block found on /dev/sdf1 (Expected magic a92b4efc, got 104e0ec4)
1.1 /dev/sdf1
mdadm: No super block found on /dev/sdf1 (Expected magic a92b4efc, got 00000000)
1.2 /dev/sdf1
mdadm: No super block found on /dev/sdf1 (Expected magic a92b4efc, got 00007fff)
0.90 /dev/sdf2
mdadm: No super block found on /dev/sdf2 (Expected magic a92b4efc, got 1a3e2e0f)
1.0 /dev/sdf2
/dev/sdf2:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : eed65e38:78f4e6e0:55198bdc:fe77de48
           Name : 2
  Creation Time : Thu Feb 22 02:28:12 2007
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953262752 (931.39 GiB 1000.07 GB)
     Array Size : 5859788160 (2794.16 GiB 3000.21 GB)
  Used Dev Size : 1953262720 (931.39 GiB 1000.07 GB)
   Super Offset : 1953263008 sectors
          State : clean
    Device UUID : 4d0e18c4:92574d6d:798f2111:18c93628

    Update Time : Thu Jun 11 22:24:17 2009
       Checksum : 3fecde34 - correct
         Events : 10784

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 4 (failed, failed, failed, failed, 3, 0, 1, 2)
   Array State : uuuU 4 failed
1.1 /dev/sdf2
mdadm: No super block found on /dev/sdf2 (Expected magic a92b4efc, got 00000000)
1.2 /dev/sdf2
mdadm: No super block found on /dev/sdf2 (Expected magic a92b4efc, got 6f6dc87d)
