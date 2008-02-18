From: Jeff Garzik <jeff@garzik.org>
Subject: Re: HDD errors in dmesg, but don't know why...
Date: Mon, 18 Feb 2008 15:18:47 -0500
Message-ID: <47B9E827.4060800@garzik.org>
References: <13c501c87264$411461d0$0603a8c0@meanmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1250; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <13c501c87264$411461d0$0603a8c0@meanmachine>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Fairbairn <steve@fairbairn-family.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Steve Fairbairn wrote:
> Hi All,
> 
> I've got a degraded RAID5 which I'm trying to add in the replacement
> disk.  Trouble is, every time the recovery starts, it flies along at
> 70MB/s or so.  Then after doing about 1%, it starts dropping rapidly,
> until eventually a device is marked failed.
> 
> When I look in dmesg, I get the following...
> 
> SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
> sdd: Write Protect is off
> sdd: Mode Sense: 00 3a 00 00
> SCSI device sdd: drive cache: write back
> ata5.00: exception Emask 0x0 SAct 0x7ff SErr 0x0 action 0x0
> ata5.00: (irq_stat 0x00060002, device error via SDB FIS)
> ata5.00: cmd 60/00:10:3f:0e:f9/01:00:00:00:00/40 tag 2 cdb 0x0 data
> 131072 in
>          res 41/40:00:50:0e:f9/9c:00:00:00:00/40 Emask 0x9 (media error)
> ata5.00: configured for UDMA/100
> ata5: EH complete
> SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
> sdd: Write Protect is off
> sdd: Mode Sense: 00 3a 00 00
> SCSI device sdd: drive cache: write back
> ata5.00: exception Emask 0x0 SAct 0x7ff SErr 0x0 action 0x0
> ata5.00: (irq_stat 0x00060002, device error via SDB FIS)
> ata5.00: cmd 60/00:18:3f:02:f9/01:00:00:00:00/40 tag 3 cdb 0x0 data
> 131072 in
>          res 41/40:00:c3:02:f9/9c:00:00:00:00/40 Emask 0x9 (media error)

"media error" means just that -- your hard drive is reporting bad media 
to libata, which in turn dutifully reports that info to you :)

	Jeff




