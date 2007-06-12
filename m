From: simon redfern <simon@musicpictures.com>
Subject: conflicting superblocks - Re: what is the best approach for fixing
 a degraded RAID5 (one drive failed) using mdadm?
Date: Tue, 12 Jun 2007 06:44:38 +0200
Message-ID: <466E24B6.6070505@musicpictures.com>
References: <466D4F51.40009@musicpictures.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <466D4F51.40009@musicpictures.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Folks,

Re our RAID5 that has failed,

It turns out that the disk we thought that had failed (sdb), is working
because /dev/sdb1 is mounted as / ok.

we're using mdadm version version 1.12.0 - 14 June 2005

Here are the four superblocks that make up /dev/md0. They don't all agree:

deagol:~ # mdadm --examine /dev/sda2
/dev/sda2:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : c88a2afe:2990ceff:33d71a2a:eeb7be47
  Creation Time : Fri Mar 31 12:08:16 2006
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Jun  1 04:15:00 2004
          State : active
Active Devices : 3
Working Devices : 3
Failed Devices : 2
  Spare Devices : 0
       Checksum : 55a0fe49 - correct
         Events : 0.35025133

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       0        0        1      faulty removed
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2



   deagol:~ # mdadm --examine /dev/sdb2
/dev/sdb2:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : c88a2afe:2990ceff:33d71a2a:eeb7be47
  Creation Time : Fri Mar 31 12:08:16 2006
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Apr 27 09:55:54 2004
          State : active
Active Devices : 4
Working Devices : 4
Failed Devices : 0
  Spare Devices : 0
       Checksum : 5545337b - correct
         Events : 0.32012979

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     1       8       18        1      active sync   /dev/sdb2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2



deagol:~ # mdadm --examine /dev/sdc2
/dev/sdc2:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : c88a2afe:2990ceff:33d71a2a:eeb7be47
  Creation Time : Fri Mar 31 12:08:16 2006
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Jun  1 04:15:00 2004
          State : active
Active Devices : 3
Working Devices : 3
Failed Devices : 2
  Spare Devices : 0
       Checksum : 55a0fe6d - correct
         Events : 0.35025133

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     2       8       34        2      active sync   /dev/sdc2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       0        0        1      faulty removed
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2


   deagol:~ # mdadm --examine /dev/sdd2
/dev/sdd2:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : c88a2afe:2990ceff:33d71a2a:eeb7be47
  Creation Time : Fri Mar 31 12:08:16 2006
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Tue Jun  1 04:15:00 2004
          State : active
Active Devices : 3
Working Devices : 3
Failed Devices : 2
  Spare Devices : 0
       Checksum : 55a0fe7f - correct
         Events : 0.35025133

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     3       8       50        3      active sync   /dev/sdd2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       0        0        1      faulty removed
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2


Can anyone please advise which commands we should use to get the array
back to at least a read only state?

Below is some of dmesg output:

Thanks!

Simon.





