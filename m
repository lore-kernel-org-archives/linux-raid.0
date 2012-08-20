From: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Subject: md raid6 not working
Date: Mon, 20 Aug 2012 19:06:17 +0000
Message-ID: <CC5802CB.287BB%michael.vanhorn@wright.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <0565DB80A46FAA43998553268B77DFB9@prod.exchangelabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I have/had an 8-disk md raid 6, /dev/md0. At some point over the weekend,
two of the disks suddently became marked as "spare" and the other has
disappeared completely (at least as far as mdadm is concerned).

All eight disks seem to be just fine, so I think the data is okay, and if
I could just convince it to start the array with all 8 disks, I actually
think everything would be fine. However, everything I've tried has come to
nothing, and now I think I am stuck.

Is there some way to just "force" is to change the two spare disks from
"spare" to "active", and then let it go?

Here's what I think are relevant details:

The RAID is/was composed of /dev/sd[bcdefghi]1.

/proc/mdstat says:

# cat /proc/mdstat
Personalities : [raid6]
md0 : inactive sdc1[1] sdd1[10] sdi1[8] sdg1[5] sdf1[4] sde1[3] sdh1[2]
      13674583552 blocks
       
unused devices: <none>
# 

So, here, sdb is the only one missing. However, if I try to start the array

# mdadm --assemble /dev/md0
mdadm: /dev/sdi1 has no superblock - assembly aborted
#


So, I check /dev/sdi1:

# mdadm --examine /dev/sdi1
/dev/sdi1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 6b8b4567:327b23c6:643c9869:66334873
  Creation Time : Mon Jun 28 10:46:51 2010
     Raid Level : raid6
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
     Array Size : 11721071616 (11178.09 GiB 12002.38 GB)
   Raid Devices : 8
  Total Devices : 6
Preferred Minor : 0

    Update Time : Mon Aug 20 12:10:18 2012
          State : clean
 Active Devices : 5
Working Devices : 6
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 297da62d - correct
         Events : 59235337

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     8       8      129        8      spare   /dev/sdi1

   0     0       0        0        0      removed
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       0        0        7      faulty removed
   8     8       8      129        8      spare   /dev/sdi1
#


The fact that that command worked on /dev/sdi1 indicates that there is, in
fact, a superblock, doesn't it?

At any rate, going from the output of --examine on sdi1, it would seem
that /dev/sdd1 is also not working. So,

# mdadm --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 6b8b4567:327b23c6:643c9869:66334873
  Creation Time : Mon Jun 28 10:46:51 2010
     Raid Level : raid6
  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
     Array Size : 11721071616 (11178.09 GiB 12002.38 GB)
   Raid Devices : 8
  Total Devices : 5
Preferred Minor : 0

    Update Time : Mon Aug 20 12:10:21 2012
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 297da583 - correct
         Events : 59235338

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this    10       8       49       -1      spare   /dev/sdd1

   0     0       0        0        0      removed
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8      113        2      active sync   /dev/sdh1
   3     3       8       65        3      active sync   /dev/sde1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       97        5      active sync   /dev/sdg1
   6     6       0        0        6      faulty removed
   7     7       0        0        7      faulty removed
# 


Which would seem to indicate that sdd1 is fine, too. So, then, what about
sdb1?

# mdadm --examine /dev/sdb1
mdadm: No md superblock detected on /dev/sdb1.
#


Okay, fine, maybe something actually has happened to sdb1. However, since
it's a RAID6, having that one bad disk should be survivable. If I could
just get the other two disks (sdi1 and sdd1) to not be spares.


---
Mike VanHorn
Senior Computer Systems Administrator
College of Engineering and Computer Science
Wright State University
265 Russ Engineering Center
937-775-5157
michael.vanhorn@wright.edu
http://www.cecs.wright.edu/~mvanhorn/




