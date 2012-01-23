From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Drive goes into slow state with uncorrectable sectors, but does not fail
Date: Mon, 23 Jan 2012 16:02:52 +0000
Message-ID: <jfk0bd$ei4$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We have a drive in a RAID 1 that has gone into a slow state after a MD data 
check, running Scientific Linux 6.1. It has ~3200 pending sectors (no 
uncorrectable or reallocated sectors) and it is "healthy" according to 
smartctl. Doing a raid check now runs at ~100 kB/s, but doesn't produce any 
MD errors. It's a Maxtor 6H500F0.

The initial error messages on the drive were
Jan 22 04:00:47 xserv2 kernel: ata3: EH in SWNCQ mode,QC:qc_active 
0x7FFFEFFF sactive 0x7FFFEFFF
Jan 22 04:00:47 xserv2 kernel: ata3: SWNCQ:qc_active 0x1102E00D defer_bits 
0x6EFD0FF2 last_issue_tag 0x3
Jan 22 04:00:47 xserv2 kernel:  dhfis 0x1102E00D dmafis 0x0 sdbfis 
0x6EFD1FF2
Jan 22 04:00:47 xserv2 kernel: ata3: ATA_REG 0x40 ERR_REG 0x0
Jan 22 04:00:47 xserv2 kernel: ata3: tag : dhfis dmafis sdbfis sacitve
Jan 22 04:00:47 xserv2 kernel: ata3: tag 0x0: 1 0 0 1  
Jan 22 04:00:47 xserv2 kernel: ata3: tag 0x2: 1 0 0 1  
Jan 22 04:00:47 xserv2 kernel: ata3: tag 0x3: 1 0 0 1  
Jan 22 04:00:47 xserv2 kernel: ata3: tag 0xd: 1 0 0 1  
Jan 22 04:00:47 xserv2 kernel: ata3: tag 0xe: 1 0 0 1  
Jan 22 04:00:47 xserv2 kernel: ata3: tag 0xf: 1 0 0 1  
Jan 22 04:00:47 xserv2 kernel: ata3: tag 0x11: 1 0 0 1  
Jan 22 04:00:47 xserv2 kernel: ata3: tag 0x18: 1 0 0 1  
Jan 22 04:00:47 xserv2 kernel: ata3: tag 0x1c: 1 0 0 1  
Jan 22 04:00:47 xserv2 kernel: ata3.00: exception Emask 0x0 SAct 0x7fffefff 
SErr 0x0 action 0x6 frozen
Jan 22 04:00:47 xserv2 kernel: ata3.00: failed command: READ FPDMA QUEUED
Jan 22 04:00:47 xserv2 kernel: ata3.00: cmd 
60/80:00:00:a1:72/00:00:01:00:00/40 tag 0 ncq 65536 in
Jan 22 04:00:47 xserv2 kernel:         res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jan 22 04:00:47 xserv2 kernel: ata3.00: status: { DRDY }
...
Jan 22 04:00:47 xserv2 kernel: ata3: hard resetting link
Jan 22 04:00:47 xserv2 kernel: ata3: nv: skipping hardreset on occupied port
Jan 22 04:00:49 xserv2 kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Jan 22 04:00:49 xserv2 kernel: ata3.00: configured for UDMA/133
Jan 22 04:00:49 xserv2 kernel: ata3.00: device reported invalid CHS sector 0
Jan 22 04:00:49 xserv2 kernel: ata3.00: device reported invalid CHS sector 0
...
Jan 22 04:00:49 xserv2 kernel: ata3: EH complete
Jan 22 04:01:19 xserv2 kernel: ata3: EH in SWNCQ mode,QC:qc_active 
0x2F3FFFF7 sactive 0x2F3FFFF7
Jan 22 04:01:19 xserv2 kernel: ata3: SWNCQ:qc_active 0x2F3FFFF7 defer_bits 
0x0 last_issue_tag 0x1d
Jan 22 04:01:19 xserv2 kernel:  dhfis 0x2F3FFFF7 dmafis 0x0 sdbfis 
0x10C00008

This repeats several times. Stangely ata3 is reported to be the other drive 
on bootup, so I don't know what's going on there. The drive with the bad 
sectors is very slow if you try to time it with dd, but the other drive is 
fine.

Unfortunately, although the system is very unresponsive, md is not failing 
the bad drive. Is this just a case of a drive not properly realising that 
it's faulty, or is md missing these errors?

When you do a MD "check", does this actually verify that the data is the 
same on both drives?

Jeremy



