From: "Bailey, Scott" <scott.bailey@eds.com>
Subject: RE: raid1 boots with one disk only
Date: Mon, 7 Mar 2005 15:18:00 -0500
Message-ID: <2263802DEDF02046B82EB18DE91725ED17A3F2@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-raid-owner@vger.kernel.org
To: 'Steve Kwee' <skwee@itw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Steve writes:

>Thank you for the hint, but unfortunatly it does not change the behaviour
>I now boot with a grub entry like 1.)
>But still get 2. in dmesg after boot.
>
>As one can see md0 is fine while md1 is not. Does this possibly have
something
>to do with the fact that /dev/md1 is also used as the root device ?
>
>1. /boot/grub/menu.lst
>----------------------------------------------
>title Ubuntu Linux (Kernel hd0, Root /dev/md1)
>        kernel  (hd0,0)/vmlinuz-2.6.8.1-3-386 root=/dev/md1
>md=1,/dev/hda2,/dev/hdc2 ro splash
>        initrd  (hd0,0)/initrd.img-2.6.8.1-3-386
>        savedefault
>        boot

I don't think this is a problem - my root device is on an md device also.
From my Alphaserver (which is conveniently close to hand and alive) I have
this entry in /etc/aboot.conf:

0:1/vmlinuz-2.4.27-hamster.8 md=1,/dev/sda2,/dev/sdg2 ro root=/dev/md1
console=ttyS0

In English :-) I am booting from partition 1 of my boot disk, which happens
to be /dev/sda1 (which with /dev/sdg1 forms /dev/md0, which is mounted as
/boot). I am loading a locally-built kernel which has md and lvm and scsi
support built-in (thus no initrd is used). I don't know if that makes a
difference.

>2. dmesg after boot
>----------------------------------------------
>ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
>hda: max request size: 128KiB
>hda: 120103200 sectors (61492 MB) w/1916KiB Cache, CHS=65535/16/63,
UDMA(33)
> /dev/ide/host0/bus0/target0/lun0: p1 p2 p3
>hdc: IBM-DTLA-307060, ATA DISK drive
>ide1 at 0x170-0x177,0x376 on irq 15
>hdc: max request size: 128KiB
>hdc: 120103200 sectors (61492 MB) w/1916KiB Cache, CHS=65535/16/63,
UDMA(100)
> /dev/ide/host0/bus1/target0/lun0: p1 p2 p3
>md: md1 stopped.
>md: bind<hdc2>
>raid1: raid set md1 active with 1 out of 2 mirrors
>[...]

This doesn't look quite right to me, or maybe the messages have just changed
between 2.4 and 2.6. I think that also you have had some possibly
interesting messages roll off the beginning of your dmesg buffer. One,
thought, which I am not confident about, is whether md is built as a module
and loaded from your initrd and therefore does not see the boot command line
-- does it work any better to add the magic md= options to /etc/modules.conf
and rebuild your initrd?

