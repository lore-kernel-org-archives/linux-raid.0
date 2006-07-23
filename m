From: Paul Waldo <pwaldo@waldoware.com>
Subject: Re: In Trouble--Please Help!  (was Re: Can't add disk to failed raid array)
Date: Sun, 23 Jul 2006 08:32:48 -0400
Message-ID: <200607230832.48807.pwaldo@waldoware.com>
References: <200607152056.55090.pwaldo@waldoware.com> <200607230753.47853.pwaldo@waldoware.com> <17603.25777.274507.385333@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_wx2wEvQaFJdCS1H"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17603.25777.274507.385333@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Boundary-00=_wx2wEvQaFJdCS1H
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Here is the dmesg output.  No log files are created with the FC5 rescue disk.  
Thanks!



On Sunday 23 July 2006 07:59, Neil Brown wrote:
> On Sunday July 23, pwaldo@waldoware.com wrote:
> > At this point, I'd just be happy to be able to get the degraded array
> > back up and running.  Is there any way to do that?  Thanks!
>
>  mdadm --assemble --force /dev/md1 /dev/hd[aceg]2 /dev/sd[ab]2
>
> should get you the degraded array.  If not, what kernel log messages
> do you get?

--Boundary-00=_wx2wEvQaFJdCS1H
Content-Type: text/x-log;
  charset="iso-8859-1";
  name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.log"

[APCG] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCG] -> GSI 20 (level, high) -> IRQ 19
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.1: irq 19, io mem 0xe2082000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
usb 1-3: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
  Vendor: HL-DT-ST  Model: DVDRRW GSA-2166D  Rev: 1.01
  Type:   CD-ROM                             ANSI SCSI revision: 00
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
usb-storage: device scan complete
libata version 1.20 loaded.
sata_sil 0000:01:0d.0: version 0.9
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
ACPI: PCI Interrupt 0000:01:0d.0[A] -> Link [APC3] -> GSI 18 (level, high) -> IRQ 20
ata1: SATA max UDMA/100 cmd 0xE090C080 ctl 0xE090C08A bmdma 0xE090C000 irq 20
ata2: SATA max UDMA/100 cmd 0xE090C0C0 ctl 0xE090C0CA bmdma 0xE090C008 irq 20
ata1: SATA link up 1.5 Gbps (SStatus 113)
ata1: dev 0 cfg 49:2f00 82:346b 83:7f01 84:4003 85:3c69 86:3c01 87:4003 88:20ff
ata1: dev 0 ATA-7, max UDMA7, 312581808 sectors: LBA48
ata1: dev 0 configured for UDMA/100
scsi1 : sata_sil
ata2: SATA link up 1.5 Gbps (SStatus 113)
ata2: dev 0 cfg 49:2f00 82:346b 83:7f01 84:4003 85:3c69 86:3c01 87:4003 88:20ff
ata2: dev 0 ATA-7, max UDMA7, 312581808 sectors: LBA48
ata2: dev 0 configured for UDMA/100
scsi2 : sata_sil
  Vendor: ATA       Model: SAMSUNG SP1614C   Rev: SW10
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
 sda: sda1 sda2
sd 1:0:0:0: Attached scsi disk sda
  Vendor: ATA       Model: SAMSUNG SP1614C   Rev: SW10
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
 sdb: sdb1 sdb2
sd 2:0:0:0: Attached scsi disk sdb
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.49.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCH] -> GSI 22 (level, high) -> IRQ 17
PCI: Setting latency timer of device 0000:00:04.0 to 64
eth0: forcedeth.c: subsystem: 010de:05b2 bound to 0000:00:04.0
ISO 9660 Extensions: Microsoft Joliet Level 3
Unable to load NLS charset utf8
Unable to load NLS charset utf8
ISO 9660 Extensions: RRIP_1991A
Unable to identify CD-ROM format.
VFS: Can't find an ext2 filesystem on dev loop0.
security:  3 users, 6 roles, 1161 types, 135 bools, 1 sens, 256 cats
security:  55 classes, 38679 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev loop0, type squashfs), not configured for labeling
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev eventpollfs, type eventpollfs), uses genfs_contexts
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
audit(1153657490.719:2): avc:  denied  { transition } for  pid=532 comm="loader" name="bash" dev=loop0 ino=1485 scontext=system_u:system_r:kernel_t:s0 tcontext=system_u:system_r:anaconda_t:s0 tclass=process
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :  4977.000 MB/sec
raid5: using function: pIII_sse (4977.000 MB/sec)
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid6: int32x1    757 MB/s
raid6: int32x2    835 MB/s
raid6: int32x4    779 MB/s
raid6: int32x8    598 MB/s
raid6: mmxx1     1687 MB/s
raid6: mmxx2     2966 MB/s
raid6: sse1x1    1550 MB/s
raid6: sse1x2    2705 MB/s
raid6: using algorithm sse1x2 (2705 MB/s)
md: raid6 personality registered for level 6
JFS: nTxBlock = 4030, nTxLock = 32241
SGI XFS with ACLs, security attributes, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-devel@redhat.com
program anaconda is using a deprecated SCSI ioctl, please convert it to SG_IO
program anaconda is using a deprecated SCSI ioctl, please convert it to SG_IO
usb 1-6: new high speed USB device using ehci_hcd and address 3
usb 1-6: configuration #1 chosen from 1 choice
scsi3 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
  Vendor: SanDisk   Model: Cruzer Mini       Rev: 0.1 
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sdc: 250879 512-byte hdwr sectors (128 MB)
sdc: Write Protect is off
sdc: Mode Sense: 03 00 00 00
sdc: assuming drive cache: write through
SCSI device sdc: 250879 512-byte hdwr sectors (128 MB)
sdc: Write Protect is off
sdc: Mode Sense: 03 00 00 00
sdc: assuming drive cache: write through
 sdc: sdc1
sd 3:0:0:0: Attached scsi removable disk sdc
usb-storage: device scan complete
md: md1 stopped.
md: bind<hdc2>
md: bind<hde2>
md: bind<hdg2>
md: bind<sda2>
md: bind<sdb2>
md: bind<hda2>
md: md1: raid array is not clean -- starting background reconstruction
raid6: device hda2 operational as raid disk 0
raid6: device sdb2 operational as raid disk 6
raid6: device sda2 operational as raid disk 5
raid6: device hdg2 operational as raid disk 4
raid6: device hde2 operational as raid disk 3
raid6: device hdc2 operational as raid disk 1
raid6: cannot start dirty degraded array for md1
RAID6 conf printout:
 --- rd:7 wd:6 fd:1
 disk 0, o:1, dev:hda2
 disk 1, o:1, dev:hdc2
 disk 3, o:1, dev:hde2
 disk 4, o:1, dev:hdg2
 disk 5, o:1, dev:sda2
 disk 6, o:1, dev:sdb2
raid6: failed to run raid set md1
md: pers->run() failed ...
ext3: No journal on filesystem on fd0

--Boundary-00=_wx2wEvQaFJdCS1H--
