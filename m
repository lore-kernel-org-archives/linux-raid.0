From: "Joshua C." <joshuacov@gmail.com>
Subject: Re: mdadm: mdNN: pN size extends beyond EOD, truncated (cannot access
 imsm windows raid from within linux)
Date: Fri, 7 Dec 2012 19:38:12 +0100
Message-ID: <CAKL7Q7qD-iJ-11cccypw_gr4SmDm_g8FtpgEvoAGjpJ8G4+Osw@mail.gmail.com>
References: <CAKL7Q7ruBvRKN3cnwoKT42zewj-60ExMN0h-iPYKPaNXapFdUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKL7Q7ruBvRKN3cnwoKT42zewj-60ExMN0h-iPYKPaNXapFdUQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2012/12/4 Joshua C. <joshuacov@gmail.com>:
> I have two 1TB disk that have been running in raid1 with the
> intel-p67-built-in controller. Those were created in bios (uefi;
> imsm-raids) and are actually fake(software) raids. Windows sees only
> his own (ntfs) raid and everything is fine. Under linux I set the
> partition type to 0xfd (linux auto raid) and mdadm can successfully
> see and access the linux raid partion.
>
> However I cannot access my windows-raid-partition (/dev/md126p2 on
> /dev/sd[bc]) from within linux and get the following error: "md126: p2
> size 209711104 extends beyond EOD, truncated"
>
> Looking into the data, I see that my windows-raid-partition has
> actually 4! partitions on it. This should be wrong. This what
> mdadm-3.2.6 says about my disks under kernel-3.6.8.fc17.x86_64:
>
> ===========================================
> [root@localhost]# mdadm -E /dev/md127
> /dev/md127:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.1.00
>     Orig Family : 88e429ad
>          Family : 1e27d1ba
>      Generation : 0001ad23
>      Attributes : All supported
>            UUID : 516f8fc8:bd5e663f:c254ea22:d30bb530
>        Checksum : 2438ebf9 correct
>     MPB Sectors : 1
>           Disks : 2
>    RAID Devices : 1
>
>   Disk00 Serial : WD-XXXXXXXXXXXX
>           State : active
>              Id : 00000002
>     Usable Size : 1953519880 (931.51 GiB 1000.20 GB)
>
> [Volume0]:
>            UUID : fa85ec01:25e9c177:da74f1e6:03284c35
>      RAID Level : 1
>         Members : 2
>           Slots : [UU]
>     Failed disk : none
>       This Slot : 0
>      Array Size : 1953519616 (931.51 GiB 1000.20 GB)
>    Per Dev Size : 1953519880 (931.51 GiB 1000.20 GB)
>   Sector Offset : 0
>     Num Stripes : 7630936
>      Chunk Size : 64 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>
>   Disk01 Serial : WD-XXXXXXXXXXXX
>           State : active
>              Id : 00000003
>     Usable Size : 1953519880 (931.51 GiB 1000.20 GB)
> ===========================================
> [root@localhost]# mdadm -D /dev/md127
> /dev/md127:
>         Version : imsm
>      Raid Level : container
>   Total Devices : 2
>
> Working Devices : 2
>
>
>            UUID : 516f8fc8:bd5e663f:c254ea22:d30bb530
>   Member Arrays : /dev/md/Volume0
>
>     Number   Major   Minor   RaidDevice
>
>        0       8       32        -        /dev/sdc
>        1       8       16        -        /dev/sdb
> ===========================================
> [root@localhost]# mdadm -E /dev/md126
> /dev/md126:
>    MBR Magic : aa55
> Partition[0] :   1743810560 sectors at         2048 (type fd)
> Partition[1] :    209711104 sectors at   1743812608 (type 07)
> ===========================================
> [root@localhost]# mdadm -D /dev/md126
> /dev/md126:
>       Container : /dev/md127, member 0
>      Raid Level : raid1
>      Array Size : 976759808 (931.51 GiB 1000.20 GB)
>   Used Dev Size : 976759940 (931.51 GiB 1000.20 GB)
>    Raid Devices : 2
>   Total Devices : 2
>
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>
>            UUID : fa85ec01:25e9c177:da74f1e6:03284c35
>     Number   Major   Minor   RaidDevice State
>        1       8       16        0      active sync   /dev/sdb
>        0       8       32        1      active sync   /dev/sdc
> ===========================================
> [root@localhost]# mdadm -E /dev/md126p1
> ===========================================
> [root@localhost]# mdadm -D /dev/md126p1
> /dev/md126p1:
>       Container : /dev/md127, member 0
>      Raid Level : raid1
>      Array Size : 871905280 (831.51 GiB 892.83 GB)
>   Used Dev Size : 976759940 (931.51 GiB 1000.20 GB)
>    Raid Devices : 2
>   Total Devices : 2
>
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>
>            UUID : fa85ec01:25e9c177:da74f1e6:03284c35
>     Number   Major   Minor   RaidDevice State
>        1       8       16        0      active sync   /dev/sdb
>        0       8       32        1      active sync   /dev/sdc
> ===========================================
> [root@localhost]# mdadm -E /dev/md126p2
> /dev/md126p2:
>    MBR Magic : aa55
> Partition[0] :   1917848077 sectors at      6579571 (type 70)
> Partition[1] :   1818575915 sectors at   1953251627 (type 43)
> Partition[2] :           10 sectors at    225735265 (type 72)
> Partition[3] :        51890 sectors at   2642411520 (type 00)
> ===========================================
> [root@localhost]# mdadm -D /dev/md126p2
> /dev/md126p2:
>       Container : /dev/md127, member 0
>      Raid Level : raid1
>      Array Size : 104853504 (100.00 GiB 107.37 GB)
>   Used Dev Size : 976759940 (931.51 GiB 1000.20 GB)
>    Raid Devices : 2
>   Total Devices : 2
>
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>
>            UUID : fa85ec01:25e9c177:da74f1e6:03284c35
>     Number   Major   Minor   RaidDevice State
>        1       8       16        0      active sync   /dev/sdb
>        0       8       32        1      active sync   /dev/sdc
> ===========================================
> [root@localhost]# mdadm -E /dev/sdb
> /dev/sdb:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.1.00
>     Orig Family : 88e429ad
>          Family : 1e27d1ba
>      Generation : 0001ad29
>      Attributes : All supported
>            UUID : 516f8fc8:bd5e663f:c254ea22:d30bb530
>        Checksum : 2438ebff correct
>     MPB Sectors : 1
>           Disks : 2
>    RAID Devices : 1
>
>   Disk00 Serial : WD-XXXXXXXXXXXX
>           State : active
>              Id : 00000002
>     Usable Size : 1953519880 (931.51 GiB 1000.20 GB)
>
> [Volume0]:
>            UUID : fa85ec01:25e9c177:da74f1e6:03284c35
>      RAID Level : 1
>         Members : 2
>           Slots : [UU]
>     Failed disk : none
>       This Slot : 0
>      Array Size : 1953519616 (931.51 GiB 1000.20 GB)
>    Per Dev Size : 1953519880 (931.51 GiB 1000.20 GB)
>   Sector Offset : 0
>     Num Stripes : 7630936
>      Chunk Size : 64 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>
>   Disk01 Serial : WD-XXXXXXXXXXXX
>           State : active
>              Id : 00000003
>     Usable Size : 1953519880 (931.51 GiB 1000.20 GB)
> ===========================================
> [root@localhost]# mdadm -E /dev/sdc
> /dev/sdc:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.1.00
>     Orig Family : 88e429ad
>          Family : 1e27d1ba
>      Generation : 0001ad29
>      Attributes : All supported
>            UUID : 516f8fc8:bd5e663f:c254ea22:d30bb530
>        Checksum : 2438ebff correct
>     MPB Sectors : 1
>           Disks : 2
>    RAID Devices : 1
>
>   Disk01 Serial : WD-XXXXXXXXXXXX
>           State : active
>              Id : 00000003
>     Usable Size : 1953519880 (931.51 GiB 1000.20 GB)
>
> [Volume0]:
>            UUID : fa85ec01:25e9c177:da74f1e6:03284c35
>      RAID Level : 1
>         Members : 2
>           Slots : [UU]
>     Failed disk : none
>       This Slot : 1
>      Array Size : 1953519616 (931.51 GiB 1000.20 GB)
>    Per Dev Size : 1953519880 (931.51 GiB 1000.20 GB)
>   Sector Offset : 0
>     Num Stripes : 7630936
>      Chunk Size : 64 KiB
>        Reserved : 0
>   Migrate State : idle
>       Map State : normal
>     Dirty State : clean
>
>   Disk00 Serial : WD-XXXXXXXXXXXX
>           State : active
>              Id : 00000002
>     Usable Size : 1953519880 (931.51 GiB 1000.20 GB)
> ===========================================
> [root@localhost]# cat /proc/mdstat
> Personalities : [raid1]
> md126 : active raid1 sdb[1] sdc[0]
>       976759808 blocks super external:/md127/0 [2/2] [UU]
>
> md127 : inactive sdb[1](S) sdc[0](S)
>       5288 blocks super external:imsm
>
> unused devices: <none>
> ===========================================
> [root@localhost]# cat /proc/partitions
> major minor  #blocks  name
>
>    7        0         16 loop0
>    7        1       2796 loop1
>    7        2     900352 loop2
>    7        3   10485760 loop3
>    7        4     524288 loop4
>    8        0   62522712 sda
>    8        1   18350080 sda1
>    8        2   44171264 sda2
>    8       16  976762584 sdb
>    8       32  976762584 sdc
>   11        0    1048575 sr0
>    8       48    3903488 sdd
>    8       49    3903456 sdd1
>  253        0   10485760 dm-0
>  253        1   10485760 dm-1
>    9      126  976759808 md126
>  259        0  871905280 md126p1
>  259        1  104853504 md126p2
>    8       64    2002943 sde
>    8       65    2002942 sde1
> ===========================================
> [root@localhost]# mdadm --examine --scan
> ARRAY metadata=imsm UUID=516f8fc8:bd5e663f:c254ea22:d30bb530
> ARRAY /dev/md/Volume0 container=516f8fc8:bd5e663f:c254ea22:d30bb530
> member=0 UUID=fa85ec01:25e9c177:da74f1e6:03284c35
> ===========================================
> [root@localhost]# mdadm --detail --scan
> ARRAY /dev/md127 metadata=imsm UUID=516f8fc8:bd5e663f:c254ea22:d30bb530
> ARRAY /dev/md/Volume0 container=/dev/md127 member=0
> UUID=fa85ec01:25e9c177:da74f1e6:03284c35
> ===========================================
> [root@localhost]# dmesg  |grep md
> [    0.000000] Command line: initrd=initrd0.img
> root=live:UUID=406D-2540 rootfstype=vfat ro liveimg quiet  rhgb
> rd.luks=0 rd.md=0 rd.dm=0  BOOT_IMAGE=vmlinuz0
> [    0.000000] Kernel command line: initrd=initrd0.img
> root=live:UUID=406D-2540 rootfstype=vfat ro liveimg quiet  rhgb
> rd.luks=0 rd.md=0 rd.dm=0  BOOT_IMAGE=vmlinuz0
> [    1.277784] dracut: rd.md=0: removing MD RAID activation
> [    6.231138] md: bind<sdb>
> [    6.434862] md: bind<sdc>
> [    6.440260] md: bind<sdc>
> [    6.440383] md: bind<sdb>
> [    6.453438] md: raid1 personality registered for level 1
> [    6.453654] md/raid1:md126: active with 2 out of 2 mirrors
> [    6.453678] md126: detected capacity change from 0 to 1000202043392
> [    6.460137]  md126: p1 p2
> [    6.460268] md126: p2 size 209711104 extends beyond EOD, truncated
> [    6.464890] md: md126 switched to read-write mode.
> [    6.675396] md: export_rdev(sdc)
> [    6.675454] md: export_rdev(sdb)
> [   84.923953] md: export_rdev(sdc)
> [   84.924017] md: export_rdev(sdb)
> [   93.473151] md126: detected capacity change from 1000202043392 to 0
> [   93.473228] md: md126 stopped.
> [   93.473236] md: unbind<sdb>
> [   93.479847] md: export_rdev(sdb)
> [   93.479858] md: unbind<sdc>
> [   93.486826] md: export_rdev(sdc)
> [   93.493682] md: md126 stopped.
> [   95.923141] md: md127 stopped.
> [   95.923151] md: unbind<sdc>
> [   95.927344] md: export_rdev(sdc)
> [   95.927504] md: unbind<sdb>
> [   95.936313] md: export_rdev(sdb)
> [  824.206594] md: md127 stopped.
> [  824.210398] md: bind<sdc>
> [  824.210840] md: bind<sdb>
> [  824.241537] md: bind<sdc>
> [  824.241612] md: bind<sdb>
> [  824.245817] md/raid1:md126: active with 2 out of 2 mirrors
> [  824.245829] md126: detected capacity change from 0 to 1000202043392
> [  824.247377]  md126: p1 p2
> [  824.247545] md126: p2 size 209711104 extends beyond EOD, truncated
> [  824.261049] md: md126 switched to read-write mode.
> [  824.304567] md: export_rdev(sdc)
> [  824.304594] md: export_rdev(sdb)
> [  824.320417] md: export_rdev(sdc)
> [  824.320444] md: export_rdev(sdb)
> [ 1161.533446] EXT4-fs (md126p1): warning: maximal mount count
> reached, running e2fsck is recommended
> [ 1161.573164] EXT4-fs (md126p1): mounted filesystem with ordered data
> mode. Opts: (null)
> [ 1161.573169] SELinux: initialized (dev md126p1, type ext4), uses xattr
> ===========================================
>
> Can someone take a look at why mdadm cannot access the windows-raid-partition?
>
>
> --joshua

Anyone? Any idea why I cannot access my windows raid from linux?


-- 
--joshua
