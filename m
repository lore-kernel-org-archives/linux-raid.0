From: root <root@inquisitive.linuxguru.ca>
Subject: kicking non-fresh hde1 from array!
Date: Mon, 16 Dec 2002 19:29:56 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200212161837.05355.root@inquisitive.linuxguru.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Last night I heard a ping from my server and then the output on the screen 
said it was dropping /dev/hdg from the array.   No nice University 
Education for me so I was wondering if I could draw on yours.  Here is my 
array raidtab file.  If anyone can help can you cc back to arden underscore 
wiebe at hotmail dot com.  Also I have posted the entire message for comments 
at http://www.linuxguru.ca if that helps.  I don't have any of the kernel 
tools installed on the server yet...

raiddev		    /dev/md2
raid-level		    1
nr-raid-disks		    2
chunk-size		    64k
persistent-superblock	    1
nr-spare-disks		    0
    device	    /dev/hda1
    raid-disk     0
    device	    /dev/hdc2
    raid-disk     1
raiddev		    /dev/md1
raid-level		    0
nr-raid-disks		    2
chunk-size		    64k
persistent-superblock	    1
nr-spare-disks		    0
    device	    /dev/hde3
    raid-disk     0
    device	    /dev/hdg3
    raid-disk     1
raiddev		    /dev/md0
raid-level		    1
nr-raid-disks		    2
chunk-size		    64k
persistent-superblock	    1
nr-spare-disks		    0
    device	    /dev/hde1
    raid-disk     0
    device	    /dev/hdg1
    raid-disk     1

The failing device:

[root@inquisitive root]# cat /proc/mdstat
Personalities : [raid0] [raid1]
read_ahead 1024 sectors
md1 : active raid0 hde3[0] hdg3[1]
      38562816 blocks 64k chunks

md0 : active raid1 hdg1[1]
      19282944 blocks [2/1] [_U]

md2 : active raid1 hda1[0] hdc2[1]
      19541440 blocks [2/2] [UU]

unused devices: <none>
[root@inquisitive root]#

Various hdparm settings:

[root@inquisitive root]# hdparm -iv /dev/hda

/dev/hda:
 multcount    = 16 (on)
 I/O support  =  1 (32-bit)
 unmaskirq    =  1 (on)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 nowerr       =  0 (off)
 readonly     =  0 (off)
 readahead    =  8 (on)
 geometry     = 39813/16/63, sectors = 40132503, start = 0

 Model=MAXTOR 6L020J1, FwRev=AR1.0500, SerialNo=661247741929
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs }
 RawCHS=16383/16/63, TrkSize=32256, SectSize=21298, ECCbytes=4
 BuffType=DualPortCache, BuffSize=1818kB, MaxMultSect=16, MultSect=16
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=40132503
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes: pio0 pio1 pio2 pio3 pio4
 DMA modes: mdma0 mdma1 mdma2 udma0 udma1 udma2
 AdvancedPM=no WriteCache=enabled
 Drive Supports : ATA/ATAPI-5 T13 1321D revision 1 : ATA-1 ATA-2 ATA-3 ATA-4 
ATA-5

 busstate     =  1 (on)
[root@inquisitive root]#

[root@inquisitive root]# hdparm -iv /dev/hdc

/dev/hdc:
 multcount    = 16 (on)
 I/O support  =  1 (32-bit)
 unmaskirq    =  1 (on)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 nowerr       =  0 (off)
 readonly     =  0 (off)
 readahead    =  8 (on)
 geometry     = 39813/16/63, sectors = 40132503, start = 0

 Model=MAXTOR 6L020J1, FwRev=AR1.0500, SerialNo=661207748035
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs }
 RawCHS=16383/16/63, TrkSize=32256, SectSize=21298, ECCbytes=4
 BuffType=DualPortCache, BuffSize=1818kB, MaxMultSect=16, MultSect=16
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=40132503
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes: pio0 pio1 pio2 pio3 pio4
 DMA modes: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
 AdvancedPM=no WriteCache=enabled
 Drive Supports : ATA/ATAPI-5 T13 1321D revision 1 : ATA-1 ATA-2 ATA-3 ATA-4 
ATA-5

 busstate     =  1 (on)
[root@inquisitive root]#

[root@inquisitive root]# hdparm -iv /dev/hde

/dev/hde:
 multcount    = 16 (on)
 I/O support  =  0 (default 16-bit)
 unmaskirq    =  0 (off)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 nowerr       =  0 (off)
 readonly     =  0 (off)
 readahead    =  8 (on)
 geometry     = 77557/16/63, sectors = 78177792, start = 0

 Model=MAXTOR 6L040L2, FwRev=A93.0500, SerialNo=662210271602
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs }
 RawCHS=16383/16/63, TrkSize=32256, SectSize=21298, ECCbytes=4
 BuffType=DualPortCache, BuffSize=1819kB, MaxMultSect=16, MultSect=16
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=78177792
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes: pio0 pio1 pio2 pio3 pio4
 DMA modes: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5 udma6
 AdvancedPM=no WriteCache=enabled
 Drive Supports : ATA/ATAPI-5 T13 1321D revision 1 : ATA-1 ATA-2 ATA-3 ATA-4 
ATA-5

 busstate     =  1 (on)
[root@inquisitive root]#

[root@inquisitive root]# hdparm -iv /dev/hdg

/dev/hdg:
 multcount    = 16 (on)
 I/O support  =  0 (default 16-bit)
 unmaskirq    =  0 (off)
 using_dma    =  1 (on)
 keepsettings =  0 (off)
 nowerr       =  0 (off)
 readonly     =  0 (off)
 readahead    =  8 (on)
 geometry     = 77557/16/63, sectors = 78177792, start = 0

 Model=MAXTOR 6L040L2, FwRev=A93.0500, SerialNo=662210371352
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs }
 RawCHS=16383/16/63, TrkSize=32256, SectSize=21298, ECCbytes=4
 BuffType=DualPortCache, BuffSize=1819kB, MaxMultSect=16, MultSect=16
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=78177792
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes: pio0 pio1 pio2 pio3 pio4
 DMA modes: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 *udma5 udma6
 AdvancedPM=no WriteCache=enabled
 Drive Supports : ATA/ATAPI-5 T13 1321D revision 1 : ATA-1 ATA-2 ATA-3 ATA-4 
ATA-5

 busstate     =  1 (on)
[root@inquisitive root]#

Now if you compare that to my original settings which I tweaked to get the 
disk reads matching the rest of the disks for /dev/hde and /dev/hdg at 
http://www.linuxguru.ca/article6.html to what they are now they seem faster.

[root@inquisitive root]# hdparm -Tt /dev/hda

/dev/hda:
 Timing buffer-cache reads:   128 MB in  0.59 seconds =218.47 MB/sec
 Timing buffered disk reads:  64 MB in  1.61 seconds = 39.72 MB/sec
[root@inquisitive root]# hdparm -Tt /dev/hdc

/dev/hdc:
 Timing buffer-cache reads:   128 MB in  0.60 seconds =214.89 MB/sec
 Timing buffered disk reads:  64 MB in  1.60 seconds = 39.96 MB/sec
[root@inquisitive root]# hdparm -Tt /dev/hde

/dev/hde:
 Timing buffer-cache reads:   128 MB in  0.58 seconds =219.93 MB/sec
 Timing buffered disk reads:  64 MB in  1.61 seconds = 39.77 MB/sec
[root@inquisitive root]# hdparm -Tt /dev/hdg

/dev/hdg:
 Timing buffer-cache reads:   128 MB in  0.58 seconds =220.67 MB/sec
 Timing buffered disk reads:  64 MB in  1.61 seconds = 39.86 MB/sec
[root@inquisitive root]#

I can recall the first time I heard the head drop it said something about lost 
DMA channel.  Here is the syslog:

