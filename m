From: Daniel Iliev <daniel.iliev@gmail.com>
Subject: Re: raid10 problem with spare disk
Date: Sun, 9 Aug 2009 10:55:34 +0300
Message-ID: <20090809105534.8cb0e649.daniel.iliev@gmail.com>
References: <1249755852.5095.86.camel@ilievnet.com>
	<20b671d0bba986ff7c119757440a8c26.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 9 Aug 2009 07:17:50 +1000 (EST)
"NeilBrown" <neilb@suse.de> wrote:

> On Sun, August 9, 2009 4:24 am, Daniel Iliev wrote:
[--snip--]
> >
> >
> > What happened is that I removed sdc3, mounted md2, saw the data,
> > unmounted md2 and tried to "mdadm /dev/md2 --re-add /dev/sdc3", so I'd
> > go trough the backup & restore routine later.
> 
> Possibly md thought there had been some change in the array and it
> was too late to re-add an old device.  If you have a bitmap that
> might make it work better.
> 

I guess so. Perhaps mount/unmount wrote something to the fs metadata and sdc
became inconsistant with the rest of the raid. The bitmap is internal.

> 
> >
> > Unfortunately for some reason mdadm added sdc3 as spare. I stopped md2
> > and tried to assemble it again, but this time mdadm said there wera no
> > eneough drives to start the array and sdc3 was still marked as spare.
> 
> Can you try assembling the array adding "--verbose" and post the full
> output as well as the exact version of kernel and mdadm?
> 
> NeilBrown

uname:
2.6.30-gentoo-r4-core2 #1 SMP PREEMPT Fri Jul 24 08:21:44 EEST 2009 x86_64 
mdadm -V
mdadm - v2.6.9 - 10th March 2009

mdadm.conf:
DEVICE /dev/sd[a-z][0-9]
ARRAY /dev/md0 level=raid1 num-devices=4 metadata=0.90 UUID=1b2398aa:d1563102:55dba985:94719c42
ARRAY /dev/md1 level=raid10 num-devices=4 metadata=0.90 UUID=b2be0688:d5b5f059:6507a68f:ecec3716
ARRAY /dev/md2 level=raid10 num-devices=4 metadata=0.90 UUID=28a0a8db:4120c890:175293b6:df3cd3b3

~ # mdadm -A /dev/md2 --verbose
mdadm: looking for devices for /dev/md2
mdadm: no RAID superblock on /dev/sde9
mdadm: /dev/sde9 has wrong uuid.
mdadm: no RAID superblock on /dev/sde8
mdadm: /dev/sde8 has wrong uuid.
mdadm: no RAID superblock on /dev/sde7
mdadm: /dev/sde7 has wrong uuid.
mdadm: no RAID superblock on /dev/sde6
mdadm: /dev/sde6 has wrong uuid.
mdadm: no RAID superblock on /dev/sde5
mdadm: /dev/sde5 has wrong uuid.
mdadm: no RAID superblock on /dev/sde1
mdadm: /dev/sde1 has wrong uuid.
mdadm: cannot open device /dev/sdd2: Device or resource busy
mdadm: /dev/sdd2 has wrong uuid.
mdadm: cannot open device /dev/sdd1: Device or resource busy
mdadm: /dev/sdd1 has wrong uuid.
mdadm: cannot open device /dev/sdc2: Device or resource busy
mdadm: /dev/sdc2 has wrong uuid.
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: /dev/sdc1 has wrong uuid.
mdadm: cannot open device /dev/sdb2: Device or resource busy
mdadm: /dev/sdb2 has wrong uuid.
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: /dev/sdb1 has wrong uuid.
mdadm: /dev/sdd3 is identified as a member of /dev/md2, slot 1.
mdadm: /dev/sdc3 is identified as a member of /dev/md2, slot 4.
mdadm: /dev/sdb3 is identified as a member of /dev/md2, slot 0.
mdadm: added /dev/sdd3 to /dev/md2 as 1
mdadm: no uptodate device for slot 2 of /dev/md2
mdadm: no uptodate device for slot 3 of /dev/md2
mdadm: added /dev/sdc3 to /dev/md2 as 4
mdadm: added /dev/sdb3 to /dev/md2 as 0
mdadm: /dev/md2 assembled from 2 drives and 1 spare - not enough to start the array.

(btw sd[a-d]1 = mirror, md0, /boot ; sd[a-d]2 = md1, raid10, / ;)




mdadm -R /dev/md2 -f --verbose
mdadm: failed to run array /dev/md2: Input/output error

