From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Ninth(?) Velociraptor replacement or md(RAID)/smartmontools(?)
 bug?
Date: Fri, 21 Nov 2008 12:30:23 +0100
Message-ID: <49269BCF.8060300@rabbit.us>
References: <alpine.DEB.1.10.0811210600310.5577@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811210600310.5577@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, martmontools-support@lists.sourceforge.net, Bruce Allen <ballen@gravity.phys.uwm.edu>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> Comment 1: From Alan Cox:
> 
> ================================================================================
> 
> Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
>> Error 1 occurred at disk power-on lifetime: 818 hours (34 days + 2 hours)
>>    When the command that caused the error occurred, the device was
>> doing SMART
> Offline or Self-test.
>>
>>    After command completion occurred, registers were:
>>    ER ST SC SN CL CH DH
>>    -- -- -- -- -- -- --
>>    04 51 00 34 cf f3 a3
> 
> So Error 0x04 (ABRT)
> Status 0x51 (DRDY N/A ERR)      Error occurred, and at the point data
> transfer was expected
> 
> Which the spec says means the device errored the command because it does
> not support it.
> 
> Seems odd that this then tripped a raid failover
> ================================================================================
> 
> 
> Comment 1 Response: Should this have tripped a raid fail-over?  I have
> been having raid failures like this ever since I replaced all my
> raptor150s with velociraptor300 disks, what can be done so this does not
> occur?  Is this a WD/firmware bug or a bug in the md/raid code?
> 
> ================================================================================
> 

It might very well be a WD bug. I had three (3) identical WDC
WD2500AAJS-08B4A0 drives fail on me with the same _identical_ error
(same sector number to the last digit):

Oct 27 11:33:41 Arzamas kernel: ata6.00: exception Emask 0x10 SAct 0x0
SErr 0x80000 action 0xe frozen
Oct 27 11:33:41 Arzamas kernel: ata6.00: irq_stat 0x01100010, PHY RDY
changed
Oct 27 11:33:41 Arzamas kernel: ata6: SError: { 10B8B }
Oct 27 11:33:41 Arzamas kernel: ata6.00: cmd
ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Oct 27 11:33:41 Arzamas kernel: res 06/37:00:00:00:00/00:00:00:00:06/00
Emask 0x12 (ATA bus error)
Oct 27 11:33:41 Arzamas kernel: ata6.00: error: { IDNF ABRT }
Oct 27 11:33:41 Arzamas kernel: ata6: hard resetting link
Oct 27 11:33:46 Arzamas kernel: ata6: SATA link up 3.0 Gbps (SStatus 123
SControl 0)
Oct 27 11:33:46 Arzamas kernel: ata6.00: configured for UDMA/100
Oct 27 11:33:46 Arzamas kernel: ata6: EH complete
Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] 488397168 512-byte
hardware sectors (250059 MB)
Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Write Protect is off
Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
Oct 27 11:33:46 Arzamas kernel: sd 6:0:0:0: [sde] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Oct 27 11:33:46 Arzamas kernel: end_request: I/O error, dev sde, sector
488166955
Oct 27 11:33:46 Arzamas kernel: md: super_written gets error=-5, uptodate=0


All 3 drives endured the same multiple rewriting of the sector in
question, as they did multiple smart self-tests. I am currently in the
process of replacing these two drives with Seagates, (the other 2 in the
4 member array are Maxtors). Will see what happens.

Peter

P.S. See threads http://marc.info/?l=linux-raid&m=122523835815697 and
http://marc.info/?l=linux-raid&m=122669103213041 for more info on my
setup and hardware.
