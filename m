From: Mitchell Laks <mlaks@verizon.net>
Subject: raid5 initialization errors during boot not after boot. raid5 driver loaded both times.
Date: Mon, 10 Jan 2005 16:11:27 -0500
Message-ID: <200501101611.27350.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I am running debian sarge linux kernel 2.6.8.  I boot from a sata 
drive /dev/sda, and set up a raid5 on /dev/hda, /dev/hdc, /dev/hde, /dev/hdg.

I turned off udev, and created /dev/md0 and I loaded raid5 module into 
initrd.img.
  
I set up a raid5 to start up at boot by configuring raidtools2 debian package 
which runs "raid2" script during /etc/rcS.d.

Weird is, raid5 does not start on /dev/md0 during bootup 
( i enclose the dmesg error log which says that there are errors trying) 
but after bootup when I do 
raidstart /dev/md0 
after boot, it starts like a charm...
Any ideas what causes the errors in the log????  

Here is the output of dmesg during boot.

RAMDISK: Loading 4360 blocks [1 disk] into ram disk... done.
VFS: Mounted root (cramfs filesystem) readonly.
Freeing unused kernel memory: 204k freed
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :  5512.000 MB/sec
raid5: using function: pIII_sse (5512.000 MB/sec)
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: raid5 personality registered as nr 4
md: raid1 personality registered as nr 3
vesafb: probe of vesafb0 failed with error -6
NET: Registered protocol family 1
SCSI subsystem initialized
libata version 1.02 loaded.
sata_via version 0.20
ACPI: PCI interrupt 0000:00:0f.0[B] -> GSI 10 (level, low) -> IRQ 10
sata_via(0000:00:0f.0): routed to hard irq line 10
ata1: SATA max UDMA/133 cmd 0xE800 ctl 0xE402 bmdma 0xD400 irq 10
ata2: SATA max UDMA/133 cmd 0xE000 ctl 0xD802 bmdma 0xD408 irq 10
ata1: dev 0 cfg 49:2f00 82:346b 83:5b01 84:4003 85:3469 86:1801 87:4003 
88:407f
ata1: dev 0 ATA, max UDMA/133, 78165360 sectors:
ata1: dev 0 configured for UDMA/133
scsi0 : sata_via
ata2: no device found (phy stat 00000000)
...
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
hda: WDC WD2500JB-00GVA0, ATA DISK drive
hdc: WDC WD2500JB-00GVA0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
Capability LSM initialized
md: raidstart(pid 526) used deprecated START_ARRAY ioctl. This will not be 
supported beyond 2.6
hda: max request size: 1024KiB
hda: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63
 /dev/ide/host0/bus0/target0/lun0: p1
hdc: max request size: 1024KiB
hdc: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63
 /dev/ide/host1/bus0/target0/lun0: p1
md: could not lock unknown-block(33,1).
md: could not import unknown-block(33,1), trying to run array nevertheless.
md: could not lock unknown-block(34,1).
md: could not import unknown-block(34,1), trying to run array nevertheless.
md: autorun ...
md: considering hdc1 ...
md:  adding hdc1 ...
md:  adding hda1 ...
md: created md0
md: bind<hda1>
md: bind<hdc1>
md: running: <hdc1><hda1>
raid5: device hdc1 operational as raid disk 1
raid5: device hda1 operational as raid disk 0
raid5: not enough operational devices for md0 (2/4 failed)
RAID5 conf printout:
 --- rd:4 wd:2 fd:2
 disk 0, o:1, dev:hda1
 disk 1, o:1, dev:hdc1
raid5: failed to run raid set md0
md: pers->run() failed ...
md :do_md_run() returned -22
md: md0 stopped.
md: unbind<hdc1>
md: export_rdev(hdc1)

here is the /etc/raidtab

mlaks@A1:~$ cat /etc/raidtab
raiddev /dev/md0
        raid-level      5
        nr-raid-disks   4
        nr-spare-disks  0
        persistent-superblock   1
        parity-algorithm        left-symmetric
        chunk-size      32
        device  /dev/hda1
        raid-disk       0
        device  /dev/hdc1
        raid-disk       1
        device  /dev/hde1
        raid-disk       2
        device  /dev/hdg1
        raid-disk       3

Notice the errors during attempt to start /dev/md0
moreover,
once i run
raidstart /dev/md0 i get the following in dmesg:

md: raidstart(pid 3161) used deprecated START_ARRAY ioctl. This will not be 
supported beyond 2.6
md: autorun ...
md: considering hdg1 ...
md:  adding hdg1 ...
md:  adding hde1 ...
md:  adding hdc1 ...
md:  adding hda1 ...
md: created md0
md: bind<hda1>
md: bind<hdc1>
md: bind<hde1>
md: bind<hdg1>
md: running: <hdg1><hde1><hdc1><hda1>
raid5: device hdg1 operational as raid disk 3
raid5: device hde1 operational as raid disk 2
raid5: device hdc1 operational as raid disk 1
raid5: device hda1 operational as raid disk 0
raid5: allocated 4201kB for md0
raid5: raid level 5 set md0 active with 4 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:4 fd:0
 disk 0, o:1, dev:hda1
 disk 1, o:1, dev:hdc1
 disk 2, o:1, dev:hde1
 disk 3, o:1, dev:hdg1
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.

Now it mounts normally.

Any idea what is wrong here???

Thanks
Mitchell Laks

