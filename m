From: "Boylan, Ross" <Ross.Boylan@ucsf.edu>
Subject: errors when reading in one section of a disk
Date: Wed, 25 Jan 2017 02:43:46 +0000
Message-ID: <3b82fbda-b3a7-4bcf-8c1e-cbb2b2fd7075@exhybrid01.net.ucsf.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I suspect this  problem has little to do with RAID, but since I'm using it I thought I'd start here.
I have 3 disks in a Vantec HX4 4 SATA drive box, connected by USB.  Repeatedly, when I try to read certain sectors of one disk every disk in the box seems to reset and then get remounted.  I thought this was a transient power failure the first time (though I'm on UPS), but when it happened again I figured the problem was elsewhere.  I am surprised that a read failure on one drive seems to reset the entire connection to the box.

The disk is a relatively new WD Red Pro, and so seems unlikely to have a physical failure.  The Vantec box is almost 5 years old, and seems a better suspect.  The only reason I can think that reading a particular spot on one disk would make it fail is that this is perhaps accompanied by some other activity at the same time.  The Vantec itself supplies no RAID or anything fancy, just access to the drives.

The setup is only nominally RAID1, since I have yet to add a spare drive for either array in use.

It looks as if the RAID arrays survive the redefinition of the physical devices (e.g., sde is reattached as sdj), but it's hard to tell since the partition with the error is mounted read-only and thus generates errors.  I have been rebooting the whole system shortly after the problem happens.  Should  the /dev/md* devices survive such remapping beneath them?

After the remapping the file systems the md devices supported on the host computer were still mounted (albeit ro for one of them). mdadm -D did not llist the names of the component devices and the info in proc (or maybe it was run) seemed stale, since it still had the old device names (e.g., sde3 rather than sdj3).

Linux Kernel 3.16.  Hmm, these problems are occurring a day after a security upgrade of the kernel:
[UPGRADE] linux-image-3.16.0-0.bpo.4-amd64:amd64 3.16.36-1+deb8u2~bpo70+1 -> 3.16.39-1~bpo70+1
There is a very long list of changes between those versions: http://ftp-master.metadata.debian.org/changelogs//main/l/linux/linux_3.16.39-1~bpo70+1_changelog



Here's the kern.log entries from the event start:
Jan 24 15:22:59 tempserver kernel: [96418.113742] usb 2-4: USB disconnect, device number 3
Jan 24 15:22:59 tempserver kernel: [96418.117141] scsi 7:0:0:2: rejecting I/O to offline device
Jan 24 15:22:59 tempserver kernel: [96418.117149] scsi 7:0:0:2: [sde] killing request
Jan 24 15:22:59 tempserver kernel: [96418.117172] scsi 7:0:0:2: [sde] Unhandled error code
Jan 24 15:22:59 tempserver kernel: [96418.117174] scsi 7:0:0:2: [sde]  
Jan 24 15:22:59 tempserver kernel: [96418.117175] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jan 24 15:22:59 tempserver kernel: [96418.117177] scsi 7:0:0:2: [sde] CDB: 
Jan 24 15:22:59 tempserver kernel: [96418.117178] Read(16): 88 40 00 00 00 01 93 d9 41 a8 00 00 00 f0 00 00
Jan 24 15:22:59 tempserver kernel: [96418.117188] end_request: I/O error, dev sde, sector 6775456168  # 2nd time it was 6775455984
Jan 24 15:22:59 tempserver kernel: [96418.117202] scsi 7:0:0:2: rejecting I/O to offline device
Jan 24 15:22:59 tempserver kernel: [96418.117205] scsi 7:0:0:2: [sde] killing request
Jan 24 15:22:59 tempserver kernel: [96418.117208] scsi 7:0:0:2: [sde] Unhandled error code
Jan 24 15:22:59 tempserver kernel: [96418.117210] scsi 7:0:0:2: [sde]  
Jan 24 15:22:59 tempserver kernel: [96418.117211] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jan 24 15:22:59 tempserver kernel: [96418.117212] scsi 7:0:0:2: [sde] CDB: 
Jan 24 15:22:59 tempserver kernel: [96418.117213] Read(16): 88 00 00 00 00 01 93 d9 42 98 00 00 00 20 00 00
Jan 24 15:22:59 tempserver kernel: [96418.117220] end_request: I/O error, dev sde, sector 6775456408
Jan 24 15:23:01 tempserver kernel: [96419.765989] usb 2-4: new SuperSpeed USB device number 4 using xhci_hcd
Jan 24 15:23:01 tempserver kernel: [96419.782952] usb 2-4: New USB device found, idVendor=152d, idProduct=0551
Jan 24 15:23:01 tempserver kernel: [96419.782955] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=5
Jan 24 15:23:01 tempserver kernel: [96419.782957] usb 2-4: Product: USB to ATA/ATAPI Bridge
Jan 24 15:23:01 tempserver kernel: [96419.782958] usb 2-4: Manufacturer: JMicron
Jan 24 15:23:01 tempserver kernel: [96419.782958] usb 2-4: SerialNumber: DA00862620FF
Jan 24 15:23:01 tempserver kernel: [96419.785081] usb-storage 2-4:1.0: USB Mass Storage device detected
Jan 24 15:23:01 tempserver kernel: [96419.785189] scsi8 : usb-storage 2-4:1.0
Jan 24 15:23:02 tempserver kernel: [96420.783801] scsi 8:0:0:0: Direct-Access     WDC WD20 01FASS-00W2B0         PQ: 0 ANSI: 2 CCS
Jan 24 15:23:02 tempserver kernel: [96420.784024] scsi 8:0:0:1: Direct-Access     WDC WD20 EARS-00MVWB0          PQ: 0 ANSI: 2 CCS
Jan 24 15:23:02 tempserver kernel: [96420.784240] scsi 8:0:0:2: Direct-Access     WDC WD40 01FFSX-68JNUN0        PQ: 0 ANSI: 2 CCS

The original read error seems to be in sde3, which is md/media3 aka md127 (see partition map below).  But there are subsequent failures on md126 aka media4.  The writes originate from VirtualBox which stores control info on media3 and has virtual disks on media3 and media4 (AFAIK this is all via regular files--the virtual disks are simply files on the host OS).  Here's the rest of the log, and then a bunch of diagnostic info on my system.  I'm not sure if attachments are OK, so this is all inline.

Thanks for any help you can offer.
Ross Boylan

Jan 24 15:23:02 tempserver kernel: [96420.784571] sd 8:0:0:0: Attached scsi generic sg2 type 0
Jan 24 15:23:02 tempserver kernel: [96420.784721] sd 8:0:0:1: Attached scsi generic sg3 type 0
Jan 24 15:23:02 tempserver kernel: [96420.784812] sd 8:0:0:0: [sdh] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
Jan 24 15:23:02 tempserver kernel: [96420.784831] sd 8:0:0:2: Attached scsi generic sg4 type 0
Jan 24 15:23:02 tempserver kernel: [96420.785191] sd 8:0:0:0: [sdh] Write Protect is off
Jan 24 15:23:02 tempserver kernel: [96420.785194] sd 8:0:0:0: [sdh] Mode Sense: 28 00 00 00
Jan 24 15:23:02 tempserver kernel: [96420.785342] sd 8:0:0:1: [sdi] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
Jan 24 15:23:02 tempserver kernel: [96420.785475] sd 8:0:0:2: [sdj] Very big device. Trying to use READ CAPACITY(16).
Jan 24 15:23:02 tempserver kernel: [96420.785704] sd 8:0:0:0: [sdh] No Caching mode page found
Jan 24 15:23:02 tempserver kernel: [96420.785706] sd 8:0:0:0: [sdh] Assuming drive cache: write through
Jan 24 15:23:02 tempserver kernel: [96420.786061] sd 8:0:0:1: [sdi] Write Protect is off
Jan 24 15:23:02 tempserver kernel: [96420.786063] sd 8:0:0:1: [sdi] Mode Sense: 28 00 00 00
Jan 24 15:23:02 tempserver kernel: [96420.786220] sd 8:0:0:2: [sdj] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
Jan 24 15:23:02 tempserver kernel: [96420.786527] sd 8:0:0:1: [sdi] No Caching mode page found
Jan 24 15:23:02 tempserver kernel: [96420.786530] sd 8:0:0:1: [sdi] Assuming drive cache: write through
Jan 24 15:23:02 tempserver kernel: [96420.786794] sd 8:0:0:2: [sdj] Write Protect is off
Jan 24 15:23:02 tempserver kernel: [96420.786796] sd 8:0:0:2: [sdj] Mode Sense: 28 00 00 00
Jan 24 15:23:02 tempserver kernel: [96420.787246] sd 8:0:0:2: [sdj] No Caching mode page found
Jan 24 15:23:02 tempserver kernel: [96420.787249] sd 8:0:0:2: [sdj] Assuming drive cache: write through
Jan 24 15:23:02 tempserver kernel: [96420.797382] sd 8:0:0:2: [sdj] Very big device. Trying to use READ CAPACITY(16).
Jan 24 15:23:02 tempserver kernel: [96420.927411] Alternate GPT is invalid, using primary GPT.
Jan 24 15:23:02 tempserver kernel: [96420.927424]  sdi: sdi1 sdi2
Jan 24 15:23:02 tempserver kernel: [96420.928383]  sdh: sdh1 sdh2 sdh3
Jan 24 15:23:02 tempserver kernel: [96420.937783] sd 8:0:0:1: [sdi] Attached SCSI disk
Jan 24 15:23:02 tempserver kernel: [96420.938368]  sdj: sdj1 sdj2 sdj3
Jan 24 15:23:02 tempserver kernel: [96420.943147] sd 8:0:0:0: [sdh] Attached SCSI disk
Jan 24 15:23:02 tempserver kernel: [96420.944894] sd 8:0:0:2: [sdj] Very big device. Trying to use READ CAPACITY(16).
Jan 24 15:23:02 tempserver kernel: [96420.945971] sd 8:0:0:2: [sdj] Attached SCSI disk
Jan 24 15:23:04 tempserver kernel: [96423.135634] md: super_written gets error=-19, uptodate=0
Jan 24 15:23:04 tempserver kernel: [96423.135666] EXT4-fs warning (device md127): ext4_end_bio:317: I/O error -5 writing to inode 75497479 (offset 0 size 0 starting block 15947872)
Jan 24 15:23:04 tempserver kernel: [96423.135670] Buffer I/O error on device md127, logical block 15947872
Jan 24 15:23:04 tempserver kernel: [96423.135676] EXT4-fs warning (device md127): ext4_end_bio:317: I/O error -5 writing to inode 75497479 (offset 397312 size 4096 starting block 15947873)
Jan 24 15:23:04 tempserver kernel: [96423.135679] Buffer I/O error on device md127, logical block 15947873
Jan 24 15:23:04 tempserver kernel: [96423.135684] JBD2: Detected IO errors while flushing file data on md127-8
Jan 24 15:23:04 tempserver kernel: [96423.135687] Aborting journal on device md127-8.
Jan 24 15:23:04 tempserver kernel: [96423.135698] Buffer I/O error on device md127, logical block 243826688
Jan 24 15:23:04 tempserver kernel: [96423.135698] lost page write due to I/O error on md127
Jan 24 15:23:04 tempserver kernel: [96423.135702] JBD2: Error -5 detected when updating journal superblock for md127-8.
Jan 24 15:23:04 tempserver kernel: [96423.339670] md: super_written gets error=-19, uptodate=0
Jan 24 15:23:12 tempserver kernel: [96431.622932] md: super_written gets error=-19, uptodate=0
Jan 24 15:23:12 tempserver kernel: [96431.622951] Buffer I/O error on device md127, logical block 0
Jan 24 15:23:12 tempserver kernel: [96431.622952] lost page write due to I/O error on md127
Jan 24 15:23:12 tempserver kernel: [96431.622958] EXT4-fs error (device md127): ext4_journal_check_start:56: Detected aborted journal
Jan 24 15:23:12 tempserver kernel: [96431.622961] EXT4-fs (md127): Remounting filesystem read-only
Jan 24 15:23:12 tempserver kernel: [96431.622963] EXT4-fs (md127): previous I/O error to superblock detected
Jan 24 15:23:12 tempserver kernel: [96431.622971] Buffer I/O error on device md127, logical block 0
Jan 24 15:23:12 tempserver kernel: [96431.622972] lost page write due to I/O error on md127
Jan 24 15:23:13 tempserver kernel: [96431.663207] plugin-containe[11485]: segfault at 141aa150e3c4 ip 00007fe380dfe522 sp 00007fff062466e8 error 6 in libflashplayer.so[7fe38078d000+107b000]
Jan 24 15:23:13 tempserver kernel: [96431.823785] md: super_written gets error=-19, uptodate=0
Jan 24 15:23:32 tempserver kernel: [96451.362478] device br0 left promiscuous mode
Jan 24 15:23:32 tempserver kernel: [96451.381227] vboxnetflt: 0 out of 11296830 packets were not sent (directed to host)
Jan 24 15:23:55 tempserver kernel: [96474.392410] md: super_written gets error=-19, uptodate=0
Jan 24 15:23:55 tempserver kernel: [96474.392454] Aborting journal on device md126-8.
Jan 24 15:23:55 tempserver kernel: [96474.392464] Buffer I/O error on device md126, logical block 243826688
Jan 24 15:23:55 tempserver kernel: [96474.392465] lost page write due to I/O error on md126
Jan 24 15:23:55 tempserver kernel: [96474.392469] JBD2: Error -5 detected when updating journal superblock for md126-8.
Jan 24 15:23:55 tempserver kernel: [96474.596458] md: super_written gets error=-19, uptodate=0
Jan 24 15:36:05 tempserver kernel: [97204.943952] md: super_written gets error=-19, uptodate=0
Jan 24 15:36:05 tempserver kernel: [97204.952725] Buffer I/O error on device md126, logical block 488344000
Jan 24 15:36:05 tempserver kernel: [97204.952737] Buffer I/O error on device md126, logical block 488344000
Jan 24 15:36:05 tempserver kernel: [97204.953310] Buffer I/O error on device md126, logical block 488344014
Jan 24 15:36:05 tempserver kernel: [97204.953317] Buffer I/O error on device md126, logical block 488344014
Jan 24 15:36:05 tempserver kernel: [97204.953342] Buffer I/O error on device md126, logical block 488344015
Jan 24 15:36:05 tempserver kernel: [97204.953347] Buffer I/O error on device md126, logical block 488344015
Jan 24 15:36:05 tempserver kernel: [97204.953598] Buffer I/O error on device md126, logical block 488344015
Jan 24 15:36:06 tempserver kernel: [97205.157682] md: super_written gets error=-19, uptodate=0
Jan 24 15:38:55 tempserver kernel: [97374.191852] md: super_written gets error=-19, uptodate=0
Jan 24 15:38:55 tempserver kernel: [97374.192780] Buffer I/O error on device md126, logical block 488344000
Jan 24 15:38:55 tempserver kernel: [97374.192786] Buffer I/O error on device md126, logical block 488344000
Jan 24 15:38:55 tempserver kernel: [97374.197645] Buffer I/O error on device md126, logical block 488344014
Jan 24 15:38:55 tempserver kernel: [97374.197656] Buffer I/O error on device md126, logical block 488344014
Jan 24 15:38:55 tempserver kernel: [97374.197927] Buffer I/O error on device md126, logical block 488344015
Jan 24 15:38:55 tempserver kernel: [97374.197932] Buffer I/O error on device md126, logical block 488344015
Jan 24 15:38:55 tempserver kernel: [97374.198258] Buffer I/O error on device md126, logical block 488344015
Jan 24 15:38:55 tempserver kernel: [97374.399491] md: super_written gets error=-19, uptodate=0
Jan 24 15:44:44 tempserver kernel: [97723.869340] md: super_written gets error=-19, uptodate=0
Jan 24 15:44:44 tempserver kernel: [97724.072512] md: super_written gets error=-19, uptodate=0
Jan 24 15:59:35 tempserver kernel: [98615.191953] Buffer I/O error on device md127, logical block 488344256
Jan 24 15:59:35 tempserver kernel: [98615.191962] Buffer I/O error on device md127, logical block 488344256
Jan 24 15:59:35 tempserver kernel: [98615.191970] Buffer I/O error on device md127, logical block 488344270
Jan 24 15:59:35 tempserver kernel: [98615.191973] Buffer I/O error on device md127, logical block 488344270
Jan 24 15:59:35 tempserver kernel: [98615.191979] Buffer I/O error on device md127, logical block 0
Jan 24 15:59:35 tempserver kernel: [98615.191986] Buffer I/O error on device md127, logical block 488344271
Jan 24 15:59:35 tempserver kernel: [98615.192017] Buffer I/O error on device md127, logical block 488344271
Jan 24 15:59:35 tempserver kernel: [98615.192022] Buffer I/O error on device md127, logical block 488344271
Jan 24 15:59:35 tempserver kernel: [98615.192027] Buffer I/O error on device md127, logical block 488344271
Jan 24 15:59:35 tempserver kernel: [98615.192031] Buffer I/O error on device md127, logical block 488344271
Jan 24 16:09:34 tempserver kernel: [99214.978331] md: super_written gets error=-19, uptodate=0
Jan 24 16:09:35 tempserver kernel: [99215.181417] md: super_written gets error=-19, uptodate=0
Jan 24 16:09:36 tempserver kernel: [99216.470117] nfsd: last server has exited, flushing export cache
Jan 24 16:09:37 tempserver kernel: [99217.660950] Ebtables v2.0 registered
Jan 24 16:09:38 tempserver kernel: [99218.145566] Ebtables v2.0 unregistered
Jan 24 16:10:08 tempserver kernel: [99248.258963] md: super_written gets error=-19, uptodate=0
Jan 24 16:10:08 tempserver kernel: [99248.461482] md: super_written gets error=-19, uptodate=0

root@tempserver:~# date
Tue Jan 24 16:48:33 PST 2017
root@tempserver:~# ls /dev/sd?
/dev/sda  /dev/sdb  /dev/sdc  /dev/sdd	/dev/sde  /dev/sdf  /dev/sdg
root@tempserver:~# ls -lR /dev/disk/
/dev/disk/:
total 0
drwxr-xr-x 2 root root 2580 Jan 24 16:43 by-id
drwxr-xr-x 2 root root   80 Jan 24 16:43 by-label
drwxr-xr-x 2 root root  460 Jan 24 16:43 by-path
drwxr-xr-x 2 root root  760 Jan 24 16:43 by-uuid

/dev/disk/by-id:
total 0
lrwxrwxrwx 1 root root  9 Jan 24 16:43 ata-ASUS_BW-12B1ST_D1D0CL102702 -> ../../sr0
lrwxrwxrwx 1 root root  9 Jan 24 16:43 ata-INTEL_SSDSC2CT240A4_CVKI3111011H240DGN -> ../../sda
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-INTEL_SSDSC2CT240A4_CVKI3111011H240DGN-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-INTEL_SSDSC2CT240A4_CVKI3111011H240DGN-part2 -> ../../sda2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-INTEL_SSDSC2CT240A4_CVKI3111011H240DGN-part5 -> ../../sda5
lrwxrwxrwx 1 root root  9 Jan 24 16:43 ata-ST31000528AS_5VP2GNTB -> ../../sdf
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-ST31000528AS_5VP2GNTB-part1 -> ../../sdf1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-ST31000528AS_5VP2GNTB-part2 -> ../../sdf2
lrwxrwxrwx 1 root root  9 Jan 24 16:43 ata-WDC_WD2001FASS-00W2B0_WD-WMAY00862620 -> ../../sdc
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD2001FASS-00W2B0_WD-WMAY00862620-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD2001FASS-00W2B0_WD-WMAY00862620-part2 -> ../../sdc2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD2001FASS-00W2B0_WD-WMAY00862620-part3 -> ../../sdc3
lrwxrwxrwx 1 root root  9 Jan 24 16:43 ata-WDC_WD20EARS-00MVWB0_WD-WMAZA2177901 -> ../../sdd
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD20EARS-00MVWB0_WD-WMAZA2177901-part1 -> ../../sdd1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD20EARS-00MVWB0_WD-WMAZA2177901-part2 -> ../../sdd2
lrwxrwxrwx 1 root root  9 Jan 24 16:43 ata-WDC_WD30EFRX-68AX9N0_WD-WMC1T3337275 -> ../../sdg
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD30EFRX-68AX9N0_WD-WMC1T3337275-part1 -> ../../sdg1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD30EFRX-68AX9N0_WD-WMC1T3337275-part2 -> ../../sdg2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD30EFRX-68AX9N0_WD-WMC1T3337275-part3 -> ../../sdg3
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD30EFRX-68AX9N0_WD-WMC1T3337275-part4 -> ../../sdg4
lrwxrwxrwx 1 root root  9 Jan 24 16:43 ata-WDC_WD4000FYYZ-01UL1B2_WD-WMC130E91SHR -> ../../sdb
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD4000FYYZ-01UL1B2_WD-WMC130E91SHR-part1 -> ../../sdb1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD4000FYYZ-01UL1B2_WD-WMC130E91SHR-part2 -> ../../sdb2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD4000FYYZ-01UL1B2_WD-WMC130E91SHR-part3 -> ../../sdb3
lrwxrwxrwx 1 root root  9 Jan 24 16:43 ata-WDC_WD4001FFSX-68JNUN0_WD-WMC5D0D0FC30 -> ../../sde
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD4001FFSX-68JNUN0_WD-WMC5D0D0FC30-part1 -> ../../sde1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD4001FFSX-68JNUN0_WD-WMC5D0D0FC30-part2 -> ../../sde2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 ata-WDC_WD4001FFSX-68JNUN0_WD-WMC5D0D0FC30-part3 -> ../../sde3
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-daisy-amd64 -> ../../dm-21
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-daisy-bacula--backup -> ../../dm-11
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-daisy-boot_rescue -> ../../dm-16
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-daisy-chroot -> ../../dm-20
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-daisy-cyrspool3_raw -> ../../dm-12
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-daisy-cyrspool4_raw -> ../../dm-18
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-daisy-htpc_raw -> ../../dm-22
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-daisy-media -> ../../dm-19
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-daisy-root2_raw -> ../../dm-14
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-daisy-root_rescue -> ../../dm-15
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-daisy-spare -> ../../dm-17
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-daisy-swap2_raw -> ../../dm-13
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-local -> ../../dm-27
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-name-sunflower-backup -> ../../dm-0
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-name-sunflower-corn_vdisk -> ../../dm-4
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-name-sunflower-emergency_raw -> ../../dm-8
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-name-sunflower-local_raw -> ../../dm-7
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-name-sunflower-media01b -> ../../dm-9
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-name-sunflower-tcorn_raw -> ../../dm-3
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-name-sunflower-thome_raw -> ../../dm-2
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-sunflower-tjessie_raw -> ../../dm-10
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-name-sunflower-troot_raw -> ../../dm-1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-name-sunflower-usr -> ../../dm-5
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-name-sunflower-var_raw -> ../../dm-6
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-tcorn -> ../../dm-25
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-thome -> ../../dm-24
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-troot -> ../../dm-23
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-name-var -> ../../dm-26
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-CRYPT-LUKS1-2bb2a8af61d84197bb5bf0ada5f8c145-troot -> ../../dm-23
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-CRYPT-LUKS1-5b2669f5f53d426aa020222328b7b1b5-var_unformatted -> ../../dm-26
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-CRYPT-LUKS1-8e44946b36714849bf932b1fea424152-thome_unformatted -> ../../dm-24
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-CRYPT-LUKS1-8f81993c99bd45878c6691cc34f7a72d-tcorn_unformatted -> ../../dm-25
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-CRYPT-LUKS1-c4c3307e1dc74355b856d0bb74c9b34d-local_unformatted -> ../../dm-27
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-uuid-LVM-XoFdIZYHwuly4qbL9Fs02JawEn2Lwehm1xZkVI2ym848WteFyvcU0WMI1SmxbTe5 -> ../../dm-0
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-uuid-LVM-XoFdIZYHwuly4qbL9Fs02JawEn2Lwehm5rfsZVH44ldAowRfKLUqIbOUgI4DNm6t -> ../../dm-8
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-uuid-LVM-XoFdIZYHwuly4qbL9Fs02JawEn2LwehmgqkTmQkgfRwVc9T9DXrt367flkvDySxZ -> ../../dm-5
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-uuid-LVM-XoFdIZYHwuly4qbL9Fs02JawEn2LwehmlDm0ycEdcp9iuYRrds6PYMAJaqCrBdfN -> ../../dm-6
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-uuid-LVM-XoFdIZYHwuly4qbL9Fs02JawEn2LwehmqtwcajNbZPU79hzjRIZOQ0Mfp1KqWHUi -> ../../dm-1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-uuid-LVM-XoFdIZYHwuly4qbL9Fs02JawEn2LwehmSK7oOXpTLFeETtX3H5fs3Xh03wYznC1l -> ../../dm-9
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-uuid-LVM-XoFdIZYHwuly4qbL9Fs02JawEn2LwehmTXs2ZnNyqXnBosaETfSn768SDzdWwOSa -> ../../dm-2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-uuid-LVM-XoFdIZYHwuly4qbL9Fs02JawEn2LwehmuEA7zvu1IbpGn1dTRTSoTH1HB9fLzMrW -> ../../dm-7
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-uuid-LVM-XoFdIZYHwuly4qbL9Fs02JawEn2LwehmuTNw0CbcB2KnjHimq6qivMq9v5QBoI2E -> ../../dm-4
lrwxrwxrwx 1 root root 10 Jan 24 16:43 dm-uuid-LVM-XoFdIZYHwuly4qbL9Fs02JawEn2LwehmXvn23A9ek1cLamHDhMlj0pH0HoDiasUd -> ../../dm-3
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-LVM-XoFdIZYHwuly4qbL9Fs02JawEn2LwehmyHVB0zmJLScJ0HAvMKt64l4xN4pXi0mj -> ../../dm-10
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-LVM-z2DbsrYwb0J56tBMDTcfxH7cumFodpe90vCqlTJEJz9XNqDiLqiAFb3layCyLU37 -> ../../dm-20
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-LVM-z2DbsrYwb0J56tBMDTcfxH7cumFodpe99ipPWHOKmw0yofhIvCOVboVu8UMDM4u4 -> ../../dm-15
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-LVM-z2DbsrYwb0J56tBMDTcfxH7cumFodpe9GREOTHce1L8jwqvNJFAKxSmnJ0dPTd9G -> ../../dm-11
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-LVM-z2DbsrYwb0J56tBMDTcfxH7cumFodpe9L1Bjf25QpiD4oECosMnoQRDVmVsh0qkE -> ../../dm-13
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-LVM-z2DbsrYwb0J56tBMDTcfxH7cumFodpe9mcPIsz7WhlkqQC2X2oVfxY79HBAofIHj -> ../../dm-22
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-LVM-z2DbsrYwb0J56tBMDTcfxH7cumFodpe9MSso91I10LYVQabovqhnlZDWUjEdx0V5 -> ../../dm-17
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-LVM-z2DbsrYwb0J56tBMDTcfxH7cumFodpe9Q2MlxfXKVRxtrZ0x2nvDPcrmImPt1pmR -> ../../dm-14
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-LVM-z2DbsrYwb0J56tBMDTcfxH7cumFodpe9qhvdeinb4t1wLcJSpahjLPKj7vLIUVAC -> ../../dm-18
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-LVM-z2DbsrYwb0J56tBMDTcfxH7cumFodpe9Ssp6mtjMM0QcG0o0RVd6MiMzfSbqaEp6 -> ../../dm-12
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-LVM-z2DbsrYwb0J56tBMDTcfxH7cumFodpe9sunZGxMZUjSELYuiH8dO9KkGls13MI1m -> ../../dm-21
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-LVM-z2DbsrYwb0J56tBMDTcfxH7cumFodpe9U2iTmorRBKzgoAFaOryb3gSRiJF3NKC2 -> ../../dm-16
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dm-uuid-LVM-z2DbsrYwb0J56tBMDTcfxH7cumFodpe9vGye9ccRLab1PTYCTHNeH01PZ325Dot0 -> ../../dm-19
lrwxrwxrwx 1 root root 11 Jan 24 16:43 md-name-tempserver:media3 -> ../../md127
lrwxrwxrwx 1 root root 11 Jan 24 16:43 md-name-tempserver:media4 -> ../../md126
lrwxrwxrwx 1 root root 11 Jan 24 16:43 md-uuid-285852a7:f02b9cdf:f2dca45a:f6a50616 -> ../../md127
lrwxrwxrwx 1 root root 11 Jan 24 16:43 md-uuid-69440821:e9aa9259:ab2b06ce:d09bedc7 -> ../../md126
lrwxrwxrwx 1 root root  9 Jan 24 16:43 scsi-SATA_INTEL_SSDSC2CT2CVKI3111011H240DGN -> ../../sda
lrwxrwxrwx 1 root root 10 Jan 24 16:43 scsi-SATA_INTEL_SSDSC2CT2CVKI3111011H240DGN-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 scsi-SATA_INTEL_SSDSC2CT2CVKI3111011H240DGN-part2 -> ../../sda2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 scsi-SATA_INTEL_SSDSC2CT2CVKI3111011H240DGN-part5 -> ../../sda5
lrwxrwxrwx 1 root root  9 Jan 24 16:43 scsi-SATA_ST31000528AS_5VP2GNTB -> ../../sdf
lrwxrwxrwx 1 root root 10 Jan 24 16:43 scsi-SATA_ST31000528AS_5VP2GNTB-part1 -> ../../sdf1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 scsi-SATA_ST31000528AS_5VP2GNTB-part2 -> ../../sdf2
lrwxrwxrwx 1 root root  9 Jan 24 16:43 scsi-SATA_WDC_WD30EFRX-68_WD-WMC1T3337275 -> ../../sdg
lrwxrwxrwx 1 root root 10 Jan 24 16:43 scsi-SATA_WDC_WD30EFRX-68_WD-WMC1T3337275-part1 -> ../../sdg1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 scsi-SATA_WDC_WD30EFRX-68_WD-WMC1T3337275-part2 -> ../../sdg2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 scsi-SATA_WDC_WD30EFRX-68_WD-WMC1T3337275-part3 -> ../../sdg3
lrwxrwxrwx 1 root root 10 Jan 24 16:43 scsi-SATA_WDC_WD30EFRX-68_WD-WMC1T3337275-part4 -> ../../sdg4
lrwxrwxrwx 1 root root  9 Jan 24 16:43 scsi-SWDC_WD4000FYYZ-01UL1B2_310000104102 -> ../../sdb
lrwxrwxrwx 1 root root 10 Jan 24 16:43 scsi-SWDC_WD4000FYYZ-01UL1B2_310000104102-part1 -> ../../sdb1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 scsi-SWDC_WD4000FYYZ-01UL1B2_310000104102-part2 -> ../../sdb2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 scsi-SWDC_WD4000FYYZ-01UL1B2_310000104102-part3 -> ../../sdb3
lrwxrwxrwx 1 root root  9 Jan 24 16:43 wwn-0x5000c5001e215923 -> ../../sdf
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x5000c5001e215923-part1 -> ../../sdf1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x5000c5001e215923-part2 -> ../../sdf2
lrwxrwxrwx 1 root root  9 Jan 24 16:43 wwn-0x50014ee05962817d -> ../../sdb
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x50014ee05962817d-part1 -> ../../sdb1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x50014ee05962817d-part2 -> ../../sdb2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x50014ee05962817d-part3 -> ../../sdb3
lrwxrwxrwx 1 root root  9 Jan 24 16:43 wwn-0x50014ee0aebe906f -> ../../sde
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x50014ee0aebe906f-part1 -> ../../sde1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x50014ee0aebe906f-part2 -> ../../sde2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x50014ee0aebe906f-part3 -> ../../sde3
lrwxrwxrwx 1 root root  9 Jan 24 16:43 wwn-0x50014ee6ab45f9a7 -> ../../sdd
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x50014ee6ab45f9a7-part1 -> ../../sdd1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x50014ee6ab45f9a7-part2 -> ../../sdd2
lrwxrwxrwx 1 root root  9 Jan 24 16:43 wwn-0x50014ee6addf95c6 -> ../../sdg
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x50014ee6addf95c6-part1 -> ../../sdg1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x50014ee6addf95c6-part2 -> ../../sdg2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x50014ee6addf95c6-part3 -> ../../sdg3
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x50014ee6addf95c6-part4 -> ../../sdg4
lrwxrwxrwx 1 root root  9 Jan 24 16:43 wwn-0x55cd2e400003c916 -> ../../sda
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x55cd2e400003c916-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x55cd2e400003c916-part2 -> ../../sda2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 wwn-0x55cd2e400003c916-part5 -> ../../sda5

/dev/disk/by-label:
total 0
lrwxrwxrwx 1 root root 10 Jan 24 16:43 2TB -> ../../sdb3
lrwxrwxrwx 1 root root 10 Jan 24 16:43 backup\x20NTFS -> ../../sdb2

/dev/disk/by-path:
total 0
lrwxrwxrwx 1 root root  9 Jan 24 16:43 pci-0000:00:14.0-usb-0:2:1.0-scsi-0:0:0:0 -> ../../sdb
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:14.0-usb-0:2:1.0-scsi-0:0:0:0-part1 -> ../../sdb1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:14.0-usb-0:2:1.0-scsi-0:0:0:0-part2 -> ../../sdb2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:14.0-usb-0:2:1.0-scsi-0:0:0:0-part3 -> ../../sdb3
lrwxrwxrwx 1 root root  9 Jan 24 16:43 pci-0000:00:14.0-usb-0:4:1.0-scsi-0:0:0:0 -> ../../sdc
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:14.0-usb-0:4:1.0-scsi-0:0:0:0-part1 -> ../../sdc1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:14.0-usb-0:4:1.0-scsi-0:0:0:0-part2 -> ../../sdc2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:14.0-usb-0:4:1.0-scsi-0:0:0:0-part3 -> ../../sdc3
lrwxrwxrwx 1 root root  9 Jan 24 16:43 pci-0000:00:14.0-usb-0:4:1.0-scsi-0:0:0:1 -> ../../sdd
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:14.0-usb-0:4:1.0-scsi-0:0:0:1-part1 -> ../../sdd1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:14.0-usb-0:4:1.0-scsi-0:0:0:1-part2 -> ../../sdd2
lrwxrwxrwx 1 root root  9 Jan 24 16:43 pci-0000:00:14.0-usb-0:4:1.0-scsi-0:0:0:2 -> ../../sde
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:14.0-usb-0:4:1.0-scsi-0:0:0:2-part1 -> ../../sde1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:14.0-usb-0:4:1.0-scsi-0:0:0:2-part2 -> ../../sde2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:14.0-usb-0:4:1.0-scsi-0:0:0:2-part3 -> ../../sde3
lrwxrwxrwx 1 root root  9 Jan 24 16:43 pci-0000:00:1f.2-scsi-0:0:0:0 -> ../../sdg
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:1f.2-scsi-0:0:0:0-part1 -> ../../sdf1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:1f.2-scsi-0:0:0:0-part2 -> ../../sdg2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:1f.2-scsi-0:0:0:0-part3 -> ../../sdg3
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:1f.2-scsi-0:0:0:0-part4 -> ../../sdg4
lrwxrwxrwx 1 root root 10 Jan 24 16:43 pci-0000:00:1f.2-scsi-0:0:0:0-part5 -> ../../sda5

/dev/disk/by-uuid:
total 0
lrwxrwxrwx 1 root root 10 Jan 24 16:43 0662CED262CEC621 -> ../../sdb3
lrwxrwxrwx 1 root root 10 Jan 24 16:43 081b7fd9-577f-46ad-a659-b74a03fe6e3f -> ../../dm-9
lrwxrwxrwx 1 root root 10 Jan 24 16:43 2707f7ec-48cc-4c41-98ec-4dc5ee8bb8dd -> ../../sdc2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 2bb2a8af-61d8-4197-bb5b-f0ada5f8c145 -> ../../dm-1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 2f3af1c2-9fc4-4aef-a21e-cd115b5e2a8f -> ../../sda1
lrwxrwxrwx 1 root root 10 Jan 24 16:43 303e4b54-0fd7-4139-97d1-a3b97a7e367b -> ../../sdg3
lrwxrwxrwx 1 root root 10 Jan 24 16:43 5b2669f5-f53d-426a-a020-222328b7b1b5 -> ../../dm-6
lrwxrwxrwx 1 root root 11 Jan 24 16:43 5c60cd58-788e-41c4-a5eb-78109e64bfdd -> ../../dm-14
lrwxrwxrwx 1 root root 11 Jan 24 16:43 5ff96b07-d4c2-4b9f-b481-62d77492c18e -> ../../dm-10
lrwxrwxrwx 1 root root 11 Jan 24 16:43 623c8d83-e4c5-497c-bc93-7bda97501c34 -> ../../dm-26
lrwxrwxrwx 1 root root 11 Jan 24 16:43 65bf0b61-0d0b-44ac-9e10-e22d4949b8a5 -> ../../dm-18
lrwxrwxrwx 1 root root 11 Jan 24 16:43 67dc2d8b-6cf7-4e71-8916-764260e54d47 -> ../../md126
lrwxrwxrwx 1 root root 11 Jan 24 16:43 81792fa0-2c78-4a7d-a3d3-5f2f8e7a5eee -> ../../dm-12
lrwxrwxrwx 1 root root 11 Jan 24 16:43 87345578-0806-48ba-b2c2-492fb4b5022c -> ../../dm-17
lrwxrwxrwx 1 root root 10 Jan 24 16:43 8e44946b-3671-4849-bf93-2b1fea424152 -> ../../dm-2
lrwxrwxrwx 1 root root 10 Jan 24 16:43 8f81993c-99bd-4587-8c66-91cc34f7a72d -> ../../dm-3
lrwxrwxrwx 1 root root 11 Jan 24 16:43 91b78c10-140f-4b25-aace-2cab439164be -> ../../dm-15
lrwxrwxrwx 1 root root 10 Jan 24 16:43 9839fbc0-250d-483e-b741-b4e868cb5723 -> ../../dm-0
lrwxrwxrwx 1 root root 10 Jan 24 16:43 9a5935ce-1760-4f5f-81a4-83bb25ee8fd6 -> ../../dm-5
lrwxrwxrwx 1 root root 10 Jan 24 16:43 a0ee2630-2804-435c-b45d-2710c7a49dd1 -> ../../sdg4
lrwxrwxrwx 1 root root 10 Jan 24 16:43 af09e385-caa4-4163-ab0b-b9208a263b7e -> ../../sdf1
lrwxrwxrwx 1 root root 11 Jan 24 16:43 b04de76a-16fc-458a-a3f9-1e991706e53a -> ../../dm-20
lrwxrwxrwx 1 root root 11 Jan 24 16:43 b3874960-ae0e-463b-bb40-924b214b5583 -> ../../dm-16
lrwxrwxrwx 1 root root 10 Jan 24 16:43 B4F46594F4655A1E -> ../../sdb2
lrwxrwxrwx 1 root root 11 Jan 24 16:43 ba5d596d-67cf-4546-afec-e38937a89603 -> ../../dm-22
lrwxrwxrwx 1 root root 11 Jan 24 16:43 c2c3c7dd-7e38-4073-a2d5-e33c1a8eead9 -> ../../dm-21
lrwxrwxrwx 1 root root 10 Jan 24 16:43 c4c3307e-1dc7-4355-b856-d0bb74c9b34d -> ../../dm-7
lrwxrwxrwx 1 root root 11 Jan 24 16:43 d0536249-aaac-4973-99b5-d8d192429f15 -> ../../dm-19
lrwxrwxrwx 1 root root 11 Jan 24 16:43 d1a627a2-cfcc-4b56-b8d4-52cd0d59c255 -> ../../dm-25
lrwxrwxrwx 1 root root 10 Jan 24 16:43 d53c9913-1277-4432-b62d-ab801359e237 -> ../../sda5
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dd3e1ea2-3333-40d3-846f-7ba26e44fdc1 -> ../../dm-27
lrwxrwxrwx 1 root root 11 Jan 24 16:43 dd9c3a51-e3ba-4d79-8f7d-95c6e94a3c4d -> ../../md127
lrwxrwxrwx 1 root root 11 Jan 24 16:43 e2078a85-f24d-4d04-b557-29a802231a4c -> ../../dm-11
lrwxrwxrwx 1 root root 10 Jan 24 16:43 f1083f5b-4c52-4b42-ad53-5da55f90de65 -> ../../dm-8
lrwxrwxrwx 1 root root 11 Jan 24 16:43 f8a05932-b9bd-463d-a058-97533a248b87 -> ../../dm-24
lrwxrwxrwx 1 root root 11 Jan 24 16:43 fae964d1-464e-4b03-bbdd-d5854b979918 -> ../../dm-23
root@tempserver:~# mdadm -D /dev/md126
/dev/md126:
        Version : 1.2
  Creation Time : Thu Feb 18 14:09:00 2016
     Raid Level : raid1
     Array Size : 1953376064 (1862.88 GiB 2000.26 GB)
  Used Dev Size : 1953376064 (1862.88 GiB 2000.26 GB)
   Raid Devices : 1
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Tue Jan 24 16:46:10 2017
          State : clean 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : tempserver:media4  (local to host tempserver)
           UUID : 69440821:e9aa9259:ab2b06ce:d09bedc7
         Events : 28

    Number   Major   Minor   RaidDevice State
       0       8       66        0      active sync   /dev/sde2
root@tempserver:~# mdadm -D /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Sat Dec 12 15:50:57 2015
     Raid Level : raid1
     Array Size : 1953377088 (1862.89 GiB 2000.26 GB)
  Used Dev Size : 1953377088 (1862.89 GiB 2000.26 GB)
   Raid Devices : 1
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Tue Jan 24 16:48:18 2017
          State : clean 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : tempserver:media3  (local to host tempserver)
           UUID : 285852a7:f02b9cdf:f2dca45a:f6a50616
         Events : 42

    Number   Major   Minor   RaidDevice State
       0       8       67        0      active sync   /dev/sde3
root@tempserver:~# parted /dev/sde p  # see a bit further down for same info in sectors
Model: WDC WD40 01FFSX-68JNUN0 (scsi)
Disk /dev/sde: 4001GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name            Flags
 1      1049kB  2097kB  1049kB               boot            bios_grub
 2      2097kB  2000GB  2000GB               wdredpro-spare
 3      2000GB  4001GB  2000GB               media3

root@tempserver:~# mdadm -v -E /dev/sde3
/dev/sde3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 285852a7:f02b9cdf:f2dca45a:f6a50616
           Name : tempserver:media3  (local to host tempserver)
  Creation Time : Sat Dec 12 15:50:57 2015
     Raid Level : raid1
   Raid Devices : 1

 Avail Dev Size : 3906754560 (1862.89 GiB 2000.26 GB)
     Array Size : 1953377088 (1862.89 GiB 2000.26 GB)
  Used Dev Size : 3906754176 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f3e9d7c0:45950e91:dd342a67:2a4cd675

    Update Time : Tue Jan 24 16:48:18 2017
       Checksum : 5a04fd2 - correct
         Events : 42


   Device Role : Active device 0
   Array State : A ('A' == active, '.' == missing)
root@tempserver:~# parted /dev/sde
GNU Parted 2.3
Using /dev/sde
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) unit s
(parted) p
Model: WDC WD40 01FFSX-68JNUN0 (scsi)
Disk /dev/sde: 7814037168s
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start        End          Size         File system  Name            Flags
 1      2048s        4095s        2048s                     boot            bios_grub
 2      4096s        3907018751s  3907014656s               wdredpro-spare
 3      3907018752s  7814035455s  3907016704s               media3