deagol:~ # dmesg
Bootdata ok (command line is root=/dev/sdb1 ide=nodma apm=off acpi=off
noresume selinux=0 edd=off 3)
Linux version 2.6.13-15.8-smp (geeko@buildhost) (gcc version 4.0.2
20050901 (prerelease) (SUSE Linux)) #1 SMP Tue Feb 7 11:07:24 UTC 2006
<snip>
Probing IDE interface ide0...
hda: TSSTcorpDVD-ROM SH-D162C, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
libata version 1.12 loaded.
sata_nv version 0.6
PCI: Setting latency timer of device 0000:00:0e.0 to 64
ata1: SATA max UDMA/133 cmd 0xE800 ctl 0xE482 bmdma 0xE000 irq 5
ata2: SATA max UDMA/133 cmd 0xE400 ctl 0xE082 bmdma 0xE008 irq 5
ata1: dev 0 cfg 49:2f00 82:346b 83:7f01 84:4003 85:3469 86:3c01 87:4003
88:203f
ata1: dev 0 ATA, max UDMA/100, 586072368 sectors: lba48
ata1: dev 0 configured for UDMA/100
scsi0 : sata_nv
ata2: dev 0 cfg 49:2f00 82:346b 83:7f01 84:4003 85:3469 86:3c01 87:4003
88:203f
ata2: dev 0 ATA, max UDMA/100, 586072368 sectors: lba48
ata2: dev 0 configured for UDMA/100
scsi1 : sata_nv
  Vendor: ATA       Model: WDC WD3000JD-00K  Rev: 08.0
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 586072368 512-byte hdwr sectors (300069 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 586072368 512-byte hdwr sectors (300069 MB)
SCSI device sda: drive cache: write back
sda: sda1 sda2
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
  Vendor: ATA       Model: WDC WD3000JD-00K  Rev: 08.0
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdb: 586072368 512-byte hdwr sectors (300069 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 586072368 512-byte hdwr sectors (300069 MB)
SCSI device sdb: drive cache: write back
sdb: sdb1 sdb2
Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0
Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0
sata_sil version 0.9
ata3: SATA max UDMA/100 cmd 0xFFFFC20000010C80 ctl 0xFFFFC20000010C8A
bmdma 0xFFFFC20000010C00 irq 5
ata4: SATA max UDMA/100 cmd 0xFFFFC20000010CC0 ctl 0xFFFFC20000010CCA
bmdma 0xFFFFC20000010C08 irq 5
ata3: dev 0 cfg 49:2f00 82:346b 83:7f01 84:4003 85:3469 86:3c01 87:4003
88:203f
ata3: dev 0 ATA, max UDMA/100, 586072368 sectors: lba48
ata3: dev 0 configured for UDMA/100
scsi2 : sata_sil
ata4: dev 0 cfg 49:2f00 82:346b 83:7f01 84:4003 85:3469 86:3c01 87:4003
88:203f
ata4: dev 0 ATA, max UDMA/100, 586072368 sectors: lba48
ata4: dev 0 configured for UDMA/100
scsi3 : sata_sil
  Vendor: ATA       Model: WDC WD3000JD-00K  Rev: 08.0
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdc: 586072368 512-byte hdwr sectors (300069 MB)
SCSI device sdc: drive cache: write back
SCSI device sdc: 586072368 512-byte hdwr sectors (300069 MB)
SCSI device sdc: drive cache: write back
sdc: sdc1 sdc2
Attached scsi disk sdc at scsi2, channel 0, id 0, lun 0
Attached scsi generic sg2 at scsi2, channel 0, id 0, lun 0,  type 0
  Vendor: ATA       Model: WDC WD3000JD-00K  Rev: 08.0
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdd: 586072368 512-byte hdwr sectors (300069 MB)
SCSI device sdd: drive cache: write back
SCSI device sdd: 586072368 512-byte hdwr sectors (300069 MB)
SCSI device sdd: drive cache: write back
sdd: sdd1 sdd2
Attached scsi disk sdd at scsi3, channel 0, id 0, lun 0
Attached scsi generic sg3 at scsi3, channel 0, id 0, lun 0,  type 0
ReiserFS: sdb1: found reiserfs format "3.6" with standard journal
ReiserFS: sdb1: using ordered data mode
ReiserFS: sdb1: journal params: device sdb1, size 8192, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: sdb1: checking transaction log (sdb1)
ReiserFS: sdb1: Using r5 hash to sort names
md: md0 stopped.
md: bind<sdb2>
md: bind<sdc2>
md: bind<sdd2>
md: bind<sda2>
md: kicking non-fresh sdb2 from array!
md: unbind<sdb2>
md: export_rdev(sdb2)
md: md0: raid array is not clean -- starting background reconstruction
raid5: automatically using best checksumming function: generic_sse
   generic_sse:  6157.000 MB/sec
raid5: using function: generic_sse (6157.000 MB/sec)
md: raid5 personality registered as nr 4
raid5: device sda2 operational as raid disk 0
raid5: device sdd2 operational as raid disk 3
raid5: device sdc2 operational as raid disk 2
raid5: cannot start dirty degraded array for md0
RAID5 conf printout:
--- rd:4 wd:3 fd:1
disk 0, o:1, dev:sda2
disk 2, o:1, dev:sdc2
disk 3, o:1, dev:sdd2
raid5: failed to run raid set md0
md: pers->run() failed ...
md: Autodetecting RAID arrays.
md: could not bd_claim sda2.
md: could not bd_claim sdc2.
md: could not bd_claim sdd2.
md: could not bd_claim sdb2.
md: autorun ...
md: considering sdb2 ...
md:  adding sdb2 ...
md: md0 already running, cannot run sdb2
md: export_rdev(sdb2)
md: ... autorun DONE.
device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
ReiserFS: sdc1: found reiserfs format "3.6" with standard journal
ReiserFS: sdc1: using ordered data mode
ReiserFS: sdc1: journal params: device sdc1, size 8192, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: sdc1: checking transaction log (sdc1)
ReiserFS: sdc1: Using r5 hash to sort names
ReiserFS: sdd1: found reiserfs format "3.6" with standard journal
ReiserFS: sdd1: using ordered data mode
ReiserFS: sdd1: journal params: device sdd1, size 8192, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: sdd1: checking transaction log (sdd1)
ReiserFS: sdd1: Using r5 hash to sort names
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE,EPP]
parport0: irq 7 detected
Adding 11325784k swap on /dev/sda1.  Priority:-1 extents:1
lp0: using parport0 (polling).
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
    ACPI-0768: *** Warning: Thread E09 could not acquire Mutex [<NULL>]
AE_BAD_PARAMETER
shpchp: acpi_shpchprm:get_device PCI ROOT HID fail=0x1001
    ACPI-0768: *** Warning: Thread DFF could not acquire Mutex [<NULL>]
AE_BAD_PARAMETER
shpchp: acpi_shpchprm:get_device PCI ROOT HID fail=0x1001
usbcore: registered new driver usbfs
usbcore: registered new driver hub
    ACPI-0768: *** Warning: Thread E79 could not acquire Mutex [<NULL>]
AE_BAD_PARAMETER
shpchp: acpi_shpchprm:get_device PCI ROOT HID fail=0x1001
PCI: Setting latency timer of device 0000:00:0b.1 to 64
ehci_hcd 0000:00:0b.1: EHCI Host Controller
ehci_hcd 0000:00:0b.1: debug port 1
ehci_hcd 0000:00:0b.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:0b.1: irq 3, io mem 0xfebdfc00
PCI: cache line size of 64 is not supported by device 0000:00:0b.1
ehci_hcd 0000:00:0b.1: park 0
ehci_hcd 0000:00:0b.1: USB 2.0 initialized, EHCI 1.00, driver 10 Dec 2004
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.35.
PCI: Setting latency timer of device 0000:00:14.0 to 64
ohci_hcd: 2005 April 22 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
PCI: Setting latency timer of device 0000:00:0b.0 to 64
ohci_hcd 0000:00:0b.0: OHCI Host Controller
ohci_hcd 0000:00:0b.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:0b.0: irq 5, io mem 0xfebde000
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
8139too Fast Ethernet driver 0.9.27
irq 3: nobody cared (try booting with the "irqpoll" option)

Call Trace: <IRQ> <ffffffff801655e5>{__report_bad_irq+53}
<ffffffff8016585a>{note_interrupt+538}
       <ffffffff80164fe3>{__do_IRQ+259} <ffffffff80111c48>{do_IRQ+72}
       <ffffffff8010f320>{ret_from_intr+0}  <EOI>
<ffffffff8010ed7e>{system_call+126}

handlers:
[<ffffffff88169bd0>] (usb_hcd_irq+0x0/0x70 [usbcore])
Disabling IRQ #3
eth0: forcedeth.c: subsystem: 010de:cb84 bound to 0000:00:14.0
eth1: RealTek RTL8139 at 0xffffc20000972800, 00:e0:4c:84:48:db, IRQ 5
eth1:  Identified 8139 chip type 'RTL-8100B/8139D'
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
hda: ATAPI 48X DVD-ROM drive, 256kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
eth0: no link during initialization.
eth0: link up.
IA-32 Microcode Update Driver: v1.14 <tigran@veritas.com>
microcode: CPU0 not a capable Intel processor
microcode: CPU1 not a capable Intel processor
microcode: No new microcode data for CPU0
microcode: No new microcode data for CPU1
IA-32 Microcode Update Driver v1.14 unregistered
BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
EDD information not available.
NET: Registered protocol family 10
Disabled Privacy Extensions on device ffffffff803fa060(lo)
IPv6 over IPv4 tunneling driver
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: recovery directory /var/lib/nfs/v4recovery doesn't exist
NFSD: starting 90-second grace period
eth0: no IPv6 routers present
eth1: no IPv6 routers present
st: Version 20050501, fixed bufsize 32768, s/g segs 256
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE,EPP]
parport0: irq 7 detected
lp0: using parport0 (polling).
ppa: Version 2.07 (for Linux 2.4.x)
end_request: I/O error, dev fd0, sector 0
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE,EPP]
parport0: irq 7 detected
lp0: using parport0 (polling).
ppa: Version 2.07 (for Linux 2.4.x)
end_request: I/O error, dev fd0, sector 0
NET: Registered protocol family 17
NETDEV WATCHDOG: eth0: transmit timed out


