From: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Subject: raid5 on 2.4.21 and reconstruction problem
Date: Thu, 7 Aug 2003 12:50:18 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200308071250.18543.arekm@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have two raid 5 partitions - md0 (as for root fs) and md1 (for /home)=
=2E

The problem is that md0 doesn't resync failed disk to spare disk:
[root@perfo arekm]# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md1 : active raid5 scsi/host0/bus0/target3/lun0/part3[0] scsi/host0/bus=
0/target6/lun0/part3[2] scsi/host0/bus0/target5/lun0/part3[1]
      25302144 blocks level 5, 32k chunk, algorithm 2 [3/3] [UUU]

md0 : active raid5 scsi/host0/bus0/target3/lun0/part2[0] scsi/host0/bus=
0/target6/lun0/part2[3] scsi/host0/bus0/target5/lun0/part2[1]
      9960064 blocks level 5, 32k chunk, algorithm 2 [3/2] [UU_]

unused devices: <none>

[root@perfo arekm]# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Tue May  4 09:37:53 1999
     Raid Level : raid5
     Array Size : 9960064 (9.50 GiB 10.20 GB)
    Device Size : 4980032 (4.75 GiB 5.10 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Aug  7 12:48:34 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 0
 Failed Devices : 3=20
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 32K

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       0        0        2      faulty removed
       3       8       34        3      spare   /dev/sdc2
           UUID : c6839323:6d5bd707:731f0c8c:10e7b89b
         Events : 0.140

Three failed devices???

md1 is ok:
[root@perfo arekm]# mdadm -D /dev/md1
/dev/md1:
        Version : 00.90.00
  Creation Time : Tue May  4 09:37:53 1999
     Raid Level : raid5
     Array Size : 25302144 (24.13 GiB 25.91 GB)
    Device Size : 12651072 (12.07 GiB 12.95 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Thu Aug  7 10:49:35 2003
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 32K

    Number   Major   Minor   RaidDevice State
       0       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       2       8       35        2      active sync   /dev/sdc3
           UUID : 7ef0f26f:d1a324c3:b9397eb8:99c3b008
         Events : 0.115

I'm using mdadm 1.3.0.

kernel messages:
SCSI device sda: 35843670 512-byte hdwr sectors (18352 MB)
Partition check:
 /dev/scsi/host0/bus0/target3/lun0: p1 p2 p3 p4
SCSI device sdb: 35843670 512-byte hdwr sectors (18352 MB)
 /dev/scsi/host0/bus0/target5/lun0: p1 p2 p3 p4
SCSI device sdc: 35843670 512-byte hdwr sectors (18352 MB)
 /dev/scsi/host0/bus0/target6/lun0: p1 p2 p3 p4
 [events: 0000008b]
md: bind<scsi/host0/bus0/target5/lun0/part2,1>
 [events: 0000008b]
md: bind<scsi/host0/bus0/target6/lun0/part2,2>
 [events: 0000008b]
md: bind<scsi/host0/bus0/target3/lun0/part2,3>
md: scsi/host0/bus0/target3/lun0/part2's event counter: 0000008b
md: scsi/host0/bus0/target6/lun0/part2's event counter: 0000008b
md: scsi/host0/bus0/target5/lun0/part2's event counter: 0000008b
md: md0: raid array is not clean -- starting background reconstruction
md0: max total readahead window set to 496k
md0: 2 data-disks, max readahead per data-disk: 248k
raid5: device scsi/host0/bus0/target3/lun0/part2 operational as raid di=
sk 0
raid5: spare disk scsi/host0/bus0/target6/lun0/part2
raid5: device scsi/host0/bus0/target5/lun0/part2 operational as raid di=
sk 1
raid5: md0, not all disks are operational -- trying to recover array
raid5: allocated 3291kB for md0
raid5: raid level 5 set md0 active with 2 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:scsi/host0/bus0/target3/lun0/part2
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:scsi/host0/bus0/target5/lun0/part2
 disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev 00:00]
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:scsi/host0/bus0/target3/lun0/part2
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:scsi/host0/bus0/target5/lun0/part2
 disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev 00:00]
