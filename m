From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: SparesMissing event
Date: Thu, 02 Aug 2012 19:59:45 -0700
Message-ID: <1erre9xieq.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I got this message from mdadm --monitor when I restarted one of
my servers this afternoon:

SparesMissing event on /dev/md/0:blah

[snip]

Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdg[5] sdb[0] sdk[12](S) sdd[2] sdl[10] sdi[7] sdh[6]
sde[3] sdf[4] sdc[1] sdj[8]
      15624900608 blocks super 1.2 level 6, 512k chunk, algorithm 2 [10/10] [UUUUUUUUUU]
      bitmap: 0/15 pages [0KB], 65536KB chunk

unused devices: <none>

Is mdadm reporting this because there's only one spare for a RAID6?  Or
is there something else I'm missing?

Below is my mdadm -D.  Any suggestions would be helpful.  Thanks!

--keith


# mdadm -D /dev/md/0
/dev/md/0:
        Version : 1.2
  Creation Time : Thu Feb  9 15:10:28 2012
     Raid Level : raid6
     Array Size : 15624900608 (14901.07 GiB 15999.90 GB)
  Used Dev Size : 1953112576 (1862.63 GiB 1999.99 GB)
   Raid Devices : 10
  Total Devices : 11
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Aug  2 19:45:53 2012
          State : active 
 Active Devices : 10
Working Devices : 11
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

           Name : blah
           UUID : f660639e:5b7583ae:4c69519f:ea7c8c31
         Events : 30671

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       3       8       64        3      active sync   /dev/sde
       4       8       80        4      active sync   /dev/sdf
       5       8       96        5      active sync   /dev/sdg
       6       8      112        6      active sync   /dev/sdh
       7       8      128        7      active sync   /dev/sdi
       8       8      144        8      active sync   /dev/sdj
      10       8      176        9      active sync   /dev/sdl

      12       8      160        -      spare   /dev/sdk

-- 
kkeller@wombat.san-francisco.ca.us


