From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: feature suggestion to handle read errors during re-sync of raid5
Date: Sat, 30 Jan 2010 19:59:16 +0100
Message-ID: <874om3l8qj.fsf@frosties.localdomain>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se> (Mikael
	Abrahamsson's message of "Sat, 30 Jan 2010 13:37:56 +0100 (CET)")
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson <swmike@swm.pp.se> writes:

> So, a couple of times I've been having the problem of something going
> wrong on raid5, drive being kicked, thus has a lower event number,
> re-add, during the sync a single block on one of the other drives has
> a read error (surprisingly common on WD20EADS 2TB drives), resync
> stops, I have to take down the array, ddrescue the whole read error
> drive to another drive, I lose that block, start up the array
> degraded, and then add the drive again.
>
> It would be nice if there was an option that when re-sync:ing a drive
> which earlier belonged to the array, if there is a read error on
> another drive, just use the parity from the drive being added (in my
> case it's highly likely it'll be valid, and if it's not, then I
> haven't lost anything anyway, because the read error block is gone
> anyway).
>
> Does this make sense? It would of course be nice if the md layer could
> see the difference between sata timeouts and UNC errors, because UNC
> really means something is wrong, whereas sata timeouts might be
> transient problem (?).

Ever looked into adding bitmaps? That way it only syncs the parts where
something changed, is done within minutes and unlikely do get another
error.

MfG
        Goswin
