From: Daniel Brahneborg <daniel.com@wtnord.net>
Subject: Re: Status of Promise drivers?
Date: Tue, 30 Dec 2003 20:24:47 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031230202447.D14399@nettis.grimsta>
References: <20031230200012.C14399@nettis.grimsta> <3FF1CCC1.3050304@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FF1CCC1.3050304@pobox.com>; from jgarzik@pobox.com on Tue, Dec 30, 2003 at 02:06:41PM -0500
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your quick reply, Jeff.

On Tue, Dec 30, 2003 at 02:06:41PM -0500, Jeff Garzik wrote:
> Daniel Brahneborg wrote:
> > I'm having serious problems with my Silicon Image SATA card,
> > and am considering replacing with a (more expensive) Promise
> > SATA TX2 Plus card.
> > 
> > First I have some questions, to avoid getting into the same
> > mess as I'm in now.
> > 
> >  1. What is the status of the Promise driver?  Stable for
> >     everybody? (The SI3112 has problems for some people when
> >     using the IDE driver, and for some with the SCSI driver.)
> >     A binary module is ok, a binary bzImage definately is not.
> 
> It's beta, and stable.

Great!

> Any comparison with Silicon Image is false.  The Silicon Image driver 
> has been repeatedly stated (by me, the author) to be BROKEN.  It is 
> thusly marked with CONFIG_BROKEN.
> 
> Those who ignore the author stating the Silicon Image driver is _alpha_ 
> and unfinished do so at their own risk.

Is this true for both the IDE driver and the SCSI driver?

> >  6. Has anybody used it in a non-root setup, having hda on
> >     the PATA interface?  (The SI3112 causes lots of problems
> >     with I/O port and IRQ conflicts, requiring hours of
> >     tweaking of the boot parameters.)
> 
> PATA interfaces on Promise SATA are not yet supported.

Oh, I wasn't even aware that the Promise had any PATA slots. :)
It's the builting PATA interface on the motherboard that I want
to keep.

> >  7. Do you have DMA enabled?  (SI3112 without DMA works fine,
> >     but with terrible performance.)
> 
> DMA cannot be disabled :)

Cool, that's the way it should be.

Is the same driver used for the TX4 card? Checking my logs even the
VIA driver seems to have problems running under Raid. Both Raid1
and Raid5 gives me corrupted files, unless I turn off DMA.

/Basic

