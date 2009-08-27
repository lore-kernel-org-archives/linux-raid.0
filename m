From: "MOgWai46[Saurceful of Secrets]" <street41@gmail.com>
Subject: Western Digital RE3: Raid Failure
Date: Thu, 27 Aug 2009 11:43:39 +0200
Message-ID: <b9f8dfb10908270243u1213576cs7c5cbc743d637c1c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sunday night i had a problem on my centos 5.3 Server:

Kernel: 2.6.18-128.4.1.el5
Hard Disks: 4 Western Digital Raid Edition 3 - 500 GB

ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata2.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 51/04:08:38:df:f7/00:00:00:00:00/a7 Emask 0x1 (device error)
ata2.00: status: { DRDY ERR }
ata2.00: error: { ABRT }
ata2.00: configured for UDMA/133
ata2.01: configured for UDMA/133
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata2.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 51/04:00:38:df:f7/00:00:00:00:00/a7 Emask 0x1 (device error)
ata2.00: status: { DRDY ERR }
ata2.00: error: { ABRT }
ata2.00: configured for UDMA/133
ata2.01: configured for UDMA/133
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata2.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 51/04:08:38:df:f7/00:00:00:00:00/a7 Emask 0x1 (device error)
ata2.00: status: { DRDY ERR }
ata2.00: error: { ABRT }
ata2.00: configured for UDMA/133
ata2.01: configured for UDMA/133
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata2.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 51/04:00:38:df:f7/00:00:00:00:00/a7 Emask 0x1 (device error)
ata2.00: status: { DRDY ERR }
ata2.00: error: { ABRT }
ata2.00: configured for UDMA/133
ata2.01: configured for UDMA/133
ata2: EH complete
SCSI device sdc: 976773168 512-byte hdwr sectors (500108 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: drive cache: write back
SCSI device sdc: 976773168 512-byte hdwr sectors (500108 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: drive cache: write back
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata2.00: BMDMA stat 0x65
ata2.00: cmd ca/00:08:69:22:ea/00:00:00:00:00/eb tag 0 dma 4096 out
         res 51/10:08:69:22:ea/00:00:00:00:00/eb Emask 0x81 (invalid argument)
ata2.00: status: { DRDY ERR }
ata2.00: error: { IDNF }
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
ata2.00: revalidation failed (errno=-5)
ata2: failed to recover some devices, retrying in 5 secs
ata2: soft resetting link
ata2.00: configured for UDMA/133
ata2.01: configured for UDMA/133
sd 1:0:0:0: SCSI error: return code = 0x08000002
sdc: Current [descriptor]: sense key: Aborted Command
    Add. Sense: Recorded entity not found

Descriptor sense data with sense descriptors (in hex):
        72 0b 14 00 00 00 00 0c 00 0a 80 00 00 00 00 00
        0b ea 22 69
end_request: I/O error, dev sdc, sector 199893609
raid1: Disk failure on sdc2, disabling device.
        Operation continuing on 1 devices
ata2: EH complete
SCSI device sdc: 976773168 512-byte hdwr sectors (500108 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: drive cache: write back
SCSI device sdc: 976773168 512-byte hdwr sectors (500108 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: drive cache: write back
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:1, o:0, dev:sdc2
 disk 1, wo:0, o:1, dev:sda2
RAID1 conf printout:
 --- wd:1 rd:2
 disk 1, wo:0, o:1, dev:sda2
md: unbind<sdc2>
md: export_rdev(sdc2)
md: bind<sdc2>

Monday morning i verified that SDC hard disk didn't have bad blocks
and i tried to re-add to the Raid md1. The raid array was rebuilded
with no problems.

I didn't modified the TLER settings on this four hard disk (Default
Value 7 seconds).

I have installed this type of drives beacuse with the WD Velociraptor
i had the same issue :(

Can be an issue of the Server Hardware?

Andrea
