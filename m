From: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Subject: Re: Found duplicate PV: using /dev/sda3 not /dev/md1
Date: Sun, 15 Jun 2014 20:35:03 +0200
Message-ID: <1454723160.20140615203503@oudeis.org>
References: <1896515726.20140614235853@oudeis.org>
Reply-To: =?ISO-8859-15?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1896515726.20140614235853@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

status update:

the server is running under a slight load, some incoming mails and
logging (messages, maillog). no data corruption so far.

my assumption: since all writes go to /dev/sda3 via LVM, no writes go
to the raid, therefore it doesn't sync, therefore no data corruption.

cu

RF> hi,

RF> today I replaced two old 750GB disks in a RAID1 with two new 1TB
RF> disks:

RF> /dev/md0 (sda1, sdb1) (root filesystem)
RF> /dev/md1 (sda3, sdb3) LVM with /var (and others)

RF> - remove 750GB sdb, add new 1TB sdb, fdisk & sync sda -> sdb md0 and md1
RF> - remove 750GB sda, add new 1TB sda, fdisk & sync sdb -> sda md0 (md1 pending)
RF> here I had some problems with grub, system did not boot from new sdb,
RF> so I switched SATA ports on both disks and worked on grub & bios to
RF> finally boot from sdb (maybe this was were the sh!t hit the fan)

RF> on next boot, LVM reported the following:

RF> Found duplicate PV efP9J0elVh1bokdArXcwsCB0KW0Yy9Ya: using /dev/sda3 not /dev/md1

RF> this doesn't look good, does it?

RF> is there any way to convince LVM to use md1 instead of sda3,
RF> preferrably without shutting down/rebooting the server? (remember,
RF> /var is an LVM volume) otherwise, I need to drive 70km, but that's OK
RF> if necessary.

RF> [root@gateway ~]# pvdisplay
RF>   Found duplicate PV efP9J0elVh1bokdArXcwsCB0KW0Yy9Ya: using /dev/sda3 not /dev/md1
RF>   --- Physical volume ---
RF>   PV Name               /dev/sda3
RF>   VG Name               vg_gateway
RF>   PV Size               688.64 GB / not usable 1.56 MB
RF>   Allocatable           yes
RF>   PE Size (KByte)       4096
RF>   Total PE              176291
RF>   Free PE               154787
RF>   Allocated PE          21504
RF>   PV UUID               efP9J0-elVh-1bok-dArX-cwsC-B0KW-0Yy9Ya

RF> [root@gateway ~]# mdadm --misc -D /dev/md0
RF> /dev/md0:
RF>         Version : 0.90
RF>   Creation Time : Thu May 26 02:42:30 2011
RF>      Raid Level : raid1
RF>      Array Size : 8385792 (8.00 GiB 8.59 GB)
RF>   Used Dev Size : 8385792 (8.00 GiB 8.59 GB)
RF>    Raid Devices : 2
RF>   Total Devices : 2
RF> Preferred Minor : 0
RF>     Persistence : Superblock is persistent

RF>     Update Time : Sat Jun 14 23:55:03 2014
RF>           State : clean
RF>  Active Devices : 2
RF> Working Devices : 2
RF>  Failed Devices : 0
RF>   Spare Devices : 0

RF>            UUID : e305eb48:ccdead21:b2113316:370d4eaa
RF>          Events : 0.138466

RF>     Number   Major   Minor   RaidDevice State
RF>        0       8        1        0      active sync   /dev/sda1
RF>        1       8       17        1      active sync   /dev/sdb1

RF> [root@gateway ~]# mdadm --misc -D /dev/md1
RF> /dev/md1:
RF>         Version : 0.90
RF>   Creation Time : Mon Jun  6 23:12:19 2011
RF>      Raid Level : raid1
RF>      Array Size : 722089536 (688.64 GiB 739.42 GB)
RF>   Used Dev Size : 722089536 (688.64 GiB 739.42 GB)
RF>    Raid Devices : 2
RF>   Total Devices : 2
RF> Preferred Minor : 1
RF>     Persistence : Superblock is persistent

RF>     Update Time : Sat Jun 14 23:56:06 2014
RF>           State : clean, degraded, recovering
RF>  Active Devices : 1
RF> Working Devices : 2
RF>  Failed Devices : 0
RF>   Spare Devices : 1

RF>  Rebuild Status : 96% complete

RF>            UUID : 7b278c55:0642253d:7f816378:91d6e631
RF>          Events : 0.300608

RF>     Number   Major   Minor   RaidDevice State
RF>        2       8        3        0      spare rebuilding   /dev/sda3
RF>        1       8       19        1      active sync   /dev/sdb3

RF> [root@gateway ~]# lvdisplay
RF>   Found duplicate PV efP9J0elVh1bokdArXcwsCB0KW0Yy9Ya: using /dev/sda3 not /dev/md1
RF>   --- Logical volume ---
RF>   LV Name                /dev/vg_gateway/lv_home
RF>   VG Name                vg_gateway
RF>   LV UUID                yeBeOp-yho6-rIvS-sGhr-lpWL-T3ss-T1L9tk
RF>   LV Write Access        read/write
RF>   LV Status              available
RF>   # open                 1
RF>   LV Size                12.00 GB
RF>   Current LE             3072
RF>   Segments               1
RF>   Allocation             inherit
RF>   Read ahead sectors     auto
RF>   - currently set to     256
RF>   Block device           253:0

RF>   --- Logical volume ---
RF>   LV Name                /dev/vg_gateway/lv_var
RF>   VG Name                vg_gateway
RF>   LV UUID                j5P82N-irO3-AS1k-TQtk-KwSG-PZWS-j8jsx2
RF>   LV Write Access        read/write
RF>   LV Status              available
RF>   # open                 1
RF>   LV Size                12.00 GB
RF>   Current LE             3072
RF>   Segments               1
RF>   Allocation             inherit
RF>   Read ahead sectors     auto
RF>   - currently set to     256
RF>   Block device           253:1

RF>   --- Logical volume ---
RF>   LV Name                /dev/vg_gateway/lv_data
RF>   VG Name                vg_gateway
RF>   LV UUID                ihCove-bOaa-HfYn-KNcU-5P4a-OYzO-XrbzEU
RF>   LV Write Access        read/write
RF>   LV Status              available
RF>   # open                 1
RF>   LV Size                60.00 GB
RF>   Current LE             15360
RF>   Segments               1
RF>   Allocation             inherit
RF>   Read ahead sectors     auto
RF>   - currently set to     256
RF>   Block device           253:2

RF> tnx in advance.

RF> --
RF> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
RF> the body of a message to majordomo@vger.kernel.org
RF> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--- NOT sent from an iPhone

