From: David Greaves <david@dgreaves.com>
Subject: Help recreating a raid5
Date: Sun, 02 Apr 2006 09:15:19 +0100
Message-ID: <442F8817.508@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I need to rebuild a 3-disk raid5.

One disk may be faulty (sda) ; one is good (sdd) and the other I think
is OK too (sdb).

The array dropped one disk (sda), then a short time later, another (sdb)

I mistakenly 'added' sdb back in which of course marked it as a spare.
This means that --assemble even with --force no longer works:

haze:~# mdadm --detail /dev/md1
/dev/md1:
        Version : 00.90.03
  Creation Time : Sat Jun 11 23:12:06 2005
     Raid Level : raid5
    Device Size : 195358336 (186.31 GiB 200.05 GB)
   Raid Devices : 3
  Total Devices : 2
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Sun Apr  2 08:35:50 2006
          State : clean, degraded
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 8d3c8cee:ef55096d:0f219d44:189f8912
         Events : 0.1285185

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1       0        0        -      removed
       2       0        0        -      removed

       3       8       17        -      spare   /dev/sdb1




A recent --detail whilst all was well gave:

/dev/md1:
        Version : 00.90.03
  Creation Time : Sat Jun 11 23:12:06 2005
     Raid Level : raid5
     Array Size : 390716672 (372.62 GiB 400.09 GB)
    Device Size : 195358336 (186.31 GiB 200.05 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Fri Mar 31 09:53:07 2006
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 8d3c8cee:ef55096d:0f219d44:189f8912
         Events : 0.1269558

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1       8       17        1      active sync   /dev/sdb1
       2       8        1        2      active sync   /dev/sda1

and at the first failure I saw this in dmesg:
raid5: Disk failure on sda1, disabling device. Operation continuing on 2
devices
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, o:1, dev:sdd1
 disk 1, o:1, dev:sdb1
 disk 2, o:0, dev:sda1
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, o:1, dev:sdd1
 disk 1, o:1, dev:sdb1

From some archive reading I understand that I can recreate the array using

   mdadm --create /dev/md1 -l5 -n3 /dev/sdd1 /dev/sdb1 missing

but that I need to specify the correct order for the drives.

I've not used --assume-clean, --force or --run; should I? I assume that
since it's only got 2 of 3 then it won't need the assume-clean.

The detail and dmesg data suggests that the order in the command  above
is correct.

Can anyone confirm this?

Thanks

David


-- 

