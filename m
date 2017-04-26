From: Ron Leach <ronleach@tesco.net>
Subject: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Wed, 26 Apr 2017 22:57:33 +0100
Message-ID: <590117CD.1000009@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

List, good evening,

We run a 2TB fileserver in a raid1 configuration.  Today one of the 2 
disks (/dev/sdb) failed and we've just replaced it and set up exactly 
the same partitions as the working, but degraded, raid has on /dev/sda.

Using the commands

# mdadm --manage -a /dev/mdo /dev/sdb1
(and so on for md 1->7)

is resulting in a very-unusually slow recovery.  And mdadm is now 
recovering the largest partition, 1.8TB, but expects to spend 5 days 
over it.  I think I must have done something wrong.  May I ask a 
couple of questions?

1  Is there a safe command to stop the recovery/add process that is 
ongoing?  I reread man mdadm but did not see a command I could use for 
this.

2  After the failure of /dev/sdb, mdstat listed sdb x in each md 
device with an '(F)'.  We then also 'FAIL'ed each sdb partition in 
each md device, and then powered down the machine to replace sdb. 
After powering up and booting back into Debian, we created the 
partitions on (the new) sdb to mirror those on /dev/sda.  We then 
issued these commands one after the other:

# mdadm --manage -a /dev/mdo /dev/sdb1
# mdadm --manage -a /dev/md1 /dev/sdb2
# mdadm --manage -a /dev/md2 /dev/sdb3
# mdadm --manage -a /dev/md3 /dev/sdb5
# mdadm --manage -a /dev/md4 /dev/sdb6
# mdadm --manage -a /dev/md5 /dev/sdb7
# mdadm --manage -a /dev/md6 /dev/sdb8
# mdadm --manage -a /dev/md7 /dev/sdb9

Have I missed some vital step, and so causing the recover process to 
take a very long time?

mdstat and lsdrv outputs here (UUIDs abbreviated):

# cat /proc/mdstat
Personalities : [raid1]
md7 : active raid1 sdb9[3] sda9[2]
       1894416248 blocks super 1.2 [2/1] [U_]
       [>....................]  recovery =  0.0% (1493504/1894416248) 
finish=7248.4min speed=4352K/sec

md6 : active raid1 sdb8[3] sda8[2]
       39060408 blocks super 1.2 [2/1] [U_]
         resync=DELAYED

md5 : active raid1 sdb7[3] sda7[2]
       975860 blocks super 1.2 [2/1] [U_]
         resync=DELAYED

md4 : active raid1 sdb6[3] sda6[2]
       975860 blocks super 1.2 [2/1] [U_]
         resync=DELAYED

md3 : active raid1 sdb5[3] sda5[2]
       4880372 blocks super 1.2 [2/1] [U_]
         resync=DELAYED

md2 : active raid1 sdb3[3] sda3[2]
       9764792 blocks super 1.2 [2/1] [U_]
         resync=DELAYED

md1 : active raid1 sdb2[3] sda2[2]
       2928628 blocks super 1.2 [2/2] [UU]

md0 : active raid1 sdb1[3] sda1[2]
       498676 blocks super 1.2 [2/2] [UU]

unused devices: <none>

I meant to also ask - why are the /dev/sdb partitions shown with a 
'(3)'?  Previously I think they had a '(1)'.

# ./lsdrv
**Warning** The following utility(ies) failed to execute:
   sginfo
   pvs
   lvs
Some information may be missing.

Controller platform [None]
└platform floppy.0
  └fd0 4.00k [2:0] Empty/Unknown
