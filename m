From: Luke Sheldrick <luke@sheldrick.co.uk>
Subject: RE: mdadm crashing server?
Date: Mon, 28 Apr 2008 09:25:14 +0100
Message-ID: <23803AB141208D42AD050BF05F9EFB6A31EE160DCE@londondc02.an0key.net>
References: <00c801c8a8e8$a1dc5670$0405a8c0@hp>,<alpine.LFD.1.10.0804280619240.5431@www.karsites.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0804280619240.5431@www.karsites.net>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


From the Linux software raid howto: It is not recommended to
>run the same RAID1 array on the same IDE cable as
>master/slave. In fact the howto recommends 1 drive set as
>master on one cable only. One reason being if your master
>drive goes down, then the slave may not operate correctly.


I was think it probably wasn't a good idea.

I changed over one of the disc's from the array, to sit on the secondary IDE. It seems to now die at 1% and reset the sync (not killing the machine this time however)

Below is what is cropping up in the /var/log/messages

Apr 28 09:26:51 nas kernel: ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 28 09:26:51 nas kernel: ata4.01: BMDMA stat 0x64
Apr 28 09:26:51 nas kernel: ata4.01: cmd c8/00:00:00:61:94/00:00:00:00:00/f0 tag 0 dma 131072 in
Apr 28 09:26:51 nas kernel:          res 51/40:00:80:61:94/40:04:00:00:00/f0 Emask 0x9 (media error)
Apr 28 09:26:51 nas kernel: ata4.01: status: { DRDY ERR }
Apr 28 09:26:51 nas kernel: ata4.01: error: { UNC }
Apr 28 09:26:51 nas kernel: ata4.00: configured for UDMA/33
Apr 28 09:26:51 nas kernel: ata4.01: configured for UDMA/100
Apr 28 09:26:51 nas kernel: ata4: EH complete
Apr 28 09:26:53 nas kernel: ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 28 09:26:53 nas kernel: ata4.01: BMDMA stat 0x64
Apr 28 09:26:53 nas kernel: ata4.01: cmd c8/00:00:00:61:94/00:00:00:00:00/f0 tag 0 dma 131072 in
Apr 28 09:26:53 nas kernel:          res 51/40:00:80:61:94/40:04:00:00:00/f0 Emask 0x9 (media error)
Apr 28 09:26:53 nas kernel: ata4.01: status: { DRDY ERR }
Apr 28 09:26:53 nas kernel: ata4.01: error: { UNC }
Apr 28 09:26:53 nas kernel: ata4.00: configured for UDMA/33
Apr 28 09:26:53 nas kernel: ata4.01: configured for UDMA/100
Apr 28 09:26:53 nas kernel: ata4: EH complete
Apr 28 09:26:53 nas kernel: sd 3:0:0:0: [sde] 586072368 512-byte hardware sectors (300069 MB)
Apr 28 09:26:54 nas kernel: ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 28 09:26:54 nas kernel: ata4.01: BMDMA stat 0x64
Apr 28 09:26:54 nas kernel: ata4.01: cmd c8/00:00:00:61:94/00:00:00:00:00/f0 tag 0 dma 131072 in
Apr 28 09:26:54 nas kernel:          res 51/40:00:80:61:94/40:04:00:00:00/f0 Emask 0x9 (media error)
Apr 28 09:26:54 nas kernel: ata4.01: status: { DRDY ERR }
Apr 28 09:26:54 nas kernel: ata4.01: error: { UNC }
Apr 28 09:26:54 nas kernel: ata4.00: configured for UDMA/33
Apr 28 09:26:54 nas kernel: ata4.01: configured for UDMA/100
Apr 28 09:26:54 nas kernel: ata4: EH complete
Apr 28 09:26:54 nas kernel: sd 3:0:0:0: [sde] Write Protect is off
Apr 28 09:26:56 nas kernel: ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 28 09:26:56 nas kernel: ata4.01: BMDMA stat 0x64
Apr 28 09:26:56 nas kernel: ata4.01: cmd c8/00:00:00:61:94/00:00:00:00:00/f0 tag 0 dma 131072 in
Apr 28 09:26:56 nas kernel:          res 51/40:00:80:61:94/40:04:00:00:00/f0 Emask 0x9 (media error)
Apr 28 09:26:56 nas kernel: ata4.01: status: { DRDY ERR }
Apr 28 09:26:56 nas kernel: ata4.01: error: { UNC }
Apr 28 09:26:56 nas kernel: ata4.00: configured for UDMA/33
Apr 28 09:26:56 nas kernel: ata4.01: configured for UDMA/100
Apr 28 09:26:56 nas kernel: ata4: EH complete
Apr 28 09:26:57 nas kernel: ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 28 09:26:57 nas kernel: ata4.01: BMDMA stat 0x64
Apr 28 09:26:57 nas kernel: ata4.01: cmd c8/00:00:00:61:94/00:00:00:00:00/f0 tag 0 dma 131072 in
Apr 28 09:26:57 nas kernel:          res 51/40:00:80:61:94/40:04:00:00:00/f0 Emask 0x9 (media error)
Apr 28 09:26:57 nas kernel: ata4.01: status: { DRDY ERR }
Apr 28 09:26:57 nas kernel: ata4.01: error: { UNC }
Apr 28 09:26:57 nas kernel: ata4.00: configured for UDMA/33
Apr 28 09:26:57 nas kernel: ata4.01: configured for UDMA/100
Apr 28 09:26:57 nas kernel: ata4: EH complete
Apr 28 09:26:57 nas kernel: sd 3:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 28 09:26:59 nas kernel: ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 28 09:26:59 nas kernel: ata4.01: BMDMA stat 0x64
Apr 28 09:26:59 nas kernel: ata4.01: cmd c8/00:00:00:61:94/00:00:00:00:00/f0 tag 0 dma 131072 in
Apr 28 09:26:59 nas kernel:          res 51/40:00:80:61:94/40:04:00:00:00/f0 Emask 0x9 (media error)
Apr 28 09:26:59 nas kernel: ata4.01: status: { DRDY ERR }
Apr 28 09:26:59 nas kernel: ata4.01: error: { UNC }
Apr 28 09:26:59 nas kernel: ata4.00: configured for UDMA/33
Apr 28 09:26:59 nas kernel: ata4.01: configured for UDMA/100
Apr 28 09:26:59 nas kernel: sd 3:0:1:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Apr 28 09:26:59 nas kernel: sd 3:0:1:0: [sdf] Sense Key : Medium Error [current] [descriptor]
Apr 28 09:26:59 nas kernel: Descriptor sense data with sense descriptors (in hex):
Apr 28 09:26:59 nas kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
Apr 28 09:26:59 nas kernel:         00 94 61 80
Apr 28 09:26:59 nas kernel: sd 3:0:1:0: [sdf] Add. Sense: Unrecovered read error - auto reallocate failed
Apr 28 09:26:59 nas kernel: end_request: I/O error, dev sdf, sector 9724288
Apr 28 09:26:59 nas kernel: ata4: EH complete
Apr 28 09:26:59 nas kernel: sd 3:0:1:0: [sdf] 490234752 512-byte hardware sectors (251000 MB)
Apr 28 09:26:59 nas kernel: sd 3:0:1:0: [sdf] Write Protect is off
Apr 28 09:26:59 nas kernel: sd 3:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 28 09:26:59 nas kernel: sd 3:0:0:0: [sde] 586072368 512-byte hardware sectors (300069 MB)
Apr 28 09:27:01 nas kernel: ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 28 09:27:01 nas kernel: ata4.01: BMDMA stat 0x64
Apr 28 09:27:01 nas kernel: ata4.01: cmd c8/00:08:80:61:94/00:00:00:00:00/f0 tag 0 dma 4096 in
Apr 28 09:27:01 nas kernel:          res 51/40:08:80:61:94/40:04:00:00:00/f0 Emask 0x9 (media error)
Apr 28 09:27:01 nas kernel: ata4.01: status: { DRDY ERR }
Apr 28 09:27:01 nas kernel: ata4.01: error: { UNC }
Apr 28 09:27:01 nas kernel: ata4.00: configured for UDMA/33
Apr 28 09:27:01 nas kernel: ata4.01: configured for UDMA/100
Apr 28 09:27:01 nas kernel: ata4: EH complete
Apr 28 09:27:01 nas kernel: sd 3:0:0:0: [sde] Write Protect is off
Apr 28 09:27:02 nas kernel: ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 28 09:27:02 nas kernel: ata4.01: BMDMA stat 0x64
Apr 28 09:27:02 nas kernel: ata4.01: cmd c8/00:08:80:61:94/00:00:00:00:00/f0 tag 0 dma 4096 in
Apr 28 09:27:02 nas kernel:          res 51/40:08:80:61:94/40:04:00:00:00/f0 Emask 0x9 (media error)
Apr 28 09:27:02 nas kernel: ata4.01: status: { DRDY ERR }
Apr 28 09:27:02 nas kernel: ata4.01: error: { UNC }
Apr 28 09:27:02 nas kernel: ata4.00: configured for UDMA/33
Apr 28 09:27:02 nas kernel: ata4.01: configured for UDMA/100
Apr 28 09:27:02 nas kernel: ata4: EH complete
Apr 28 09:27:04 nas kernel: ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 28 09:27:04 nas kernel: ata4.01: BMDMA stat 0x64
Apr 28 09:27:04 nas kernel: ata4.01: cmd c8/00:08:80:61:94/00:00:00:00:00/f0 tag 0 dma 4096 in
Apr 28 09:27:04 nas kernel:          res 51/40:08:80:61:94/40:04:00:00:00/f0 Emask 0x9 (media error)
Apr 28 09:27:04 nas kernel: ata4.01: status: { DRDY ERR }
Apr 28 09:27:04 nas kernel: ata4.01: error: { UNC }
Apr 28 09:27:04 nas kernel: ata4.00: configured for UDMA/33
Apr 28 09:27:04 nas kernel: ata4.01: configured for UDMA/100
Apr 28 09:27:04 nas kernel: ata4: EH complete
Apr 28 09:27:04 nas kernel: sd 3:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 28 09:27:05 nas kernel: ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 28 09:27:05 nas kernel: ata4.01: BMDMA stat 0x64
Apr 28 09:27:05 nas kernel: ata4.01: cmd c8/00:08:80:61:94/00:00:00:00:00/f0 tag 0 dma 4096 in
Apr 28 09:27:05 nas kernel:          res 51/40:08:80:61:94/40:04:00:00:00/f0 Emask 0x9 (media error)
Apr 28 09:27:05 nas kernel: ata4.01: status: { DRDY ERR }
Apr 28 09:27:05 nas kernel: ata4.01: error: { UNC }
Apr 28 09:27:05 nas kernel: ata4.00: configured for UDMA/33
Apr 28 09:27:05 nas kernel: ata4.01: configured for UDMA/100
Apr 28 09:27:05 nas kernel: ata4: EH complete
Apr 28 09:27:07 nas kernel: ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 28 09:27:07 nas kernel: ata4.01: BMDMA stat 0x64
Apr 28 09:27:07 nas kernel: ata4.01: cmd c8/00:08:80:61:94/00:00:00:00:00/f0 tag 0 dma 4096 in
Apr 28 09:27:07 nas kernel:          res 51/40:08:80:61:94/40:04:00:00:00/f0 Emask 0x9 (media error)
Apr 28 09:27:07 nas kernel: ata4.01: status: { DRDY ERR }
Apr 28 09:27:07 nas kernel: ata4.01: error: { UNC }
Apr 28 09:27:07 nas kernel: ata4.00: configured for UDMA/33
Apr 28 09:27:07 nas kernel: ata4.01: configured for UDMA/100
Apr 28 09:27:07 nas kernel: ata4: EH complete
Apr 28 09:27:09 nas kernel: ata4.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Apr 28 09:27:09 nas kernel: ata4.01: BMDMA stat 0x64
Apr 28 09:27:09 nas kernel: ata4.01: cmd c8/00:08:80:61:94/00:00:00:00:00/f0 tag 0 dma 4096 in
Apr 28 09:27:09 nas kernel:          res 51/40:08:80:61:94/40:04:00:00:00/f0 Emask 0x9 (media error)
Apr 28 09:27:09 nas kernel: ata4.01: status: { DRDY ERR }
Apr 28 09:27:09 nas kernel: ata4.01: error: { UNC }
Apr 28 09:27:09 nas kernel: ata4.00: configured for UDMA/33
Apr 28 09:27:09 nas kernel: ata4.01: configured for UDMA/100
Apr 28 09:27:09 nas kernel: sd 3:0:1:0: [sdf] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Apr 28 09:27:09 nas kernel: sd 3:0:1:0: [sdf] Sense Key : Medium Error [current] [descriptor]
Apr 28 09:27:09 nas kernel: Descriptor sense data with sense descriptors (in hex):
Apr 28 09:27:09 nas kernel:         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
Apr 28 09:27:09 nas kernel:         00 94 61 80
Apr 28 09:27:09 nas kernel: sd 3:0:1:0: [sdf] Add. Sense: Unrecovered read error - auto reallocate failed
Apr 28 09:27:09 nas kernel: end_request: I/O error, dev sdf, sector 9724288
Apr 28 09:27:09 nas kernel: ata4: EH complete
Apr 28 09:27:09 nas kernel: raid1: sdf: unrecoverable I/O read error for block 9722240
Apr 28 09:27:09 nas kernel: md: md0: recovery done.
Apr 28 09:27:09 nas kernel: sd 3:0:1:0: [sdf] 490234752 512-byte hardware sectors (251000 MB)
Apr 28 09:27:09 nas kernel: sd 3:0:1:0: [sdf] Write Protect is off
Apr 28 09:27:09 nas kernel: sd 3:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 28 09:27:09 nas kernel: sd 3:0:0:0: [sde] 586072368 512-byte hardware sectors (300069 MB)
Apr 28 09:27:09 nas kernel: sd 3:0:0:0: [sde] Write Protect is off
Apr 28 09:27:09 nas kernel: sd 3:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 28 09:27:09 nas kernel: sd 3:0:1:0: [sdf] 490234752 512-byte hardware sectors (251000 MB)
Apr 28 09:27:09 nas kernel: sd 3:0:1:0: [sdf] Write Protect is off
Apr 28 09:27:09 nas kernel: sd 3:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr 28 09:27:09 nas kernel: RAID1 conf printout:
Apr 28 09:27:09 nas kernel:  --- wd:1 rd:2
Apr 28 09:27:09 nas kernel:  disk 0, wo:1, o:1, dev:sda1
Apr 28 09:27:09 nas kernel:  disk 1, wo:0, o:1, dev:sdf1
Apr 28 09:27:09 nas kernel: RAID1 conf printout:
Apr 28 09:27:09 nas kernel:  --- wd:1 rd:2
Apr 28 09:27:09 nas kernel:  disk 1, wo:0, o:1, dev:sdf1
Apr 28 09:27:09 nas kernel: RAID1 conf printout:
Apr 28 09:27:09 nas kernel:  --- wd:1 rd:2
Apr 28 09:27:09 nas kernel:  disk 0, wo:1, o:1, dev:sda1
Apr 28 09:27:09 nas kernel:  disk 1, wo:0, o:1, dev:sdf1
Apr 28 09:27:09 nas kernel: md: recovery of RAID array md0
Apr 28 09:27:09 nas kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Apr 28 09:27:09 nas kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Apr 28 09:27:09 nas kernel: md: using 128k window, over a total of 245111616 blocks.

b0rked disk?