md: updating md0 RAID superblock on device
md: scsi/host0/bus0/target3/lun0/part2 [events: 0000008c]<6>(write) scs=
i/host0/bus0/target3/lun0/part2's sb of
fset: 4980032
md: recovery thread got woken up ...
md0: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
VFS: Mounted root (ext2 filesystem) readonly.
Trying to move old root to /initrd ... failed
Unmounting old root
Trying to free ramdisk memory ... failed
=46reeing unused kernel memory: 112k freed
Real Time Clock Driver v1.10e
Adding Swap: 265032k swap-space (priority -1)
Adding Swap: 265032k swap-space (priority -2)
Adding Swap: 265032k swap-space (priority -3)
 [events: 00000072]
md: bind<scsi/host0/bus0/target5/lun0/part3,1>
 [events: 00000072]
md: bind<scsi/host0/bus0/target6/lun0/part3,2>
 [events: 00000072]
md: bind<scsi/host0/bus0/target3/lun0/part3,3>
md: scsi/host0/bus0/target3/lun0/part3's event counter: 00000072
md: scsi/host0/bus0/target6/lun0/part3's event counter: 00000072
md: scsi/host0/bus0/target5/lun0/part3's event counter: 00000072
md: md1: raid array is not clean -- starting background reconstruction
md1: max total readahead window set to 496k
md1: 2 data-disks, max readahead per data-disk: 248k
raid5: device scsi/host0/bus0/target3/lun0/part3 operational as raid di=
sk 0
raid5: device scsi/host0/bus0/target6/lun0/part3 operational as raid di=
sk 2
raid5: device scsi/host0/bus0/target5/lun0/part3 operational as raid di=
sk 1
raid5: allocated 3291kB for md1
raid5: raid level 5 set md1 active with 3 out of 3 devices, algorithm 2
raid5: raid set md1 not clean; reconstructing parity
RAID5 conf printout:
 --- rd:3 wd:3 fd:0
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:scsi/host0/bus0/target3/lun0/part3
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:scsi/host0/bus0/target5/lun0/part3
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:scsi/host0/bus0/target6/lun0/part3
RAID5 conf printout:
 --- rd:3 wd:3 fd:0
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:scsi/host0/bus0/target3/lun0/part3
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:scsi/host0/bus0/target5/lun0/part3
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:scsi/host0/bus0/target6/lun0/part3
md: updating md1 RAID superblock on device
md: scsi/host0/bus0/target3/lun0/part3 [events: 00000073]<6>(write) scs=
i/host0/bus0/target3/lun0/part3's sb of
fset: 12651072
md: syncing RAID array md1
md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 100000 =
KB/sec) for reconstruction.
md: using 124k window, over a total of 12651072 blocks.
md: scsi/host0/bus0/target6/lun0/part3 [events: 00000073]<6>(write) scs=
i/host0/bus0/target6/lun0/part3's sb of
fset: 12651072
md: scsi/host0/bus0/target5/lun0/part3 [events: 00000073]<6>(write) scs=
i/host0/bus0/target5/lun0/part3's sb of
fset: 12651072
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
See Documentation/networking/vortex.txt
00:09.0: 3Com PCI 3c905C Tornado at 0xe400. Vers LK1.1.16
 00:04:76:18:6e:eb, IRQ 10
  product code 4d57 rev 00.13 date 01-14-01
  Internal config register is 1800000, transceivers 0xa.
  8K byte-wide RAM 5:3 Rx:Tx split, autoselect/Autonegotiate interface.
  MII transceiver found at address 24, status 782d.
  Enabling bus-master transmits and whole-frame receives.
00:09.0: scatter/gather enabled. h/w checksums enabled
divert: allocating divert_blk for eth0
eth0: Setting promiscuous mode.
device eth0 entered promiscuous mode
device eth0 left promiscuous mode
md: md1: sync done.
raid5: resync finished.

no md0 resync :-(

Both arrays was created under some 2.2 kernel. Resync doesn't happen on=
 2.5.25, too.

I've tried to remove spare disk and add it again via mdadm but that doe=
sn't help.
--=20
Arkadiusz Mi=B6kiewicz    CS at FoE, Wroclaw University of Technology
arekm@sse.pl   AM2-6BONE, 1024/3DB19BBD, arekm(at)ircnet, PLD/Linux

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
