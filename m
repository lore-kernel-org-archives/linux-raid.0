From: PFC <lists@peufeu.com>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Thu, 19 Jan 2006 08:20:59 +0100
Message-ID: <op.s3l6o9krcigqcu@apollo13>
References: <20060117174531.27739.patches@notabene> <43CCA80B.4020603@tls.msk.ru> <20060117095019.GA27262@localhost.localdomain> <43CCD453.9070900@tls.msk.ru> <20060117160829.GA16606@lug.udel.edu> <43CD3388.9050107@tls.msk.ru> <20060118081407.GC18945@localhost.localdomain> <43CE3898.7090207@xs4all.nl> <Pine.LNX.4.56.0601181248460.19220@lion.drogon.net> <17358.54414.410350.594083@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17358.54414.410350.594083@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	While we're at it, here's a little issue I had with RAID5 ; not really  
the fault of md, but you might want to know...

	I have a 5x250GB RAID5 array for home storage (digital photo, my lossless  
ripped cds, etc). 1 IDE Drive ave 4 SATA Drives.
	Now, turns out one of the SATA drives is a Maxtor 6V250F0, and these have  
problems ; it died, then was RMA'd, then died again. Finally, it turned  
out this drive series is incompatible with nvidia sata chipsets. A third  
drive seems to work, setting the jumper to SATA 150.
	Back to the point.

	Failure mode of these drives is an IDE command timeout. This takes a long  
time ! So, when the drive has failed, each command to it takes forever. md  
will eventually reject said drive, but it takes hours ; and meanwhile, the  
computer is unusable and data is offline...

	In this case, the really tempting solution is to hit the windows key (er,  
the hard reset button) ; but doing this, makes the array dirty and  
degraded, and it won't mount, and all data is seemingly lost. (well,  
recoverable with a bit of hacking /* goto error; */, but that's not very  
clean...)

	This isn't really a md issue, but it's really annoying only when using  
RAID, because it makes a normal process (kicking a dead drive out) so slow  
it's almost non-functional. Is there a way to modify the timeout in  
question ?

	Note that, re-reading the log below, it writes "Disk failure on sdd1,  
disabling device. Operation continuing on 4 devices", but errors continue  
to come, and the array is still unreachable (ie. cat /proc/mdstat hangs,  
etc). Hmm...

	Thanks for the time.


Jan  8 21:38:41 apollo13 ReiserFS: md2: checking transaction log (md2)
Jan  8 21:39:11 apollo13 ata4: command 0xca timeout, stat 0xd0 host_stat  
0x21
Jan  8 21:39:11 apollo13 ata4: translated ATA stat/err 0xca/00 to SCSI  
SK/ASC/ASCQ 0xb/47/00
Jan  8 21:39:11 apollo13 ata4: status=0xca { Busy }
Jan  8 21:39:11 apollo13 sd 3:0:0:0: SCSI error: return code = 0x8000002
Jan  8 21:39:11 apollo13 sdd: Current: sense key=0xb
Jan  8 21:39:11 apollo13 ASC=0x47 ASCQ=0x0
Jan  8 21:39:11 apollo13 Info fld=0x3f
Jan  8 21:39:11 apollo13 end_request: I/O error, dev sdd, sector 63
Jan  8 21:39:11 apollo13 raid5: Disk failure on sdd1, disabling device.  
Operation continuing on 4 devices
Jan  8 21:39:11 apollo13 ATA: abnormal status 0xD0 on port 0x977
Jan  8 21:39:11 apollo13 ATA: abnormal status 0xD0 on port 0x977
Jan  8 21:39:11 apollo13 ATA: abnormal status 0xD0 on port 0x977
Jan  8 21:39:41 apollo13 ata4: command 0xca timeout, stat 0xd0 host_stat  
0x21
Jan  8 21:39:41 apollo13 ata4: translated ATA stat/err 0xca/00 to SCSI  
SK/ASC/ASCQ 0xb/47/00
Jan  8 21:39:41 apollo13 ata4: status=0xca { Busy }
Jan  8 21:39:41 apollo13 sd 3:0:0:0: SCSI error: return code = 0x8000002
Jan  8 21:39:41 apollo13 sdd: Current: sense key=0xb
Jan  8 21:39:41 apollo13 ASC=0x47 ASCQ=0x0
Jan  8 21:39:41 apollo13 Info fld=0x9840097
Jan  8 21:39:41 apollo13 end_request: I/O error, dev sdd, sector 159645847
Jan  8 21:39:41 apollo13 ATA: abnormal status 0xD0 on port 0x977
Jan  8 21:39:41 apollo13 ATA: abnormal status 0xD0 on port 0x977
Jan  8 21:39:41 apollo13 ATA: abnormal status 0xD0 on port 0x977
Jan  8 21:40:01 apollo13 cron[17973]: (root) CMD (test -x  
/usr/sbin/run-crons && /usr/sbin/run-crons )
Jan  8 21:40:11 apollo13 ata4: command 0x35 timeout, stat 0xd0 host_stat  
0x21
Jan  8 21:40:11 apollo13 ata4: translated ATA stat/err 0x35/00 to SCSI  
SK/ASC/ASCQ 0x4/00/00
Jan  8 21:40:11 apollo13 ata4: status=0x35 { DeviceFault SeekComplete  
CorrectedError Error }
Jan  8 21:40:11 apollo13 sd 3:0:0:0: SCSI error: return code = 0x8000002
Jan  8 21:40:11 apollo13 sdd: Current: sense key=0x4
Jan  8 21:40:11 apollo13 ASC=0x0 ASCQ=0x0
Jan  8 21:40:11 apollo13 end_request: I/O error, dev sdd, sector 465232831
