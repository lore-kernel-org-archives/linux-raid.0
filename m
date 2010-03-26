From: John Robinson <john.robinson@anonymous.org.uk>
Subject: An oddity: UNC error while re-adding/resyncing
Date: Fri, 26 Mar 2010 00:43:05 +0000
Message-ID: <4BAC0319.4010901@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I did `mdadm --add /dev/md1 /dev/sdd2` and got the following in my 
kernel log:

Mar 25 23:56:21 beast kernel: md: bind<sdd2>
Mar 25 23:56:21 beast kernel: RAID5 conf printout:
Mar 25 23:56:21 beast kernel:  --- rd:3 wd:2 fd:1
Mar 25 23:56:21 beast kernel:  disk 0, o:1, dev:sda2
Mar 25 23:56:21 beast kernel:  disk 1, o:1, dev:sdb2
Mar 25 23:56:21 beast kernel:  disk 2, o:1, dev:sdd2
Mar 25 23:56:21 beast kernel: md: syncing RAID array md1
Mar 25 23:56:21 beast kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Mar 25 23:56:21 beast kernel: md: using maximum available idle IO 
bandwidth (but not more than 2
00000 KB/sec) for reconstruction.
Mar 25 23:56:21 beast kernel: md: using 128k window, over a total of 
976655360 blocks.
Mar 25 23:56:22 beast kernel: ata3.00: exception Emask 0x0 SAct 0x3 SErr 
0x0 action 0x0
Mar 25 23:56:22 beast kernel: ata3.00: irq_stat 0x40000008
Mar 25 23:56:22 beast kernel: ata3.00: cmd 
60/00:00:a5:3f:03/04:00:00:00:00/40 tag 0 ncq 524288
in
Mar 25 23:56:25 beast kernel:          res 
41/40:00:a0:41:03/8c:00:00:00:00/40 Emask 0x409 (medi
a error) <F>
Mar 25 23:56:25 beast kernel: ata3.00: status: { DRDY ERR }
Mar 25 23:56:26 beast kernel: ata3.00: error: { UNC }
Mar 25 23:56:26 beast kernel: ata3.00: configured for UDMA/133
Mar 25 23:56:26 beast kernel: ata3: EH complete
Mar 25 23:56:26 beast kernel: SCSI device sda: 1953525168 512-byte hdwr 
sectors (1000205 MB)
Mar 25 23:56:26 beast kernel: sda: Write Protect is off
Mar 25 23:56:27 beast kernel: SCSI device sda: drive cache: write back
Mar 25 23:56:27 beast kernel: ata3.00: exception Emask 0x0 SAct 0x3 SErr 
0x0 action 0x0
Mar 25 23:56:28 beast kernel: ata3.00: irq_stat 0x40000008
Mar 25 23:56:28 beast kernel: ata3.00: cmd 
60/00:08:a5:3f:03/04:00:00:00:00/40 tag 1 ncq 524288
in
Mar 25 23:56:28 beast kernel:          res 
41/40:00:a2:41:03/8c:00:00:00:00/40 Emask 0x409 (medi
a error) <F>
Mar 25 23:56:28 beast kernel: ata3.00: status: { DRDY ERR }
Mar 25 23:56:28 beast kernel: ata3.00: error: { UNC }
Mar 25 23:56:29 beast kernel: ata3.00: configured for UDMA/133
Mar 25 23:56:29 beast kernel: ata3: EH complete
Mar 25 23:56:29 beast kernel: SCSI device sda: 1953525168 512-byte hdwr 
sectors (1000205 MB)
Mar 25 23:56:29 beast kernel: sda: Write Protect is off
Mar 25 23:56:29 beast kernel: SCSI device sda: drive cache: write back
Mar 25 23:56:34 beast kernel: md: md1: sync done.
Mar 25 23:56:34 beast kernel: RAID5 conf printout:
Mar 25 23:56:34 beast kernel:  --- rd:3 wd:3 fd:0
Mar 25 23:56:34 beast kernel:  disk 0, o:1, dev:sda2
Mar 25 23:56:34 beast kernel:  disk 1, o:1, dev:sdb2
Mar 25 23:56:34 beast kernel:  disk 2, o:1, dev:sdd2

i.e. a brief whinge about another of the discs in the RAID, while doing 
the resync. And this is repeatable. Now, is this simply a sign that I 
need a new disc, or is there something else funny going on? It's not as 
if either of the discs (the one I was re-adding or the one that had the 
UNC during the resync) is getting dropped from the array. But the one 
with the UNC does have one offline uncorrectable and two current pending 
sectors, according to smartctl.

NB CentOS 5, 2.6.18-128.4.1.el5 kernel, mdadm 2.6.4. Probably time I 
updated a few packages.

Cheers,

John.