(parted) q
root@tempserver:~# df -h .
Filesystem         Size  Used Avail Use% Mounted on
/dev/mapper/troot  959M  433M  478M  48% /
root@tempserver:~# cd
root@tempserver:~# pwd
/root
root@tempserver:~# date; smartctl -H -i -l scterc /dev/sde
Tue Jan 24 17:28:33 PST 2017
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.16.0-0.bpo.4-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD4001FFSX-68JNUN0
Serial Number:    WD-WMC5D0D0FC30
LU WWN Device Id: 5 0014ee 0aebe906f
Firmware Version: 81.00A81
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Tue Jan 24 17:28:33 2017 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

Error Write SCT (Get) Error Recovery Control Command failed: ATA output registers not supported
Warning: device does not support SCT (Get) Error Recovery Control command

root@tempserver:~# mdadm -E /dev/sde
/dev/sde:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
root@tempserver:~# mdadm -E /dev/sde[23]
/dev/sde2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 69440821:e9aa9259:ab2b06ce:d09bedc7
           Name : tempserver:media4  (local to host tempserver)
  Creation Time : Thu Feb 18 14:09:00 2016
     Raid Level : raid1
   Raid Devices : 1

 Avail Dev Size : 3906752512 (1862.88 GiB 2000.26 GB)
     Array Size : 1953376064 (1862.88 GiB 2000.26 GB)
  Used Dev Size : 3906752128 (1862.88 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 41e5317f:225a70b9:5970930e:6a5ff665

    Update Time : Tue Jan 24 16:46:10 2017
       Checksum : 9d338c13 - correct
         Events : 28


   Device Role : Active device 0
   Array State : A ('A' == active, '.' == missing)
/dev/sde3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 285852a7:f02b9cdf:f2dca45a:f6a50616
           Name : tempserver:media3  (local to host tempserver)
  Creation Time : Sat Dec 12 15:50:57 2015
     Raid Level : raid1
   Raid Devices : 1

 Avail Dev Size : 3906754560 (1862.89 GiB 2000.26 GB)
     Array Size : 1953377088 (1862.89 GiB 2000.26 GB)
  Used Dev Size : 3906754176 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f3e9d7c0:45950e91:dd342a67:2a4cd675

    Update Time : Tue Jan 24 16:48:18 2017
       Checksum : 5a04fd2 - correct
         Events : 42


   Device Role : Active device 0
   Array State : A ('A' == active, '.' == missing)
root@tempserver:~# mdadm -D /dev/md/media3
/dev/md/media3:
        Version : 1.2
  Creation Time : Sat Dec 12 15:50:57 2015
     Raid Level : raid1
     Array Size : 1953377088 (1862.89 GiB 2000.26 GB)
  Used Dev Size : 1953377088 (1862.89 GiB 2000.26 GB)
   Raid Devices : 1
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Tue Jan 24 16:48:18 2017
          State : clean 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : tempserver:media3  (local to host tempserver)
           UUID : 285852a7:f02b9cdf:f2dca45a:f6a50616
         Events : 42

    Number   Major   Minor   RaidDevice State
       0       8       67        0      active sync   /dev/sde3
root@tempserver:~# mdadm -D /dev/md/media4
/dev/md/media4:
        Version : 1.2
  Creation Time : Thu Feb 18 14:09:00 2016
     Raid Level : raid1
     Array Size : 1953376064 (1862.88 GiB 2000.26 GB)
  Used Dev Size : 1953376064 (1862.88 GiB 2000.26 GB)
   Raid Devices : 1
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Tue Jan 24 16:46:10 2017
          State : clean 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : tempserver:media4  (local to host tempserver)
           UUID : 69440821:e9aa9259:ab2b06ce:d09bedc7
         Events : 28

    Number   Major   Minor   RaidDevice State
       0       8       66        0      active sync   /dev/sde2
root@tempserver:~# /usr/local/src/lsdrv/lsdrv 
Traceback (most recent call last):
  File "/usr/local/src/lsdrv/lsdrv", line 469, in <module>
    devstat = os.stat('/dev/'+vg_name+'/'+lv_name)
OSError: [Errno 2] No such file or directory: '/dev/daisy/cyrlib'
root@tempserver:~# cat /proc/mdstat
Personalities : [raid1] 
md126 : active raid1 sde2[0]
      1953376064 blocks super 1.2 [1/1] [U]
      
md127 : active raid1 sde3[0]
      1953377088 blocks super 1.2 [1/1] [U]
      
unused devices: <none>


