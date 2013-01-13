From: Divan Santana <divan@s-tainment.co.za>
Subject: Slow RAID 5 performance all of a sudden
Date: Sun, 13 Jan 2013 11:06:09 +0200
Message-ID: <50F27901.4070404@s-tainment.co.za>
Reply-To: divan@s-tainment.co.za
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I've done my home work(tried to) to investigate this slow RAID 5 
performance all of a sudden. It doesn't appear to be any hardware 
problem(although perhaps it is).

Would you more clued up guys  have a quick look below and let me know 
what sort of steps I can next to try make progress with this?

Note below tests done with:
* Almost no other IO activity on the systems
* Mem+cpu usage very low

== Problematic RAID details (RAID A) ==
# mdadm --detail -vvv /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Sat Oct 29 08:08:17 2011
      Raid Level : raid5
      Array Size : 3906635776 (3725.66 GiB 4000.40 GB)
   Used Dev Size : 1953317888 (1862.83 GiB 2000.20 GB)
    Raid Devices : 3
   Total Devices : 3
     Persistence : Superblock is persistent

     Update Time : Sun Jan 13 10:53:48 2013
           State : clean
  Active Devices : 3
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

            Name : st0000:0
            UUID : 23b5f98b:9f950291:d00a9762:63c83168
          Events : 361

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2
        2       8       34        2      active sync   /dev/sdc2

# blkid|grep md0
/dev/md0: UUID="9cfb479f-8062-41fe-b24f-37bff20a203c" TYPE="crypto_LUKS"
# cat /etc/crypttab
crypt UUID=9cfb479f-8062-41fe-b24f-37bff20a203c 
/dev/disk/by-uuid/0d903ca9-5e08-4bea-bc1d-ac6483a109b6:/secretkey 
luks,keyscript=/lib/cryptsetup/scripts/passdev

# ll /dev/mapper/crypt
lrwxrwxrwx 1 root root 7 Jan  8 07:51 /dev/mapper/crypt -> ../dm-0
# pvs
   PV         VG   Fmt  Attr PSize PFree
   /dev/dm-0  vg0  lvm2 a-   3,64t 596,68g
# vgs
   VG   #PV #LV #SN Attr   VSize VFree
   vg0    1  15   0 wz--n- 3,64t 596,68g
# df -Ph / |column -t
Filesystem            Size  Used  Avail  Use%  Mounted  on
/dev/mapper/vg0-root  19G   8,5G  9,0G   49%   /


# hdparm -Tt /dev/sda
/dev/sda:
   Timing cached reads:   23792 MB in  2.00 seconds = 11907.88 MB/sec
  Timing buffered disk reads: 336 MB in  3.01 seconds = 111.73 MB/sec

# hdparm -Tt /dev/sdb
/dev/sdb:
  Timing cached reads:   26736 MB in  2.00 seconds = 13382.64 MB/sec
  Timing buffered disk reads: 366 MB in  3.01 seconds = 121.63 MB/sec

# hdparm -Tt /dev/sdc
/dev/sdc:
   Timing cached reads:   27138 MB in  2.00 seconds = 13586.04 MB/sec
  Timing buffered disk reads: 356 MB in  3.00 seconds = 118.47 MB/sec

# time dd if=/dev/zero of=/root/test.file oflag=direct bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 66.6886 s, 16.1 MB/s

real    1m6.716s
user    0m0.008s
sys     0m0.232s


# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [linear] [multipath] 
[raid0] [raid10]
md1 : active raid1 sda3[0] sdb3[1] sdc3[2]
       192500 blocks super 1.2 [3/3] [UUU]

md0 : active raid5 sdc2[2] sdb2[1] sda2[0]
       3906635776 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[3/3] [UUU]
       [>....................]  check =  0.0% (1786240/1953317888) 
finish=31477.6min speed=1032K/sec

unused devices: <none>

Notice in the above:
* how slow the mdadm scan takes (speed=1032K/sec)
* That writing a file is slow at 16.1MB/s despite the individual drive 
speeds being faster

== Normal RAID details (RAID B) ==
# hdparm -Tt /dev/sda

/dev/sda:
  Timing cached reads:   23842 MB in  2.00 seconds = 11932.63 MB/sec
  Timing buffered disk reads:  312 MB in  3.00 seconds = 103.89 MB/sec
# hdparm -Tt /dev/sdb

/dev/sdb:
  Timing cached reads:   22530 MB in  2.00 seconds = 11275.78 MB/sec
  Timing buffered disk reads:  272 MB in  3.01 seconds =  90.43 MB/sec
# hdparm -Tt /dev/sdc

/dev/sdc:
  Timing cached reads:   22630 MB in  2.00 seconds = 11326.20 MB/sec
  Timing buffered disk reads:  260 MB in  3.02 seconds =  86.22 MB/sec
# time dd if=/dev/zero of=/root/test.file oflag=direct bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 7.40439 s, 145 MB/s

real    0m7.407s
user    0m0.000s
sys     0m0.710s

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [linear] [multipath] 
[raid0] [raid10]
md1 : active raid5 sdb2[1] sdc2[2] sda2[0] sdd2[3](S)
       1952546688 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
       [=>...................]  check =  7.1% (70111616/976273344) 
finish=279.8min speed=53976K/sec

md0 : active raid1 sdb1[1] sda1[0] sdc1[2] sdd1[3](S)
       487360 blocks [3/3] [UUU]

unused devices: <none>

Notice above that the:
* mdadm scan speed is much faster
* the same dd command writes a lot faster

== Difference between RAID A and RAID B ==
* A ubuntu 12.04.1 | B ubuntu 10.04.4
* A GPT | B msdos partitions
* A Full disk encryption+LVM+ext4 | B no encryption+LVM+ext4
* A 3 x 2.00 TB, ST32000641AS | B 3 x 1TB + active spare
* A 512K chunk | B 64K chunk
* A stride 128 | B 16
* A stripe width 256 | B 32.
* A and B FS block size 4k
As far as I can see the FS block size+ chunk size + stripe width + 
stride is already optimal for RAID A(although if it wasn't I don't think 
that would be the issue anyway as I've noticed the slow down lately only).

I also ran SMART tests on the three disks in the RAID A and all seem fine:
  # smartctl -a /dev/sda|grep Completed
# 1  Extended offline    Completed without error       00% 9927         -
# 2  Conveyance offline  Completed without error       00% 9911         -
# 3  Short offline       Completed without error       00% 9911         -
  # smartctl -a /dev/sdb|grep Completed
# 1  Extended offline    Completed without error       00% 10043         -
# 2  Conveyance offline  Completed without error       00% 9911         -
# 3  Short offline       Completed without error       00% 9911         -
  # smartctl -a /dev/sdc|grep Completed
# 1  Extended offline    Completed without error       00% 10052         -
# 2  Conveyance offline  Completed without error       00% 9912         -
# 3  Short offline       Completed without error       00% 9912         -

Anyone have any ideas what I can do to troubleshoot this further or what 
may be causing this?

-- 
Best regards,
Divan Santana
+27 82 787 8522

