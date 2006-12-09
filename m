From: Jacob Schmidt Madsen <jacob@mungo.dk>
Subject: Re: mdadm assemble question
Date: Sat, 9 Dec 2006 01:47:59 +0100
Message-ID: <200612090147.59683.jacob@mungo.dk>
References: <200612081427.22117.jacob@mungo.dk> <17785.61010.745533.90298@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17785.61010.745533.90298@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm using kernel-2.6.19 and mdadm-2.5.5.

I figured out that the error occured because large block device support wasnt 
enabled in the kernel, and because the array is bigger than 2tb now.

If its possible to change, then I'd suggest replacing the "compute_blocknr: 
map not correct" message (from the reshape process) with a hit or something 
more informative.
Also mdadm could post a warning before someone try to cross the 2tb limit in a 
grow process, which require large block support - or just check if its been 
enabled.
It would atleast have saved me from the trouble :-)

You can check out the recent "Trouble when growing a raid5 array" email 
thread, where I try to describe the experience more detailed.



# mdadm -D /dev/md5
/dev/md5:
        Version : 00.90.03
  Creation Time : Fri Dec  8 19:07:26 2006
     Raid Level : raid5
     Array Size : 2187980032 (2086.62 GiB 2240.49 GB)
    Device Size : 312568576 (298.09 GiB 320.07 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 5
    Persistence : Superblock is persistent

    Update Time : Fri Dec  8 22:34:03 2006
          State : clean, degraded, recovering
 Active Devices : 7
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

 Rebuild Status : 46% complete

           UUID : a24c9a1d:6ff2910a:9e2ad3b1:f5e7c6a5
         Events : 0.22

    Number   Major   Minor   RaidDevice State
       0       8       81        0      active sync   /dev/sdf1
       1       8       97        1      active sync   /dev/sdg1
       2       8      113        2      active sync   /dev/sdh1
       3       8      129        3      active sync   /dev/sdi1
       4       8       65        4      active sync   /dev/sde1
       5       8       49        5      active sync   /dev/sdd1
       6       8       33        6      active sync   /dev/sdc1
       8       8       17        7      spare rebuilding   /dev/sdb1



# mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a24c9a1d:6ff2910a:9e2ad3b1:f5e7c6a5
  Creation Time : Fri Dec  8 19:07:26 2006
     Raid Level : raid5
    Device Size : 312568576 (298.09 GiB 320.07 GB)
     Array Size : 2187980032 (2086.62 GiB 2240.49 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 5

    Update Time : Fri Dec  8 22:34:03 2006
          State : clean
 Active Devices : 7
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 1
       Checksum : ed130785 - correct
         Events : 0.22

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     8       8       17        8      spare   /dev/sdb1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       97        1      active sync   /dev/sdg1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8      129        3      active sync   /dev/sdi1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       49        5      active sync   /dev/sdd1
   6     6       8       33        6      active sync   /dev/sdc1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      spare   /dev/sdb1



# mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a24c9a1d:6ff2910a:9e2ad3b1:f5e7c6a5
  Creation Time : Fri Dec  8 19:07:26 2006
     Raid Level : raid5
    Device Size : 312568576 (298.09 GiB 320.07 GB)
     Array Size : 2187980032 (2086.62 GiB 2240.49 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 5

    Update Time : Fri Dec  8 22:34:03 2006
          State : clean
 Active Devices : 7
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 1
       Checksum : ed130797 - correct
         Events : 0.22

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       33        6      active sync   /dev/sdc1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       97        1      active sync   /dev/sdg1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8      129        3      active sync   /dev/sdi1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       49        5      active sync   /dev/sdd1
   6     6       8       33        6      active sync   /dev/sdc1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      spare   /dev/sdb1



# mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a24c9a1d:6ff2910a:9e2ad3b1:f5e7c6a5
  Creation Time : Fri Dec  8 19:07:26 2006
     Raid Level : raid5
    Device Size : 312568576 (298.09 GiB 320.07 GB)
     Array Size : 2187980032 (2086.62 GiB 2240.49 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 5

    Update Time : Fri Dec  8 22:34:03 2006
          State : clean
 Active Devices : 7
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 1
       Checksum : ed1307a5 - correct
         Events : 0.22

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       49        5      active sync   /dev/sdd1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       97        1      active sync   /dev/sdg1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8      129        3      active sync   /dev/sdi1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       49        5      active sync   /dev/sdd1
   6     6       8       33        6      active sync   /dev/sdc1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      spare   /dev/sdb1



# mdadm -E /dev/sde1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a24c9a1d:6ff2910a:9e2ad3b1:f5e7c6a5
  Creation Time : Fri Dec  8 19:07:26 2006
     Raid Level : raid5
    Device Size : 312568576 (298.09 GiB 320.07 GB)
     Array Size : 2187980032 (2086.62 GiB 2240.49 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 5

    Update Time : Fri Dec  8 22:34:03 2006
          State : clean
 Active Devices : 7
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 1
       Checksum : ed1307b3 - correct
         Events : 0.22

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       97        1      active sync   /dev/sdg1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8      129        3      active sync   /dev/sdi1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       49        5      active sync   /dev/sdd1
   6     6       8       33        6      active sync   /dev/sdc1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      spare   /dev/sdb1



# mdadm -E /dev/sdf1
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a24c9a1d:6ff2910a:9e2ad3b1:f5e7c6a5
  Creation Time : Fri Dec  8 19:07:26 2006
     Raid Level : raid5
    Device Size : 312568576 (298.09 GiB 320.07 GB)
     Array Size : 2187980032 (2086.62 GiB 2240.49 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 5

    Update Time : Fri Dec  8 22:34:03 2006
          State : clean
 Active Devices : 7
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 1
       Checksum : ed1307bb - correct
         Events : 0.22

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       81        0      active sync   /dev/sdf1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       97        1      active sync   /dev/sdg1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8      129        3      active sync   /dev/sdi1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       49        5      active sync   /dev/sdd1
   6     6       8       33        6      active sync   /dev/sdc1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      spare   /dev/sdb1



# mdadm -E /dev/sdg1
/dev/sdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a24c9a1d:6ff2910a:9e2ad3b1:f5e7c6a5
  Creation Time : Fri Dec  8 19:07:26 2006
     Raid Level : raid5
    Device Size : 312568576 (298.09 GiB 320.07 GB)
     Array Size : 2187980032 (2086.62 GiB 2240.49 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 5

    Update Time : Fri Dec  8 22:34:03 2006
          State : clean
 Active Devices : 7
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 1
       Checksum : ed1307cd - correct
         Events : 0.22

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       97        1      active sync   /dev/sdg1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       97        1      active sync   /dev/sdg1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8      129        3      active sync   /dev/sdi1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       49        5      active sync   /dev/sdd1
   6     6       8       33        6      active sync   /dev/sdc1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      spare   /dev/sdb1



# mdadm -E /dev/sdh1
/dev/sdh1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a24c9a1d:6ff2910a:9e2ad3b1:f5e7c6a5
  Creation Time : Fri Dec  8 19:07:26 2006
     Raid Level : raid5
    Device Size : 312568576 (298.09 GiB 320.07 GB)
     Array Size : 2187980032 (2086.62 GiB 2240.49 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 5

    Update Time : Fri Dec  8 22:34:03 2006
          State : clean
 Active Devices : 7
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 1
       Checksum : ed1307df - correct
         Events : 0.22

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8      113        2      active sync   /dev/sdh1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       97        1      active sync   /dev/sdg1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8      129        3      active sync   /dev/sdi1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       49        5      active sync   /dev/sdd1
   6     6       8       33        6      active sync   /dev/sdc1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      spare   /dev/sdb1



# mdadm -E /dev/sdi1
/dev/sdi1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : a24c9a1d:6ff2910a:9e2ad3b1:f5e7c6a5
  Creation Time : Fri Dec  8 19:07:26 2006
     Raid Level : raid5
    Device Size : 312568576 (298.09 GiB 320.07 GB)
     Array Size : 2187980032 (2086.62 GiB 2240.49 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 5

    Update Time : Fri Dec  8 22:34:03 2006
          State : clean
 Active Devices : 7
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 1
       Checksum : ed1307f1 - correct
         Events : 0.22

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8      129        3      active sync   /dev/sdi1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       97        1      active sync   /dev/sdg1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8      129        3      active sync   /dev/sdi1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       49        5      active sync   /dev/sdd1
   6     6       8       33        6      active sync   /dev/sdc1
   7     7       0        0        7      faulty removed
   8     8       8       17        8      spare   /dev/sdb1




On Friday 08 December 2006 23:59, Neil Brown wrote:
> On Friday December 8, jacob@mungo.dk wrote:
> > Hey,
> >
> > I've added 2 new disks to an existing raid5 array and started the grow
> > process.
> >
> > The grow process was unsuccessfull because it stalled at 98.1% and the
> > system log show a long list of "compute_blocknr: map not correct".
>
> Not good!
>
> > Am I just blind or is it not possible to start an array without starting
> > the reshape process?
>
> Normally you wouldn't want to....
>
> Can you post the output of "mdadm --examine" on each of the component
> devices please.  And tell me what version of the Linux kernel you are
> using, and what version of mdadm?  I'll see if I can figure out what
> happened and what the best way to fix it is.
>
> Thanks,
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
