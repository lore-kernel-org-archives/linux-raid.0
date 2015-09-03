From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Raid 10 array problems
Date: Thu, 3 Sep 2015 17:33:35 -0500
Message-ID: <CAPpdf592+kr9HPpqNaqRhTujZGcFUEcXLOKQzm=qcM10Vh-cEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings

Had updated a system to Debian 8 which also had a Raid 10 array that
has been in use for about 3 1/2 years. (Setup raid under Debian 6 then
ran it mostly under Debian 7 mounting the array each time after
booting using the command

#mount /dev/dm-o /home/myspace/RAID

and didn't have any major problems with it (besides a failed drive
which was replaced and things went OK).)

Really enjoyed Debian 8's feature where after a boot (done seldom as I
was running the machine 24/7) where in the file manager clicking on
the icon for the 1.8TB drive a dialog box would popup requesting the
root password and upon correct completion the array was accessible.

Found with Debian 8 that I had the option of using a sleep state (shut
down to ram) and liked the idea of reducing power consumption (my box
with 3 gpus and 6 hdds does like to pull power) for over night.

On Aug 28th evening I noticed that I didn't have my raid array accessible.

Went to bed (have learned not to change things when I am very tired as
I can bork things up too fast.

Next morning tried a reboot to see if things would clear themselves -
-  they didn't.

After some running in circles I found this in a log:

Aug 30 19:51:40 debiantestingbase kernel: [100718.675021] FAT-fs
(md0): utf8 is not a recommended IO charset for FAT filesystems,
filesystem will be case sensitive!
Aug 30 21:35:33 debiantestingbase kernel: [106954.860493] EXT4-fs
(md0): VFS: Can't find ext4 filesystem
Aug 30 21:37:05 debiantestingbase kernel: [107046.607187] EXT4-fs
(md0): VFS: Can't find ext4 filesystem
Aug 30 22:20:33 debiantestingbase kernel: [109656.411356] PM: Syncing
filesystems ... done.



Aug 28 10:39:56 debiantestingbase udisksd[1777]: Cleaning up mount
point /media/darald/49552036-b46f-4956-ade9-3541a3dd7f0a (device 253:0
no longer exist)

from syslog.3
That UUID was the 'name' of the array previously


Aug 28 10:39:28 debiantestingbase kernel: [    3.025162] scsi 3:0:0:0:
Direct-Access     ATA      ST31000524AS     JC4B PQ: 0 ANSI: 5
Aug 28 10:39:28 debiantestingbase kernel: [    3.025768] sd 3:0:0:0:
[sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Aug 28 10:39:28 debiantestingbase kernel: [    3.026296] sd 3:0:0:0:
[sdb] Write Protect is off
Aug 28 10:39:28 debiantestingbase kernel: [    3.026304] sd 3:0:0:0:
[sdb] Mode Sense: 00 3a 00 00
Aug 28 10:39:28 debiantestingbase kernel: [    3.026484] sd 3:0:0:0:
[sdb] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
Aug 28 10:39:28 debiantestingbase kernel: [    3.028273]  sdb: sdb1
Aug 28 10:39:28 debiantestingbase kernel: [    3.028698] sd 3:0:0:0:
[sdb] Attached SCSI disk
Aug 28 10:39:28 debiantestingbase kernel: [    3.086532] Switched to
clocksource tsc
Aug 28 10:39:28 debiantestingbase kernel: [    3.168919] md: bind<sdb1>
Aug 28 10:39:28 debiantestingbase kernel: [    3.342285] ata5: SATA
link up 3.0 Gbps (SStatus 123 SControl 300)
Aug 28 10:39:28 debiantestingbase kernel: [    3.343153] ata5.00:
ATA-9: ST1000DM003-1ER162, CC45, max UDMA/133
Aug 28 10:39:28 debiantestingbase kernel: [    3.343158] ata5.00:
1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Aug 28 10:39:28 debiantestingbase kernel: [    3.344067] ata5.00:
configured for UDMA/133
Aug 28 10:39:28 debiantestingbase kernel: [    3.344255] scsi 4:0:0:0:
Direct-Access     ATA      ST1000DM003-1ER1 CC45 PQ: 0 ANSI: 5
Aug 28 10:39:28 debiantestingbase kernel: [    3.344627] sd 4:0:0:0:
[sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Aug 28 10:39:28 debiantestingbase kernel: [    3.344631] sd 4:0:0:0:
[sdc] 4096-byte physical blocks
Aug 28 10:39:28 debiantestingbase kernel: [    3.344823] sd 4:0:0:0:
[sdc] Write Protect is off
Aug 28 10:39:28 debiantestingbase kernel: [    3.344831] sd 4:0:0:0:
[sdc] Mode Sense: 00 3a 00 00
Aug 28 10:39:28 debiantestingbase kernel: [    3.344946] sd 4:0:0:0:
[sdc] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
Aug 28 10:39:28 debiantestingbase kernel: [    3.411364]  sdc: sdc1
Aug 28 10:39:28 debiantestingbase kernel: [    3.412317] sd 4:0:0:0:
[sdc] Attached SCSI disk
Aug 28 10:39:28 debiantestingbase kernel: [    3.501080] md: bind<sdc1>
Aug 28 10:39:28 debiantestingbase kernel: [    3.662509] ata6: SATA
link up 3.0 Gbps (SStatus 123 SControl 300)
Aug 28 10:39:28 debiantestingbase kernel: [    3.674767] ata6.00:
ATA-8: Corsair Force 3 SSD, 1.3.3, max UDMA/133
Aug 28 10:39:28 debiantestingbase kernel: [    3.674772] ata6.00:
468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Aug 28 10:39:28 debiantestingbase kernel: [    3.684647] ata6.00:
configured for UDMA/133
Aug 28 10:39:28 debiantestingbase kernel: [    3.684933] scsi 5:0:0:0:
Direct-Access     ATA      Corsair Force 3  3    PQ: 0 ANSI: 5
Aug 28 10:39:28 debiantestingbase kernel: [    3.685504] sd 5:0:0:0:
[sdd] 468862128 512-byte logical blocks: (240 GB/223 GiB)
Aug 28 10:39:28 debiantestingbase kernel: [    3.685975] sd 5:0:0:0:
[sdd] Write Protect is off
Aug 28 10:39:28 debiantestingbase kernel: [    3.685983] sd 5:0:0:0:
[sdd] Mode Sense: 00 3a 00 00
Aug 28 10:39:28 debiantestingbase kernel: [    3.686186] sd 5:0:0:0:
[sdd] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
Aug 28 10:39:28 debiantestingbase kernel: [    3.688051]  sdd: sdd1
sdd4 < sdd5 sdd6 sdd7 sdd8 sdd9 sdd10 >
Aug 28 10:39:28 debiantestingbase kernel: [    3.689305] sd 5:0:0:0:
[sdd] Attached SCSI disk
Aug 28 10:39:28 debiantestingbase kernel: [    4.002712] ata8: SATA
link down (SStatus 0 SControl 300)
Aug 28 10:39:28 debiantestingbase kernel: [    4.003107] scsi 8:0:0:0:
Direct-Access     ATA      ST31000524AS     JC4B PQ: 0 ANSI: 5
Aug 28 10:39:28 debiantestingbase kernel: [    4.003597] sd 8:0:0:0:
[sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Aug 28 10:39:28 debiantestingbase kernel: [    4.003843] scsi 9:0:0:0:
Direct-Access     ATA      ST31000524AS     JC4B PQ: 0 ANSI: 5
Aug 28 10:39:28 debiantestingbase kernel: [    4.003975] sd 8:0:0:0:
[sde] Write Protect is off
Aug 28 10:39:28 debiantestingbase kernel: [    4.003980] sd 8:0:0:0:
[sde] Mode Sense: 00 3a 00 00
Aug 28 10:39:28 debiantestingbase kernel: [    4.004090] sd 8:0:0:0:
[sde] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
Aug 28 10:39:28 debiantestingbase kernel: [    4.004478] sd 9:0:0:0:
[sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Aug 28 10:39:28 debiantestingbase kernel: [    4.004645] sd 9:0:0:0:
[sdf] Write Protect is off
Aug 28 10:39:28 debiantestingbase kernel: [    4.004650] sd 9:0:0:0:
[sdf] Mode Sense: 00 3a 00 00
Aug 28 10:39:28 debiantestingbase kernel: [    4.004737] sd 9:0:0:0:
[sdf] Write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
Aug 28 10:39:28 debiantestingbase kernel: [    4.004778] scsi
15:0:0:0: Processor         Marvell  91xx Config      1.01 PQ: 0 ANSI:
5
Aug 28 10:39:28 debiantestingbase kernel: [    4.006375]  sdf: sdf1
Aug 28 10:39:28 debiantestingbase kernel: [    4.006967] sd 9:0:0:0:
[sdf] Attached SCSI disk
Aug 28 10:39:28 debiantestingbase kernel: [    4.008855]  sde: sde1
Aug 28 10:39:28 debiantestingbase kernel: [    4.009704] sd 8:0:0:0:
[sde] Attached SCSI disk
Aug 28 10:39:28 debiantestingbase kernel: [    4.018710] ata16.00:
exception Emask 0x1 SAct 0x0 SErr 0x0 action 0x0
Aug 28 10:39:28 debiantestingbase kernel: [    4.018753] ata16.00:
irq_stat 0x40000001
Aug 28 10:39:28 debiantestingbase kernel: [    4.018783] ata16.00: cmd
a0/01:00:00:00:01/00:00:00:00:00/a0 tag 1 dma 16640 in
Aug 28 10:39:28 debiantestingbase kernel: [    4.018783]
Inquiry 12 01 00 00 ff 00res 50/00:00:af:6d:70/00:00:74:00:00/e0 Emask
0x1 (device error)
Aug 28 10:39:28 debiantestingbase kernel: [    4.018868] ata16.00:
status: { DRDY }
Aug 28 10:39:28 debiantestingbase kernel: [    4.125325] random:
nonblocking pool is initialized
Aug 28 10:39:28 debiantestingbase kernel: [    4.125530] md: bind<sde1>
Aug 28 10:39:28 debiantestingbase kernel: [    4.142140] md: bind<sdf1>
Aug 28 10:39:28 debiantestingbase kernel: [    4.144984] md: raid10
personality registered for level 10
Aug 28 10:39:28 debiantestingbase kernel: [    4.145397]
md/raid10:md0: active with 4 out of 4 devices
Aug 28 10:39:28 debiantestingbase kernel: [    4.145440] md0: detected
capacity change from 0 to 2000403038208
Aug 28 10:39:28 debiantestingbase kernel: [    4.208978]  md0:
Aug 28 10:39:28 debiantestingbase kernel: [    4.479305]
device-mapper: uevent: version 1.0.3
Aug 28 10:39:28 debiantestingbase kernel: [    4.479536]
device-mapper: ioctl: 4.30.0-ioctl (2014-12-22) initialised:
dm-devel@redhat.com



some further information

>> Disk /dev/md0: 1.8 TiB, 2000403038208 bytes, 3907037184 sectors
>> Units: sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 4096 bytes
>> I/O size (minimum/optimal): 524288 bytes / 1048576 bytes
>> Disklabel type: gpt
>> Disk identifier: 1EB47793-0CDF-4E16-AE84-33EC825AC448
>
>
>
>     parted -l


Model: ATA ST31000524AS (scsi)
Disk /dev/sdf: 1000GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  1000GB  1000GB  primary               raid


Model: Linux Software RAID Array (md)
Disk /dev/md0: 2000GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt
Disk Flags:

Number  Start  End  Size  File system  Name  Flags


# parted -l
Model: ATA ST1000DM003-1ER1 (scsi)
Disk /dev/sda: 1000GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system     Name   Flags
 1      1049kB  269MB   268MB   fat32                  boot, esp
 2      269MB   538MB   268MB                   /boot  msftdata
 3      538MB   26.8GB  26.2GB  ext4            /      msftdata
 4      26.8GB  93.9GB  67.1GB  linux-swap(v1)  swap
 5      93.9GB  494GB   400GB   ext4


Model: ATA ST31000524AS (scsi)
Disk /dev/sdb: 1000GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  1000GB  1000GB  primary               raid


Model: ATA ST1000DM003-1ER1 (scsi)
Disk /dev/sdc: 1000GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name              Flags
 1      1049kB  1000GB  1000GB               Linux filesystem


Model: ATA Corsair Force 3 (scsi)
Disk /dev/sdd: 240GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type      File system     Flags
 1      1049kB  256MB   255MB   primary   ext2            boot
 4      257MB   123GB   123GB   extended
 5      258MB   21.2GB  21.0GB  logical   ext4
 6      21.2GB  42.2GB  21.0GB  logical   ext4
 7      42.2GB  73.7GB  31.5GB  logical   ext4
 8      73.7GB  77.9GB  4194MB  logical   ext4
 9      77.9GB  98.8GB  21.0GB  logical   ext4
10      98.8GB  123GB   24.5GB  logical   linux-swap(v1)


Model: ATA ST31000524AS (scsi)
Disk /dev/sde: 1000GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  1000GB  1000GB  primary               raid


Model: ATA ST31000524AS (scsi)
Disk /dev/sdf: 1000GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start  End  Size  File system  Name  Flags


The array was formed from sdb1, sdc1, sde1 and sdf1.

The array had been setup as an ext4 device.

I halted the array using:

mdadm --stop /dev/md0

I then setup a copy from the original drives (sdc1 and sdf1) to a
drive pulled from a project that I have just started on.


 dd if=/dev/sdc1 bs=1M | gzip > /mnt/newbackupdisk/sdc1.img.gz
  dd if=/dev/sdf1 bs=1M | gzip > /mnt/newbackupdisk/sdf1.img.gz


When I checked using md5sum the copy of sdf1 and the original do NOT match.


Please?

How can I get a copy of the information off of the raid 10 array?
Is there a way to verify this copy?
How to I re-setup the raid 10 array?
Should I be replacing sde (drive with a momentary failure)?

(Hopefully not too many questions nor too much initial information!!)

Any advice will be greatly appreciated!!

TIA

Dee
