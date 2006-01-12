From: PFC <lists@peufeu.com>
Subject: Re: [git patch] 2.6.x libata fix
Date: Thu, 12 Jan 2006 11:57:49 +0100
Message-ID: <op.s29h2nbncigqcu@apollo13>
References: <20060109171104.GA25793@havoc.gtf.org> <43C4DB86.7030603@projecthugo.co.uk> <43C628FE.9020303@projecthugo.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43C628FE.9020303@projecthugo.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: kernel-lists@projecthugo.co.uk, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


	Hello,

	I've had a lot of problems with nv_sata (nforce3) and Maxtor harddrives.  
Basically it always boils down to :

Dec 24 23:04:34 apollo13 ata3: command 0x35 timeout, stat 0xd0 host_stat  
0x21
Dec 24 23:04:34 apollo13 ata3: translated ATA stat/err 0x35/00 to SCSI  
SK/ASC/ASCQ 0x4/00/00
Dec 24 23:04:34 apollo13 ata3: status=0x35 { DeviceFault SeekComplete  
CorrectedError Error }
Dec 24 23:04:34 apollo13 sd 2:0:0:0: SCSI error: return code = 0x8000002
Dec 24 23:04:34 apollo13 sdc: Current: sense key=0x4
Dec 24 23:04:34 apollo13 ASC=0x0 ASCQ=0x0
Dec 24 23:04:34 apollo13 end_request: I/O error, dev sdc, sector 490223295
Dec 24 23:04:34 apollo13 raid5: Disk failure on sdc1, disabling device.  
Operation continuing on 3 devices

	Plugging the Maxtor drives on the not-nv SATA sockets solved it (thanks  
god I have 2 maxtor and 2 seagate drives)...

	If you want more info, just ask.
