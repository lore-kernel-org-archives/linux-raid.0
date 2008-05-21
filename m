From: Cry <cry_regarder@yahoo.com>
Subject: Re: Two Drive Failure on RAID-5
Date: Wed, 21 May 2008 14:14:20 +0000 (UTC)
Message-ID: <loom.20080521T140522-597@post.gmane.org>
References: <loom.20080519T224713-779@post.gmane.org> <4832966A.3010707@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves <david <at> dgreaves.com> writes:
> 
> Cry wrote:
>> Folks,
>> 
>> I had a drive fail on my 6 drive raid-5 array.  while syncing in the 
>> replacement
>> drive (11 percent complete) a second drive went bad.
>> 
>
> blockdev --getra /dev/SOURCE <note the readahead value>
> blockdev --setro /dev/SOURCE
> blockdev --setra  0 /dev/SOURCE
> ddrescue /dev/SOURCE /dev/TARGET /somewhere_safe/logfile
> 
 
> unless you've rebooted:
> blockdev --setrw /dev/SOURCE
> blockdev --setra  <saved readahead value> /dev/SOURCE
> 
> mdadm --assemble --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1
> /dev/sde1
 
> cat /proc/mdstat will show the drive status
> mdadm --detail /dev/md0
> mdadm --examine /dev/sd[abcdef]1 [components]

I performed the above steps, however I used dd_rescue instead of ddrescue.

]# dd_rescue -l sda_rescue.log -o sda_rescue.bad -v /dev/sda /dev/sdg1 

dd_rescue: (info): about to transfer 0.0 kBytes from /dev/sda to /dev/sdg1
dd_rescue: (info): blocksizes: soft 65536, hard 512
dd_rescue: (info): starting positions: in 0.0k, out 0.0k
dd_rescue: (info): Logfile: sda_rescue.log, Maxerr: 0
dd_rescue: (info): Reverse: no , Trunc: no , interactive: no 
dd_rescue: (info): abort on Write errs: no , spArse write: if err

.......

dd_rescue: (info): /dev/sda (488386592.0k): EOF
Summary for /dev/sda -> /dev/sdg1:
dd_rescue: (info): ipos: 488386592.0k, opos: 488386592.0k, 
  xferd: 488386592.0k
                   errs:    504, errxfer:       252.0k, 
  succxfer: 488386336.0k
             +curr.rate:    47904kB/s, avg.rate:    14835kB/s, 
  avg.load:  9.6%


/dev/sdg1 is my replacement drive (750G) that I had tried to sync
previously.  The problem now is that while the copy happened, mdadm 
still thinks it is that old spare:

~]#  mdadm -E /dev/sdg1 /dev/sda
/dev/sdg1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 18e3d0b8:a21b31d2:7216c3e5:9bbd9f39
  Creation Time : Thu May 24 01:55:48 2007
     Raid Level : raid5
  Used Dev Size : 488386432 (465.76 GiB 500.11 GB)
     Array Size : 2441932160 (2328.81 GiB 2500.54 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Mon May 19 22:32:56 2008
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 1
       Checksum : 1dc8dcfa - correct
         Events : 0.1187802

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     6       8       97        6      spare   /dev/sdg1

   0     0       8       80        0      active sync   /dev/sdf
   1     1       8       64        1      active sync   /dev/sde
   2     2       8      128        2      active sync   /dev/sdi
   3     3       0        0        3      faulty removed
   4     4       0        0        4      faulty removed
   5     5       8      144        5      active sync   /dev/sdj
   6     6       8       97        6      spare   /dev/sdg1
/dev/sda:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 18e3d0b8:a21b31d2:7216c3e5:9bbd9f39
  Creation Time : Thu May 24 01:55:48 2007
     Raid Level : raid5
  Used Dev Size : 488386432 (465.76 GiB 500.11 GB)
     Array Size : 2441932160 (2328.81 GiB 2500.54 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Mon May 19 21:40:13 2008
          State : clean
 Active Devices : 5
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 1dc8d023 - correct
         Events : 0.1187796

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     4       8        0        4      active sync   /dev/sda

   0     0       8       80        0      active sync   /dev/sdf
   1     1       8       64        1      active sync   /dev/sde
   2     2       8      128        2      active sync   /dev/sdi
   3     3       0        0        3      faulty removed
   4     4       8        0        4      active sync   /dev/sda
   5     5       8      144        5      active sync   /dev/sdj
   6     6       8       97        6      spare   /dev/sdg1

and when I try to assemble the array, it only sees four disks 
plus a spare.

]# mdadm --assemble --force --verbose /dev/md0 /dev/sdf /dev/sde 
/dev/sdi /dev/sdj /dev/sdg1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdf is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sde is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdi is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdj is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 6.
mdadm: added /dev/sde to /dev/md0 as 1
mdadm: added /dev/sdi to /dev/md0 as 2
mdadm: no uptodate device for slot 3 of /dev/md0
mdadm: no uptodate device for slot 4 of /dev/md0
mdadm: added /dev/sdj to /dev/md0 as 5
mdadm: added /dev/sdg1 to /dev/md0 as 6
mdadm: added /dev/sdf to /dev/md0 as 0
mdadm: /dev/md0 assembled from 4 drives and 1 spare - not enough to 
start the array.


How do I transfer the label from /dev/sda (no partitions) to /dev/sdg1?

Thanks,

Cry

