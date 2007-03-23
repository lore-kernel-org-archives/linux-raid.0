From: linux@horizon.com
Subject: Re: 2.6.20.3 AMD64 oops in CFQ code
Date: 23 Mar 2007 13:46:30 -0400
Message-ID: <20070323174630.31051.qmail@science.horizon.com>
References: <17923.8970.917375.917772@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17923.8970.917375.917772@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: dan.j.williams@intel.com, linux-ide@vger.kernel.org, neilb@suse.de
Cc: cebbert@redhat.com, jens.axboe@oracle.com, linux-kernel@dale.us, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux@horizon.com
List-Id: linux-raid.ids

As an additional data point, here's a libata problem I'm having trying to
rebuild the array.

I have six identical 400 GB drives (ST3400832AS), and one is giving
me hassles.  I've run SMART short and long diagnostics, badblocks, and
Seagate's "seatools" diagnostic software, and none of these find problems.
It is the only one of the six with a non-zero reallocated sector count
(it's 26).

Anyway, the drive is partitioned into a 45G RAID-10 part and a 350G RAID-5
part.  The RAID-10 part integrated successfully, but the RAID-5 got to
about 60% and then puked:

ata5.00: exception Emask 0x0 SAct 0x1ef SErr 0x0 action 0x2 frozen
ata5.00: cmd 61/c0:00:d2:d0:b9/00:00:1c:00:00/40 tag 0 cdb 0x0 data 98304 out
         res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/40:08:92:d1:b9/00:00:1c:00:00/40 tag 1 cdb 0x0 data 32768 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/00:10:d2:d1:b9/01:00:1c:00:00/40 tag 2 cdb 0x0 data 131072 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/00:18:d2:d2:b9/01:00:1c:00:00/40 tag 3 cdb 0x0 data 131072 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/00:28:d2:d3:b9/01:00:1c:00:00/40 tag 5 cdb 0x0 data 131072 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/00:30:d2:d4:b9/01:00:1c:00:00/40 tag 6 cdb 0x0 data 131072 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/00:38:d2:d5:b9/01:00:1c:00:00/40 tag 7 cdb 0x0 data 131072 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: cmd 61/00:40:d2:d6:b9/01:00:1c:00:00/40 tag 8 cdb 0x0 data 131072 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5: soft resetting port
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: configured for UDMA/100
ata5: EH complete
SCSI device sde: 781422768 512-byte hdwr sectors (400088 MB)
sde: Write Protect is off
SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata5.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
         res 40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5: soft resetting port
ata5: softreset failed (timeout)
ata5: softreset failed, retrying in 5 secs
ata5: hard resetting port
ata5: softreset failed (timeout)
ata5: follow-up softreset failed, retrying in 5 secs
ata5: hard resetting port
ata5: softreset failed (timeout)
ata5: reset failed, giving up
ata5.00: disabled
ata5: EH complete
sd 4:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sde, sector 91795259
md: super_written gets error=-5, uptodate=0
raid10: Disk failure on sde3, disabling device. 
        Operation continuing on 5 devices
sd 4:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sde, sector 481942994
raid5: Disk failure on sde4, disabling device. Operation continuing on 5 devices
sd 4:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sde, sector 481944018
md: md5: recovery done.
RAID10 conf printout:
 --- wd:5 rd:6
 disk 0, wo:0, o:1, dev:sdb3
 disk 1, wo:0, o:1, dev:sdc3
 disk 2, wo:0, o:1, dev:sdd3
 disk 3, wo:1, o:0, dev:sde3
 disk 4, wo:0, o:1, dev:sdf3
 disk 5, wo:0, o:1, dev:sda3
RAID10 conf printout:
 --- wd:5 rd:6
 disk 0, wo:0, o:1, dev:sdb3
 disk 1, wo:0, o:1, dev:sdc3
 disk 2, wo:0, o:1, dev:sdd3
 disk 4, wo:0, o:1, dev:sdf3
 disk 5, wo:0, o:1, dev:sda3
RAID5 conf printout:
 --- rd:6 wd:5
 disk 0, o:1, dev:sda4
 disk 1, o:1, dev:sdb4
 disk 2, o:1, dev:sdc4
 disk 3, o:1, dev:sdd4
 disk 4, o:0, dev:sde4
 disk 5, o:1, dev:sdf4
RAID5 conf printout:
 --- rd:6 wd:5
 disk 0, o:1, dev:sda4
 disk 1, o:1, dev:sdb4
 disk 2, o:1, dev:sdc4
 disk 3, o:1, dev:sdd4
 disk 5, o:1, dev:sdf4

The first error address is just barely inside the RAID-10 part (which ends at
sector 91,795,410), while the second and third errors (at 481,942,994)
look like where the reconstruction was working.


Anyway, what's annoying is that I can't figure out how to bring the
drive back on line without resetting the box.  It's in a hot-swap enclosure,
but power cycling the drive doesn't seem to help.  I thought libata hotplug
was working?  (SiI3132 card, using the sil24 driver.)

(H'm... after rebooting, reallocated sectors jumped from 26 to 39.
Something is up with that drive.)
