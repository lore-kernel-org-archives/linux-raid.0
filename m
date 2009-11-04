From: Adam Huffman <bloch@verdurin.com>
Subject: Re: RAID1 array losing one member
Date: Wed, 4 Nov 2009 17:55:07 +0000
Message-ID: <20091104175507.GD20938@shuttle.verdurin.salon>
References: <20091104161801.GC20938@shuttle.verdurin.salon> <ABFC24E4C13D81489F7F624E14891C865AA4CA39@uk-ex-mbx1.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ABFC24E4C13D81489F7F624E14891C865AA4CA39@uk-ex-mbx1.terastack.bluearc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Jackson <sjackson@bluearc.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Nov 04, 2009 at 05:43:13PM +0000, Simon Jackson wrote:
> What sort of drive and interface is this on?
>

Hitachi HDS721075KLA330 attached to an Intel Corporation 631xESB/632xESB
SATA AHCI Controller

> Look at the system log files to see if there are low level driver errors being logged.  
> 

Here's an error the last time it dropped out:

kernel: ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
kernel: ata2.00: irq_stat 0x40000001
kernel: ata2.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
kernel:         res 51/04:00:00:00:00/00:00:00:00:00/a0 Emask 0x1
(device error)
kernel: ata2.00: status: { DRDY ERR }
kernel: ata2.00: error: { ABRT }
kernel: ata2.00: revalidation failed (errno=-2)
kernel: ata2: hard resetting link
kernel: ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
kernel: ata2.00: configured for UDMA/133
kernel: ata2.00: device reported invalid CHS sector 0
kernel: ata2: EH complete
kernel: sd 1:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156
MB)
kernel: sd 1:0:0:0: [sdb] Write Protect is off
kernel: sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
kernel: end_request: I/O error, dev sdb, sector 730290071
kernel: raid1: Disk failure on sdb1, disabling device.
kernel: raid1: Operation continuing on 1 devices.
kernel: md: md0: recovery done.
kernel: RAID1 conf printout:
kernel: --- wd:1 rd:2
kernel: disk 0, wo:0, o:1, dev:sda1
kernel: disk 1, wo:1, o:0, dev:sdb1
kernel: RAID1 conf printout:
kernel: --- wd:1 rd:2
kernel: disk 0, wo:0, o:1, dev:sda1


> I am investigating similar problems with SATA drives droping out of RAID 1 due to ata level problems.
>  
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Adam Huffman
> Sent: 04 November 2009 16:18
> To: linux-raid@vger.kernel.org
> Subject: RAID1 array losing one member
> 
> 
> I have an annoying problem with a RAID1 array.
> 
> One of the members keeps dropping out of the array:
> 
> /dev/md0:
>         Version : 0.90
>   Creation Time : Sun Jun 28 13:24:02 2009
>      Raid Level : raid1
>      Array Size : 732571904 (698.64 GiB 750.15 GB)
>   Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Wed Nov  4 16:12:36 2009
>           State : clean, degraded
>  Active Devices : 1
> Working Devices : 1
>  Failed Devices : 1
>   Spare Devices : 0
> 
>            UUID : 281b623a:4f01e4e1:36bee1ae:cd0903da
>          Events : 0.4682740
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/sda1
>        1       0        0        1      removed
> 
>        2       8       17        -      faulty spare   /dev/sdb1
> 
> I've run extended SMART self-tests and the manufacturer's diagnostic
> test on the drive - in neither case is any error found.
> 
> When I try to re-add the disk, reconstruction of the array begins.
> However, it always fails, at different points.
> 
> Is there another test I can run to see what might be wrong with the
> drive?  Could this be a different MD problem?
> 
> The machine is running Fedora 10, 
> kernel 2.6.27.37-170.2.104.fc10.x86_64.
> 
> This is the device that keeps failing:
> 
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : 281b623a:4f01e4e1:36bee1ae:cd0903da
>   Creation Time : Sun Jun 28 13:24:02 2009
>      Raid Level : raid1
>   Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
>      Array Size : 732571904 (698.64 GiB 750.15 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 0
> 
>     Update Time : Tue Nov  3 17:20:42 2009
>           State : active
>  Active Devices : 1
> Working Devices : 2
>  Failed Devices : 1
>   Spare Devices : 1
>        Checksum : e5396754 - correct
>          Events : 4651695
> 
> 
>       Number   Major   Minor   RaidDevice State
> this     2       8       17        2      spare   /dev/sdb1
> 
>    0     0       8        1        0      active sync   /dev/sda1
>    1     1       0        0        1      faulty removed
>    2     2       8       17        2      spare   /dev/sdb1
> 
> 
> 
> Adam
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
