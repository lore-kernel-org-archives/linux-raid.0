From: Victor <linux-raid@vitoni.de>
Subject: Re: missing superblock on RAID5
Date: Mon, 13 Oct 2003 23:09:37 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F8B1491.57BCF640@vitoni.de>
References: <3F8ACBD2.CA1B8CBD@vitoni.de> <3F8AD02C.8080606@fantinibakery.com> <3F8AE51C.3F0A9451@vitoni.de> <3F8B039F.2070403@fantinibakery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Actually I have 2 arrays and both have a device more than they should.


# mdadm --detail /dev/md1
/dev/md1:
        Version : 00.90.00
  Creation Time : Wed Jul 30 21:49:33 2003
     Raid Level : raid5
     Array Size : 18474496 (17.62 GiB 18.92 GB)
    Device Size : 9237248 (8.81 GiB 9.46 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Wed Oct  8 23:53:50 2003
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync
/dev/ide/host0/bus0/target0/lun0/part3
       1      33        2        1      active sync
/dev/ide/host2/bus0/target0/lun0/part2
       2      34        2        2      active sync
/dev/ide/host2/bus1/target0/lun0/part2
           UUID : 7aa04659:9100ac93:b3808182:f11c0b78
         Events : 0.36



rob wrote:

> that does look strange.  But I've been using software raid for just a
> couple weeks, so don't know a lot about it.
>
> here is same command on our computer. i have only 2 devices.  looks
> like
> something is up with yours.  do you have another md device you can
> check
> the command on?
>
>
> root@fbc5:~ #  mdadm --detail /dev/md0
> /dev/md0:
>         Version : 00.90.00
>   Creation Time : Tue Sep 30 15:22:45 2003
>      Raid Level : raid1
>      Array Size : 8337600 (7.95 GiB 8.54 GB)
>     Device Size : 8337600 (7.95 GiB 8.54 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 0
>     Persistence : Superblock is persistent
>
>     Update Time : Fri Oct 10 08:37:34 2003
>           State : dirty, no-errors
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>     Number   Major   Minor   RaidDevice State
>        0       8        6        0      active sync
> /dev/scsi/host0/bus0/target1/lun0/part6
>        1       8       22        1      active sync
> /dev/scsi/host0/bus0/target3/lun0/part6
>            UUID : 131c021d:7bc1e937:1bea7923:d7eed283
>          Events : 0.54
>