Dec 16 02:06:40 inquisitive modprobe: modprobe: Can't locate module 
char-major-81
Dec 16 02:06:52 inquisitive insmod: 
/lib/modules/2.4.18-17.7.x/kernel/drivers/sound/via82cxxx_audio.o: 
init_module: No such device
Dec 16 02:06:52 inquisitive insmod: 
/lib/modules/2.4.18-17.7.x/kernel/drivers/sound/via82cxxx_audio.o: insmod 
sound-slot-0 failed
Dec 16 02:06:52 inquisitive modprobe: modprobe: Can't locate module 
sound-service-0-3
Dec 16 03:48:04 inquisitive xinetd[1169]: Exiting...
Dec 16 03:50:35 inquisitive kernel: Linux version 2.4.18-17.7.x 
(bhcompile@porky.devel.redhat.com) (gcc version 2.96 20000731 (Red Hat Linux 
7.3 2.96-112)) #1 Tue Oct 8 11:49:30 EDT 2002
Dec 16 03:50:35 inquisitive kernel:  BIOS-e820: 0000000000000000 - 
000000000009fc00 (usable)
Dec 16 03:50:35 inquisitive kernel:  BIOS-e820: 000000000009fc00 - 
00000000000a0000 (reserved)
Dec 16 03:50:35 inquisitive kernel:  BIOS-e820: 00000000000f0000 - 
0000000000100000 (reserved)
Dec 16 03:50:35 inquisitive kernel:  BIOS-e820: 0000000000100000 - 
0000000050000000 (usable)
Dec 16 03:50:35 inquisitive kernel:  BIOS-e820: 00000000ffff0000 - 
0000000100000000 (reserved)
Dec 16 03:50:35 inquisitive kernel: On node 0 totalpages: 327680
Dec 16 03:50:35 inquisitive kernel: zone(0): 4096 pages.
Dec 16 03:50:35 inquisitive kernel: zone(1): 225280 pages.
Dec 16 03:50:35 inquisitive kernel: zone(2): 98304 pages.
Dec 16 03:50:35 inquisitive kernel: Kernel command line: ro root=/dev/md2
Dec 16 03:50:35 inquisitive kernel: Detected 1005.437 MHz processor.
Dec 16 03:50:35 inquisitive kernel: Speakup v-1.00 CVS: Tue Jun 11 14:22:53 
EDT 2002 : initialized
Dec 16 03:50:35 inquisitive kernel: Console: colour VGA+ 80x25
Dec 16 03:50:35 inquisitive kernel: Calibrating delay loop... 1993.77 BogoMIPS
Dec 16 03:50:35 inquisitive kernel: Page-cache hash table entries: 524288 
(order: 9, 2097152 bytes)
Dec 16 03:50:35 inquisitive kernel: CPU: AMD Duron(tm) processor stepping 01
Dec 16 03:50:35 inquisitive kernel: POSIX conformance testing by UNIFIX
Dec 16 03:50:35 inquisitive kernel: mtrr: v1.40 (20010327) Richard Gooch 
(rgooch@atnf.csiro.au)
Dec 16 03:50:35 inquisitive kernel: mtrr: detected mtrr type: Intel
Dec 16 03:50:35 inquisitive kernel: speakup:  initialized device: /dev/synth, 
node (MAJOR 10, MINOR 25)
Dec 16 03:50:35 inquisitive kernel: Initializing RT netlink socket
Dec 16 03:50:35 inquisitive kernel: Starting kswapd
Dec 16 03:50:35 inquisitive kernel: allocated 64 pages and 64 bhs reserved for 
the highmem bounces
Dec 16 03:50:35 inquisitive kernel: pty: 2048 Unix98 ptys configured
Dec 16 03:50:35 inquisitive kernel: block: 1024 slots per queue, batch=256
Dec 16 03:50:35 inquisitive kernel: ide: Assuming 33MHz system bus speed for 
PIO modes; override with idebus=xx
Dec 16 03:50:35 inquisitive kernel: HPT372: IDE controller on PCI bus 00 dev 
70
Dec 16 03:50:35 inquisitive kernel: HPT372: chipset revision 5
Dec 16 03:50:35 inquisitive kernel: HPT372: not 100%% native mode: will probe 
irqs later
Dec 16 03:50:35 inquisitive kernel: HPT37X: using 33MHz PCI clock
Dec 16 03:50:35 inquisitive kernel:     ide2: BM-DMA at 0xd400-0xd407, BIOS 
settings: hde:DMA, hdf:pio
Dec 16 03:50:35 inquisitive kernel:     ide3: BM-DMA at 0xd408-0xd40f, BIOS 
settings: hdg:DMA, hdh:pio
Dec 16 03:50:35 inquisitive kernel: VP_IDE: IDE controller on PCI bus 00 dev 
89
Dec 16 03:50:35 inquisitive kernel: PCI: No IRQ known for interrupt pin A of 
device 00:11.1. Please try using pci=biosirq.
Dec 16 03:50:35 inquisitive kernel: VP_IDE: chipset revision 6
Dec 16 03:50:35 inquisitive kernel: VP_IDE: not 100%% native mode: will probe 
irqs later
Dec 16 03:50:35 inquisitive kernel: ide: Assuming 33MHz system bus speed for 
PIO modes; override with idebus=xx
Dec 16 03:50:35 inquisitive kernel:     ide0: BM-DMA at 0xd800-0xd807, BIOS 
settings: hda:DMA, hdb:DMA
Dec 16 03:50:35 inquisitive kernel:     ide1: BM-DMA at 0xd808-0xd80f, BIOS 
settings: hdc:DMA, hdd:pio
Dec 16 03:50:35 inquisitive kernel: hda: MAXTOR 6L020J1, ATA DISK drive
Dec 16 03:50:35 inquisitive kernel: hdb: IDE/ATAPI CD-ROM 36X, ATAPI 
CD/DVD-ROM drive
Dec 16 03:50:35 inquisitive kernel: hdc: MAXTOR 6L020J1, ATA DISK drive
Dec 16 03:50:35 inquisitive kernel: hde: MAXTOR 6L040L2, ATA DISK drive
Dec 16 03:50:35 inquisitive kernel: hdg: MAXTOR 6L040L2, ATA DISK drive
Dec 16 03:50:35 inquisitive kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Dec 16 03:50:35 inquisitive kernel: ide1 at 0x170-0x177,0x376 on irq 15
Dec 16 03:50:35 inquisitive kernel: ide2 at 0xc400-0xc407,0xc802 on irq 10
Dec 16 03:50:35 inquisitive kernel: ide3 at 0xcc00-0xcc07,0xd002 on irq 10
Dec 16 03:50:35 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 03:50:35 inquisitive kernel: RAMDISK driver initialized: 16 RAM disks 
of 4096K size 1024 blocksize
Dec 16 03:50:35 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 03:50:35 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-2, errno = 2
Dec 16 03:50:35 inquisitive kernel: md: personality 2 is not loaded!
Dec 16 03:50:35 inquisitive kernel: md :do_md_run() returned -22
Dec 16 03:50:36 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-3, errno = 2
Dec 16 03:50:36 inquisitive kernel: md: personality 3 is not loaded!
Dec 16 03:50:36 inquisitive kernel: md :do_md_run() returned -22
Dec 16 03:50:36 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-3, errno = 2
Dec 16 03:50:36 inquisitive kernel: md: personality 3 is not loaded!
Dec 16 03:50:36 inquisitive kernel: md :do_md_run() returned -22
Dec 16 03:50:36 inquisitive kernel: VFS: Mounted root (ext2 filesystem).
Dec 16 03:50:37 inquisitive kernel: raid0: looking at hde3
Dec 16 03:50:37 inquisitive kernel: raid0:   comparing hde3(19281408) with 
hde3(19281408)
Dec 16 03:50:37 inquisitive kernel: raid0:   END
Dec 16 03:50:37 inquisitive kernel: raid0:   ==> UNIQUE
Dec 16 03:50:37 inquisitive kernel: raid0: 1 zones
Dec 16 03:50:37 inquisitive kernel: raid0: looking at hdg3
Dec 16 03:50:37 inquisitive kernel: raid0:   comparing hdg3(19281408) with 
hde3(19281408)
Dec 16 03:50:37 inquisitive kernel: raid0:   EQUAL
Dec 16 03:50:37 inquisitive kernel: raid0: FINAL 1 zones
Dec 16 03:50:37 inquisitive kernel: raid0: zone 0
Dec 16 03:50:37 inquisitive kernel: raid0: checking hde3 ... contained as 
device 0
Dec 16 03:50:37 inquisitive kernel:   (19281408) is smallest!.
Dec 16 03:50:37 inquisitive kernel: raid0: checking hdg3 ... contained as 
device 1
Dec 16 03:50:37 inquisitive kernel: raid0: zone->nb_dev: 2, size: 38562816
Dec 16 03:50:37 inquisitive kernel: raid0: current zone offset: 19281408
Dec 16 03:50:37 inquisitive kernel: raid0: done.
Dec 16 03:50:37 inquisitive kernel: raid0 : md_size is 38562816 blocks.
Dec 16 03:50:37 inquisitive kernel: raid0 : conf->smallest->size is 38562816 
blocks.
Dec 16 03:50:37 inquisitive kernel: raid0 : nb_zone is 1.
Dec 16 03:50:37 inquisitive kernel: raid0 : Allocating 8 bytes for hash.
Dec 16 03:50:37 inquisitive kernel: usb-uhci.c: Detected 2 ports
Dec 16 03:50:37 inquisitive kernel: usb-uhci.c: Detected 2 ports
Dec 16 03:50:37 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 03:50:37 inquisitive kernel: hdb: ATAPI 16X CD-ROM drive, 128kB Cache
Dec 16 03:50:37 inquisitive kernel: ip_tables: (C) 2000-2002 Netfilter core 
team
Dec 16 03:50:37 inquisitive kernel: ip_conntrack (8192 buckets, 65536 max)
Dec 16 03:50:37 inquisitive xinetd[1168]: Server /usr/sbin/in.rexecd is not 
executable [line=13]
Dec 16 03:50:37 inquisitive xinetd[1168]: Error parsing attribute server - 
DISABLING SERVICE [line=13]
Dec 16 03:50:37 inquisitive xinetd[1168]: Server /usr/sbin/in.rlogind is not 
executable [line=13]
Dec 16 03:50:37 inquisitive xinetd[1168]: Error parsing attribute server - 
DISABLING SERVICE [line=13]
Dec 16 03:50:37 inquisitive xinetd[1168]: Server /usr/sbin/in.rshd is not 
executable [line=14]
Dec 16 03:50:37 inquisitive xinetd[1168]: Error parsing attribute server - 
DISABLING SERVICE [line=14]
Dec 16 03:50:53 inquisitive postfix/postfix-script: warning: 
/var/spool/postfix/etc/resolv.conf and /etc/resolv.conf differ
Dec 16 06:02:03 inquisitive kernel: hde: dma_intr: status=0x7f { DriveReady 
DeviceFault SeekComplete DataRequest CorrectedError Index Error }
Dec 16 06:02:03 inquisitive kernel: hde: dma_intr: error=0x7f { 
DriveStatusError UncorrectableError SectorIdNotFound TrackZeroNotFound 
AddrMarkNotFound }, LBAsect=260013951, sector=274616
Dec 16 06:02:03 inquisitive kernel: hde: DMA disabled
Dec 16 06:02:03 inquisitive kernel: ide2: reset: master: error (0x7f?)
Dec 16 06:02:03 inquisitive kernel: hde: status error: status=0x7f { 
DriveReady DeviceFault SeekComplete DataRequest CorrectedError Index Error }
Dec 16 06:02:03 inquisitive kernel: hde: status error: error=0x7f { 
DriveStatusError UncorrectableError SectorIdNotFound TrackZeroNotFound 
AddrMarkNotFound }, LBAsect=260013951, sector=274616
Dec 16 06:02:03 inquisitive kernel: hde: drive not ready for command
Dec 16 06:02:03 inquisitive kernel: ide2: reset: master: error (0x7f?)
Dec 16 06:02:03 inquisitive kernel: end_request: I/O error, dev 21:01 (hde), 
sector 274616
Dec 16 06:02:03 inquisitive kernel: raid1: Disk failure on hde1, disabling 
device.
Dec 16 06:02:03 inquisitive kernel: ^IOperation continuing on 1 devices
Dec 16 06:02:03 inquisitive kernel: raid1: hde1: rescheduling block 274616
Dec 16 06:02:03 inquisitive kernel: end_request: I/O error, dev 21:01 (hde), 
sector 145496
Dec 16 06:02:13 inquisitive kernel: md0: no spare disk to reconstruct array! 
-- continuing in degraded mode
Dec 16 06:02:13 inquisitive kernel: hdg: timeout waiting for DMA
Dec 16 06:02:13 inquisitive kernel: ide_dmaproc: chipset supported 
ide_dma_timeout func only: 14
Dec 16 06:02:13 inquisitive kernel: hdg: status error: status=0x58 { 
DriveReady SeekComplete DataRequest }
Dec 16 06:02:13 inquisitive kernel: hdg: drive not ready for command
Dec 16 06:02:13 inquisitive kernel: raid1: hdg1: redirecting sector 274616 to 
another mirror
Dec 16 06:06:11 inquisitive xinetd[1168]: Exiting...
Dec 16 06:15:06 inquisitive kernel: Linux version 2.4.18-17.7.x 
(bhcompile@porky.devel.redhat.com) (gcc version 2.96 20000731 (Red Hat Linux 
7.3 2.96-112)) #1 Tue Oct 8 11:49:30 EDT 2002
Dec 16 06:15:06 inquisitive kernel:  BIOS-e820: 0000000000000000 - 
000000000009fc00 (usable)
Dec 16 06:15:06 inquisitive kernel:  BIOS-e820: 000000000009fc00 - 
00000000000a0000 (reserved)
Dec 16 06:15:06 inquisitive kernel:  BIOS-e820: 00000000000f0000 - 
0000000000100000 (reserved)
Dec 16 06:15:06 inquisitive kernel:  BIOS-e820: 0000000000100000 - 
0000000050000000 (usable)
Dec 16 06:15:06 inquisitive kernel:  BIOS-e820: 00000000ffff0000 - 
0000000100000000 (reserved)
Dec 16 06:15:06 inquisitive kernel: On node 0 totalpages: 327680
Dec 16 06:15:06 inquisitive kernel: zone(0): 4096 pages.
Dec 16 06:15:06 inquisitive kernel: zone(1): 225280 pages.
Dec 16 06:15:07 inquisitive kernel: zone(2): 98304 pages.
Dec 16 06:15:07 inquisitive kernel: Kernel command line: ro root=/dev/md2
Dec 16 06:15:07 inquisitive kernel: Detected 1005.588 MHz processor.
Dec 16 06:15:07 inquisitive kernel: Speakup v-1.00 CVS: Tue Jun 11 14:22:53 
EDT 2002 : initialized
Dec 16 06:15:07 inquisitive kernel: Console: colour VGA+ 80x25
Dec 16 06:15:07 inquisitive kernel: Calibrating delay loop... 1993.77 BogoMIPS
Dec 16 06:15:07 inquisitive kernel: Page-cache hash table entries: 524288 
(order: 9, 2097152 bytes)
Dec 16 06:15:07 inquisitive kernel: CPU: AMD Duron(tm) processor stepping 01
Dec 16 06:15:07 inquisitive kernel: POSIX conformance testing by UNIFIX
Dec 16 06:15:07 inquisitive kernel: mtrr: v1.40 (20010327) Richard Gooch 
(rgooch@atnf.csiro.au)
Dec 16 06:15:07 inquisitive kernel: mtrr: detected mtrr type: Intel
Dec 16 06:15:07 inquisitive kernel: speakup:  initialized device: /dev/synth, 
node (MAJOR 10, MINOR 25)
Dec 16 06:15:07 inquisitive kernel: Initializing RT netlink socket
Dec 16 06:15:07 inquisitive kernel: Starting kswapd
Dec 16 06:15:07 inquisitive kernel: allocated 64 pages and 64 bhs reserved for 
the highmem bounces
Dec 16 06:15:07 inquisitive kernel: pty: 2048 Unix98 ptys configured
Dec 16 06:15:07 inquisitive kernel: block: 1024 slots per queue, batch=256
Dec 16 06:15:07 inquisitive kernel: ide: Assuming 33MHz system bus speed for 
PIO modes; override with idebus=xx
Dec 16 06:15:07 inquisitive kernel: HPT372: IDE controller on PCI bus 00 dev 
70
Dec 16 06:15:07 inquisitive kernel: HPT372: chipset revision 5
Dec 16 06:15:07 inquisitive kernel: HPT372: not 100%% native mode: will probe 
irqs later
Dec 16 06:15:07 inquisitive kernel: HPT37X: using 33MHz PCI clock
Dec 16 06:15:07 inquisitive kernel:     ide2: BM-DMA at 0xd400-0xd407, BIOS 
settings: hde:DMA, hdf:pio
Dec 16 06:15:07 inquisitive kernel:     ide3: BM-DMA at 0xd408-0xd40f, BIOS 
settings: hdg:DMA, hdh:pio
Dec 16 06:15:07 inquisitive kernel: VP_IDE: IDE controller on PCI bus 00 dev 
89
Dec 16 06:15:07 inquisitive kernel: PCI: No IRQ known for interrupt pin A of 
device 00:11.1. Please try using pci=biosirq.
Dec 16 06:15:07 inquisitive kernel: VP_IDE: chipset revision 6
Dec 16 06:15:07 inquisitive kernel: VP_IDE: not 100%% native mode: will probe 
irqs later
Dec 16 06:15:07 inquisitive kernel: ide: Assuming 33MHz system bus speed for 
PIO modes; override with idebus=xx
Dec 16 06:15:07 inquisitive kernel:     ide0: BM-DMA at 0xd800-0xd807, BIOS 
settings: hda:DMA, hdb:DMA
Dec 16 06:15:07 inquisitive kernel:     ide1: BM-DMA at 0xd808-0xd80f, BIOS 
settings: hdc:DMA, hdd:pio
Dec 16 06:15:07 inquisitive kernel: hda: MAXTOR 6L020J1, ATA DISK drive
Dec 16 06:15:07 inquisitive kernel: hdb: IDE/ATAPI CD-ROM 36X, ATAPI 
CD/DVD-ROM drive
Dec 16 06:15:07 inquisitive kernel: hdc: MAXTOR 6L020J1, ATA DISK drive
Dec 16 06:15:07 inquisitive kernel: hde: MAXTOR 6L040L2, ATA DISK drive
Dec 16 06:15:07 inquisitive kernel: hdg: MAXTOR 6L040L2, ATA DISK drive
Dec 16 06:15:07 inquisitive kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Dec 16 06:15:07 inquisitive kernel: ide1 at 0x170-0x177,0x376 on irq 15
Dec 16 06:15:07 inquisitive kernel: ide2 at 0xc400-0xc407,0xc802 on irq 10
Dec 16 06:15:07 inquisitive kernel: ide3 at 0xcc00-0xcc07,0xd002 on irq 10
Dec 16 06:15:07 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 06:15:07 inquisitive kernel: RAMDISK driver initialized: 16 RAM disks 
of 4096K size 1024 blocksize
Dec 16 06:15:07 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 06:15:07 inquisitive kernel: md: superblock update time inconsistency 
-- using the most recent one
Dec 16 06:15:07 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-2, errno = 2
Dec 16 06:15:07 inquisitive kernel: md: personality 2 is not loaded!
Dec 16 06:15:07 inquisitive kernel: md :do_md_run() returned -22
Dec 16 06:15:07 inquisitive kernel: md: superblock update time inconsistency 
-- using the most recent one
Dec 16 06:15:07 inquisitive kernel: md: kicking non-fresh hde1 from array!
Dec 16 06:15:07 inquisitive kernel: md0: removing former faulty hde1!
Dec 16 06:15:07 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-3, errno = 2
Dec 16 06:15:07 inquisitive kernel: md: personality 3 is not loaded!
Dec 16 06:15:07 inquisitive kernel: md :do_md_run() returned -22
Dec 16 06:15:07 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-3, errno = 2
Dec 16 06:15:07 inquisitive kernel: md: personality 3 is not loaded!
Dec 16 06:15:07 inquisitive kernel: md :do_md_run() returned -22
Dec 16 06:15:07 inquisitive kernel: VFS: Mounted root (ext2 filesystem).
Dec 16 06:15:08 inquisitive kernel: md: superblock update time inconsistency 
-- using the most recent one
Dec 16 06:15:08 inquisitive kernel: md: kicking non-fresh hde1 from array!
Dec 16 06:15:08 inquisitive kernel: md0: removing former faulty hde1!
Dec 16 06:15:08 inquisitive kernel: raid1: md0, not all disks are operational 
-- trying to recover array
Dec 16 06:15:08 inquisitive kernel: md0: no spare disk to reconstruct array! 
-- continuing in degraded mode
Dec 16 06:15:08 inquisitive kernel: md: superblock update time inconsistency 
-- using the most recent one
Dec 16 06:15:08 inquisitive kernel: raid0: looking at hde3
Dec 16 06:15:08 inquisitive kernel: raid0:   comparing hde3(19281408) with 
hde3(19281408)
Dec 16 06:15:08 inquisitive kernel: raid0:   END
Dec 16 06:15:08 inquisitive kernel: raid0:   ==> UNIQUE
Dec 16 06:15:08 inquisitive kernel: raid0: 1 zones
Dec 16 06:15:08 inquisitive kernel: raid0: looking at hdg3
Dec 16 06:15:08 inquisitive kernel: raid0:   comparing hdg3(19281408) with 
hde3(19281408)
Dec 16 06:15:08 inquisitive kernel: raid0:   EQUAL
Dec 16 06:15:08 inquisitive kernel: raid0: FINAL 1 zones
Dec 16 06:15:08 inquisitive kernel: raid0: zone 0
Dec 16 06:15:08 inquisitive kernel: raid0: checking hde3 ... contained as 
device 0
Dec 16 06:15:08 inquisitive kernel:   (19281408) is smallest!.
Dec 16 06:15:08 inquisitive kernel: raid0: checking hdg3 ... contained as 
device 1
Dec 16 06:15:08 inquisitive kernel: raid0: zone->nb_dev: 2, size: 38562816
Dec 16 06:15:08 inquisitive kernel: raid0: current zone offset: 19281408
Dec 16 06:15:08 inquisitive kernel: raid0: done.
Dec 16 06:15:08 inquisitive kernel: raid0 : md_size is 38562816 blocks.
Dec 16 06:15:08 inquisitive kernel: raid0 : conf->smallest->size is 38562816 
blocks.
Dec 16 06:15:08 inquisitive kernel: raid0 : nb_zone is 1.
Dec 16 06:15:08 inquisitive kernel: raid0 : Allocating 8 bytes for hash.
Dec 16 06:15:08 inquisitive kernel: usb-uhci.c: Detected 2 ports
Dec 16 06:15:08 inquisitive kernel: usb-uhci.c: Detected 2 ports
Dec 16 06:15:08 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 06:15:08 inquisitive kernel: hdb: ATAPI 16X CD-ROM drive, 128kB Cache
Dec 16 06:15:08 inquisitive kernel: ip_tables: (C) 2000-2002 Netfilter core 
team
Dec 16 06:15:08 inquisitive kernel: ip_conntrack (8192 buckets, 65536 max)
Dec 16 06:15:09 inquisitive xinetd[1168]: Server /usr/sbin/in.rexecd is not 
executable [line=13]
Dec 16 06:15:09 inquisitive xinetd[1168]: Error parsing attribute server - 
DISABLING SERVICE [line=13]
Dec 16 06:15:09 inquisitive xinetd[1168]: Server /usr/sbin/in.rlogind is not 
executable [line=13]
Dec 16 06:15:09 inquisitive xinetd[1168]: Error parsing attribute server - 
DISABLING SERVICE [line=13]
Dec 16 06:15:09 inquisitive xinetd[1168]: Server /usr/sbin/in.rshd is not 
executable [line=14]
Dec 16 06:15:09 inquisitive xinetd[1168]: Error parsing attribute server - 
DISABLING SERVICE [line=14]
Dec 16 06:15:27 inquisitive postfix/postfix-script: warning: 
/var/spool/postfix/etc/resolv.conf and /etc/resolv.conf differ
Dec 16 06:23:37 localhost kernel: Linux version 2.4.18-17.7.x 
(bhcompile@porky.devel.redhat.com) (gcc version 2.96 20000731 (Red Hat Linux 
7.3 2.96-112)) #1 Tue Oct 8 11:49:30 EDT 2002
Dec 16 06:23:37 localhost kernel:  BIOS-e820: 0000000000000000 - 
000000000009fc00 (usable)
Dec 16 06:23:37 localhost kernel:  BIOS-e820: 000000000009fc00 - 
00000000000a0000 (reserved)
Dec 16 06:23:37 localhost kernel:  BIOS-e820: 00000000000f0000 - 
0000000000100000 (reserved)
Dec 16 06:23:37 localhost kernel:  BIOS-e820: 0000000000100000 - 
0000000050000000 (usable)
Dec 16 06:23:37 localhost kernel:  BIOS-e820: 00000000ffff0000 - 
0000000100000000 (reserved)
Dec 16 06:23:37 localhost kernel: On node 0 totalpages: 327680
Dec 16 06:23:37 localhost kernel: zone(0): 4096 pages.
Dec 16 06:23:37 localhost kernel: zone(1): 225280 pages.
Dec 16 06:23:37 localhost kernel: zone(2): 98304 pages.
Dec 16 06:23:37 localhost kernel: Kernel command line: ro root=/dev/md2
Dec 16 06:23:37 localhost kernel: Detected 1005.588 MHz processor.
Dec 16 06:23:37 localhost kernel: Speakup v-1.00 CVS: Tue Jun 11 14:22:53 EDT 
2002 : initialized
Dec 16 06:23:37 localhost kernel: Console: colour VGA+ 80x25
Dec 16 06:23:37 localhost kernel: Calibrating delay loop... 1993.77 BogoMIPS
Dec 16 06:23:38 localhost kernel: Page-cache hash table entries: 524288 
(order: 9, 2097152 bytes)
Dec 16 06:23:38 localhost kernel: CPU: AMD Duron(tm) processor stepping 01
Dec 16 06:23:38 localhost kernel: POSIX conformance testing by UNIFIX
Dec 16 06:23:38 localhost kernel: mtrr: v1.40 (20010327) Richard Gooch 
(rgooch@atnf.csiro.au)
Dec 16 06:23:38 localhost kernel: mtrr: detected mtrr type: Intel
Dec 16 06:23:38 localhost kernel: speakup:  initialized device: /dev/synth, 
node (MAJOR 10, MINOR 25)
Dec 16 06:23:38 localhost kernel: Initializing RT netlink socket
Dec 16 06:23:38 localhost kernel: Starting kswapd
Dec 16 06:23:38 localhost kernel: allocated 64 pages and 64 bhs reserved for 
the highmem bounces
Dec 16 06:23:38 localhost kernel: pty: 2048 Unix98 ptys configured
Dec 16 06:23:38 localhost kernel: block: 1024 slots per queue, batch=256
Dec 16 06:23:38 localhost kernel: ide: Assuming 33MHz system bus speed for PIO 
modes; override with idebus=xx
Dec 16 06:23:38 localhost kernel: HPT372: IDE controller on PCI bus 00 dev 70
Dec 16 06:23:38 localhost kernel: HPT372: chipset revision 5
Dec 16 06:23:38 localhost kernel: HPT372: not 100%% native mode: will probe 
irqs later
Dec 16 06:23:38 localhost kernel: HPT37X: using 33MHz PCI clock
Dec 16 06:23:38 localhost kernel:     ide2: BM-DMA at 0xd400-0xd407, BIOS 
settings: hde:DMA, hdf:pio
Dec 16 06:23:38 localhost kernel:     ide3: BM-DMA at 0xd408-0xd40f, BIOS 
settings: hdg:DMA, hdh:pio
Dec 16 06:23:38 localhost kernel: VP_IDE: IDE controller on PCI bus 00 dev 89
Dec 16 06:23:38 localhost kernel: PCI: No IRQ known for interrupt pin A of 
device 00:11.1. Please try using pci=biosirq.
Dec 16 06:23:38 localhost kernel: VP_IDE: chipset revision 6
Dec 16 06:23:38 localhost kernel: VP_IDE: not 100%% native mode: will probe 
irqs later
Dec 16 06:23:38 localhost kernel: ide: Assuming 33MHz system bus speed for PIO 
modes; override with idebus=xx
Dec 16 06:23:38 localhost kernel:     ide0: BM-DMA at 0xd800-0xd807, BIOS 
settings: hda:DMA, hdb:DMA
Dec 16 06:23:38 localhost kernel:     ide1: BM-DMA at 0xd808-0xd80f, BIOS 
settings: hdc:DMA, hdd:pio
Dec 16 06:23:38 localhost kernel: hda: MAXTOR 6L020J1, ATA DISK drive
Dec 16 06:23:38 localhost kernel: hdb: IDE/ATAPI CD-ROM 36X, ATAPI CD/DVD-ROM 
drive
Dec 16 06:23:38 localhost kernel: hdc: MAXTOR 6L020J1, ATA DISK drive
Dec 16 06:23:38 localhost kernel: hde: MAXTOR 6L040L2, ATA DISK drive
Dec 16 06:23:38 localhost kernel: hdg: MAXTOR 6L040L2, ATA DISK drive
Dec 16 06:23:38 localhost kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Dec 16 06:23:38 localhost kernel: ide1 at 0x170-0x177,0x376 on irq 15
Dec 16 06:23:38 localhost kernel: ide2 at 0xc400-0xc407,0xc802 on irq 10
Dec 16 06:23:38 localhost kernel: ide3 at 0xcc00-0xcc07,0xd002 on irq 10
Dec 16 06:23:38 localhost kernel: ide-floppy driver 0.99.newide
Dec 16 06:23:38 localhost kernel: RAMDISK driver initialized: 16 RAM disks of 
4096K size 1024 blocksize
Dec 16 06:23:38 localhost kernel: ide-floppy driver 0.99.newide
Dec 16 06:23:38 localhost kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-2, errno = 2
Dec 16 06:23:38 localhost kernel: md: personality 2 is not loaded!
Dec 16 06:23:38 localhost kernel: md :do_md_run() returned -22
Dec 16 06:23:38 localhost kernel: md: superblock update time inconsistency -- 
using the most recent one
Dec 16 06:23:38 localhost kernel: md: kicking non-fresh hde1 from array!
Dec 16 06:23:38 localhost kernel: md: md0: raid array is not clean -- starting 
background reconstruction
Dec 16 06:23:38 localhost kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-3, errno = 2
Dec 16 06:23:38 localhost kernel: md: personality 3 is not loaded!
Dec 16 06:23:38 localhost kernel: md :do_md_run() returned -22
Dec 16 06:23:38 localhost kernel: md: md2: raid array is not clean -- starting 
background reconstruction
Dec 16 06:23:38 localhost kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-3, errno = 2
Dec 16 06:23:38 localhost kernel: md: personality 3 is not loaded!
Dec 16 06:23:38 localhost kernel: md :do_md_run() returned -22
Dec 16 06:23:38 localhost kernel: VFS: Mounted root (ext2 filesystem).
Dec 16 06:23:38 localhost kernel: md: md2: raid array is not clean -- starting 
background reconstruction
Dec 16 06:23:38 localhost kernel: raid1: raid set md2 not clean; 
reconstructing mirrors
Dec 16 06:23:38 localhost sshd[932]: error: Bind to port 22 on 192.168.0.2 
failed: Cannot assign requested address.
Dec 16 06:23:38 localhost sshd[932]: fatal: Cannot bind any address.
Dec 16 06:23:39 localhost kernel: md: superblock update time inconsistency -- 
using the most recent one
Dec 16 06:23:39 localhost kernel: md: kicking non-fresh hde1 from array!
Dec 16 06:23:39 localhost kernel: md: md0: raid array is not clean -- starting 
background reconstruction
Dec 16 06:23:39 localhost kernel: raid1: md0, not all disks are operational -- 
trying to recover array
Dec 16 06:23:39 localhost kernel: md0: no spare disk to reconstruct array! -- 
continuing in degraded mode
Dec 16 06:23:39 localhost kernel: raid0: looking at hde3
Dec 16 06:23:39 localhost kernel: raid0:   comparing hde3(19281408) with 
hde3(19281408)
Dec 16 06:23:39 localhost kernel: raid0:   END
Dec 16 06:23:39 localhost kernel: raid0:   ==> UNIQUE
Dec 16 06:23:39 localhost kernel: raid0: 1 zones
Dec 16 06:23:39 localhost kernel: raid0: looking at hdg3
Dec 16 06:23:39 localhost kernel: raid0:   comparing hdg3(19281408) with 
hde3(19281408)
Dec 16 06:23:39 localhost kernel: raid0:   EQUAL
Dec 16 06:23:39 localhost kernel: raid0: FINAL 1 zones
Dec 16 06:23:39 localhost kernel: raid0: zone 0
Dec 16 06:23:39 localhost kernel: raid0: checking hde3 ... contained as device 
0
Dec 16 06:23:39 localhost kernel:   (19281408) is smallest!.
Dec 16 06:23:39 localhost kernel: raid0: checking hdg3 ... contained as device 
1
Dec 16 06:23:39 localhost kernel: raid0: zone->nb_dev: 2, size: 38562816
Dec 16 06:23:39 localhost kernel: raid0: current zone offset: 19281408
Dec 16 06:23:39 localhost kernel: raid0: done.
Dec 16 06:23:39 localhost kernel: raid0 : md_size is 38562816 blocks.
Dec 16 06:23:39 localhost kernel: raid0 : conf->smallest->size is 38562816 
blocks.
Dec 16 06:23:39 localhost kernel: raid0 : nb_zone is 1.
Dec 16 06:23:39 localhost kernel: raid0 : Allocating 8 bytes for hash.
Dec 16 06:23:39 localhost kernel: usb-uhci.c: Detected 2 ports
Dec 16 06:23:39 localhost kernel: usb-uhci.c: Detected 2 ports
Dec 16 06:23:39 localhost kernel: ide-floppy driver 0.99.newide
Dec 16 06:23:39 localhost kernel: hdb: ATAPI 16X CD-ROM drive, 128kB Cache
Dec 16 06:23:39 localhost kernel: ip_tables: (C) 2000-2002 Netfilter core team
Dec 16 06:23:39 localhost kernel: ip_conntrack (8192 buckets, 65536 max)
Dec 16 06:23:39 localhost xinetd[964]: Server /usr/sbin/in.rexecd is not 
executable [line=13]
Dec 16 06:23:39 localhost xinetd[964]: Error parsing attribute server - 
DISABLING SERVICE [line=13]
Dec 16 06:23:39 localhost xinetd[964]: Server /usr/sbin/in.rlogind is not 
executable [line=13]
Dec 16 06:23:39 localhost xinetd[964]: Error parsing attribute server - 
DISABLING SERVICE [line=13]
Dec 16 06:23:39 localhost xinetd[964]: Server /usr/sbin/in.rshd is not 
executable [line=14]
Dec 16 06:23:39 localhost xinetd[964]: Error parsing attribute server - 
DISABLING SERVICE [line=14]
Dec 16 06:23:37 localhost dhcpcd[735]: timed out waiting for a valid DHCP 
server response  
Dec 16 06:23:57 localhost postfix/postfix-script: warning: 
/var/spool/postfix/etc/resolv.conf and /etc/resolv.conf differ
Dec 16 06:24:03 localhost snort: WARNING: OpenPcap() device eth0 network 
lookup:  ^Ieth0: no IPv4 address assigned 
Dec 16 06:24:27 localhost xinetd[964]: Exiting...
Dec 16 06:25:51 inquisitive kernel: Linux version 2.4.18-17.7.x 
(bhcompile@porky.devel.redhat.com) (gcc version 2.96 20000731 (Red Hat Linux 
7.3 2.96-112)) #1 Tue Oct 8 11:49:30 EDT 2002
Dec 16 06:25:51 inquisitive kernel:  BIOS-e820: 0000000000000000 - 
000000000009fc00 (usable)
Dec 16 06:25:51 inquisitive kernel:  BIOS-e820: 000000000009fc00 - 
00000000000a0000 (reserved)
Dec 16 06:25:51 inquisitive kernel:  BIOS-e820: 00000000000f0000 - 
0000000000100000 (reserved)
Dec 16 06:25:51 inquisitive kernel:  BIOS-e820: 0000000000100000 - 
0000000050000000 (usable)
Dec 16 06:25:51 inquisitive kernel:  BIOS-e820: 00000000ffff0000 - 
0000000100000000 (reserved)
Dec 16 06:25:51 inquisitive kernel: On node 0 totalpages: 327680
Dec 16 06:25:51 inquisitive kernel: zone(0): 4096 pages.
Dec 16 06:25:51 inquisitive kernel: zone(1): 225280 pages.
Dec 16 06:25:51 inquisitive kernel: zone(2): 98304 pages.
Dec 16 06:25:51 inquisitive kernel: Kernel command line: ro root=/dev/md2
Dec 16 06:25:51 inquisitive kernel: Detected 1005.588 MHz processor.
Dec 16 06:25:51 inquisitive kernel: Speakup v-1.00 CVS: Tue Jun 11 14:22:53 
EDT 2002 : initialized
Dec 16 06:25:51 inquisitive kernel: Console: colour VGA+ 80x25
Dec 16 06:25:51 inquisitive kernel: Calibrating delay loop... 1993.77 BogoMIPS
Dec 16 06:25:51 inquisitive kernel: Page-cache hash table entries: 524288 
(order: 9, 2097152 bytes)
Dec 16 06:25:51 inquisitive kernel: CPU: AMD Duron(tm) processor stepping 01
Dec 16 06:25:51 inquisitive kernel: POSIX conformance testing by UNIFIX
Dec 16 06:25:51 inquisitive kernel: mtrr: v1.40 (20010327) Richard Gooch 
(rgooch@atnf.csiro.au)
Dec 16 06:25:51 inquisitive kernel: mtrr: detected mtrr type: Intel
Dec 16 06:25:51 inquisitive kernel: speakup:  initialized device: /dev/synth, 
node (MAJOR 10, MINOR 25)
Dec 16 06:25:51 inquisitive kernel: Initializing RT netlink socket
Dec 16 06:25:51 inquisitive kernel: Starting kswapd
Dec 16 06:25:51 inquisitive kernel: allocated 64 pages and 64 bhs reserved for 
the highmem bounces
Dec 16 06:25:51 inquisitive kernel: pty: 2048 Unix98 ptys configured
Dec 16 06:25:51 inquisitive kernel: block: 1024 slots per queue, batch=256
Dec 16 06:25:51 inquisitive kernel: ide: Assuming 33MHz system bus speed for 
PIO modes; override with idebus=xx
Dec 16 06:25:51 inquisitive kernel: HPT372: IDE controller on PCI bus 00 dev 
70
Dec 16 06:25:51 inquisitive kernel: HPT372: chipset revision 5
Dec 16 06:25:52 inquisitive kernel: HPT372: not 100%% native mode: will probe 
irqs later
Dec 16 06:25:52 inquisitive kernel: HPT37X: using 33MHz PCI clock
Dec 16 06:25:52 inquisitive kernel:     ide2: BM-DMA at 0xd400-0xd407, BIOS 
settings: hde:DMA, hdf:pio
Dec 16 06:25:52 inquisitive kernel:     ide3: BM-DMA at 0xd408-0xd40f, BIOS 
settings: hdg:DMA, hdh:pio
Dec 16 06:25:52 inquisitive kernel: VP_IDE: IDE controller on PCI bus 00 dev 
89
Dec 16 06:25:52 inquisitive kernel: PCI: No IRQ known for interrupt pin A of 
device 00:11.1. Please try using pci=biosirq.
Dec 16 06:25:52 inquisitive kernel: VP_IDE: chipset revision 6
Dec 16 06:25:52 inquisitive kernel: VP_IDE: not 100%% native mode: will probe 
irqs later
Dec 16 06:25:52 inquisitive kernel: ide: Assuming 33MHz system bus speed for 
PIO modes; override with idebus=xx
Dec 16 06:25:52 inquisitive kernel:     ide0: BM-DMA at 0xd800-0xd807, BIOS 
settings: hda:DMA, hdb:DMA
Dec 16 06:25:52 inquisitive kernel:     ide1: BM-DMA at 0xd808-0xd80f, BIOS 
settings: hdc:DMA, hdd:pio
Dec 16 06:25:52 inquisitive kernel: hda: MAXTOR 6L020J1, ATA DISK drive
Dec 16 06:25:52 inquisitive kernel: hdb: IDE/ATAPI CD-ROM 36X, ATAPI 
CD/DVD-ROM drive
Dec 16 06:25:52 inquisitive kernel: hdc: MAXTOR 6L020J1, ATA DISK drive
Dec 16 06:25:52 inquisitive kernel: hde: MAXTOR 6L040L2, ATA DISK drive
Dec 16 06:25:52 inquisitive kernel: hdg: MAXTOR 6L040L2, ATA DISK drive
Dec 16 06:25:52 inquisitive kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Dec 16 06:25:52 inquisitive kernel: ide1 at 0x170-0x177,0x376 on irq 15
Dec 16 06:25:52 inquisitive kernel: ide2 at 0xc400-0xc407,0xc802 on irq 10
Dec 16 06:25:52 inquisitive kernel: ide3 at 0xcc00-0xcc07,0xd002 on irq 10
Dec 16 06:25:52 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 06:25:52 inquisitive kernel: RAMDISK driver initialized: 16 RAM disks 
of 4096K size 1024 blocksize
Dec 16 06:25:52 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 06:25:52 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-2, errno = 2
Dec 16 06:25:52 inquisitive kernel: md: personality 2 is not loaded!
Dec 16 06:25:52 inquisitive kernel: md :do_md_run() returned -22
Dec 16 06:25:52 inquisitive kernel: md: superblock update time inconsistency 
-- using the most recent one
Dec 16 06:25:52 inquisitive kernel: md: kicking non-fresh hde1 from array!
Dec 16 06:25:52 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-3, errno = 2
Dec 16 06:25:52 inquisitive kernel: md: personality 3 is not loaded!
Dec 16 06:25:52 inquisitive kernel: md :do_md_run() returned -22
Dec 16 06:25:52 inquisitive kernel: md: md2: raid array is not clean -- 
starting background reconstruction
Dec 16 06:25:52 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-3, errno = 2
Dec 16 06:25:52 inquisitive kernel: md: personality 3 is not loaded!
Dec 16 06:25:52 inquisitive kernel: md :do_md_run() returned -22
Dec 16 06:25:52 inquisitive kernel: VFS: Mounted root (ext2 filesystem).
Dec 16 06:25:52 inquisitive kernel: md: md2: raid array is not clean -- 
starting background reconstruction
Dec 16 06:25:52 inquisitive kernel: raid1: raid set md2 not clean; 
reconstructing mirrors
Dec 16 06:25:53 inquisitive kernel: md: superblock update time inconsistency 
-- using the most recent one
Dec 16 06:25:53 inquisitive kernel: md: kicking non-fresh hde1 from array!
Dec 16 06:25:53 inquisitive kernel: raid1: md0, not all disks are operational 
-- trying to recover array
Dec 16 06:25:53 inquisitive kernel: md0: no spare disk to reconstruct array! 
-- continuing in degraded mode
Dec 16 06:25:53 inquisitive kernel: raid0: looking at hde3
Dec 16 06:25:53 inquisitive kernel: raid0:   comparing hde3(19281408) with 
hde3(19281408)
Dec 16 06:25:53 inquisitive kernel: raid0:   END
Dec 16 06:25:53 inquisitive kernel: raid0:   ==> UNIQUE
Dec 16 06:25:53 inquisitive kernel: raid0: 1 zones
Dec 16 06:25:53 inquisitive kernel: raid0: looking at hdg3
Dec 16 06:25:53 inquisitive kernel: raid0:   comparing hdg3(19281408) with 
hde3(19281408)
Dec 16 06:25:53 inquisitive kernel: raid0:   EQUAL
Dec 16 06:25:53 inquisitive kernel: raid0: FINAL 1 zones
Dec 16 06:25:53 inquisitive kernel: raid0: zone 0
Dec 16 06:25:53 inquisitive kernel: raid0: checking hde3 ... contained as 
device 0
Dec 16 06:25:53 inquisitive kernel:   (19281408) is smallest!.
Dec 16 06:25:53 inquisitive kernel: raid0: checking hdg3 ... contained as 
device 1
Dec 16 06:25:53 inquisitive kernel: raid0: zone->nb_dev: 2, size: 38562816
Dec 16 06:25:53 inquisitive kernel: raid0: current zone offset: 19281408
Dec 16 06:25:53 inquisitive kernel: raid0: done.
Dec 16 06:25:53 inquisitive kernel: raid0 : md_size is 38562816 blocks.
Dec 16 06:25:53 inquisitive kernel: raid0 : conf->smallest->size is 38562816 
blocks.
Dec 16 06:25:53 inquisitive kernel: raid0 : nb_zone is 1.
Dec 16 06:25:53 inquisitive kernel: raid0 : Allocating 8 bytes for hash.
Dec 16 06:25:53 inquisitive kernel: usb-uhci.c: Detected 2 ports
Dec 16 06:25:53 inquisitive kernel: usb-uhci.c: Detected 2 ports
Dec 16 06:25:53 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 06:25:53 inquisitive kernel: hdb: ATAPI 16X CD-ROM drive, 128kB Cache
Dec 16 06:25:53 inquisitive kernel: ip_tables: (C) 2000-2002 Netfilter core 
team
Dec 16 06:25:53 inquisitive kernel: ip_conntrack (8192 buckets, 65536 max)
Dec 16 06:25:53 inquisitive xinetd[1169]: Server /usr/sbin/in.rexecd is not 
executable [line=13]
Dec 16 06:25:53 inquisitive xinetd[1169]: Error parsing attribute server - 
DISABLING SERVICE [line=13]
Dec 16 06:25:53 inquisitive xinetd[1169]: Server /usr/sbin/in.rlogind is not 
executable [line=13]
Dec 16 06:25:53 inquisitive xinetd[1169]: Error parsing attribute server - 
DISABLING SERVICE [line=13]
Dec 16 06:25:53 inquisitive xinetd[1169]: Server /usr/sbin/in.rshd is not 
executable [line=14]
Dec 16 06:25:53 inquisitive xinetd[1169]: Error parsing attribute server - 
DISABLING SERVICE [line=14]
Dec 16 06:26:13 inquisitive postfix/postfix-script: warning: 
/var/spool/postfix/etc/resolv.conf and /etc/resolv.conf differ
Dec 16 15:51:06 inquisitive mc: /dev/gpmctl: No such file or directory
Dec 16 15:56:50 inquisitive modprobe: modprobe: Can't locate module 
char-major-81
Dec 16 15:57:11 inquisitive modprobe: modprobe: Can't locate module 
sound-slot-0
Dec 16 15:57:11 inquisitive modprobe: modprobe: Can't locate module 
sound-service-0-3
Dec 16 16:03:19 inquisitive xinetd[1169]: Exiting...
Dec 16 16:04:40 inquisitive kernel: Linux version 2.4.18-17.7.x 
(bhcompile@porky.devel.redhat.com) (gcc version 2.96 20000731 (Red Hat Linux 
7.3 2.96-112)) #1 Tue Oct 8 11:49:30 EDT 2002
Dec 16 16:04:40 inquisitive kernel:  BIOS-e820: 0000000000000000 - 
000000000009fc00 (usable)
Dec 16 16:04:40 inquisitive kernel:  BIOS-e820: 000000000009fc00 - 
00000000000a0000 (reserved)
Dec 16 16:04:40 inquisitive kernel:  BIOS-e820: 00000000000f0000 - 
0000000000100000 (reserved)
Dec 16 16:04:40 inquisitive kernel:  BIOS-e820: 0000000000100000 - 
0000000050000000 (usable)
Dec 16 16:04:40 inquisitive kernel:  BIOS-e820: 00000000ffff0000 - 
0000000100000000 (reserved)
Dec 16 16:04:40 inquisitive kernel: On node 0 totalpages: 327680
Dec 16 16:04:40 inquisitive kernel: zone(0): 4096 pages.
Dec 16 16:04:40 inquisitive kernel: zone(1): 225280 pages.
Dec 16 16:04:40 inquisitive kernel: zone(2): 98304 pages.
Dec 16 16:04:40 inquisitive kernel: Kernel command line: ro root=/dev/md2
Dec 16 16:04:40 inquisitive kernel: Detected 1005.588 MHz processor.
Dec 16 16:04:40 inquisitive kernel: Speakup v-1.00 CVS: Tue Jun 11 14:22:53 
EDT 2002 : initialized
Dec 16 16:04:40 inquisitive kernel: Console: colour VGA+ 80x25
Dec 16 16:04:40 inquisitive kernel: Calibrating delay loop... 1993.77 BogoMIPS
Dec 16 16:04:40 inquisitive kernel: Page-cache hash table entries: 524288 
(order: 9, 2097152 bytes)
Dec 16 16:04:40 inquisitive kernel: CPU: AMD Duron(tm) processor stepping 01
Dec 16 16:04:40 inquisitive kernel: POSIX conformance testing by UNIFIX
Dec 16 16:04:40 inquisitive kernel: mtrr: v1.40 (20010327) Richard Gooch 
(rgooch@atnf.csiro.au)
Dec 16 16:04:40 inquisitive kernel: mtrr: detected mtrr type: Intel
Dec 16 16:04:40 inquisitive kernel: speakup:  initialized device: /dev/synth, 
node (MAJOR 10, MINOR 25)
Dec 16 16:04:40 inquisitive kernel: Initializing RT netlink socket
Dec 16 16:04:40 inquisitive kernel: Starting kswapd
Dec 16 16:04:40 inquisitive kernel: allocated 64 pages and 64 bhs reserved for 
the highmem bounces
Dec 16 16:04:40 inquisitive kernel: pty: 2048 Unix98 ptys configured
Dec 16 16:04:40 inquisitive kernel: block: 1024 slots per queue, batch=256
Dec 16 16:04:40 inquisitive kernel: ide: Assuming 33MHz system bus speed for 
PIO modes; override with idebus=xx
Dec 16 16:04:40 inquisitive kernel: HPT372: IDE controller on PCI bus 00 dev 
70
Dec 16 16:04:40 inquisitive kernel: HPT372: chipset revision 5
Dec 16 16:04:40 inquisitive kernel: HPT372: not 100%% native mode: will probe 
irqs later
Dec 16 16:04:40 inquisitive kernel: HPT37X: using 33MHz PCI clock
Dec 16 16:04:40 inquisitive kernel:     ide2: BM-DMA at 0xd400-0xd407, BIOS 
settings: hde:DMA, hdf:pio
Dec 16 16:04:40 inquisitive kernel:     ide3: BM-DMA at 0xd408-0xd40f, BIOS 
settings: hdg:DMA, hdh:pio
Dec 16 16:04:41 inquisitive kernel: VP_IDE: IDE controller on PCI bus 00 dev 
89
Dec 16 16:04:41 inquisitive kernel: PCI: No IRQ known for interrupt pin A of 
device 00:11.1. Please try using pci=biosirq.
Dec 16 16:04:41 inquisitive kernel: VP_IDE: chipset revision 6
Dec 16 16:04:41 inquisitive kernel: VP_IDE: not 100%% native mode: will probe 
irqs later
Dec 16 16:04:41 inquisitive kernel: ide: Assuming 33MHz system bus speed for 
PIO modes; override with idebus=xx
Dec 16 16:04:41 inquisitive kernel:     ide0: BM-DMA at 0xd800-0xd807, BIOS 
settings: hda:DMA, hdb:DMA
Dec 16 16:04:41 inquisitive kernel:     ide1: BM-DMA at 0xd808-0xd80f, BIOS 
settings: hdc:DMA, hdd:pio
Dec 16 16:04:41 inquisitive kernel: hda: MAXTOR 6L020J1, ATA DISK drive
Dec 16 16:04:41 inquisitive kernel: hdb: IDE/ATAPI CD-ROM 36X, ATAPI 
CD/DVD-ROM drive
Dec 16 16:04:41 inquisitive kernel: hdc: MAXTOR 6L020J1, ATA DISK drive
Dec 16 16:04:41 inquisitive kernel: hde: MAXTOR 6L040L2, ATA DISK drive
Dec 16 16:04:41 inquisitive kernel: hdg: MAXTOR 6L040L2, ATA DISK drive
Dec 16 16:04:41 inquisitive kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Dec 16 16:04:41 inquisitive kernel: ide1 at 0x170-0x177,0x376 on irq 15
Dec 16 16:04:41 inquisitive kernel: ide2 at 0xc400-0xc407,0xc802 on irq 10
Dec 16 16:04:41 inquisitive kernel: ide3 at 0xcc00-0xcc07,0xd002 on irq 10
Dec 16 16:04:41 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 16:04:41 inquisitive kernel: RAMDISK driver initialized: 16 RAM disks 
of 4096K size 1024 blocksize
Dec 16 16:04:41 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 16:04:41 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-2, errno = 2
Dec 16 16:04:41 inquisitive kernel: md: personality 2 is not loaded!
Dec 16 16:04:41 inquisitive kernel: md :do_md_run() returned -22
Dec 16 16:04:41 inquisitive kernel: md: superblock update time inconsistency 
-- using the most recent one
Dec 16 16:04:41 inquisitive kernel: md: kicking non-fresh hde1 from array!
Dec 16 16:04:41 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-3, errno = 2
Dec 16 16:04:41 inquisitive kernel: md: personality 3 is not loaded!
Dec 16 16:04:41 inquisitive kernel: md :do_md_run() returned -22
Dec 16 16:04:41 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-3, errno = 2
Dec 16 16:04:41 inquisitive kernel: md: personality 3 is not loaded!
Dec 16 16:04:41 inquisitive kernel: md :do_md_run() returned -22
Dec 16 16:04:41 inquisitive kernel: VFS: Mounted root (ext2 filesystem).
Dec 16 16:04:41 inquisitive kernel: md: superblock update time inconsistency 
-- using the most recent one
Dec 16 16:04:41 inquisitive kernel: md: kicking non-fresh hde1 from array!
Dec 16 16:04:41 inquisitive kernel: raid1: md0, not all disks are operational 
-- trying to recover array
Dec 16 16:04:41 inquisitive kernel: md0: no spare disk to reconstruct array! 
-- continuing in degraded mode
Dec 16 16:04:41 inquisitive kernel: raid0: looking at hde3
Dec 16 16:04:41 inquisitive kernel: raid0:   comparing hde3(19281408) with 
hde3(19281408)
Dec 16 16:04:41 inquisitive kernel: raid0:   END
Dec 16 16:04:41 inquisitive kernel: raid0:   ==> UNIQUE
Dec 16 16:04:41 inquisitive kernel: raid0: 1 zones
Dec 16 16:04:41 inquisitive kernel: raid0: looking at hdg3
Dec 16 16:04:41 inquisitive kernel: raid0:   comparing hdg3(19281408) with 
hde3(19281408)
Dec 16 16:04:41 inquisitive kernel: raid0:   EQUAL
Dec 16 16:04:41 inquisitive kernel: raid0: FINAL 1 zones
Dec 16 16:04:41 inquisitive kernel: raid0: zone 0
Dec 16 16:04:41 inquisitive kernel: raid0: checking hde3 ... contained as 
device 0
Dec 16 16:04:41 inquisitive kernel:   (19281408) is smallest!.
Dec 16 16:04:41 inquisitive kernel: raid0: checking hdg3 ... contained as 
device 1
Dec 16 16:04:41 inquisitive kernel: raid0: zone->nb_dev: 2, size: 38562816
Dec 16 16:04:41 inquisitive kernel: raid0: current zone offset: 19281408
Dec 16 16:04:41 inquisitive kernel: raid0: done.
Dec 16 16:04:41 inquisitive kernel: raid0 : md_size is 38562816 blocks.
Dec 16 16:04:41 inquisitive kernel: raid0 : conf->smallest->size is 38562816 
blocks.
Dec 16 16:04:41 inquisitive kernel: raid0 : nb_zone is 1.
Dec 16 16:04:41 inquisitive kernel: raid0 : Allocating 8 bytes for hash.
Dec 16 16:04:42 inquisitive kernel: usb-uhci.c: Detected 2 ports
Dec 16 16:04:42 inquisitive kernel: usb-uhci.c: Detected 2 ports
Dec 16 16:04:42 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 16:04:42 inquisitive kernel: hdb: ATAPI 16X CD-ROM drive, 128kB Cache
Dec 16 16:04:42 inquisitive kernel: ip_tables: (C) 2000-2002 Netfilter core 
team
Dec 16 16:04:42 inquisitive kernel: ip_conntrack (8192 buckets, 65536 max)
Dec 16 16:04:42 inquisitive xinetd[1168]: Server /usr/sbin/in.rexecd is not 
executable [line=13]
Dec 16 16:04:42 inquisitive xinetd[1168]: Error parsing attribute server - 
DISABLING SERVICE [line=13]
Dec 16 16:04:42 inquisitive xinetd[1168]: Server /usr/sbin/in.rlogind is not 
executable [line=13]
Dec 16 16:04:42 inquisitive xinetd[1168]: Error parsing attribute server - 
DISABLING SERVICE [line=13]
Dec 16 16:04:42 inquisitive xinetd[1168]: Server /usr/sbin/in.rshd is not 
executable [line=14]
Dec 16 16:04:42 inquisitive xinetd[1168]: Error parsing attribute server - 
DISABLING SERVICE [line=14]
Dec 16 16:05:00 inquisitive postfix/postfix-script: warning: 
/var/spool/postfix/etc/resolv.conf and /etc/resolv.conf differ
Dec 16 16:07:10 inquisitive modprobe: modprobe: Can't locate module 
char-major-81
Dec 16 16:07:30 inquisitive modprobe: modprobe: Can't locate module 
sound-slot-0
Dec 16 16:07:30 inquisitive modprobe: modprobe: Can't locate module 
sound-service-0-3
Dec 16 16:36:35 inquisitive kernel: Linux version 2.4.18-17.7.x 
(bhcompile@porky.devel.redhat.com) (gcc version 2.96 20000731 (Red Hat Linux 
7.3 2.96-112)) #1 Tue Oct 8 11:49:30 EDT 2002
Dec 16 16:36:35 inquisitive kernel:  BIOS-e820: 0000000000000000 - 
000000000009fc00 (usable)
Dec 16 16:36:35 inquisitive kernel:  BIOS-e820: 000000000009fc00 - 
00000000000a0000 (reserved)
Dec 16 16:36:35 inquisitive kernel:  BIOS-e820: 00000000000f0000 - 
0000000000100000 (reserved)
Dec 16 16:36:35 inquisitive kernel:  BIOS-e820: 0000000000100000 - 
0000000050000000 (usable)
Dec 16 16:36:35 inquisitive kernel:  BIOS-e820: 00000000ffff0000 - 
0000000100000000 (reserved)
Dec 16 16:36:35 inquisitive kernel: On node 0 totalpages: 327680
Dec 16 16:36:35 inquisitive kernel: zone(0): 4096 pages.
Dec 16 16:36:35 inquisitive kernel: zone(1): 225280 pages.
Dec 16 16:36:35 inquisitive kernel: zone(2): 98304 pages.
Dec 16 16:36:35 inquisitive kernel: Kernel command line: ro root=/dev/md2
Dec 16 16:36:35 inquisitive kernel: Detected 1005.588 MHz processor.
Dec 16 16:36:35 inquisitive kernel: Speakup v-1.00 CVS: Tue Jun 11 14:22:53 
EDT 2002 : initialized
Dec 16 16:36:35 inquisitive kernel: Console: colour VGA+ 80x25
Dec 16 16:36:35 inquisitive kernel: Calibrating delay loop... 1993.77 BogoMIPS
Dec 16 16:36:35 inquisitive kernel: Page-cache hash table entries: 524288 
(order: 9, 2097152 bytes)
Dec 16 16:36:35 inquisitive kernel: CPU: AMD Duron(tm) processor stepping 01
Dec 16 16:36:35 inquisitive kernel: POSIX conformance testing by UNIFIX
Dec 16 16:36:35 inquisitive kernel: mtrr: v1.40 (20010327) Richard Gooch 
(rgooch@atnf.csiro.au)
Dec 16 16:36:35 inquisitive kernel: mtrr: detected mtrr type: Intel
Dec 16 16:36:35 inquisitive kernel: speakup:  initialized device: /dev/synth, 
node (MAJOR 10, MINOR 25)
Dec 16 16:36:35 inquisitive kernel: Initializing RT netlink socket
Dec 16 16:36:35 inquisitive kernel: Starting kswapd
Dec 16 16:36:35 inquisitive kernel: allocated 64 pages and 64 bhs reserved for 
the highmem bounces
Dec 16 16:36:35 inquisitive kernel: pty: 2048 Unix98 ptys configured
Dec 16 16:36:35 inquisitive kernel: block: 1024 slots per queue, batch=256
Dec 16 16:36:35 inquisitive kernel: ide: Assuming 33MHz system bus speed for 
PIO modes; override with idebus=xx
Dec 16 16:36:35 inquisitive kernel: HPT372: IDE controller on PCI bus 00 dev 
70
Dec 16 16:36:35 inquisitive kernel: HPT372: chipset revision 5
Dec 16 16:36:35 inquisitive kernel: HPT372: not 100%% native mode: will probe 
irqs later
Dec 16 16:36:35 inquisitive kernel: HPT37X: using 33MHz PCI clock
Dec 16 16:36:35 inquisitive kernel:     ide2: BM-DMA at 0xd400-0xd407, BIOS 
settings: hde:DMA, hdf:pio
Dec 16 16:36:35 inquisitive kernel:     ide3: BM-DMA at 0xd408-0xd40f, BIOS 
settings: hdg:DMA, hdh:pio
Dec 16 16:36:35 inquisitive kernel: VP_IDE: IDE controller on PCI bus 00 dev 
89
Dec 16 16:36:35 inquisitive kernel: PCI: No IRQ known for interrupt pin A of 
device 00:11.1. Please try using pci=biosirq.
Dec 16 16:36:35 inquisitive kernel: VP_IDE: chipset revision 6
Dec 16 16:36:35 inquisitive kernel: VP_IDE: not 100%% native mode: will probe 
irqs later
Dec 16 16:36:35 inquisitive kernel: ide: Assuming 33MHz system bus speed for 
PIO modes; override with idebus=xx
Dec 16 16:36:35 inquisitive kernel:     ide0: BM-DMA at 0xd800-0xd807, BIOS 
settings: hda:DMA, hdb:DMA
Dec 16 16:36:35 inquisitive kernel:     ide1: BM-DMA at 0xd808-0xd80f, BIOS 
settings: hdc:DMA, hdd:pio
Dec 16 16:36:35 inquisitive kernel: hda: MAXTOR 6L020J1, ATA DISK drive
Dec 16 16:36:35 inquisitive kernel: hdb: IDE/ATAPI CD-ROM 36X, ATAPI 
CD/DVD-ROM drive
Dec 16 16:36:35 inquisitive kernel: hdc: MAXTOR 6L020J1, ATA DISK drive
Dec 16 16:36:35 inquisitive kernel: hde: MAXTOR 6L040L2, ATA DISK drive
Dec 16 16:36:35 inquisitive kernel: hdg: MAXTOR 6L040L2, ATA DISK drive
Dec 16 16:36:35 inquisitive kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Dec 16 16:36:35 inquisitive kernel: ide1 at 0x170-0x177,0x376 on irq 15
Dec 16 16:36:35 inquisitive kernel: ide2 at 0xc400-0xc407,0xc802 on irq 10
Dec 16 16:36:35 inquisitive kernel: ide3 at 0xcc00-0xcc07,0xd002 on irq 10
Dec 16 16:36:35 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 16:36:35 inquisitive kernel: RAMDISK driver initialized: 16 RAM disks 
of 4096K size 1024 blocksize
Dec 16 16:36:35 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 16:36:35 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-2, errno = 2
Dec 16 16:36:35 inquisitive kernel: md: personality 2 is not loaded!
Dec 16 16:36:35 inquisitive kernel: md :do_md_run() returned -22
Dec 16 16:36:35 inquisitive kernel: md: superblock update time inconsistency 
-- using the most recent one
Dec 16 16:36:35 inquisitive kernel: md: kicking non-fresh hde1 from array!
Dec 16 16:36:35 inquisitive kernel: md: md0: raid array is not clean -- 
starting background reconstruction
Dec 16 16:36:35 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-3, errno = 2
Dec 16 16:36:35 inquisitive kernel: md: personality 3 is not loaded!
Dec 16 16:36:35 inquisitive kernel: md :do_md_run() returned -22
Dec 16 16:36:36 inquisitive kernel: md: md2: raid array is not clean -- 
starting background reconstruction
Dec 16 16:36:36 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-3, errno = 2
Dec 16 16:36:36 inquisitive kernel: md: personality 3 is not loaded!
Dec 16 16:36:36 inquisitive kernel: md :do_md_run() returned -22
Dec 16 16:36:36 inquisitive kernel: VFS: Mounted root (ext2 filesystem).
Dec 16 16:36:36 inquisitive kernel: md: md2: raid array is not clean -- 
starting background reconstruction
Dec 16 16:36:36 inquisitive kernel: raid1: raid set md2 not clean; 
reconstructing mirrors
Dec 16 16:36:36 inquisitive kernel: md: superblock update time inconsistency 
-- using the most recent one
Dec 16 16:36:36 inquisitive kernel: md: kicking non-fresh hde1 from array!
Dec 16 16:36:36 inquisitive kernel: md: md0: raid array is not clean -- 
starting background reconstruction
Dec 16 16:36:36 inquisitive kernel: raid1: md0, not all disks are operational 
-- trying to recover array
Dec 16 16:36:36 inquisitive kernel: md0: no spare disk to reconstruct array! 
-- continuing in degraded mode
Dec 16 16:36:36 inquisitive kernel: raid0: looking at hde3
Dec 16 16:36:36 inquisitive kernel: raid0:   comparing hde3(19281408) with 
hde3(19281408)
Dec 16 16:36:36 inquisitive kernel: raid0:   END
Dec 16 16:36:36 inquisitive kernel: raid0:   ==> UNIQUE
Dec 16 16:36:36 inquisitive kernel: raid0: 1 zones
Dec 16 16:36:36 inquisitive kernel: raid0: looking at hdg3
Dec 16 16:36:36 inquisitive kernel: raid0:   comparing hdg3(19281408) with 
hde3(19281408)
Dec 16 16:36:36 inquisitive kernel: raid0:   EQUAL
Dec 16 16:36:36 inquisitive kernel: raid0: FINAL 1 zones
Dec 16 16:36:36 inquisitive kernel: raid0: zone 0
Dec 16 16:36:36 inquisitive kernel: raid0: checking hde3 ... contained as 
device 0
Dec 16 16:36:36 inquisitive kernel:   (19281408) is smallest!.
Dec 16 16:36:36 inquisitive kernel: raid0: checking hdg3 ... contained as 
device 1
Dec 16 16:36:36 inquisitive kernel: raid0: zone->nb_dev: 2, size: 38562816
Dec 16 16:36:36 inquisitive kernel: raid0: current zone offset: 19281408
Dec 16 16:36:36 inquisitive kernel: raid0: done.
Dec 16 16:36:36 inquisitive kernel: raid0 : md_size is 38562816 blocks.
Dec 16 16:36:36 inquisitive kernel: raid0 : conf->smallest->size is 38562816 
blocks.
Dec 16 16:36:36 inquisitive kernel: raid0 : nb_zone is 1.
Dec 16 16:36:36 inquisitive kernel: raid0 : Allocating 8 bytes for hash.
Dec 16 16:36:37 inquisitive kernel: usb-uhci.c: Detected 2 ports
Dec 16 16:36:37 inquisitive kernel: usb-uhci.c: Detected 2 ports
Dec 16 16:36:37 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 16:36:37 inquisitive kernel: hdb: ATAPI 16X CD-ROM drive, 128kB Cache
Dec 16 16:36:37 inquisitive kernel: ip_tables: (C) 2000-2002 Netfilter core 
team
Dec 16 16:36:37 inquisitive kernel: ip_conntrack (8192 buckets, 65536 max)
Dec 16 16:36:38 inquisitive xinetd[1184]: Server /usr/sbin/in.rexecd is not 
executable [line=13]
Dec 16 16:36:38 inquisitive xinetd[1184]: Error parsing attribute server - 
DISABLING SERVICE [line=13]
Dec 16 16:36:38 inquisitive xinetd[1184]: Server /usr/sbin/in.rlogind is not 
executable [line=13]
Dec 16 16:36:38 inquisitive xinetd[1184]: Error parsing attribute server - 
DISABLING SERVICE [line=13]
Dec 16 16:36:38 inquisitive xinetd[1184]: Server /usr/sbin/in.rshd is not 
executable [line=14]
Dec 16 16:36:38 inquisitive xinetd[1184]: Error parsing attribute server - 
DISABLING SERVICE [line=14]
Dec 16 16:36:56 inquisitive postfix/postfix-script: warning: 
/var/spool/postfix/etc/resolv.conf and /etc/resolv.conf differ
Dec 16 16:39:42 inquisitive login(pam_unix)[2388]: bad username [ root]
Dec 16 16:39:46 inquisitive login(pam_unix)[2388]: check pass; user unknown
Dec 16 16:41:59 inquisitive modprobe: modprobe: Can't locate module 
char-major-81
Dec 16 16:42:23 inquisitive insmod: 
/lib/modules/2.4.18-17.7.x/kernel/drivers/sound/via82cxxx_audio.o: 
init_module: No such device
Dec 16 16:42:23 inquisitive insmod: 
/lib/modules/2.4.18-17.7.x/kernel/drivers/sound/via82cxxx_audio.o: insmod 
sound-slot-0 failed
Dec 16 16:42:23 inquisitive modprobe: modprobe: Can't locate module 
sound-service-0-3
Dec 16 17:43:44 inquisitive kernel: Linux version 2.4.18-17.7.x 
(bhcompile@porky.devel.redhat.com) (gcc version 2.96 20000731 (Red Hat Linux 
7.3 2.96-112)) #1 Tue Oct 8 11:49:30 EDT 2002
Dec 16 17:43:44 inquisitive kernel:  BIOS-e820: 0000000000000000 - 
000000000009fc00 (usable)
Dec 16 17:43:44 inquisitive kernel:  BIOS-e820: 000000000009fc00 - 
00000000000a0000 (reserved)
Dec 16 17:43:44 inquisitive kernel:  BIOS-e820: 00000000000f0000 - 
0000000000100000 (reserved)
Dec 16 17:43:44 inquisitive kernel:  BIOS-e820: 0000000000100000 - 
0000000050000000 (usable)
Dec 16 17:43:44 inquisitive kernel:  BIOS-e820: 00000000ffff0000 - 
0000000100000000 (reserved)
Dec 16 17:43:44 inquisitive kernel: On node 0 totalpages: 327680
Dec 16 17:43:44 inquisitive kernel: zone(0): 4096 pages.
Dec 16 17:43:44 inquisitive kernel: zone(1): 225280 pages.
Dec 16 17:43:44 inquisitive kernel: zone(2): 98304 pages.
Dec 16 17:43:44 inquisitive kernel: Kernel command line: ro root=/dev/md2
Dec 16 17:43:44 inquisitive kernel: Detected 1005.588 MHz processor.
Dec 16 17:43:44 inquisitive kernel: Speakup v-1.00 CVS: Tue Jun 11 14:22:53 
EDT 2002 : initialized
Dec 16 17:43:44 inquisitive kernel: Console: colour VGA+ 80x25
Dec 16 17:43:44 inquisitive kernel: Calibrating delay loop... 1993.77 BogoMIPS
Dec 16 17:43:44 inquisitive kernel: Page-cache hash table entries: 524288 
(order: 9, 2097152 bytes)
Dec 16 17:43:44 inquisitive kernel: CPU: AMD Duron(tm) processor stepping 01
Dec 16 17:43:44 inquisitive kernel: POSIX conformance testing by UNIFIX
Dec 16 17:43:44 inquisitive kernel: mtrr: v1.40 (20010327) Richard Gooch 
(rgooch@atnf.csiro.au)
Dec 16 17:43:44 inquisitive kernel: mtrr: detected mtrr type: Intel
Dec 16 17:43:44 inquisitive kernel: speakup:  initialized device: /dev/synth, 
node (MAJOR 10, MINOR 25)
Dec 16 17:43:44 inquisitive kernel: Initializing RT netlink socket
Dec 16 17:43:44 inquisitive kernel: Starting kswapd
Dec 16 17:43:44 inquisitive kernel: allocated 64 pages and 64 bhs reserved for 
the highmem bounces
Dec 16 17:43:44 inquisitive kernel: pty: 2048 Unix98 ptys configured
Dec 16 17:43:44 inquisitive kernel: block: 1024 slots per queue, batch=256
Dec 16 17:43:44 inquisitive kernel: ide: Assuming 33MHz system bus speed for 
PIO modes; override with idebus=xx
Dec 16 17:43:44 inquisitive kernel: HPT372: IDE controller on PCI bus 00 dev 
70
Dec 16 17:43:44 inquisitive kernel: HPT372: chipset revision 5
Dec 16 17:43:44 inquisitive kernel: HPT372: not 100%% native mode: will probe 
irqs later
Dec 16 17:43:44 inquisitive kernel: HPT37X: using 33MHz PCI clock
Dec 16 17:43:44 inquisitive kernel:     ide2: BM-DMA at 0xd400-0xd407, BIOS 
settings: hde:DMA, hdf:pio
Dec 16 17:43:44 inquisitive kernel:     ide3: BM-DMA at 0xd408-0xd40f, BIOS 
settings: hdg:DMA, hdh:pio
Dec 16 17:43:44 inquisitive kernel: VP_IDE: IDE controller on PCI bus 00 dev 
89
Dec 16 17:43:44 inquisitive kernel: PCI: No IRQ known for interrupt pin A of 
device 00:11.1. Please try using pci=biosirq.
Dec 16 17:43:44 inquisitive kernel: VP_IDE: chipset revision 6
Dec 16 17:43:44 inquisitive kernel: VP_IDE: not 100%% native mode: will probe 
irqs later
Dec 16 17:43:44 inquisitive kernel: ide: Assuming 33MHz system bus speed for 
PIO modes; override with idebus=xx
Dec 16 17:43:44 inquisitive kernel:     ide0: BM-DMA at 0xd800-0xd807, BIOS 
settings: hda:DMA, hdb:DMA
Dec 16 17:43:44 inquisitive kernel:     ide1: BM-DMA at 0xd808-0xd80f, BIOS 
settings: hdc:DMA, hdd:pio
Dec 16 17:43:44 inquisitive kernel: hda: MAXTOR 6L020J1, ATA DISK drive
Dec 16 17:43:44 inquisitive kernel: hdb: IDE/ATAPI CD-ROM 36X, ATAPI 
CD/DVD-ROM drive
Dec 16 17:43:44 inquisitive kernel: hdc: MAXTOR 6L020J1, ATA DISK drive
Dec 16 17:43:44 inquisitive kernel: hde: MAXTOR 6L040L2, ATA DISK drive
Dec 16 17:43:44 inquisitive kernel: hdg: MAXTOR 6L040L2, ATA DISK drive
Dec 16 17:43:44 inquisitive kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Dec 16 17:43:44 inquisitive kernel: ide1 at 0x170-0x177,0x376 on irq 15
Dec 16 17:43:44 inquisitive kernel: ide2 at 0xc400-0xc407,0xc802 on irq 10
Dec 16 17:43:44 inquisitive kernel: ide3 at 0xcc00-0xcc07,0xd002 on irq 10
Dec 16 17:43:44 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 17:43:44 inquisitive kernel: RAMDISK driver initialized: 16 RAM disks 
of 4096K size 1024 blocksize
Dec 16 17:43:44 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 17:43:44 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-2, errno = 2
Dec 16 17:43:44 inquisitive kernel: md: personality 2 is not loaded!
Dec 16 17:43:44 inquisitive kernel: md :do_md_run() returned -22
Dec 16 17:43:44 inquisitive kernel: md: superblock update time inconsistency 
-- using the most recent one
Dec 16 17:43:44 inquisitive kernel: md: kicking non-fresh hde1 from array!
Dec 16 17:43:44 inquisitive kernel: md: md0: raid array is not clean -- 
starting background reconstruction
Dec 16 17:43:44 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-3, errno = 2
Dec 16 17:43:44 inquisitive kernel: md: personality 3 is not loaded!
Dec 16 17:43:44 inquisitive kernel: md :do_md_run() returned -22
Dec 16 17:43:45 inquisitive kernel: md: md2: raid array is not clean -- 
starting background reconstruction
Dec 16 17:43:45 inquisitive kernel: kmod: failed to exec /sbin/modprobe -s -k 
md-personality-3, errno = 2
Dec 16 17:43:45 inquisitive kernel: md: personality 3 is not loaded!
Dec 16 17:43:45 inquisitive kernel: md :do_md_run() returned -22
Dec 16 17:43:45 inquisitive kernel: VFS: Mounted root (ext2 filesystem).
Dec 16 17:43:45 inquisitive kernel: md: md2: raid array is not clean -- 
starting background reconstruction
Dec 16 17:43:45 inquisitive kernel: raid1: raid set md2 not clean; 
reconstructing mirrors
Dec 16 17:43:45 inquisitive kernel: md: superblock update time inconsistency 
-- using the most recent one
Dec 16 17:43:45 inquisitive kernel: md: kicking non-fresh hde1 from array!
Dec 16 17:43:45 inquisitive kernel: md: md0: raid array is not clean -- 
starting background reconstruction
Dec 16 17:43:45 inquisitive kernel: raid1: md0, not all disks are operational 
-- trying to recover array
Dec 16 17:43:45 inquisitive kernel: md0: no spare disk to reconstruct array! 
-- continuing in degraded mode
Dec 16 17:43:45 inquisitive kernel: raid0: looking at hde3
Dec 16 17:43:45 inquisitive kernel: raid0:   comparing hde3(19281408) with 
hde3(19281408)
Dec 16 17:43:45 inquisitive kernel: raid0:   END
Dec 16 17:43:45 inquisitive kernel: raid0:   ==> UNIQUE
Dec 16 17:43:45 inquisitive kernel: raid0: 1 zones
Dec 16 17:43:45 inquisitive kernel: raid0: looking at hdg3
Dec 16 17:43:45 inquisitive kernel: raid0:   comparing hdg3(19281408) with 
hde3(19281408)
Dec 16 17:43:45 inquisitive kernel: raid0:   EQUAL
Dec 16 17:43:45 inquisitive kernel: raid0: FINAL 1 zones
Dec 16 17:43:45 inquisitive kernel: raid0: zone 0
Dec 16 17:43:45 inquisitive kernel: raid0: checking hde3 ... contained as 
device 0
Dec 16 17:43:45 inquisitive kernel:   (19281408) is smallest!.
Dec 16 17:43:45 inquisitive kernel: raid0: checking hdg3 ... contained as 
device 1
Dec 16 17:43:45 inquisitive kernel: raid0: zone->nb_dev: 2, size: 38562816
Dec 16 17:43:45 inquisitive kernel: raid0: current zone offset: 19281408
Dec 16 17:43:45 inquisitive kernel: raid0: done.
Dec 16 17:43:45 inquisitive kernel: raid0 : md_size is 38562816 blocks.
Dec 16 17:43:45 inquisitive kernel: raid0 : conf->smallest->size is 38562816 
blocks.
Dec 16 17:43:45 inquisitive kernel: raid0 : nb_zone is 1.
Dec 16 17:43:45 inquisitive kernel: raid0 : Allocating 8 bytes for hash.
Dec 16 17:43:45 inquisitive kernel: usb-uhci.c: Detected 2 ports
Dec 16 17:43:45 inquisitive kernel: usb-uhci.c: Detected 2 ports
Dec 16 17:43:45 inquisitive kernel: ide-floppy driver 0.99.newide
Dec 16 17:43:45 inquisitive kernel: hdb: ATAPI 16X CD-ROM drive, 128kB Cache
Dec 16 17:43:45 inquisitive kernel: ip_tables: (C) 2000-2002 Netfilter core 
team
Dec 16 17:43:45 inquisitive kernel: ip_conntrack (8192 buckets, 65536 max)
Dec 16 17:43:46 inquisitive xinetd[1184]: Server /usr/sbin/in.rexecd is not 
executable [line=13]
Dec 16 17:43:46 inquisitive xinetd[1184]: Error parsing attribute server - 
DISABLING SERVICE [line=13]
Dec 16 17:43:46 inquisitive xinetd[1184]: Server /usr/sbin/in.rlogind is not 
executable [line=13]
Dec 16 17:43:46 inquisitive xinetd[1184]: Error parsing attribute server - 
DISABLING SERVICE [line=13]
Dec 16 17:43:46 inquisitive xinetd[1184]: Server /usr/sbin/in.rshd is not 
executable [line=14]
Dec 16 17:43:46 inquisitive xinetd[1184]: Error parsing attribute server - 
DISABLING SERVICE [line=14]
Dec 16 17:44:05 inquisitive postfix/postfix-script: warning: 
/var/spool/postfix/etc/resolv.conf and /etc/resolv.conf differ
Dec 16 17:45:59 inquisitive modprobe: modprobe: Can't locate module 
char-major-81
Dec 16 17:46:23 inquisitive insmod: 
/lib/modules/2.4.18-17.7.x/kernel/drivers/sound/via82cxxx_audio.o: 
init_module: No such device
Dec 16 17:46:23 inquisitive insmod: 
/lib/modules/2.4.18-17.7.x/kernel/drivers/sound/via82cxxx_audio.o: insmod 
sound-slot-0 failed
Dec 16 17:46:23 inquisitive modprobe: modprobe: Can't locate module 
sound-service-0-3

Now the only thing I did previous to this was to enter the bios and shut down 
the onboard sound.  Then after the reboot about five hours latter the drive 
drops complaining about no DMA.  I have since turned the onboard audio back 
on!  There was widespread power outages in the area that night.

When I do

raidstop /dev/md0 

I get 

Segmentation fault.

then I issue:

mdadm --assemble --force /dev/md0 /dev/hdg /dev/hde

And my system is very effectively rendered useless.

Ardently;

Arden A. Wiebe

