From: "John Stoffel" <john@stoffel.org>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Thu, 27 Apr 2017 10:25:35 -0400
Message-ID: <22785.65375.947842.648174@quad.stoffel.home>
References: <590117CD.1000009@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <590117CD.1000009@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ron Leach <ronleach@tesco.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Ron> We run a 2TB fileserver in a raid1 configuration.  Today one of
Ron> the 2 disks (/dev/sdb) failed and we've just replaced it and set
Ron> up exactly the same partitions as the working, but degraded, raid
Ron> has on /dev/sda.

First off, why are you bothering to do this?  You should just mirror
the entire disk with MD, then build LVM volumes on top of that which
you can then allocate as you see fit, moving your data around,
growing, shrinking volumes as you need.

Ron> Using the commands

Ron> # mdadm --manage -a /dev/mdo /dev/sdb1
Ron> (and so on for md 1->7)

Ron> is resulting in a very-unusually slow recovery.  And mdadm is now
Ron> recovering the largest partition, 1.8TB, but expects to spend 5
Ron> days over it.  I think I must have done something wrong.  May I
Ron> ask a couple of questions?

Did you check that values in
/sys/devices/virtual/block/md0/md/sync_speed* settings?  I suspect you
want to up the sync_speed_max to a higher number on your system.

Ron> 1 Is there a safe command to stop the recovery/add process that
Ron> is ongoing?  I reread man mdadm but did not see a command I could
Ron> use for this.

Why would you want to do this?  

Ron> 2  After the failure of /dev/sdb, mdstat listed sdb x in each md 
Ron> device with an '(F)'.  We then also 'FAIL'ed each sdb partition in 
Ron> each md device, and then powered down the machine to replace sdb. 
Ron> After powering up and booting back into Debian, we created the 
Ron> partitions on (the new) sdb to mirror those on /dev/sda.  We then 
Ron> issued these commands one after the other:

Ron> # mdadm --manage -a /dev/mdo /dev/sdb1
Ron> # mdadm --manage -a /dev/md1 /dev/sdb2
Ron> # mdadm --manage -a /dev/md2 /dev/sdb3
Ron> # mdadm --manage -a /dev/md3 /dev/sdb5
Ron> # mdadm --manage -a /dev/md4 /dev/sdb6
Ron> # mdadm --manage -a /dev/md5 /dev/sdb7
Ron> # mdadm --manage -a /dev/md6 /dev/sdb8
Ron> # mdadm --manage -a /dev/md7 /dev/sdb9

Ugh!  You're setting yourself up for a true seek storm here, and way
too much pain down the road, IMHO.  Just mirror the entire disk and
put LVM volumes on top.  

Ron> Have I missed some vital step, and so causing the recover process to 
Ron> take a very long time?

Ron> mdstat and lsdrv outputs here (UUIDs abbreviated):

Ron> # cat /proc/mdstat
Ron> Personalities : [raid1]
Ron> md7 : active raid1 sdb9[3] sda9[2]
Ron>        1894416248 blocks super 1.2 [2/1] [U_]
Ron>        [>....................]  recovery =  0.0% (1493504/1894416248) 
Ron> finish=7248.4min speed=4352K/sec

Ron> md6 : active raid1 sdb8[3] sda8[2]
Ron>        39060408 blocks super 1.2 [2/1] [U_]
Ron>          resync=DELAYED

Ron> md5 : active raid1 sdb7[3] sda7[2]
Ron>        975860 blocks super 1.2 [2/1] [U_]
Ron>          resync=DELAYED

Ron> md4 : active raid1 sdb6[3] sda6[2]
Ron>        975860 blocks super 1.2 [2/1] [U_]
Ron>          resync=DELAYED

Ron> md3 : active raid1 sdb5[3] sda5[2]
Ron>        4880372 blocks super 1.2 [2/1] [U_]
Ron>          resync=DELAYED

Ron> md2 : active raid1 sdb3[3] sda3[2]
Ron>        9764792 blocks super 1.2 [2/1] [U_]
Ron>          resync=DELAYED

Ron> md1 : active raid1 sdb2[3] sda2[2]
Ron>        2928628 blocks super 1.2 [2/2] [UU]

Ron> md0 : active raid1 sdb1[3] sda1[2]
Ron>        498676 blocks super 1.2 [2/2] [UU]

Ron> unused devices: <none>

Ron> I meant to also ask - why are the /dev/sdb partitions shown with a 
Ron> '(3)'?  Previously I think they had a '(1)'.

Ron> # ./lsdrv
Ron> **Warning** The following utility(ies) failed to execute:
Ron>    sginfo
Ron>    pvs
Ron>    lvs
Ron> Some information may be missing.

