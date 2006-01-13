From: Matt Darcy <kernel-lists@projecthugo.co.uk>
Subject: Re: [git patch] 2.6.x libata fix
Date: Fri, 13 Jan 2006 09:26:03 +0000
Message-ID: <43C7722B.2060408@projecthugo.co.uk>
References: <20060109171104.GA25793@havoc.gtf.org> <43C4DB86.7030603@projecthugo.co.uk> <43C628FE.9020303@projecthugo.co.uk> <op.s29h2nbncigqcu@apollo13>
Reply-To: kernel-lists@projecthugo.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.s29h2nbncigqcu@apollo13>
Sender: linux-raid-owner@vger.kernel.org
To: PFC <lists@peufeu.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

PFC wrote:

>
>     Hello,
>
>     I've had a lot of problems with nv_sata (nforce3) and Maxtor 
> harddrives.  Basically it always boils down to :
>
> Dec 24 23:04:34 apollo13 ata3: command 0x35 timeout, stat 0xd0 
> host_stat  0x21
> Dec 24 23:04:34 apollo13 ata3: translated ATA stat/err 0x35/00 to 
> SCSI  SK/ASC/ASCQ 0x4/00/00
> Dec 24 23:04:34 apollo13 ata3: status=0x35 { DeviceFault SeekComplete  
> CorrectedError Error }
> Dec 24 23:04:34 apollo13 sd 2:0:0:0: SCSI error: return code = 0x8000002
> Dec 24 23:04:34 apollo13 sdc: Current: sense key=0x4
> Dec 24 23:04:34 apollo13 ASC=0x0 ASCQ=0x0
> Dec 24 23:04:34 apollo13 end_request: I/O error, dev sdc, sector 
> 490223295
> Dec 24 23:04:34 apollo13 raid5: Disk failure on sdc1, disabling 
> device.  Operation continuing on 3 devices
>
>     Plugging the Maxtor drives on the not-nv SATA sockets solved it 
> (thanks  god I have 2 maxtor and 2 seagate drives)...
>
>

Thanks for the message,

I'm not using nv_sata, I'm using sata_mv,

just to clarify.

Could we please try to keep this thread on topic.

Regards,

Matt



