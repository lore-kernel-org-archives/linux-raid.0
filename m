From: Simon Jackson <sjackson@bluearc.com>
Subject: Reducing retries of devices in RAID 1 sets.
Date: Wed, 16 Sep 2009 11:17:30 +0100
Message-ID: <ABFC24E4C13D81489F7F624E14891C8622CB300E@uk-ex-mbx1.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am interested in whether the retry algorithm can be modified for SATA drives running in RAID 1 configurations when unrecoverable read error occurs.

It seems that by default the ata and sd drivers try hard to recover the data from the original member before kicking off the recovery read from the alternate member.  In a RAID 1 volume I would like to reduce these retries.

I used hdparm --make-bad-sector to flag a sector of a specific file on a RAID 1 member drive as corrupt then read the file.  Luckily (well I had a 50 50 chance) the first time I tried to read the file, the driver chose the corrupted member and there was a long (40 second) delay before the file was read.

I looked at kern.log and saw repeated retires before the ata and sd drivers drivers gave up and md recovered using the alternate member.

How can I get tell the drivers to give up after less retries and have the RAID recovery occur more quickly?

kern.log below shows the result of the test I ran.


2009-09-16T10:33:19+01:00 st67-2 kernel: [169804.411085] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
2009-09-16T10:33:19+01:00 st67-2 kernel: [169804.411085] ata1.00: irq_stat 0x40000008
2009-09-16T10:33:19+01:00 st67-2 kernel: [169804.411085] ata1.00: cmd 60/08:00:1e:2b:6c/00:00:07:00:00/40 tag 0 ncq 4096 in
2009-09-16T10:33:19+01:00 st67-2 kernel: [169804.411085]          res 41/40:08:1e:2b:6c/24:00:07:00:00/40 Emask 0x409 (media error) <F>
2009-09-16T10:33:19+01:00 st67-2 kernel: [169804.411085] ata1.00: status: { DRDY ERR }
2009-09-16T10:33:19+01:00 st67-2 kernel: [169804.411085] ata1.00: error: { UNC }
2009-09-16T10:33:19+01:00 st67-2 kernel: [169804.411085] ata1.00: configured for UDMA/133
2009-09-16T10:33:19+01:00 st67-2 kernel: [169804.411085] ata1: EH complete
2009-09-16T10:33:19+01:00 st67-2 kernel: [169804.411085] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
2009-09-16T10:33:19+01:00 st67-2 kernel: [169804.411085] sd 0:0:0:0: [sda] Write Protect is off
2009-09-16T10:33:19+01:00 st67-2 kernel: [169804.411085] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
2009-09-16T10:33:19+01:00 st67-2 kernel: [169804.411085] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2009-09-16T10:33:23+01:00 st67-2 kernel: [169808.625223] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
2009-09-16T10:33:23+01:00 st67-2 kernel: [169808.625223] ata1.00: irq_stat 0x40000008
2009-09-16T10:33:23+01:00 st67-2 kernel: [169808.625223] ata1.00: cmd 60/08:00:1e:2b:6c/00:00:07:00:00/40 tag 0 ncq 4096 in
2009-09-16T10:33:23+01:00 st67-2 kernel: [169808.625223]          res 41/40:08:1e:2b:6c/24:00:07:00:00/40 Emask 0x409 (media error) <F>
2009-09-16T10:33:23+01:00 st67-2 kernel: [169808.625223] ata1.00: status: { DRDY ERR }
2009-09-16T10:33:23+01:00 st67-2 kernel: [169808.625223] ata1.00: error: { UNC }
2009-09-16T10:33:23+01:00 st67-2 kernel: [169808.625223] ata1.00: configured for UDMA/133
2009-09-16T10:33:23+01:00 st67-2 kernel: [169808.625223] ata1: EH complete
2009-09-16T10:33:23+01:00 st67-2 kernel: [169808.631399] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
2009-09-16T10:33:23+01:00 st67-2 kernel: [169808.631399] sd 0:0:0:0: [sda] Write Protect is off
2009-09-16T10:33:23+01:00 st67-2 kernel: [169808.631399] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
2009-09-16T10:33:23+01:00 st67-2 kernel: [169808.631399] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2009-09-16T10:33:26+01:00 st67-2 kernel: [169812.282466] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
2009-09-16T10:33:26+01:00 st67-2 kernel: [169812.282466] ata1.00: irq_stat 0x40000008
2009-09-16T10:33:26+01:00 st67-2 kernel: [169812.282466] ata1.00: cmd 60/08:00:1e:2b:6c/00:00:07:00:00/40 tag 0 ncq 4096 in
2009-09-16T10:33:26+01:00 st67-2 kernel: [169812.282466]          res 41/40:08:1e:2b:6c/24:00:07:00:00/40 Emask 0x409 (media error) <F>
2009-09-16T10:33:26+01:00 st67-2 kernel: [169812.282466] ata1.00: status: { DRDY ERR }
2009-09-16T10:33:26+01:00 st67-2 kernel: [169812.282466] ata1.00: error: { UNC }
2009-09-16T10:33:26+01:00 st67-2 kernel: [169812.342602] ata1.00: configured for UDMA/133
2009-09-16T10:33:26+01:00 st67-2 kernel: [169812.342602] ata1: EH complete
2009-09-16T10:33:26+01:00 st67-2 kernel: [169812.282466] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
2009-09-16T10:33:26+01:00 st67-2 kernel: [169812.282466] sd 0:0:0:0: [sda] Write Protect is off
2009-09-16T10:33:26+01:00 st67-2 kernel: [169812.282466] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
2009-09-16T10:33:26+01:00 st67-2 kernel: [169812.282466] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2009-09-16T10:33:30+01:00 st67-2 kernel: [169816.044440] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
2009-09-16T10:33:30+01:00 st67-2 kernel: [169816.044440] ata1.00: irq_stat 0x40000008
2009-09-16T10:33:30+01:00 st67-2 kernel: [169816.044440] ata1.00: cmd 60/08:00:1e:2b:6c/00:00:07:00:00/40 tag 0 ncq 4096 in
2009-09-16T10:33:30+01:00 st67-2 kernel: [169816.044440]          res 41/40:08:1e:2b:6c/24:00:07:00:00/40 Emask 0x409 (media error) <F>
2009-09-16T10:33:30+01:00 st67-2 kernel: [169816.044440] ata1.00: status: { DRDY ERR }
2009-09-16T10:33:30+01:00 st67-2 kernel: [169816.044440] ata1.00: error: { UNC }
2009-09-16T10:33:30+01:00 st67-2 kernel: [169816.067752] ata1.00: configured for UDMA/133
2009-09-16T10:33:30+01:00 st67-2 kernel: [169816.067752] ata1: EH complete
2009-09-16T10:33:30+01:00 st67-2 kernel: [169816.214674] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
2009-09-16T10:33:30+01:00 st67-2 kernel: [169816.214674] sd 0:0:0:0: [sda] Write Protect is off
2009-09-16T10:33:30+01:00 st67-2 kernel: [169816.214674] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
2009-09-16T10:33:30+01:00 st67-2 kernel: [169816.214674] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2009-09-16T10:33:33+01:00 st67-2 kernel: [169820.288149] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
2009-09-16T10:33:33+01:00 st67-2 kernel: [169820.288149] ata1.00: irq_stat 0x40000008
2009-09-16T10:33:33+01:00 st67-2 kernel: [169820.288149] ata1.00: cmd 60/08:00:1e:2b:6c/00:00:07:00:00/40 tag 0 ncq 4096 in
2009-09-16T10:33:33+01:00 st67-2 kernel: [169820.288149]          res 41/40:08:1e:2b:6c/24:00:07:00:00/40 Emask 0x409 (media error) <F>
2009-09-16T10:33:33+01:00 st67-2 kernel: [169820.288149] ata1.00: status: { DRDY ERR }
2009-09-16T10:33:33+01:00 st67-2 kernel: [169820.288149] ata1.00: error: { UNC }
2009-09-16T10:33:33+01:00 st67-2 kernel: [169820.295846] ata1.00: configured for UDMA/133
2009-09-16T10:33:33+01:00 st67-2 kernel: [169820.295846] ata1: EH complete
2009-09-16T10:33:33+01:00 st67-2 kernel: [169820.295846] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
2009-09-16T10:33:33+01:00 st67-2 kernel: [169820.304066] sd 0:0:0:0: [sda] Write Protect is off
2009-09-16T10:33:33+01:00 st67-2 kernel: [169820.304068] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
2009-09-16T10:33:33+01:00 st67-2 kernel: [169820.304091] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] ata1.00: irq_stat 0x40000008
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] ata1.00: cmd 60/08:00:1e:2b:6c/00:00:07:00:00/40 tag 0 ncq 4096 in
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436]          res 41/40:08:1e:2b:6c/24:00:07:00:00/40 Emask 0x409 (media error) <F>
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] ata1.00: status: { DRDY ERR }
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] ata1.00: error: { UNC }
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] ata1.00: configured for UDMA/133
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] sd 0:0:0:0: [sda] Sense Key : Medium Error [current] [descriptor]
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] Descriptor sense data with sense descriptors (in hex):
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436]         07 6c 2b 1e
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] sd 0:0:0:0: [sda] Add. Sense: Unrecovered read error - auto reallocate failed
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] end_request: I/O error, dev sda, sector 124529438
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] raid1: sda6: rescheduling sector 69795920
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] ata1: EH complete
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] sd 0:0:0:0: [sda] Write Protect is off
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
2009-09-16T10:33:37+01:00 st67-2 kernel: [169824.396436] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2009-09-16T10:33:41+01:00 st67-2 kernel: [169828.345476] ata1.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
2009-09-16T10:33:41+01:00 st67-2 kernel: [169828.345476] ata1.00: irq_stat 0x40000008
2009-09-16T10:33:41+01:00 st67-2 kernel: [169828.345476] ata1.00: cmd 60/08:08:1e:2b:6c/00:00:07:00:00/40 tag 1 ncq 4096 in
2009-09-16T10:33:41+01:00 st67-2 kernel: [169828.345476]          res 41/40:08:1e:2b:6c/24:00:07:00:00/40 Emask 0x409 (media error) <F>
2009-09-16T10:33:41+01:00 st67-2 kernel: [169828.345476] ata1.00: status: { DRDY ERR }
2009-09-16T10:33:41+01:00 st67-2 kernel: [169828.345476] ata1.00: error: { UNC }
2009-09-16T10:33:41+01:00 st67-2 kernel: [169828.355378] ata1.00: configured for UDMA/133
2009-09-16T10:33:41+01:00 st67-2 kernel: [169828.355378] ata1: EH complete
2009-09-16T10:33:41+01:00 st67-2 kernel: [169828.355378] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
2009-09-16T10:33:41+01:00 st67-2 kernel: [169828.355378] sd 0:0:0:0: [sda] Write Protect is off
2009-09-16T10:33:41+01:00 st67-2 kernel: [169828.355378] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
2009-09-16T10:33:41+01:00 st67-2 kernel: [169828.355378] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2009-09-16T10:33:44+01:00 st67-2 kernel: [169831.798030] ata1.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
2009-09-16T10:33:44+01:00 st67-2 kernel: [169831.798030] ata1.00: irq_stat 0x40000008
2009-09-16T10:33:44+01:00 st67-2 kernel: [169831.798030] ata1.00: cmd 60/08:00:1e:2b:6c/00:00:07:00:00/40 tag 0 ncq 4096 in
2009-09-16T10:33:44+01:00 st67-2 kernel: [169831.798030]          res 41/40:08:1e:2b:6c/24:00:07:00:00/40 Emask 0x409 (media error) <F>
2009-09-16T10:33:44+01:00 st67-2 kernel: [169831.798030] ata1.00: status: { DRDY ERR }
2009-09-16T10:33:44+01:00 st67-2 kernel: [169831.798030] ata1.00: error: { UNC }
2009-09-16T10:33:44+01:00 st67-2 kernel: [169832.303786] ata1.00: configured for UDMA/133
2009-09-16T10:33:44+01:00 st67-2 kernel: [169832.303786] ata1: EH complete
2009-09-16T10:33:44+01:00 st67-2 kernel: [169832.303786] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
2009-09-16T10:33:44+01:00 st67-2 kernel: [169832.303786] sd 0:0:0:0: [sda] Write Protect is off
2009-09-16T10:33:44+01:00 st67-2 kernel: [169832.303786] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
2009-09-16T10:33:44+01:00 st67-2 kernel: [169832.303786] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2009-09-16T10:33:48+01:00 st67-2 kernel: [169836.587555] ata1.00: exception Emask 0x0 SAct 0x2 SErr 0x0 action 0x0
2009-09-16T10:33:48+01:00 st67-2 kernel: [169836.587555] ata1.00: irq_stat 0x40000008
2009-09-16T10:33:48+01:00 st67-2 kernel: [169836.587555] ata1.00: cmd 60/08:08:1e:2b:6c/00:00:07:00:00/40 tag 1 ncq 4096 in
2009-09-16T10:33:48+01:00 st67-2 kernel: [169836.587555]          res 41/40:08:1e:2b:6c/24:00:07:00:00/40 Emask 0x409 (media error) <F>
2009-09-16T10:33:48+01:00 st67-2 kernel: [169836.587555] ata1.00: status: { DRDY ERR }
2009-09-16T10:33:48+01:00 st67-2 kernel: [169836.587555] ata1.00: error: { UNC }
2009-09-16T10:33:48+01:00 st67-2 kernel: [169836.587555] ata1.00: configured for UDMA/133
2009-09-16T10:33:48+01:00 st67-2 kernel: [169836.587555] ata1: EH complete
2009-09-16T10:33:48+01:00 st67-2 kernel: [169836.593900] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
2009-09-16T10:33:48+01:00 st67-2 kernel: [169836.593900] sd 0:0:0:0: [sda] Write Protect is off
2009-09-16T10:33:48+01:00 st67-2 kernel: [169836.593900] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
2009-09-16T10:33:48+01:00 st67-2 kernel: [169836.593900] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2009-09-16T10:33:52+01:00 st67-2 kernel: [169840.548847] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
2009-09-16T10:33:52+01:00 st67-2 kernel: [169840.548847] ata1.00: irq_stat 0x40000008
2009-09-16T10:33:52+01:00 st67-2 kernel: [169840.548847] ata1.00: cmd 60/08:00:1e:2b:6c/00:00:07:00:00/40 tag 0 ncq 4096 in
2009-09-16T10:33:52+01:00 st67-2 kernel: [169840.548847]          res 41/40:08:1e:2b:6c/24:00:07:00:00/40 Emask 0x409 (media error) <F>
2009-09-16T10:33:52+01:00 st67-2 kernel: [169840.548847] ata1.00: status: { DRDY ERR }
2009-09-16T10:33:52+01:00 st67-2 kernel: [169840.548847] ata1.00: error: { UNC }
2009-09-16T10:33:52+01:00 st67-2 kernel: [169840.548847] ata1.00: configured for UDMA/133
2009-09-16T10:33:52+01:00 st67-2 kernel: [169840.548847] ata1: EH complete
2009-09-16T10:33:52+01:00 st67-2 kernel: [169840.548847] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
2009-09-16T10:33:52+01:00 st67-2 kernel: [169840.548847] sd 0:0:0:0: [sda] Write Protect is off
2009-09-16T10:33:52+01:00 st67-2 kernel: [169840.548847] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
2009-09-16T10:33:52+01:00 st67-2 kernel: [169840.548847] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2009-09-16T10:33:55+01:00 st67-2 kernel: [169844.579719] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
2009-09-16T10:33:55+01:00 st67-2 kernel: [169844.579719] ata1.00: irq_stat 0x40000008
2009-09-16T10:33:55+01:00 st67-2 kernel: [169844.579719] ata1.00: cmd 60/08:00:1e:2b:6c/00:00:07:00:00/40 tag 0 ncq 4096 in
2009-09-16T10:33:55+01:00 st67-2 kernel: [169844.579719]          res 41/40:08:1e:2b:6c/24:00:07:00:00/40 Emask 0x409 (media error) <F>
2009-09-16T10:33:55+01:00 st67-2 kernel: [169844.579719] ata1.00: status: { DRDY ERR }
2009-09-16T10:33:55+01:00 st67-2 kernel: [169844.579719] ata1.00: error: { UNC }
2009-09-16T10:33:55+01:00 st67-2 kernel: [169844.588005] ata1.00: configured for UDMA/133
2009-09-16T10:33:55+01:00 st67-2 kernel: [169844.588005] ata1: EH complete
2009-09-16T10:33:55+01:00 st67-2 kernel: [169844.588005] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
2009-09-16T10:33:55+01:00 st67-2 kernel: [169844.588005] sd 0:0:0:0: [sda] Write Protect is off
2009-09-16T10:33:55+01:00 st67-2 kernel: [169844.588005] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
2009-09-16T10:33:55+01:00 st67-2 kernel: [169844.588005] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.560574] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.560574] ata1.00: irq_stat 0x40000008
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.560574] ata1.00: cmd 60/08:00:1e:2b:6c/00:00:07:00:00/40 tag 0 ncq 4096 in
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.560574]          res 41/40:08:1e:2b:6c/24:00:07:00:00/40 Emask 0x409 (media error) <F>
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.560574] ata1.00: status: { DRDY ERR }
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.560574] ata1.00: error: { UNC }
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.584575] ata1.00: configured for UDMA/133
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.584575] sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.584575] sd 0:0:0:0: [sda] Sense Key : Medium Error [current] [descriptor]
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.584575] Descriptor sense data with sense descriptors (in hex):
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.584575]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.584575]         07 6c 2b 1e
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.584575] sd 0:0:0:0: [sda] Add. Sense: Unrecovered read error - auto reallocate failed
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.584575] end_request: I/O error, dev sda, sector 124529438
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.584575] ata1: EH complete
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.584575] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.584575] sd 0:0:0:0: [sda] Write Protect is off
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.584575] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.584575] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.876943] raid1:md1: read error corrected (8 sectors at 69795920 on sda6)
2009-09-16T10:33:59+01:00 st67-2 kernel: [169848.876943] raid1: sda6: redirecting sector 69795920 to another mirror


