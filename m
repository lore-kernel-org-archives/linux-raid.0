From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: raid5:md3: read error corrected ,  followed by ,  Machine Check
 Exception: .
Date: Sat, 14 Jul 2007 17:08:27 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0707141658210.16611@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>, Linux Kernel Maillist <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello All ,  I was under the impression that a 'machine check' would be 
caused by some near to the CPU hardware failure ,  Not a bad disk ?
 	I was also under the impression that software raid s/b a little more 
resilient than this .
 	But then maybe one or the other of the subsystems walked all over the 
other one trying to correct itself .  Who knows .
 	The below is ALL I'll be able to get .  A log of a previous boot is 
available at ...

http://www.baby-dragons.com/test-2.6.21.5-mptscsi-4.00.10.00-2007006161326.log

 		Tia ,  JimL

filesrv2 login: Jul 14 22:58:48 filesrv2 -- MARK --
Jul 14 23:00:26 filesrv2 kernel: sd 2:0:1:0: SCSI error: return code = 0x08000002
Jul 14 23:00:26 filesrv2 kernel: sdd: Current: sense key: Medium Error
Jul 14 23:00:26 filesrv2 kernel:     Additional sense: Read retries exhausted
Jul 14 23:00:26 filesrv2 kernel: Info fld=0x2f9c0f8
Jul 14 23:00:26 filesrv2 kernel: end_request: I/O error, dev sdd, sector 49922296
Jul 14 23:00:27 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 49922296 on sdd)
Jul 14 23:17:06 filesrv2 kernel: sd 2:0:1:0: SCSI error: return code = 0x08000002
Jul 14 23:17:06 filesrv2 kernel: sdd: Current: sense key: Medium Error
Jul 14 23:17:06 filesrv2 kernel:     Additional sense: Read retries exhausted
Jul 14 23:17:06 filesrv2 kernel: Info fld=0x44ebd82
Jul 14 23:17:06 filesrv2 kernel: end_request: I/O error, dev sdd, sector 72269186
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269184 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269192 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269200 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269208 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269216 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269224 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269232 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269240 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269248 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269256 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269264 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269272 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269280 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269288 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269296 on sdd)
Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269304 on sdd)
Jul 14 23:20:11 filesrv2 kernel: sd 2:0:1:0: SCSI error: return code = 0x08000002
Jul 14 23:20:11 filesrv2 kernel: sdd: Current: sense key: Medium Error
Jul 14 23:20:11 filesrv2 kernel:     Additional sense: Read retries exhausted
Jul 14 23:20:11 filesrv2 kernel: Info fld=0x4895ac1
Jul 14 23:20:11 filesrv2 kernel: end_request: I/O error, dev sdd, sector 76110529
Jul 14 23:20:12 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76110528 on sdd)
Jul 14 23:20:12 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76110536 on sdd)
Jul 14 23:20:12 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76110544 on sdd)
Jul 14 23:20:12 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76110552 on sdd)
Jul 14 23:20:12 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76110560 on sdd)
Jul 14 23:20:12 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76110568 on sdd)
Jul 14 23:20:12 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76110576 on sdd)
Jul 14 23:20:12 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76110584 on sdd)
Jul 14 23:20:28 filesrv2 kernel: sd 2:0:1:0: SCSI error: return code = 0x08000002
Jul 14 23:20:28 filesrv2 kernel: sdd: Current: sense key: Medium Error
Jul 14 23:20:28 filesrv2 kernel:     Additional sense: Read retries exhausted
Jul 14 23:20:28 filesrv2 kernel: Info fld=0x48d97ac
Jul 14 23:20:28 filesrv2 kernel: end_request: I/O error, dev sdd, sector 76388268
Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388264 on sdd)
Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388272 on sdd)
Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388280 on sdd)
Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388288 on sdd)
Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388296 on sdd)
Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388304 on sdd)
Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388312 on sdd)
Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388320 on sdd)
Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388328 on sdd)
Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388336 on sdd)
Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388344 on sdd)
Jul 14 23:38:48 filesrv2 -- MARK --
CPU 5: Machine Check Exception: 0000000000000004
CPU 4: Machine Check Exception: 0000000000000004
Kernel panic - not syncing: Unable to continue



-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
