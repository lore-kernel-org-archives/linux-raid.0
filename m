From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Status of Promise drivers?
Date: Tue, 30 Dec 2003 14:57:34 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FF1D8AE.2000107@pobox.com>
References: <20031230200012.C14399@nettis.grimsta> <3FF1CCC1.3050304@pobox.com> <20031230202447.D14399@nettis.grimsta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031230202447.D14399@nettis.grimsta>
To: Daniel Brahneborg <daniel.com@wtnord.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel Brahneborg wrote:
> On Tue, Dec 30, 2003 at 02:06:41PM -0500, Jeff Garzik wrote:
>>Any comparison with Silicon Image is false.  The Silicon Image driver 
>>has been repeatedly stated (by me, the author) to be BROKEN.  It is 
>>thusly marked with CONFIG_BROKEN.
>>
>>Those who ignore the author stating the Silicon Image driver is _alpha_ 
>>and unfinished do so at their own risk.
> 
> 
> Is this true for both the IDE driver and the SCSI driver?

Only the "scsi" driver, sata_sil.  People do have some problems with the 
IDE driver siimage, but it is on the whole much more stable.


>>> 6. Has anybody used it in a non-root setup, having hda on
>>>    the PATA interface?  (The SI3112 causes lots of problems
>>>    with I/O port and IRQ conflicts, requiring hours of
>>>    tweaking of the boot parameters.)
>>
>>PATA interfaces on Promise SATA are not yet supported.
> 
> 
> Oh, I wasn't even aware that the Promise had any PATA slots. :)
> It's the builting PATA interface on the motherboard that I want
> to keep.

That's a different driver, then :)


> Is the same driver used for the TX4 card? Checking my logs even the
> VIA driver seems to have problems running under Raid. Both Raid1
> and Raid5 gives me corrupted files, unless I turn off DMA.

sata_promise is used for all known Promise SATA cards.

Which VIA driver are you referring to?  And PATA or SATA?  You need to 
be more specific :)   The drivers/ide via82cxxx driver seems to work for 
PATA.  The sata_via ("scsi") driver and the generic IDE driver work for 
VIA SATA, but people have reported problems on x86-64.

	Jeff



