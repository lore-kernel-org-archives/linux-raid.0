From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: rebuild raid6 after two failures
Date: Mon, 30 Jan 2012 22:31:04 -0800
Message-ID: <8eekv8xpcn.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

I recently had a RAID6 lose two drives in quick succession, with one
spare already in place.  The rebuild started fine with the spare, but
now that I've replaced the failed disks, should I expect the current
rebuild to finish, then rebuild on another spare?  Or do I need to do
something special to kick off the rebuilding on another spare?  I tried
looking for the answer using various web search permutations with no
success.

My mdadm and uname output is below.  (I did not remember to use a newer
mdadm to add the spares, so I originally used 2.6.9, but I do have 3.2.3
available on this box.)  Thanks for any pointers.

--keith

# uname -a
Linux xxxxxxxxxx 2.6.39-4.1.el5.elrepo #1 SMP PREEMPT Wed Jan 18 13:16:25 EST 2012 x86_64 x86_64 x86_64 GNU/Linux
# mdadm -D /dev/md0
/dev/md0:
        Version : 1.01
  Creation Time : Thu Sep 29 21:26:35 2011
     Raid Level : raid6
     Array Size : 15624911360 (14901.08 GiB 15999.91 GB)
  Used Dev Size : 1953113920 (1862.63 GiB 1999.99 GB)
   Raid Devices : 10
  Total Devices : 12
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Jan 30 22:07:26 2012
          State : clean, degraded, recovering
 Active Devices : 8
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 4

     Chunk Size : 64K

 Rebuild Status : 18% complete

           Name : 0
           UUID : 24363b01:90deb9b5:4b51e5df:68b8b6ea
         Events : 164419

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
      13       8       33        1      active sync   /dev/sdc1
      11       8      145        2      active sync   /dev/sdj1
      12       8      161        3      active sync   /dev/sdk1
       4       8       65        4      active sync   /dev/sde1
       9       8      113        5      active sync   /dev/sdh1
      10       8       81        6      active sync   /dev/sdf1
       3       8       49        7      spare rebuilding   /dev/sdd1
       8       8      129        8      active sync   /dev/sdi1
       9       0        0        9      removed

      14       8      177        -      spare   /dev/sdl1
      15       8      209        -      spare   /dev/sdn1
      16       8      225        -      spare   /dev/sdo1


-- 
kkeller@wombat.san-francisco.ca.us
(try just my userid to email me)
AOLSFAQ=http://www.therockgarden.ca/aolsfaq.txt
see X- headers for PGP signature information