end of dmesg




simon redfern wrote:
> Hi Folks,
>
> Greetings from Berlin.
>
> We have a RAID5 (originally with 4 drives) - but it seems 1 drive has 
> failed although it still appears in lsscsi.
> Of the remaining 3 drives, 2 have the correct Event that matches the 
> Array Event.
>
> My question is: what is the best way to get the array to a readable 
> state? Do we need to replace the failed drive or should we be able to 
> recover with the remaining 3 drives?
>
> Here is some more info:
>
> At boot we have messages like the following:
>
> raid5 failed to run raid set md0
> ....
> mdadm: failed to RUN_ARRAY
> ......
> could not bd_claim sda2
> ......
> md0 already running, cannot run sdb2
> .......
>
> here is our mdadm.conf:
>
> cat /etc/mdadm.conf
>
> /dev/md0 <- the raid
>
> /dev/sda2 <- the raid members.
> /dev/sdb2
> /dev/sdc2
> /dev/sdd2
>
>
> and our mdstat:
>
> cat /proc/mdstat
>
> Personalities : [raid5]
> md0 : inactive sda2[0] sdd2[3] sdc2[2]
> a-number blocks
>
> unused devices <none>
>
> Thus it seems we are missing sdb2[1] from the array.
>
>
> mdadm --detail /dev/md0
>
> Device Site: 288.47 GB
> Raid Devices: 4
> Total Devices: 3
> Preferred Minor : 0
> Persistance: Superblock is persistent
>
> Update Time: Jun 1 2004 (note: system date is june 17 2007)
> State: active, degraded
> Active devices: 3
> Working devices: 3
> Failed Devices: 0
> Spare Devices: 0
> Layout: left-symetric
> Chunk Size: 128K
>
> UUID: a-long-char-string.
> Events: 0.35025133
>
>
> Number     Major    Minor     RaidDevice     State
> 0        8        2        0            active sync     /dev/sda2
> 1        0        0        -            removed   2        8        
> 34        2            active sync     /dev/sdc2
> 3        8        50        3            active sync     /dev/sdd2
>
> ------------------
> It seems that the array is both dirty and degraded. Only two of the 
> drives have the same "Event" and one would hope that at least 3 (in a 
> 4 drive array) would have the same "Event" number.
> Guess this is the number of operations on each drive since they (all) 
> joined the raid.
>
> this is discovered thus:
>
> mdadm -E /dev/sd[b-i]1 | grep Event
>
>
> Events : 0.32012979 <- different!
> Events : 0.35025133
> Events : 0.35025133
>
> However, lsscsi shows all 4 drives (as ATA drives)
>
> Any suggestions much appreciated!
>
> cheers,
>
> Simon.
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>





