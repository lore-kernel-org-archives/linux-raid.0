From: Daniel Brahneborg <daniel.com@wtnord.net>
Subject: Re: Status of Promise drivers?
Date: Tue, 3 Feb 2004 19:23:36 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040203192336.A5570@nettis.grimsta>
References: <20031230200012.C14399@nettis.grimsta> <3FF1CCC1.3050304@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FF1CCC1.3050304@pobox.com>; from jgarzik@pobox.com on Tue, Dec 30, 2003 at 02:06:41PM -0500
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Daniel Brahneborg <daniel.com@wtnord.net>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

(Continued from an earlier discussion on the linux-raid list.)

I made the mistake of getting a Highpoint Rocket 1540 instead
of a Promise SATA card, and I simply can't get it to work
with the hpt366 driver in the kernel.  The driver from Highpoint
works better, but only works for the RedHat 2.4.20-8 kernel,
so I won't bother anybody with the problems with that one.

A major factor seems to be the KT600 chipset on the Abit KV7
motherboard. Is this a known issue?

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

Since I'm paranoid: What motherboards has it been tested and
verified with?

> >  3. Has anybody used it with *2* network cards?  Bonus
> >     points for the builtin Via Rhine and an 8139 card.
> >     (The SCSI driver for the SI3112 kills the machine when a
> >     second card is activated.)

Interestingly enough, the Highpoint card has the same effect
when activating the first network card (it doesn't matter which
one), but only with the 2.4 kernel. The 2.6 kernel works fine.
Again, could this be a motherboard issue?

/Basic

