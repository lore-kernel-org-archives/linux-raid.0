From: David Chow <davidchow@shaolinmicro.com>
Subject: Re: RAID-1 does not rebuild after hot-add
Date: Tue, 05 Aug 2003 14:32:31 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F2F4F7F.6010801@shaolinmicro.com>
References: <3F2D1FAC.9030905@shaolinmicro.com>	<16173.43804.617586.906225@gargle.gargle.HOWL>	<3F2E8CAE.7090208@shaolinmicro.com> <16175.4992.765886.291774@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
>
>Rather than a hex dump, just use
>
>  mdadm --examine /dev/XXX
>
>That is the easiest way to view the superblock on the device.
>
>NeilBrown
>
Neil,

OK, I find out there is a problem in the superblock which is descrbed as 
follows. The "Total Devices" is wrong. It should be 2 instead of 3. This 
is probably a bug of the mkraid (from raidtools) which when I created 
the array with a "failed-disk" in degraded mode. mkraid incorrectly made 
a wrong superblock even I put "nr-raid-disk 2" and "nr-spare-disks 0" in 
the raidtab. Ok, the superblock is incorrect, but how can I change the 
total devices and spare device pramaters without re-initialize the array?

David Chow

[root@www2 /]# mdadm --examine /dev/sda3
/dev/sda3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 39042a54:7c2ca55a:939c1846:94f73fb8
  Creation Time : Sat Aug  2 21:00:17 2003
     Raid Level : raid1
    Device Size : 3076352 (2.93 GiB 3.15 GB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 2

    Update Time : Mon Aug  4 06:25:32 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 578aa21 - correct
         Events : 0.15


      Number   Major   Minor   RaidDevice State
this     2       8        3        2        /dev/sda3
   0     0       0        0       -1      faulty
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       8        3        2        /dev/sda3
[root@www2 /]# mdadm --examine /dev/sdb3
/dev/sdb3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 39042a54:7c2ca55a:939c1846:94f73fb8
  Creation Time : Sat Aug  2 21:00:17 2003
     Raid Level : raid1
    Device Size : 3076352 (2.93 GiB 3.15 GB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 2

    Update Time : Mon Aug  4 06:25:32 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 578aa35 - correct
         Events : 0.15


      Number   Major   Minor   RaidDevice State
this     1       8       19        1      active sync   /dev/sdb3
   0     0       0        0       -1      faulty
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       8        3        2        /dev/sda3