mdadm -D /dev/md2
/dev/md2:
        Version : 0.90
  Creation Time : Mon Mar  9 09:18:45 2009
     Raid Level : raid10
  Used Dev Size : 463765504 (442.28 GiB 474.90 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sat Aug  8 18:49:04 2009
          State : active, degraded, Not Started
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1

         Layout : far=2
     Chunk Size : 4096K

           UUID : 28a0a8db:4120c890:175293b6:df3cd3b3
         Events : 0.778144

    Number   Major   Minor   RaidDevice State
       0       8       19        0      active sync   /dev/sdb3
       1       8       51        1      active sync   /dev/sdd3
       2       0        0        2      removed
       3       0        0        3      removed

       4       8       35        -      spare   /dev/sdc3




dmesg:

md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 9 and added 9 devices.
md: autorun ...
md: considering sdd3 ...
md:  adding sdd3 ...
md: sdd2 has different UUID to sdd3
md: sdd1 has different UUID to sdd3
md:  adding sdc3 ...
md: sdc2 has different UUID to sdd3
md: sdc1 has different UUID to sdd3
md:  adding sdb3 ...
md: sdb2 has different UUID to sdd3
md: sdb1 has different UUID to sdd3
md: created md2
md: bind<sdb3>
md: bind<sdc3>
md: bind<sdd3>
md: running: <sdd3><sdc3><sdb3>
raid10: not enough operational mirrors for md2
md: pers->run() failed ...
md: do_md_run() returned -5
md: md2 stopped.
md: unbind<sdd3>
md: export_rdev(sdd3)
md: unbind<sdc3>
md: export_rdev(sdc3)
md: unbind<sdb3>
md: export_rdev(sdb3)
md: considering sdd2 ...
md:  adding sdd2 ...
md: sdd1 has different UUID to sdd2
md:  adding sdc2 ...
md: sdc1 has different UUID to sdd2
md:  adding sdb2 ...
md: sdb1 has different UUID to sdd2
md: created md1
md: bind<sdb2>
md: bind<sdc2>
md: bind<sdd2>
md: running: <sdd2><sdc2><sdb2>
raid10: raid set md1 active with 3 out of 4 devices
md1: bitmap initialized from disk: read 12/12 pages, set 117875 bits
created bitmap (187 pages) for device md1
md: considering sdd1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md: created md0
md: bind<sdb1>
md: bind<sdc1>
md: bind<sdd1>
md: running: <sdd1><sdc1><sdb1>
raid1: raid set md0 active with 3 out of 4 mirrors
md0: bitmap initialized from disk: read 2/2 pages, set 316 bits
created bitmap (25 pages) for device md0
md: ... autorun DONE.
 md1: unknown partition table
EXT4-fs: barriers enabled
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem md1 with ordered data mode
VFS: Mounted root (ext4 filesystem) readonly on device 9:1.
kjournald2 starting: pid 699, dev md1:8, commit interval 120 seconds
Freeing unused kernel memory: 452k freed
udev: starting version 141
pata_jmicron 0000:05:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
pata_jmicron 0000:05:00.0: setting latency timer to 64
scsi6 : pata_jmicron
scsi7 : pata_jmicron
ata7: PATA max UDMA/100 cmd 0xec00 ctl 0xe880 bmdma 0xe400 irq 19
ata8: PATA max UDMA/100 cmd 0xe800 ctl 0xe480 bmdma 0xe408 irq 19
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
nvidia: module license 'NVIDIA' taints kernel.
Disabling lock debugging due to kernel taint
 md0:
ata7.01: ATAPI: HL-DT-STDVD-RAM GSA-H20L, 1.00, max UDMA/33
ata7.01: configured for UDMA/33
scsi 6:0:1:0: CD-ROM            HL-DT-ST DVD-RAM GSA-H20L 1.00 PQ: 0 ANSI: 5
scsi 6:0:1:0: Attached scsi generic sg5 type 5
nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nvidia 0000:01:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  185.18.31  Tue Jul 28 17:52:27 PDT 2009
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 6:0:1:0: Attached scsi CD-ROM sr0
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
ata2.00: configured for UDMA/133
ata2: EH complete
sd 1:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: configured for UDMA/133
ata3: EH complete
sd 2:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
ata4.00: configured for UDMA/133
ata4: EH complete
sd 3:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
ata5.00: configured for UDMA/133
ata5: EH complete
sd 4:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
EXT4 FS on md1, internal journal on md1:8
EXT4-fs: unable to read superblock





