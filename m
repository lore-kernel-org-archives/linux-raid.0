From: James Doebbler <jamesdoebbler@gmail.com>
Subject: Corruption during RAID5->RAID6 migration
Date: Tue, 14 May 2013 14:56:22 -0500
Message-ID: <CAJDy474SBN7qMgccmkzc++=ZP43L1M=jVkyx_YVkqdZmbvwZfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have encountered a scary situation with corruption on my RAID array
and would like any help/advice/pointers that might help me
save/recover any data I can.  I'll try to describe the situation as
best I can, so forgive the length of this email.

I have a personal file and media server running Ubuntu Linux Server
12.04.2, kernel version 3.2.0-41-generic.  I have a mdadm RAID5 array
of 2TB disks that I've been adding disks to and growing as needed off
the past couple of years and everything has been great other than a
non-zero mismatch_cnt.  The array was currently at 10TB/6 device and I
decided it was time to move to a RAID6 array since the number of
devices was getting large.  I wanted to minimize the chance of a total
failure during a rebuild as well as hopefully be able to resolve any
future mismatch_cnts correctly with the extra parity information.

I had read on Neil Brown's blog that the migration would be much
faster if I was also adding capacity, so I installed two new 2TB
drives, added them to the array (as spares) and started the
reshape/grow. I've appended the commands used and mdadm output to the
end of this email.

The reshape seemed to be going along as expected except I was only
getting ~5MB/s instead of the ~40MB/s I usually see.  Several hours
later I noticed that some of my recent downloads were corrupt when
extracting from archives.  I created some files from data in
/dev/urandom and calculated the md5sum.  A minute or so later I
recalculated the sum, and it was different.  Similarly, copying the
file resulted in another md5sum that was not the same as the previous
two.

At that point I am not sure where the problem is, but I know my RAID
array is no longer correctly returning the data I store to them.  I do
not have verification data for most of the data already on the drive,
so I do not know if there is a problem reading any data, or a problem
writing new data (in which case my pre-existing data might be okay).

Running iostat, I noticed that one drive was the bottleneck
(/dev/sdh).  It was one of the new drives and even though I had tested
them thoroughly, I worried that it was this drive that was returning
bad data or something.  I failed the drive in question and the RAID
reshape sped up considerably (to ~35MB/s).  However, doing the same
md5sum of new random data files with the drive non-active in the array
still failed in the same way.

I then became worried about a hardware problem with my RAM or SATA
card, although I hadn't had previous problems and found no errors in
dmesg/syslog and no UDMA CRC errors in any drive SMART data.  Since
the reshape operation reads and writes all data, I knew that the
longer I went, the more likely I was to corrupt data.  So I shut down
the server with around 45% of the reshape operation complete.  I hope
this doesn't cause future complications, but I didn't want to risk any
more data loss.

I ran Memtest86+ over the weekend for 60 passes (~65 hrs) straight
with no errors detected.

I have shut down the server and am trying to figure out what to do.
If there's not a miracle software solution, my leading idea is to boot
up, fail the other added disk, and use the original 6 disks in a
degraded array to try to get off any data I can.  This is under the
assumption that the data that hasn't been moved during the reshape
would still be good as these are the same drives connected to the same
SATA ports with the same cables that gave me no problems before.

I'm curious if anyone has ever seen this kind of behavior before and
has any recommendations on what to do next.  I believe I have backups
of 80%+ of the non-replaceable data on the array, but I'm not
completely current and I'd like to save as much data as possible.

Thanks,
James


Commands and output from the reshape:

$ sudo mdadm --add /dev/md2 /dev/sdi
mdadm: added /dev/sdi
$ sudo mdadm --add /dev/md2 /dev/sdh
mdadm: added /dev/sdh
$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1] [linear] [multipath]
[raid0] [raid10]
md1 : active raid1 sdl2[1] sdk2[0]
      239256440 blocks super 1.2 [2/2] [UU]

md0 : active raid1 sdk1[0] sdl1[1]
      250868 blocks super 1.2 [2/2] [UU]

md2 : active raid5 sdh[9](S) sdi[8](S) sda[7] sdf[5] sdb[2] sde[6] sdc[0] sdd[3]
      9767564800 blocks super 1.2 level 5, 512k chunk, algorithm 2
[6/6] [UUUUUU]

unused devices: <none>
$ sudo mdadm --grow /dev/md2 --raid-devices=8 --level=6
--backup-file=/root/grow_md2_to_raid6.bak
mdadm: level of /dev/md2 changed to raid6
mdadm: Need to backup 15360K of critical section..
jamesd@oracle:~$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1] [linear] [multipath]
[raid0] [raid10]
md1 : active raid1 sdl2[1] sdk2[0]
      239256440 blocks super 1.2 [2/2] [UU]

md0 : active raid1 sdk1[0] sdl1[1]
      250868 blocks super 1.2 [2/2] [UU]

md2 : active raid6 sdh[9] sdi[8] sda[7] sdf[5] sdb[2] sde[6] sdc[0] sdd[3]
      9767564800 blocks super 1.2 level 6, 512k chunk, algorithm 18
[8/7] [UUUUUU_U]
      [>....................]  reshape =  0.0% (18432/1953512960)
finish=4234.9min speed=7680K/sec

unused devices: <none>

(later)
$ sudo mdadm --detail /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Mon Sep 12 22:07:25 2011
     Raid Level : raid6
     Array Size : 9767564800 (9315.08 GiB 10001.99 GB)
  Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
   Raid Devices : 8
  Total Devices : 8
    Persistence : Superblock is persistent

    Update Time : Thu May  9 02:11:21 2013
          State : active, degraded, reshaping
 Active Devices : 7
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric-6
     Chunk Size : 512K

 Reshape Status : 2% complete
  Delta Devices : 1, (7->8)
     New Layout : left-symmetric

           Name : oracle:2  (local to host oracle)
           UUID : ed86ce45:ba8fd59c:5c217ab5:e99eddfe
         Events : 115349

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       2       8       16        1      active sync   /dev/sdb
       3       8       48        2      active sync   /dev/sdd
       6       8       64        3      active sync   /dev/sde
       5       8       80        4      active sync   /dev/sdf
       7       8        0        5      active sync   /dev/sda
       9       8      112        6      spare rebuilding   /dev/sdh
       8       8      128        7      active sync   /dev/sdi