For comparison, here is what I see on the console -- this morning, rebooting
after a machine check locked up the system, sigh, which forced all of my
mirrors to get rebuilt. :-(

I marked a couple interesting lines with "@" in the left margin. Note the
echoing of the command line along with the note that my forcing of /dev/md1
membership will be used later on. The built-in auto-detect pass for md does
nothing, which is a known feature on non-x86 architectures apparently, and
then /dev/md1 is built and started as specified by me. Later on, at the
point where rc scripts gets run, /etc/init.d/mdadm-raid detects and starts
all of the non-root RAID devices.

 CPU 0 booting
 
 (boot dkb0.0.0.2000.1 -flags 0)
 block 0 of dkb0.0.0.2000.1 is a valid boot block
 reading 173 blocks from dkb0.0.0.2000.1
 bootstrap code read in
 Building FRU table
 base = 200000, image_start = 0, image_bytes = 15a00
 initializing HWRPB at 2000
 initializing page table at 1f2000
 initializing machine state
 setting affinity to the primary CPU
 jumping to bootstrap code
 aboot: Linux/Alpha SRM bootloader version 0.9
 aboot: switching to OSF/1 PALcode version 1.23
 aboot: booting from device 'SCSI 1 2000 0 0 0 1011 10201077'
 aboot: valid disklabel found: 4 partitions.
 aboot: loading uncompressed vmlinuz-2.4.27-hamster.8...
 aboot: loading compressed vmlinuz-2.4.27-hamster.8...
 aboot: zero-filling 464776 bytes at 0xfffffc0000626638
 aboot: starting kernel vmlinuz-2.4.27-hamster.8 with arguments
md=1,/dev/sda2,/dev/sdg2 ro root=/dev/md1 console=ttyS0
 Linux version 2.4.27-hamster.8 (czhc72@hamster) (gcc version 3.3.5 (Debian
1:3.3.5-5)) #1 SMP Tue Jan 25 16:52:41 EST 2005
 Booting on Rawhide variation Dodge using machine vector Rawhide from SRM
 Major Options: SMP EV56 LEGACY_START MAGIC_SYSRQ 
 Command line: md=1,/dev/sda2,/dev/sdg2 ro root=/dev/md1 console=ttyS0
 memcluster 0, usage 1, start        0, end      256
 memcluster 1, usage 0, start      256, end   393216
 memcluster 2, usage 0, start   524288, end   655351
 memcluster 3, usage 1, start   655351, end   655360
 freeing pages 256:384
 freeing pages 846:393216
 freeing pages 524288:655351
 reserving pages 846:856
 SMP: 3 CPUs probed -- cpu_present_mask = 7
 On node 0 totalpages: 655351
 zone(0): 524288 pages.
 zone(1): 131063 pages.
 zone(2): 0 pages.
@Kernel command line: md=1,/dev/sda2,/dev/sdg2 ro root=/dev/md1
console=ttyS0
@md: Will configure md1 (super-block) from /dev/sda2,/dev/sdg2, below.
 mcpcia_init_hoses: found 2 hoses
 HWRPB cycle frequency bogus.  Estimated 466084829 Hz
 Using epoch = 2000
 Turning on RTC interrupts.
 Calibrating delay loop... 928.12 BogoMIPS
 Memory: 4129936k/5242808k available (1921k kernel code, 62248k reserved,
809k data, 352k init)
 Dentry cache hash table entries: 262144 (order: 9, 4194304 bytes)
 Inode cache hash table entries: 262144 (order: 9, 4194304 bytes)
 Mount cache hash table entries: 512 (order: 0, 8192 bytes)
 Buffer cache hash table entries: 524288 (order: 9, 4194304 bytes)
 Page-cache hash table entries: 524288 (order: 9, 4194304 bytes)
 POSIX conformance testing by UNIFIX
 SMP starting up secondaries.
 Calibrating delay loop... 932.24 BogoMIPS
 Calibrating delay loop... 932.24 BogoMIPS
 SMP: Total of 3 processors activated (2793.60 BogoMIPS).
 Waiting on wait_init_idle (map = 0x6)
 All processors have done init_idle
 PCI: Bus 1, bridge: Digital Equipment Corporation DECchip 21050
   IO window: 8000-8fff
   MEM window: 02200000-022fffff
   PREFETCH window: disabled.
 PCI: Bus 2, bridge: Digital Equipment Corporation DECchip 21050 (#2)
   IO window: 9000-9fff
   MEM window: 02300000-023fffff
   PREFETCH window: disabled.
 PCI: Bus 4, bridge: Digital Equipment Corporation DECchip 21050 (#3)
   IO window: 8000-8fff
   MEM window: 02200000-022fffff
   PREFETCH window: disabled.
 isapnp: Scanning for PnP cards...
 isapnp: No Plug & Play device found
 Linux NET4.0 for Linux 2.4
 Based upon Swansea University Computer Society NET3.039
 Initializing RT netlink socket
 srm_env: version 0.0.5 loaded successfully
 Starting kswapd
 Journalled Block Device driver loaded
 initialize_kbd: Keyboard reset failed, no ACK
 pty: 256 Unix98 ptys configured
 keyboard: Timeout - AT keyboard not present?(ed)
 keyboard: Timeout - AT keyboard not present?(f4)
 Serial driver version 5.05c (2001-07-08) with MANY_PORTS SHARE_IRQ
SERIAL_PCI ISAPNP enabled
 ttyS00 at 0x03f8 (irq = 4) is a 16550A
 ttyS01 at 0x02f8 (irq = 3) is a 16550A
 rtc: SRM (post-2000) epoch (2000) detected
 Real Time Clock Driver v1.10f
 Floppy drive(s): fd0 is 2.88M
 FDC 0 is a National Semiconductor PC87306
 RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
 SCSI subsystem driver Revision: 1.00
 ISP SCSI and Fibre Channel Host Adapter Driver
       Linux Platform Version 2.1
       Common Core Code Version 2.8
       Built on Jan 25 2005, 16:59:32
 isp0: Board Type 1020A, Chip Revision 0x2, loaded F/W Revision 4.66.0
 isp0: Last F/W revision was 5.57.1
 isp1: Board Type 1020A, Chip Revision 0x2, loaded F/W Revision 4.66.0
 isp1: Last F/W revision was 5.57.1
 isp2: Board Type 1020A, Chip Revision 0x2, loaded F/W Revision 4.66.0
 isp2: Last F/W revision was 5.57.1
 scsi0 : Driver for a Qlogic ISP 1020/1040 Host Adapter
 scsi1 : Driver for a Qlogic ISP 1020/1040 Host Adapter
 scsi2 : Driver for a Qlogic ISP 1020/1040 Host Adapter
   Vendor: DEC       Model: TZ89     (C) DEC  Rev: 296D
   Type:   Sequential-Access                  ANSI SCSI revision: 02
   Vendor: DEC       Model: RZ2DD-LS (C) DEC  Rev: 0306
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: COMPAQ    Model: BD009122C6        Rev: B016
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: COMPAQ    Model: BD009122C6        Rev: B016
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: DEC       Model: RZ2DD-LS (C) DEC  Rev: 0306
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: DEC       Model: RZ2DD-LS (C) DEC  Rev: 0306
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: DEC       Model: RZ2DD-LS (C) DEC  Rev: 0306
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: COMPAQ    Model: BD009122BA        Rev: 3B07
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: COMPAQ    Model: BD009122C6        Rev: B016
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: COMPAQ    Model: BD009122C6        Rev: B016
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: COMPAQ    Model: BD009122C6        Rev: B016
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: COMPAQ    Model: BD009122C6        Rev: B016
   Type:   Direct-Access                      ANSI SCSI revision: 02
   Vendor: COMPAQ    Model: BD009122C6        Rev: B016
   Type:   Direct-Access                      ANSI SCSI revision: 02
 ncr53c8xx: at PCI bus 3, device 1, function 0
 ncr53c8xx: 53c810 detected 
 ncr53c810-0: rev 0x2 on pci bus 3 device 1 function 0 irq 56
 ncr53c810-0: ID 7, Fast-10, Parity Checking
 scsi3 : ncr53c8xx-3.4.3b-20010512
   Vendor: DEC       Model: RRD46   (C) DEC   Rev: 0557
   Type:   CD-ROM                             ANSI SCSI revision: 02
 st: Version 20040102, bufsize 32768, max init. bufs 4, s/g segs 16
 Attached scsi tape st0 at scsi0, channel 0, id 0, lun 0
 Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
 Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0
 Attached scsi disk sdc at scsi1, channel 0, id 2, lun 0
 Attached scsi disk sdd at scsi1, channel 0, id 3, lun 0
 Attached scsi disk sde at scsi1, channel 0, id 4, lun 0
 Attached scsi disk sdf at scsi1, channel 0, id 5, lun 0
 Attached scsi disk sdg at scsi2, channel 0, id 0, lun 0
 Attached scsi disk sdh at scsi2, channel 0, id 1, lun 0
 Attached scsi disk sdi at scsi2, channel 0, id 2, lun 0
 Attached scsi disk sdj at scsi2, channel 0, id 3, lun 0
 Attached scsi disk sdk at scsi2, channel 0, id 4, lun 0
 Attached scsi disk sdl at scsi2, channel 0, id 5, lun 0
 SCSI device sda: 17773524 512-byte hdwr sectors (9100 MB)
 Partition check:
  sda: sda1 sda2 sda4
 SCSI device sdb: 17773524 512-byte hdwr sectors (9100 MB)
  sdb: sdb1
 SCSI device sdc: 17773524 512-byte hdwr sectors (9100 MB)
  sdc: sdc1
 SCSI device sdd: 17773524 512-byte hdwr sectors (9100 MB)
  sdd: sdd1
 SCSI device sde: 17773524 512-byte hdwr sectors (9100 MB)
  sde: sde1
 SCSI device sdf: 17773524 512-byte hdwr sectors (9100 MB)
  sdf: sdf1
 SCSI device sdg: 17773524 512-byte hdwr sectors (9100 MB)
  sdg: sdg1 sdg2 sdg4
 SCSI device sdh: 17773524 512-byte hdwr sectors (9100 MB)
  sdh: sdh1
 SCSI device sdi: 17773524 512-byte hdwr sectors (9100 MB)
  sdi: sdi1
 SCSI device sdj: 17773524 512-byte hdwr sectors (9100 MB)
  sdj: sdj1
 SCSI device sdk: 17773524 512-byte hdwr sectors (9100 MB)
  sdk: sdk1
 SCSI device sdl: 17773524 512-byte hdwr sectors (9100 MB)
  sdl: sdl1
 Attached scsi CD-ROM sr0 at scsi3, channel 0, id 5, lun 0
 ncr53c810-0-<5,*>: FAST-10 SCSI 10.0 MB/s (100 ns, offset 8)
 sr0: scsi-1 drive
 Uniform CD-ROM driver Revision: 3.12
 md: raid1 personality registered as nr 3
 md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
 md: Autodetecting RAID arrays.
@md: autorun ...
@md: ... autorun DONE.
 md: Loading md1: /dev/sda2
  [events: 00000123]
 md: bind<sda2,1>
  [events: 00000123]
 md: bind<sdg2,2>
 md: sdg2's event counter: 00000123
 md: sda2's event counter: 00000123
 md: md1: raid array is not clean -- starting background reconstruction
 md: RAID level 1 does not need chunksize! Continuing anyway.
 md1: max total readahead window set to 248k
 md1: 1 data-disks, max readahead per data-disk: 248k
 raid1: device sdg2 operational as mirror 1
 raid1: device sda2 operational as mirror 0
 raid1: raid set md1 not clean; reconstructing mirrors
@raid1: raid set md1 active with 2 out of 2 mirrors
 md: syncing RAID array md1
 md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
 md: using maximum available idle IO bandwith (but not more than 100000
KB/sec) for reconstruction.
 md: using 248k window, over a total of 309056 blocks.
 md: updating md1 RAID superblock on device
 md: sdg2 [events: 00000124]<6>(write) sdg2's sb offset: 309056
 md: sda2 [events: 00000124]<6>(write) sda2's sb offset: 309056
 LVM version 1.0.8(17/11/2003)
 device-mapper: 4.1.1-ioctl (2004-04-07) initialised: dm-devel@redhat.com
 NET4: Linux TCP/IP 1.0 for NET4.0
 IP: routing cache hash table of 65536 buckets, 1024Kbytes
 TCP: Hash tables configured (established 262144 bind 65536)
 NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
 EXT3-fs: INFO: recovery required on readonly filesystem.
 EXT3-fs: write access will be enabled during recovery.
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs: recovery complete.
 EXT3-fs: mounted filesystem with ordered data mode.
 VFS: Mounted root (ext3 filesystem) readonly.
 Freeing unused kernel memory: 352k freed
 INIT: version 2.86 booting
 Activating swap.
 Checking root file system...
 fsck 1.35 (28-Feb-2004)
 root: clean, 4815/77520 files, 6EXT3 FS 2.4-0.9.19, 19 August 2002 on
md(9,1), i0592/309056 blonternal journal
 ks
 System time was Mon Mar  7 15:09:28 UTC 2005.
 Setting the System Clock using the Hardware Clock as reference...
 System Clock set. System local time is now Mon Mar  7 15:09:30 UTC 2005.
 Cleaning up ifupdown...done.
 Calculating module dependencies... done.
 Loading modules: 
 Creating device-mapper devices...done.
@Starting RAID devices:  [events: 000000a1]
  [events: 000000a1]
 md: autorun ...
 md: considering sdg1 ...
 md:  adding sdg1 ...
 md:  adding sda1 ...
 md: created md0
 md: bind<sda1,1>
 md: bind<sdg1,2>
 md: running: <sdg1><sda1>
 md: sdg1's event counter: 000000a1
 md: sda1's event counter: 000000a1
 md: md0: raid array is not clean -- starting background reconstruction
 md: RAID level 1 does not need chunksize! Continuing anyway.
 md0: max total readahead window set to 248k
 md0: 1 data-disks, max readahead per data-disk: 248k
 raid1: device sdg1 operational as mirror 1
 raid1: device sda1 operational as mirror 0
 raid1: raid set md0 not clean; reconstructing mirrors
 raid1: raid set md0 active with 2 out of 2 mirrors
 md: delaying resync of md0 until md1 has finished resync (they share one or
more physical units)
 md: updating md0 RAID superblock on device
 md: sdg1 [events: 000000a2]<6>(write) sdg1's sb offset: 53696
 md: sda1 [events: 000000a2]<6>(write) sda1's sb offset: 53696
 md: ... autorun DONE.
 /dev/md0
[...]
