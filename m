From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Joys of spare disks!
Date: Mon, 28 Feb 2005 14:24:48 +0000
Message-ID: <cvv9ai$svg$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I run a RAID5 array built from six 250GB Maxtor Maxline II SATA disks. 
After having several problems with Maxtor disks I decided to use a spare 
disk, i.e. 5+1 spare.

Well, *another* disk failed last week. The spare disk was brought into 
play seamlessly:

[root@dude ~]# mdadm --detail /dev/md5
/dev/md5:
         Version : 00.90.01
   Creation Time : Thu Jul 29 21:41:38 2004
      Raid Level : raid5
      Array Size : 974566400 (929.42 GiB 997.96 GB)
     Device Size : 243641600 (232.35 GiB 249.49 GB)
    Raid Devices : 5
   Total Devices : 6
Preferred Minor : 5
     Persistence : Superblock is persistent

     Update Time : Mon Feb 28 14:00:54 2005
           State : clean
  Active Devices : 5
Working Devices : 5
  Failed Devices : 1
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 128K

            UUID : a4bbcd09:5e178c5b:3bf8bd45:8c31d2a1
          Events : 0.6941488

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2
        2       8       34        2      active sync   /dev/sdc2
        3       8       82        3      active sync   /dev/sdf2
        4       8       66        4      active sync   /dev/sde2

        5       8       50        -      faulty   /dev/sdd2

I've done a quick test of /dev/sdd2:

[root@dude ~]# dd if=/dev/sdd2 of=/dev/null bs=64k
dd: reading `/dev/sdd2': Input/output error
50921+1 records in
50921+1 records out

So, I guess it's time to raise another return with Maxtor <sigh>.

/dev/sdd1 is used in /dev/md0. So, just to confirm, is this what I need 
to do to remove bad disk/add new disk:

Remove faulty partition:

	mdadm --manage /dev/md5 --remove /dev/sdd2

Remove "good" from RAID1 array:

	mdadm --manage /dev/md0 --fail /dev/sdd1
	mdadm --manage /dev/md0 --remove /dev/sdd1

[pull out bad disk, install replacement]

Partition new disk (will be /dev/sdd) (All six disks are partitioned the 
same):

	fdisk -l /dev/sda | fdisk /dev/sdd

(I seem to remember having a problem with this when I did it last time. 
Something about a bug in fdisk that won't partition brand new new disks 
correctly? Or was it sfdisk?)

Add new partitions to arrays:

	mdadm --manage /dev/md0 --add /dev/sdd1
	mdadm --manage /dev/md5 --add /dev/sdd2

Thanks,

R.
-- 
http://robinbowes.com

