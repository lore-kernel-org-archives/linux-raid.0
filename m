From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Uncorrectable errors: how do I fix it?
Date: Fri, 28 Nov 2008 18:21:20 +0000
Message-ID: <493036A0.10707@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

One of the drives in my RAID-5 array is showing uncorrectable errors:
Nov 28 17:52:36 beast smartd[8184]: Device: /dev/sdc, 1 Currently 
unreadable (pending) sectors
Nov 28 17:52:36 beast smartd[8184]: Device: /dev/sdc, 1 Offline 
uncorrectable sectors

And it fails a self-test:
SMART Self-test log structure revision number 0
Warning: ATA Specification requires self-test log structure revision 
number = 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed: read failure       20%       931 
   1953520763

Now that's not good but it's probably not bad enough to get the drive 
replaced. (Opinions?) Anyway, rewriting the sector ought to "cure" it, 
so how do I do that?

Here's the details of my array:
[root@beast md]# mdadm --detail /dev/md1
/dev/md1:
         Version : 00.90.03
   Creation Time : Mon Jul 28 15:49:09 2008
      Raid Level : raid5
      Array Size : 1953310720 (1862.82 GiB 2000.19 GB)
   Used Dev Size : 976655360 (931.41 GiB 1000.10 GB)
    Raid Devices : 3
   Total Devices : 3
Preferred Minor : 1
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Fri Nov 28 17:56:22 2008
           State : active
  Active Devices : 3
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 256K

            UUID : d8c57a89:166ee722:23adec48:1574b5fc
          Events : 0.6112

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2
        2       8       34        2      active sync   /dev/sdc2

I tried:
[root@beast md]# mdadm /dev/md1 --fail /dev/sdc2
mdadm: set /dev/sdc2 faulty in /dev/md1
[root@beast md]# mdadm /dev/md1 --remove /dev/sdc2
mdadm: hot removed /dev/sdc2
[root@beast md]# mdadm /dev/md1 --add /dev/sdc2
mdadm: re-added /dev/sdc2

but that finished instantly. I guess it would since the array has a 
write-intent bitmap and it's noticed that sdc2 is being re-added. I 
could tell the system to do a complete resync with:
# echo repair > /sys/block/md1/md/sync_action

but really I want to tell the system to rebuild entirely from sda2 and 
sdb2, onto sdc2. At least I think I do. I've a feeling the answer is to 
zero the superblock, but I'm not confident about doing that because I'm 
not sure if re-adding the thing without a superblock will either work or 
do the Right Thing[tm].

Cheers,

John.
