From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: Joys of spare disks!
Date: Wed, 02 Mar 2005 02:48:32 +0000
Message-ID: <d03987$nif$1@sea.gmane.org>
References: <cvv9ai$svg$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <cvv9ai$svg$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Bowes wrote:
> Hi,
> 
> I run a RAID5 array built from six 250GB Maxtor Maxline II SATA disks. 
> After having several problems with Maxtor disks I decided to use a spare 
> disk, i.e. 5+1 spare.
> 
> Well, *another* disk failed last week. The spare disk was brought into 
> play seamlessly:

Thanks to some advice from Guy the "failed" disk is now back up and running.

To fix it I did the following;

Removed the bad partition from the array:

   mdadm --manage /dev/md5 --remove /dev/sdd2

Wrote to the whole disk, causing bad blocks to be re-located:

   [root@dude test]#  dd if=/dev/zero of=/dev/sdd2 bs=64k
   dd: writing `/dev/sdd2': No space left on device
   3806903+0 records in
   3806902+0 records out

Verified the disk:

   [root@dude test]# dd if=/dev/sdd2 of=/dev/null bs=64k
   3806902+1 records in
   3806902+1 records out

Added the partition back to the array:

   [root@dude test]# mdadm /dev/md5 --add /dev/sdd2
   mdadm: hot added /dev/sdd2

Quick look at the arrya configuration to make sure:

   [root@dude test]# mdadm --detail /dev/md5
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

        Update Time : Wed Mar  2 02:01:24 2005
              State : clean
     Active Devices : 5
    Working Devices : 6
     Failed Devices : 0
      Spare Devices : 1

             Layout : left-symmetric
         Chunk Size : 128K

               UUID : a4bbcd09:5e178c5b:3bf8bd45:8c31d2a1
             Events : 0.7036368

        Number   Major   Minor   RaidDevice State
           0       8        2        0      active sync   /dev/sda2
           1       8       18        1      active sync   /dev/sdb2
           2       8       34        2      active sync   /dev/sdc2
           3       8       82        3      active sync   /dev/sdf2
           4       8       66        4      active sync   /dev/sde2

           5       8       50        -      spare   /dev/sdd2

This raises the question: why can't md do this automatically? Not for 
the whole disk/partition, but just for a bad block when encountered? I 
envisage something like:

md attempts read
one disk/partition fails with a bad block
md re-calculates correct data from other disks
md writes correct data to "bad" disk
  - disk will re-locate the bad block

Of course, if you encounter further bad blocks when reading from the 
other disks then you're screwed and it's time to get the backup tapes out!

Is there any sound reason why this is not feasible? Is it just that 
someone needs to write the code to implement it?

R.
-- 
http://robinbowes.com