Ron> Controller platform [None]
Ron> └platform floppy.0
Ron>   └fd0 4.00k [2:0] Empty/Unknown
Ron> PCI [sata_nv] 00:08.0 IDE interface: nVidia Corporation MCP61 SATA 
Ron> Controller (rev a2)
Ron> ├scsi 0:0:0:0 ATA      WDC WD20EZRX-00D {WD-WC....R1}
Ron> │└sda 1.82t [8:0] Partitioned (dos)
Ron> │ ├sda1 487.00m [8:1] MD raid1 (0/2) (w/ sdb1) in_sync 'Server6:0' 
Ron> {b307....e950}
Ron> │ │└md0 486.99m [9:0] MD v1.2 raid1 (2) clean {b307....e950}
Ron> │ │ │                 ext2 {4ed1....e8b1}
Ron> │ │ └Mounted as /dev/md0 @ /boot
Ron> │ ├sda2 2.79g [8:2] MD raid1 (0/2) (w/ sdb2) in_sync 'Server6:1' 
Ron> {77b1....50f2}
Ron> │ │└md1 2.79g [9:1] MD v1.2 raid1 (2) clean {77b1....50f2}
Ron> │ │ │               jfs {7d08....bae5}
Ron> │ │ └Mounted as /dev/disk/by-uuid/7d08....bae5 @ /
Ron> │ ├sda3 9.31g [8:3] MD raid1 (0/2) (w/ sdb3) in_sync 'Server6:2' 
Ron> {afd6....b694}
Ron> │ │└md2 9.31g [9:2] MD v1.2 raid1 (2) clean DEGRADED, recover 
Ron> (0.00k/18.62g) 0.00k/sec {afd6....b694}
Ron> │ │ │               jfs {81bb....92f8}
Ron> │ │ └Mounted as /dev/md2 @ /usr
Ron> │ ├sda4 1.00k [8:4] Partitioned (dos)
Ron> │ ├sda5 4.66g [8:5] MD raid1 (0/2) (w/ sdb5) in_sync 'Server6:3' 
Ron> {d00a....4e99}
Ron> │ │└md3 4.65g [9:3] MD v1.2 raid1 (2) active DEGRADED, recover 
Ron> (0.00k/9.31g) 0.00k/sec {d00a....4e99}
Ron> │ │ │               jfs {375b....4fd5}
Ron> │ │ └Mounted as /dev/md3 @ /var
Ron> │ ├sda6 953.00m [8:6] MD raid1 (0/2) (w/ sdb6) in_sync 'Server6:4' 
Ron> {25af....d910}
Ron> │ │└md4 952.99m [9:4] MD v1.2 raid1 (2) clean DEGRADED, recover 
Ron> (0.00k/1.86g) 0.00k/sec {25af....d910}
Ron> │ │                   swap {d92f....2ad7}
Ron> │ ├sda7 953.00m [8:7] MD raid1 (0/2) (w/ sdb7) in_sync 'Server6:5' 
Ron> {0034....971a}
Ron> │ │└md5 952.99m [9:5] MD v1.2 raid1 (2) active DEGRADED, recover 
Ron> (0.00k/1.86g) 0.00k/sec {0034....971a}
Ron> │ │ │                 jfs {4bf7....0fff}
Ron> │ │ └Mounted as /dev/md5 @ /tmp
Ron> │ ├sda8 37.25g [8:8] MD raid1 (0/2) (w/ sdb8) in_sync 'Server6:6' 
Ron> {a5d9....568d}
Ron> │ │└md6 37.25g [9:6] MD v1.2 raid1 (2) clean DEGRADED, recover 
Ron> (0.00k/74.50g) 0.00k/sec {a5d9....568d}
Ron> │ │ │                jfs {fdf0....6478}
Ron> │ │ └Mounted as /dev/md6 @ /home
Ron> │ └sda9 1.76t [8:9] MD raid1 (0/2) (w/ sdb9) in_sync 'Server6:7' 
Ron> {9bb1....bbb4}
Ron> │  └md7 1.76t [9:7] MD v1.2 raid1 (2) clean DEGRADED, recover 
Ron> (0.00k/3.53t) 3.01m/sec {9bb1....bbb4}
Ron> │   │               jfs {60bc....33fc}
Ron> │   └Mounted as /dev/md7 @ /srv
Ron> └scsi 1:0:0:0 ATA      ST2000DL003-9VT1 {5Y....HT}
Ron>   └sdb 1.82t [8:16] Partitioned (dos)
Ron>    ├sdb1 487.00m [8:17] MD raid1 (1/2) (w/ sda1) in_sync 'Server6:0' 
Ron> {b307....e950}
Ron>    │└md0 486.99m [9:0] MD v1.2 raid1 (2) clean {b307....e950}
Ron>    │                   ext2 {4ed1....e8b1}
Ron>    ├sdb2 2.79g [8:18] MD raid1 (1/2) (w/ sda2) in_sync 'Server6:1' 
Ron> {77b1....50f2}
Ron>    │└md1 2.79g [9:1] MD v1.2 raid1 (2) clean {77b1....50f2}
Ron>    │                 jfs {7d08....bae5}
Ron>    ├sdb3 9.31g [8:19] MD raid1 (1/2) (w/ sda3) spare 'Server6:2' 
Ron> {afd6....b694}
Ron>    │└md2 9.31g [9:2] MD v1.2 raid1 (2) clean DEGRADED, recover 
Ron> (0.00k/18.62g) 0.00k/sec {afd6....b694}
Ron>    │                 jfs {81bb....92f8}
Ron>    ├sdb4 1.00k [8:20] Partitioned (dos)
Ron>    ├sdb5 4.66g [8:21] MD raid1 (1/2) (w/ sda5) spare 'Server6:3' 
Ron> {d00a....4e99}
Ron>    │└md3 4.65g [9:3] MD v1.2 raid1 (2) active DEGRADED, recover 
Ron> (0.00k/9.31g) 0.00k/sec {d00a....4e99}
Ron>    │                 jfs {375b....4fd5}
Ron>    ├sdb6 953.00m [8:22] MD raid1 (1/2) (w/ sda6) spare 'Server6:4' 
Ron> {25af....d910}
Ron>    │└md4 952.99m [9:4] MD v1.2 raid1 (2) clean DEGRADED, recover 
Ron> (0.00k/1.86g) 0.00k/sec {25af....d910}
Ron>    │                   swap {d92f....2ad7}
Ron>    ├sdb7 953.00m [8:23] MD raid1 (1/2) (w/ sda7) spare 'Server6:5' 
Ron> {0034....971a}
Ron>    │└md5 952.99m [9:5] MD v1.2 raid1 (2) active DEGRADED, recover 
Ron> (0.00k/1.86g) 0.00k/sec {0034....971a}
Ron>    │                   jfs {4bf7....0fff}
Ron>    ├sdb8 37.25g [8:24] MD raid1 (1/2) (w/ sda8) spare 'Server6:6' 
Ron> {a5d9....568d}
Ron>    │└md6 37.25g [9:6] MD v1.2 raid1 (2) clean DEGRADED, recover 
Ron> (0.00k/74.50g) 0.00k/sec {a5d9....568d}
Ron>    │                  jfs {fdf0....6478}
Ron>    ├sdb9 1.76t [8:25] MD raid1 (1/2) (w/ sda9) spare 'Server6:7' 
Ron> {9bb1....bbb4}
Ron>    │└md7 1.76t [9:7] MD v1.2 raid1 (2) clean DEGRADED, recover 
Ron> (0.00k/3.53t) 3.01m/sec {9bb1....bbb4}
Ron>    │                 jfs {60bc....33fc}
Ron>    └sdb10 1.00m [8:26] Empty/Unknown
Ron> PCI [pata_amd] 00:06.0 IDE interface: nVidia Corporation MCP61 IDE 
Ron> (rev a2)
Ron> ├scsi 2:0:0:0 AOPEN    CD-RW CRW5224 
Ron> {AOPEN_CD-RW_CRW5224_1.07_20020606_}
Ron> │└sr0 1.00g [11:0] Empty/Unknown
Ron> └scsi 3:x:x:x [Empty]
Ron> Other Block Devices
Ron> ├loop0 0.00k [7:0] Empty/Unknown
Ron> ├loop1 0.00k [7:1] Empty/Unknown
Ron> ├loop2 0.00k [7:2] Empty/Unknown
Ron> ├loop3 0.00k [7:3] Empty/Unknown
Ron> ├loop4 0.00k [7:4] Empty/Unknown
Ron> ├loop5 0.00k [7:5] Empty/Unknown
Ron> ├loop6 0.00k [7:6] Empty/Unknown
Ron> └loop7 0.00k [7:7] Empty/Unknown

Ron> OS is still as originally installed some years ago - Debian 6/Squeeze. 
Ron>   The OS has been pretty solid, though we've had to renew disks 
Ron> previously but without this very slow recovery.

Ron> I'd be very grateful for any thoughts.

Ron> regards, Ron
Ron> --
Ron> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
Ron> the body of a message to majordomo@vger.kernel.org
Ron> More majordomo info at  http://vger.kernel.org/majordomo-info.html
