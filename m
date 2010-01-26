From: Giovanni Tessore <giotex@texsoft.it>
Subject: Read errors on raid5 ignored, array still clean .. then disaster
 !!
Date: Tue, 26 Jan 2010 23:28:03 +0100
Message-ID: <4B5F6C73.30707@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everybody!
I'm not very deep inside software raid, so I'd like some expert's help

I'm having a big problem with a raid5 array with 6 sata disks: /dev/md3 
made of /dev/sd[acbdef]4
kernel is 2.6.24 (ubuntu 8.04 2.6.24-21-server)
mdadm - v2.6.3 - 20th August 2007

Here is what happened as read from logs:
- since beginning of december a lot (hundreds) of read errors occurred 
on /dev/sdb, but md3 silently recovered them, WITHOUT setting the device 
as faulty (see error reported below) or signaling the situation
- on 18 january a failure occured on /dev/sdf, and md3 marked it as faulty
- after /dev/sdf was replaced with new disk and re-added to array, the 
resync started
- at 98% of the resync, a read error occurred on /dev/sdb (as is was 
clearly in bad shape) and the whole array became unusable !!!

Is this some kind of bug?
Is there any way to configure raid in order to have devices marked 
faulty on read errors (at least when they clearly become too many)?

This could (and for me did) bring to big disasters!
Suppose you have a 4 disk raid with 2 spare disk ready for recovery
There are lot of read errors on disk 1, but md silently recovers them 
whitout marking disk as faulty (as it did for me)
Disk 3 fails
md adds one of the spare disks, and starts resync
resync fails due to the read errors on disk 1
everything is lost! till having 2 spare disks!!!???
This is no fault tollerance ... it's fault creation!!!

In a post of some months ago of a person who had a similar problem, I 
read as reply that ignoring the read errors is the wanted behaviour of 
md ... but I can't believe this!!

I was able to recover something with
mdadm --create /dev/md3 --assume-clean --level=5 --raid-devices=6 
--spare-devices=0 /dev/sda4 /dev/sdb4 /dev/sdc4 /dev/sdd4 /dev/sde4 missing
and use md3 in degraded mode, reapplying the command on each read error 
on /dev/sdb

Thanks in advance


Read errors reported into log about /dev/sdb long before the failure of 
/dev/sdf where like (notice the data recover message at bottom):

Dec 27 11:40:45 teroknor kernel:           res 
41/40:08:3b:b2:c3/14:00:38:00:00/00 Emask 0x409 (media error) <F>
Dec 27 11:40:45 teroknor kernel: ata2.00: configured for UDMA/133
Dec 27 11:40:45 teroknor kernel:  ata2: EH complete
Dec 27 11:40:45 teroknor kernel:  sd 1:0:0:0: [sdb] 976773168 512-byte 
hardware sectors (500108 MB)
Dec 27 11:40:45 teroknor kernel:  sd 1:0:0:0: [sdb] Write Protect is off
Dec 27 11:40:45 teroknor kernel:  sd 1:0:0:0: [sdb] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
Dec 27 11:40:48 teroknor kernel:           res 
41/40:08:3b:b2:c3/14:00:38:00:00/00 Emask 0x409 (media error) <F>
Dec 27 11:40:48 teroknor kernel:  ata2.00: configured for UDMA/133
Dec 27 11:40:48 teroknor kernel:  ata2: EH complete
Dec 27 11:40:48 teroknor kernel:  sd 1:0:0:0: [sdb] 976773168 512-byte 
hardware sectors (500108 MB)
Dec 27 11:40:48 teroknor kernel:  sd 1:0:0:0: [sdb] Write Protect is off
Dec 27 11:40:48 teroknor kernel:  sd 1:0:0:0: [sdb] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
Dec 27 11:40:51 teroknor kernel:           res 
41/40:08:3b:b2:c3/14:00:38:00:00/00 Emask 0x409 (media error) <F>
Dec 27 11:40:51 teroknor kernel:  ata2.00: configured for UDMA/133
Dec 27 11:40:51 teroknor kernel:  ata2: EH complete
Dec 27 11:40:51 teroknor kernel:  sd 1:0:0:0: [sdb] 976773168 512-byte 
hardware sectors (500108 MB)
Dec 27 11:40:51 teroknor kernel:  sd 1:0:0:0: [sdb] Write Protect is off
Dec 27 11:40:51 teroknor kernel:  sd 1:0:0:0: [sdb] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
Dec 27 11:40:54 teroknor kernel:           res 
41/40:08:3b:b2:c3/14:00:38:00:00/00 Emask 0x409 (media error) <F>
Dec 27 11:40:54 teroknor kernel:  ata2.00: configured for UDMA/133
Dec 27 11:40:54 teroknor kernel:  ata2: EH complete
Dec 27 11:40:54 teroknor kernel:  sd 1:0:0:0: [sdb] 976773168 512-byte 
hardware sectors (500108 MB)
Dec 27 11:40:54 teroknor kernel:  sd 1:0:0:0: [sdb] Write Protect is off
Dec 27 11:40:54 teroknor kernel:  sd 1:0:0:0: [sdb] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
Dec 27 11:40:57 teroknor kernel:           res 
41/40:08:3b:b2:c3/14:00:38:00:00/00 Emask 0x409 (media error) <F>
Dec 27 11:40:57 teroknor kernel:  ata2.00: configured for UDMA/133
Dec 27 11:40:57 teroknor kernel:  ata2: EH complete
Dec 27 11:40:57 teroknor kernel:  sd 1:0:0:0: [sdb] 976773168 512-byte 
hardware sectors (500108 MB)
Dec 27 11:40:57 teroknor kernel:  sd 1:0:0:0: [sdb] Write Protect is off
Dec 27 11:40:57 teroknor kernel:  sd 1:0:0:0: [sdb] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
Dec 27 11:40:59 teroknor kernel:           res 
41/40:08:3b:b2:c3/14:00:38:00:00/00 Emask 0x409 (media error) <F>
Dec 27 11:40:59 teroknor kernel:  ata2.00: configured for UDMA/133
Dec 27 11:40:59 teroknor kernel:  sd 1:0:0:0: [sdb] Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Dec 27 11:40:59 teroknor kernel:  sd 1:0:0:0: [sdb] Sense Key : Medium 
Error [current] [descriptor]
Dec 27 11:40:59 teroknor kernel:  Descriptor sense data with sense 
descriptors (in hex):
Dec 27 11:40:59 teroknor kernel:          72 03 11 04 00 00 00 0c 00 0a 
80 00 00 00 00 00
Dec 27 11:40:59 teroknor kernel:          00 00 00 3b
Dec 27 11:40:59 teroknor kernel:  sd 1:0:0:0: [sdb] Add. Sense: 
Unrecovered read error - auto reallocate failed
Dec 27 11:40:59 teroknor kernel:  end_request: I/O error, dev sdb, 
sector 952349242
Dec 27 11:40:59 teroknor kernel:  ata2: EH complete
Dec 27 11:40:59 teroknor kernel:  sd 1:0:0:0: [sdb] 976773168 512-byte 
hardware sectors (500108 MB)
Dec 27 11:40:59 teroknor kernel:  sd 1:0:0:0: [sdb] Write Protect is off
Dec 27 11:40:59 teroknor kernel:  sd 1:0:0:0: [sdb] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
Dec 27 11:41:00 teroknor kernel:  raid5:md3: read error corrected (8 
sectors at 942549592 on sdb4)

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


