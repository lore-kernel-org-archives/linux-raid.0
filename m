From: Jed Davidow <jed@ultralame.com>
Subject: Re: md rotates RAID5 spare at boot
Date: Thu, 10 Jan 2008 10:03:46 -0800
Message-ID: <47865E02.1070108@ultralame.com>
References: <47852984.5040707@ultralame.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47852984.5040707@ultralame.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm sorry- is this an inappropriate list to ask for help?  There seemed 
to be a fair amount of that when I searched the archives, but I don't 
want to bug developers with my problems!

Please let me know if I should find another place to ask for help (and 
please let me know where that might be!).

Thanks!

Jed Davidow wrote:
> I have a RAID5 (5+1spare) setup that works perfectly well until I 
> reboot.  I have 6 drives (two different models) partitioned to give me 
> 2 arrays, md0 and md1, that I use for /home and /var respectively.
>
> When I reboot, the system assembles each array, but swaps out what was 
> the spare with one of the member drives.  It then immediately detects 
> a degraded array and rebuilds.  After that, all is fine and testing 
> has shown things to be working like they should.  Until I reboot.
>
> Example:
> Built two arrays:  /dev/md0 -> /dev/sd[abcef]1 and /dev/md1 -> 
> /dev/sd[abcef]2
> Added /dev/sdg1 and /dev/sdg2 as spares, and this works.
>
> One scenario when I reboot:
>    md0 is assembled from sd[abceg]1; it's degraded and reports a 
> "spares missing" event.
>    md1 assembles correctly, spare is not missing
>
> Any ideas?  I have asked about this on various boards (some said UDEV 
> rules would help, some thought the issue had to do with the /dev/sdX 
> names changing, etc).  I don't think those are applicable since dmesg 
> reports the arrays assemble as soon as the disks are detected.
>
>
> Thanks in advance!
>
>
> INFO:
> (currently the boot drive (non raid) is sdd, otherwise all sd devices 
> are part of the raid)
>
> fdisk:
>
>    $ sudo fdisk -l
>
>    Disk /dev/sda: 250.0 GB, 250059350016 bytes
>    255 heads, 63 sectors/track, 30401 cylinders
>    Units = cylinders of 16065 * 512 = 8225280 bytes
>    Disk identifier: 0x00000000
>
>       Device Boot      Start         End      Blocks   Id  System
>    /dev/sda1               1        1521    12217401   fd  Linux raid
>    autodetect
>    /dev/sda2            1522       30401   231978600   fd  Linux raid
>    autodetect
>
>    Disk /dev/sdb: 251.0 GB, 251000193024 bytes
>    255 heads, 63 sectors/track, 30515 cylinders
>    Units = cylinders of 16065 * 512 = 8225280 bytes
>    Disk identifier: 0x00000000
>
>       Device Boot      Start         End      Blocks   Id  System
>    /dev/sdb1               1        1521    12217401   fd  Linux raid
>    autodetect
>    /dev/sdb2            1522       30401   231978600   fd  Linux raid
>    autodetect
>
>    Disk /dev/sdc: 251.0 GB, 251000193024 bytes
>    255 heads, 63 sectors/track, 30515 cylinders
>    Units = cylinders of 16065 * 512 = 8225280 bytes
>    Disk identifier: 0x00000000
>
>       Device Boot      Start         End      Blocks   Id  System
>    /dev/sdc1               1        1521    12217401   fd  Linux raid
>    autodetect
>    /dev/sdc2            1522       30401   231978600   fd  Linux raid
>    autodetect
>
>    Disk /dev/md0: 50.0 GB, 50041978880 bytes
>    2 heads, 4 sectors/track, 12217280 cylinders
>    Units = cylinders of 8 * 512 = 4096 bytes
>    Disk identifier: 0x00000000
>
>    Disk /dev/md0 doesn't contain a valid partition table
>
>    Disk /dev/md1: 950.1 GB, 950183919616 bytes
>    2 heads, 4 sectors/track, 231978496 cylinders
>    Units = cylinders of 8 * 512 = 4096 bytes
>    Disk identifier: 0x00000000
>
>    Disk /dev/md1 doesn't contain a valid partition table
>
>    Disk /dev/sdd: 120.0 GB, 120034123776 bytes
>    255 heads, 63 sectors/track, 14593 cylinders
>    Units = cylinders of 16065 * 512 = 8225280 bytes
>    Disk identifier: 0x535bfd7a
>
>       Device Boot      Start         End      Blocks   Id  System
>    /dev/sdd1   *           1       14219   114214086   83  Linux
>    /dev/sdd2           14220       14593     3004155    5  Extended
>    /dev/sdd5           14220       14593     3004123+  82  Linux swap /
>    Solaris
>
>    Disk /dev/sde: 251.0 GB, 251000193024 bytes
>    255 heads, 63 sectors/track, 30515 cylinders
>    Units = cylinders of 16065 * 512 = 8225280 bytes
>    Disk identifier: 0x00000000
>
>       Device Boot      Start         End      Blocks   Id  System
>    /dev/sde1               1        1521    12217401   fd  Linux raid
>    autodetect
>    /dev/sde2            1522       30401   231978600   fd  Linux raid
>    autodetect
>
>    Disk /dev/sdf: 250.0 GB, 250059350016 bytes
>    255 heads, 63 sectors/track, 30401 cylinders
>    Units = cylinders of 16065 * 512 = 8225280 bytes
>    Disk identifier: 0x00000000
>
>       Device Boot      Start         End      Blocks   Id  System
>    /dev/sdf1               1        1521    12217401   fd  Linux raid
>    autodetect
>    /dev/sdf2            1522       30401   231978600   fd  Linux raid
>    autodetect
>
>    Disk /dev/sdg: 250.0 GB, 250059350016 bytes
>    255 heads, 63 sectors/track, 30401 cylinders
>    Units = cylinders of 16065 * 512 = 8225280 bytes
>    Disk identifier: 0x00000000
>
>       Device Boot      Start         End      Blocks   Id  System
>    /dev/sdg1               1        1521    12217401   fd  Linux raid
>    autodetect
>    /dev/sdg2            1522       30401   231978600   fd  Linux raid
>    autodetect
>
>
> $ sudo mdadm --detail /dev/md0 (md1 shows similar info)
>
>    /dev/md0:
>            Version : 00.90.03
>      Creation Time : Sat Apr  7 23:32:58 2007
>         Raid Level : raid5
>         Array Size : 48869120 (46.61 GiB 50.04 GB)
>      Used Dev Size : 12217280 (11.65 GiB 12.51 GB)
>       Raid Devices : 5
>      Total Devices : 6
>    Preferred Minor : 0
>        Persistence : Superblock is persistent
>
>        Update Time : Wed Jan  9 11:35:54 2008
>              State : clean
>     Active Devices : 5
>    Working Devices : 6
>     Failed Devices : 0
>      Spare Devices : 1
>
>             Layout : left-symmetric
>         Chunk Size : 64K
>
>               UUID : e7356e2b:71e53a26:94b87bc7:e6a9e6b2
>             Events : 0.2601918
>
>        Number   Major   Minor   RaidDevice State
>           0       8       65        0      active sync   /dev/sde1
>           1       8       81        1      active sync   /dev/sdf1
>           2       8       17        2      active sync   /dev/sdb1
>           3       8        1        3      active sync   /dev/sda1
>           4       8       33        4      active sync   /dev/sdc1
>
>           5       8       97        -      spare   /dev/sdg1
>
> $ sudo mdadm --examine /dev/sda1 (The other SBs contain info that 
> looks OK)
>
>    /dev/sda1:
>              Magic : a92b4efc
>            Version : 00.90.00
>               UUID : e7356e2b:71e53a26:94b87bc7:e6a9e6b2
>      Creation Time : Sat Apr  7 23:32:58 2007
>         Raid Level : raid5
>      Used Dev Size : 12217280 (11.65 GiB 12.51 GB)
>         Array Size : 48869120 (46.61 GiB 50.04 GB)
>       Raid Devices : 5
>      Total Devices : 6
>    Preferred Minor : 0
>
>        Update Time : Wed Jan  9 11:41:29 2008
>              State : clean
>     Active Devices : 5
>    Working Devices : 6
>     Failed Devices : 0
>      Spare Devices : 1
>           Checksum : c50df29 - correct
>             Events : 0.2601918
>
>             Layout : left-symmetric
>         Chunk Size : 64K
>
>          Number   Major   Minor   RaidDevice State
>    this     3       8        1        3      active sync   /dev/sda1
>
>       0     0       8       65        0      active sync   /dev/sde1
>       1     1       8       81        1      active sync   /dev/sdf1
>       2     2       8       17        2      active sync   /dev/sdb1
>       3     3       8        1        3      active sync   /dev/sda1
>       4     4       8       33        4      active sync   /dev/sdc1
>       5     5       8       97        5      spare   /dev/sdg1
>
>
> /proc/mdstat:
>
>    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>    [raid4] [raid10]
>    md1 : active raid5 sdg2[5](S) sde2[0] sda2[3] sdc2[4] sdb2[2] sdf2[1]
>          927913984 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
>
>    md0 : active raid5 sdg1[5](S) sde1[0] sdc1[4] sda1[3] sdb1[2] sdf1[1]
>          48869120 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
>
>    unused devices: <none>
>
> /etc/mdadm/mdadm.conf
>
>    DEVICE partitions
>    ARRAY /dev/md0 level=raid5 num-devices=5 spares=1
>    UUID=e7356e2b:71e53a26:94b87bc7:e6a9e6b2
>    ARRAY /dev/md1 level=raid5 num-devices=5 spares=1
>    UUID=aa0264a3:5fb0396b:04071607:a713ba9
>
>
> Dmesg (edited):
>
>    [   36.112449] md: linear personality registered for level -1
>    [   36.117197] md: multipath personality registered for level -4
>    [   36.121795] md: raid0 personality registered for level 0
>    [   36.126950] md: raid1 personality registered for level 1
>    [   36.131424] raid5: automatically using best checksumming
>    function: pIII_sse
>    [   36.149971]    pIII_sse  :  4564.000 MB/sec
>    [   36.150020] raid5: using function: pIII_sse (4564.000 MB/sec)
>    [   36.218015] raid6: int32x1    780 MB/s
>    [   36.285943] raid6: int32x2    902 MB/s
>    [   36.353961] raid6: int32x4    667 MB/s
>    [   36.421869] raid6: int32x8    528 MB/s
>    [   36.489811] raid6: mmxx1     1813 MB/s
>    [   36.557775] raid6: mmxx2     2123 MB/s
>    [   36.625763] raid6: sse1x1    1101 MB/s
>    [   36.693717] raid6: sse1x2    1898 MB/s
>    [   36.761688] raid6: sse2x1    2227 MB/s
>    [   36.829647] raid6: sse2x2    3178 MB/s
>    [   36.829695] raid6: using algorithm sse2x2 (3178 MB/s)
>    [   36.829744] md: raid6 personality registered for level 6
>    [   36.829793] md: raid5 personality registered for level 5
>    [   36.829842] md: raid4 personality registered for level 4
>    [   36.853475] md: raid10 personality registered for level 10
>
>    [   39.634924] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors
>    (250059 MB)
>    [   39.634995] sd 0:0:0:0: [sda] Write Protect is off
>    [   39.635048] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>    [   39.635076] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
>    enabled, doesn't support DPO or FUA
>    [   39.635218] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors
>    (250059 MB)
>    [   39.635292] sd 0:0:0:0: [sda] Write Protect is off
>    [   39.635350] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>    [   39.635380] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
>    enabled, doesn't support DPO or FUA
>    [   39.635462]  sda: sda1 sda2
>    [   39.650092] sd 0:0:0:0: [sda] Attached SCSI disk
>
>    [   39.650226] sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors
>    (251000 MB)
>    [   39.650296] sd 1:0:0:0: [sdb] Write Protect is off
>    [   39.650348] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>    [   39.650379] sd 1:0:0:0: [sdb] Write cache: disabled, read cache:
>    enabled, doesn't support DPO or FUA
>    [   39.650505] sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors
>    (251000 MB)
>    [   39.650573] sd 1:0:0:0: [sdb] Write Protect is off
>    [   39.650625] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>    [   39.650657] sd 1:0:0:0: [sdb] Write cache: disabled, read cache:
>    enabled, doesn't support DPO or FUA
>    [   39.650727]  sdb: sdb1 sdb2
>    [   39.667599] sd 1:0:0:0: [sdb] Attached SCSI disk
>
>    [   39.667719] sd 3:0:0:0: [sdc] 490234752 512-byte hardware sectors
>    (251000 MB)
>    [   39.667788] sd 3:0:0:0: [sdc] Write Protect is off
>    [   39.667840] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
>    [   39.667871] sd 3:0:0:0: [sdc] Write cache: enabled, read cache:
>    enabled, doesn't support DPO or FUA
>    [   39.667997] sd 3:0:0:0: [sdc] 490234752 512-byte hardware sectors
>    (251000 MB)
>    [   39.668064] sd 3:0:0:0: [sdc] Write Protect is off
>    [   39.668116] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
>    [   39.668146] sd 3:0:0:0: [sdc] Write cache: enabled, read cache:
>    enabled, doesn't support DPO or FUA
>    [   39.668213]  sdc: sdc1 sdc2
>    [   39.692703] sd 3:0:0:0: [sdc] Attached SCSI disk
>
>    [   39.699348] sd 0:0:0:0: Attached scsi generic sg0 type 0
>    [   39.699570] sd 1:0:0:0: Attached scsi generic sg1 type 0
>    [   39.699786] sd 3:0:0:0: Attached scsi generic sg2 type 0
>
>    [   39.834560] md: md0 stopped.
>    [   39.870361] md: bind<sdc1>
>    [   39.870527] md: md1 stopped.
>    [   39.910999] md: md0 stopped.
>    [   39.911064] md: unbind<sdc1>
>    [   39.911120] md: export_rdev(sdc1)
>    [   39.929760] md: bind<sda1>
>    [   39.929953] md: bind<sdc1>
>    [   39.930139] md: bind<sdb1>
>    [   39.930231] md: md1 stopped.
>    [   39.932468] md: bind<sdc2>
>    [   39.932674] md: bind<sda2>
>    [   39.932860] md: bind<sdb2>
>
>    [   40.880217] sd 6:0:0:0: [sdd] 234441648 512-byte hardware sectors
>    (120034 MB)
>    [   40.880288] sd 6:0:0:0: [sdd] Write Protect is off
>    [   40.880340] sd 6:0:0:0: [sdd] Mode Sense: 00 3a 00 00
>    [   40.880367] sd 6:0:0:0: [sdd] Write cache: enabled, read cache:
>    enabled, doesn't support DPO or FUA
>    [   40.880504] sd 6:0:0:0: [sdd] 234441648 512-byte hardware sectors
>    (120034 MB)
>    [   40.880572] sd 6:0:0:0: [sdd] Write Protect is off
>    [   40.880623] sd 6:0:0:0: [sdd] Mode Sense: 00 3a 00 00
>    [   40.880651] sd 6:0:0:0: [sdd] Write cache: enabled, read cache:
>    enabled, doesn't support DPO or FUA
>    [   40.880718]  sdd: sdd1 sdd2 <<7>ieee1394: Host added:
>    ID:BUS[0-00:1023]  GUID[001485000012704c]
>    [   40.908264]  sdd5 >
>    [   40.908479] sd 6:0:0:0: [sdd] Attached SCSI disk
>    [   40.908579] sd 6:0:0:0: Attached scsi generic sg4 type 0
>
>    [   40.908747] scsi 6:0:1:0: Direct-Access     ATA      Maxtor
>    7L250S0   BACE PQ: 0 ANSI: 5
>    [   40.908899] sd 6:0:1:0: [sde] 490234752 512-byte hardware sectors
>    (251000 MB)
>    [   40.908968] sd 6:0:1:0: [sde] Write Protect is off
>    [   40.909020] sd 6:0:1:0: [sde] Mode Sense: 00 3a 00 00
>    [   40.909050] sd 6:0:1:0: [sde] Write cache: enabled, read cache:
>    enabled, doesn't support DPO or FUA
>    [   40.909174] sd 6:0:1:0: [sde] 490234752 512-byte hardware sectors
>    (251000 MB)
>    [   40.909243] sd 6:0:1:0: [sde] Write Protect is off
>    [   40.909294] sd 6:0:1:0: [sde] Mode Sense: 00 3a 00 00
>    [   40.909324] sd 6:0:1:0: [sde] Write cache: enabled, read cache:
>    enabled, doesn't support DPO or FUA
>    [   40.909391]  sde: sde1 sde2
>    [   40.930218] sd 6:0:1:0: [sde] Attached SCSI disk
>    [   40.930318] sd 6:0:1:0: Attached scsi generic sg5 type 0
>
>    [   40.930480] scsi 7:0:0:0: Direct-Access     ATA      WDC
>    WD2500JD-00H 08.0 PQ: 0 ANSI: 5
>    [   40.930621] sd 7:0:0:0: [sdf] 488397168 512-byte hardware sectors
>    (250059 MB)
>    [   40.930689] sd 7:0:0:0: [sdf] Write Protect is off
>    [   40.930742] sd 7:0:0:0: [sdf] Mode Sense: 00 3a 00 00
>    [   40.930769] sd 7:0:0:0: [sdf] Write cache: enabled, read cache:
>    enabled, doesn't support DPO or FUA
>    [   40.930894] sd 7:0:0:0: [sdf] 488397168 512-byte hardware sectors
>    (250059 MB)
>    [   40.930963] sd 7:0:0:0: [sdf] Write Protect is off
>    [   40.931015] sd 7:0:0:0: [sdf] Mode Sense: 00 3a 00 00
>    [   40.931044] sd 7:0:0:0: [sdf] Write cache: enabled, read cache:
>    enabled, doesn't support DPO or FUA
>    [   40.931111]  sdf: sdf1 sdf2
>    [   40.948846] sd 7:0:0:0: [sdf] Attached SCSI disk
>    [   40.948946] sd 7:0:0:0: Attached scsi generic sg6 type 0
>
>    [   40.949106] scsi 7:0:1:0: Direct-Access     ATA      WDC
>    WD2500JS-00M 02.0 PQ: 0 ANSI: 5
>    [   40.949248] sd 7:0:1:0: [sdg] 488397168 512-byte hardware sectors
>    (250059 MB)
>    [   40.949317] sd 7:0:1:0: [sdg] Write Protect is off
>    [   40.949368] sd 7:0:1:0: [sdg] Mode Sense: 00 3a 00 00
>    [   40.949396] sd 7:0:1:0: [sdg] Write cache: enabled, read cache:
>    enabled, doesn't support DPO or FUA
>    [   40.949519] sd 7:0:1:0: [sdg] 488397168 512-byte hardware sectors
>    (250059 MB)
>    [   40.949588] sd 7:0:1:0: [sdg] Write Protect is off
>    [   40.949640] sd 7:0:1:0: [sdg] Mode Sense: 00 3a 00 00
>    [   40.949668] sd 7:0:1:0: [sdg] Write cache: enabled, read cache:
>    enabled, doesn't support DPO or FUA
>    [   40.949734]  sdg: sdg1 sdg2
>    [   40.969827] sd 7:0:1:0: [sdg] Attached SCSI disk
>    [   40.969926] sd 7:0:1:0: Attached scsi generic sg7 type 0
>
>    [   41.206078] md: md0 stopped.
>    [   41.206137] md: unbind<sdb1>
>    [   41.206187] md: export_rdev(sdb1)
>    [   41.206253] md: unbind<sdc1>
>    [   41.206302] md: export_rdev(sdc1)
>    [   41.206360] md: unbind<sda1>
>    [   41.206408] md: export_rdev(sda1)
>    [   41.247389] md: bind<sdf1>
>    [   41.247584] md: bind<sdb1>
>    [   41.247787] md: bind<sda1>
>    [   41.247971] md: bind<sdc1>
>    [   41.248151] md: bind<sdg1>
>    [   41.248325] md: bind<sde1>
>    [   41.256718] raid5: device sde1 operational as raid disk 0
>    [   41.256771] raid5: device sdc1 operational as raid disk 4
>    [   41.256821] raid5: device sda1 operational as raid disk 3
>    [   41.256870] raid5: device sdb1 operational as raid disk 2
>    [   41.256919] raid5: device sdf1 operational as raid disk 1
>    [   41.257426] raid5: allocated 5245kB for md0
>    [   41.257476] raid5: raid level 5 set md0 active with 5 out of 5
>    devices, algorithm 2
>    [   41.257538] RAID5 conf printout:
>    [   41.257584]  --- rd:5 wd:5
>    [   41.257631]  disk 0, o:1, dev:sde1
>    [   41.257677]  disk 1, o:1, dev:sdf1
>    [   41.257724]  disk 2, o:1, dev:sdb1
>    [   41.257771]  disk 3, o:1, dev:sda1
>    [   41.257817]  disk 4, o:1, dev:sdc1
>
>    [   41.257952] md: md1 stopped.
>    [   41.258009] md: unbind<sdb2>
>    [   41.258060] md: export_rdev(sdb2)
>    [   41.258128] md: unbind<sda2>
>    [   41.258179] md: export_rdev(sda2)
>    [   41.258248] md: unbind<sdc2>
>    [   41.258306] md: export_rdev(sdc2)
>    [   41.283067] md: bind<sdc2>
>    [   41.283297] md: bind<sda2>
>    [   41.285235] md: bind<sdb2>
>    [   41.306753] md: md1 stopped.
>    [   41.306818] md: unbind<sdb2>
>    [   41.306878] md: export_rdev(sdb2)
>    [   41.306956] md: unbind<sda2>
>    [   41.307007] md: export_rdev(sda2)
>    [   41.307075] md: unbind<sdc2>
>    [   41.307130] md: export_rdev(sdc2)
>    [   41.312250] md: bind<sdf2>
>    [   41.312476] md: bind<sdb2>
>    [   41.312711] md: bind<sdg2>
>    [   41.312922] md: bind<sdc2>
>    [   41.313138] md: bind<sda2>
>    [   41.313343] md: bind<sde2>
>    [   41.313452] md: md1: raid array is not clean -- starting
>    background reconstruction
>    [   41.322189] raid5: device sde2 operational as raid disk 0
>    [   41.322243] raid5: device sdc2 operational as raid disk 4
>    [   41.322292] raid5: device sdg2 operational as raid disk 3
>    [   41.322342] raid5: device sdb2 operational as raid disk 2
>    [   41.322391] raid5: device sdf2 operational as raid disk 1
>    [   41.322823] raid5: allocated 5245kB for md1
>    [   41.322872] raid5: raid level 5 set md1 active with 5 out of 5
>    devices, algorithm 2
>    [   41.322934] RAID5 conf printout:
>    [   41.322980]  --- rd:5 wd:5
>    [   41.323026]  disk 0, o:1, dev:sde2
>    [   41.323073]  disk 1, o:1, dev:sdf2
>    [   41.323119]  disk 2, o:1, dev:sdb2
>    [   41.323165]  disk 3, o:1, dev:sdg2
>    [   41.323212]  disk 4, o:1, dev:sdc2
>
>    [   41.323316] md: resync of RAID array md1
>    [   41.323364] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>    [   41.323415] md: using maximum available idle IO bandwidth (but
>    not more than 200000 KB/sec) for resync.
>    [   41.323492] md: using 128k window, over a total of 231978496 
> blocks.
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
