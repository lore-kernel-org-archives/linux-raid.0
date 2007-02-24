From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: nonzero mismatch_cnt with no earlier error
Date: Sat, 24 Feb 2007 11:23:55 +1100
Message-ID: <45DF859B.2050108@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I run a 'check' weekly, and yesterday it came up with a non-zero
mismatch count (184). There were no earlier RAID errors logged
and the count was zero after the run a week ago.

Now, the interesting part is that there was one i/o error logged
during the check *last week*, however the raid did not see it and
the count was zero at the end. No errors were logged during the
week since or during the check last night.

fsck (ext3 with logging) found no errors but I may have bad data
somewhere.

Should the raid have noticed the error, checked the offending
stripe and taken appropriate action? The messages from that error
are below.

Naturally, I do not know if the mismatch is related to the failure
last week, it could be from a number of other reasons (bad memory?
kernel bug?).


system details:
  2.6.20 vanilla
  /dev/sd[ab]: on motherboard
    IDE interface: Intel Corp. 82801EB (ICH5) Serial ATA 150 Storage Controller (rev 02)
  /dev/sd[cdef]: Promise SATA-II-150-TX4
    Unknown mass storage controller: Promise Technology, Inc.: Unknown device 3d18 (rev 02)
  All 6 disks are WD 320GB SATA of similar models

Tail of dmesg, showing all messages since last week 'check':

	*** last week check start:
[927080.617744] md: data-check of RAID array md0
[927080.630783] md: minimum _guaranteed_  speed: 24000 KB/sec/disk.
[927080.648734] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[927080.678103] md: using 128k window, over a total of 312568576 blocks.
	*** last week error:
[937567.332751] ata3.00: exception Emask 0x10 SAct 0x0 SErr 0x4190002 action 0x2
[937567.354094] ata3.00: cmd b0/d5:01:09:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 512 in
[937567.354096]          res 51/04:83:45:00:00/00:00:00:00:00/a0 Emask 0x10 (ATA bus error)
[937568.120783] ata3: soft resetting port
[937568.282450] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[937568.306693] ata3.00: configured for UDMA/100
[937568.319733] ata3: EH complete
[937568.361223] SCSI device sdc: 625142448 512-byte hdwr sectors (320073 MB)
[937568.397207] sdc: Write Protect is off
[937568.408620] sdc: Mode Sense: 00 3a 00 00
[937568.453522] SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
	*** last week check end:
[941696.843935] md: md0: data-check done.
[941697.246454] RAID5 conf printout:
[941697.256366]  --- rd:6 wd:6
[941697.264718]  disk 0, o:1, dev:sda1
[941697.275146]  disk 1, o:1, dev:sdb1
[941697.285575]  disk 2, o:1, dev:sdc1
[941697.296003]  disk 3, o:1, dev:sdd1
[941697.306432]  disk 4, o:1, dev:sde1
[941697.316862]  disk 5, o:1, dev:sdf1
	*** this week check start:
[1530647.746383] md: data-check of RAID array md0
[1530647.759677] md: minimum _guaranteed_  speed: 24000 KB/sec/disk.
[1530647.778041] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[1530647.807663] md: using 128k window, over a total of 312568576 blocks.
	*** this week check end:
[1545248.680745] md: md0: data-check done.
[1545249.266727] RAID5 conf printout:
[1545249.276930]  --- rd:6 wd:6
[1545249.285542]  disk 0, o:1, dev:sda1
[1545249.296228]  disk 1, o:1, dev:sdb1
[1545249.306923]  disk 2, o:1, dev:sdc1
[1545249.317613]  disk 3, o:1, dev:sdd1
[1545249.328292]  disk 4, o:1, dev:sde1
[1545249.338981]  disk 5, o:1, dev:sdf1

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
