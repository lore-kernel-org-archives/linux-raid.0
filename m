From: Seweryn Kowalski <skowalsk@us.edu.pl>
Subject: SCSI - help
Date: Mon, 24 Mar 2003 10:22:33 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030324102233.3c0978bf.skowalsk@us.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi
I've problem with my sof- raid.
On machine I've two scsi adpters (drivers: aic7xx on motherboard and atp870u pci slot)
On aic7xx I've soft raid5 (and it's o.k.) but when I try to make soft raid5 on  atp870u (with 9 disk) this process crash, tranfser goes down and in my log file I've:

Mar  5 08:20:19  kernel: scsi : aborting command due to timeout : pid 46081, scsi1, channel 0, id 11, lun 0 Read (10) 00 00 15 89 67 00 00 f8 00 
Mar  5 08:20:19  kernel:  r3b=20 
Mar  5 08:20:19  kernel: 
Mar  5 08:20:19  kernel:  que cdb=  28   0   0  15  88  6f   0   0  f8   0  last_lenu= 1f000 
Mar  5 08:20:19  kernel:  que cdb=  28   0   0  15  89  67   0   0  f8   0  last_lenu= 1f000 
Mar  5 08:20:19  kernel:  que cdb=  28   0   0  15  8c  4f   0   0  f8   0  last_lenu= 1f000 scsi : aborting command due to timeout : pid 46082, scsi1, channel 0, id 10, lun 0 Read (10) 00 00 15 88 6f 00 
00 f8 00 
Where is proble?
What I've to do?
Thanks for help
seweryn

sewer