PCI [sata_nv] 00:08.0 IDE interface: nVidia Corporation MCP61 SATA 
Controller (rev a2)
├scsi 0:0:0:0 ATA      WDC WD20EZRX-00D {WD-WC....R1}
│└sda 1.82t [8:0] Partitioned (dos)
│ ├sda1 487.00m [8:1] MD raid1 (0/2) (w/ sdb1) in_sync 'Server6:0' 
{b307....e950}
│ │└md0 486.99m [9:0] MD v1.2 raid1 (2) clean {b307....e950}
│ │ │                 ext2 {4ed1....e8b1}
│ │ └Mounted as /dev/md0 @ /boot
│ ├sda2 2.79g [8:2] MD raid1 (0/2) (w/ sdb2) in_sync 'Server6:1' 
{77b1....50f2}
│ │└md1 2.79g [9:1] MD v1.2 raid1 (2) clean {77b1....50f2}
│ │ │               jfs {7d08....bae5}
│ │ └Mounted as /dev/disk/by-uuid/7d08....bae5 @ /
│ ├sda3 9.31g [8:3] MD raid1 (0/2) (w/ sdb3) in_sync 'Server6:2' 
{afd6....b694}
│ │└md2 9.31g [9:2] MD v1.2 raid1 (2) clean DEGRADED, recover 
(0.00k/18.62g) 0.00k/sec {afd6....b694}
│ │ │               jfs {81bb....92f8}
│ │ └Mounted as /dev/md2 @ /usr
│ ├sda4 1.00k [8:4] Partitioned (dos)
│ ├sda5 4.66g [8:5] MD raid1 (0/2) (w/ sdb5) in_sync 'Server6:3' 
{d00a....4e99}
│ │└md3 4.65g [9:3] MD v1.2 raid1 (2) active DEGRADED, recover 
(0.00k/9.31g) 0.00k/sec {d00a....4e99}
│ │ │               jfs {375b....4fd5}
│ │ └Mounted as /dev/md3 @ /var
│ ├sda6 953.00m [8:6] MD raid1 (0/2) (w/ sdb6) in_sync 'Server6:4' 
{25af....d910}
│ │└md4 952.99m [9:4] MD v1.2 raid1 (2) clean DEGRADED, recover 
(0.00k/1.86g) 0.00k/sec {25af....d910}
│ │                   swap {d92f....2ad7}
│ ├sda7 953.00m [8:7] MD raid1 (0/2) (w/ sdb7) in_sync 'Server6:5' 
{0034....971a}
│ │└md5 952.99m [9:5] MD v1.2 raid1 (2) active DEGRADED, recover 
(0.00k/1.86g) 0.00k/sec {0034....971a}
│ │ │                 jfs {4bf7....0fff}
│ │ └Mounted as /dev/md5 @ /tmp
│ ├sda8 37.25g [8:8] MD raid1 (0/2) (w/ sdb8) in_sync 'Server6:6' 
{a5d9....568d}
│ │└md6 37.25g [9:6] MD v1.2 raid1 (2) clean DEGRADED, recover 
(0.00k/74.50g) 0.00k/sec {a5d9....568d}
│ │ │                jfs {fdf0....6478}
│ │ └Mounted as /dev/md6 @ /home
│ └sda9 1.76t [8:9] MD raid1 (0/2) (w/ sdb9) in_sync 'Server6:7' 
{9bb1....bbb4}
│  └md7 1.76t [9:7] MD v1.2 raid1 (2) clean DEGRADED, recover 
(0.00k/3.53t) 3.01m/sec {9bb1....bbb4}
│   │               jfs {60bc....33fc}
│   └Mounted as /dev/md7 @ /srv
└scsi 1:0:0:0 ATA      ST2000DL003-9VT1 {5Y....HT}
  └sdb 1.82t [8:16] Partitioned (dos)
   ├sdb1 487.00m [8:17] MD raid1 (1/2) (w/ sda1) in_sync 'Server6:0' 
{b307....e950}
   │└md0 486.99m [9:0] MD v1.2 raid1 (2) clean {b307....e950}
   │                   ext2 {4ed1....e8b1}
   ├sdb2 2.79g [8:18] MD raid1 (1/2) (w/ sda2) in_sync 'Server6:1' 
{77b1....50f2}
   │└md1 2.79g [9:1] MD v1.2 raid1 (2) clean {77b1....50f2}
   │                 jfs {7d08....bae5}
   ├sdb3 9.31g [8:19] MD raid1 (1/2) (w/ sda3) spare 'Server6:2' 
{afd6....b694}
   │└md2 9.31g [9:2] MD v1.2 raid1 (2) clean DEGRADED, recover 
(0.00k/18.62g) 0.00k/sec {afd6....b694}
   │                 jfs {81bb....92f8}
   ├sdb4 1.00k [8:20] Partitioned (dos)
   ├sdb5 4.66g [8:21] MD raid1 (1/2) (w/ sda5) spare 'Server6:3' 
{d00a....4e99}
   │└md3 4.65g [9:3] MD v1.2 raid1 (2) active DEGRADED, recover 
(0.00k/9.31g) 0.00k/sec {d00a....4e99}
   │                 jfs {375b....4fd5}
   ├sdb6 953.00m [8:22] MD raid1 (1/2) (w/ sda6) spare 'Server6:4' 
{25af....d910}
   │└md4 952.99m [9:4] MD v1.2 raid1 (2) clean DEGRADED, recover 
(0.00k/1.86g) 0.00k/sec {25af....d910}
   │                   swap {d92f....2ad7}
   ├sdb7 953.00m [8:23] MD raid1 (1/2) (w/ sda7) spare 'Server6:5' 
{0034....971a}
   │└md5 952.99m [9:5] MD v1.2 raid1 (2) active DEGRADED, recover 
(0.00k/1.86g) 0.00k/sec {0034....971a}
   │                   jfs {4bf7....0fff}
   ├sdb8 37.25g [8:24] MD raid1 (1/2) (w/ sda8) spare 'Server6:6' 
{a5d9....568d}
   │└md6 37.25g [9:6] MD v1.2 raid1 (2) clean DEGRADED, recover 
(0.00k/74.50g) 0.00k/sec {a5d9....568d}
   │                  jfs {fdf0....6478}
   ├sdb9 1.76t [8:25] MD raid1 (1/2) (w/ sda9) spare 'Server6:7' 
{9bb1....bbb4}
   │└md7 1.76t [9:7] MD v1.2 raid1 (2) clean DEGRADED, recover 
(0.00k/3.53t) 3.01m/sec {9bb1....bbb4}
   │                 jfs {60bc....33fc}
   └sdb10 1.00m [8:26] Empty/Unknown
PCI [pata_amd] 00:06.0 IDE interface: nVidia Corporation MCP61 IDE 
(rev a2)
├scsi 2:0:0:0 AOPEN    CD-RW CRW5224 
{AOPEN_CD-RW_CRW5224_1.07_20020606_}
│└sr0 1.00g [11:0] Empty/Unknown
└scsi 3:x:x:x [Empty]
Other Block Devices
├loop0 0.00k [7:0] Empty/Unknown
├loop1 0.00k [7:1] Empty/Unknown
├loop2 0.00k [7:2] Empty/Unknown
├loop3 0.00k [7:3] Empty/Unknown
├loop4 0.00k [7:4] Empty/Unknown
├loop5 0.00k [7:5] Empty/Unknown
├loop6 0.00k [7:6] Empty/Unknown
└loop7 0.00k [7:7] Empty/Unknown

OS is still as originally installed some years ago - Debian 6/Squeeze. 
  The OS has been pretty solid, though we've had to renew disks 
previously but without this very slow recovery.

I'd be very grateful for any thoughts.

regards, Ron
