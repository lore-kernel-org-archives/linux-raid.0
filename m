From: Neil Brown <neilb@suse.de>
Subject: Re: [RFC][PATCH -mm][Experimental] suspend: Do not freeze md_threads
Date: Mon, 6 Nov 2006 09:28:39 +1100
Message-ID: <17742.26007.249504.79631@cse.unsw.edu.au>
References: <200611022355.52856.rjw@sisk.pl>
	<20061105115804.GG4965@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Pavel Machek on Sunday November 5
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday November 5, pavel@ucw.cz wrote:
> Hi!
> 
> > If there's a swap file on a software RAID, it should be possible to use this
> > file for saving the swsusp's suspend image.  Also, this file should be
> > available to the memory management subsystem when memory is being freed before
> > the suspend image is created.
> > 
> > For the above reasons it seems that md_threads should not be frozen during
> > the suspend and the appended patch makes this happen, but then there is the
> > question if they don't cause any data to be written to disks after the
> > suspend image has been created, provided that all filesystems are frozen
> > at that time.
> 
> Looks okay to me. It would be nice to have someone (Ingo? Neil?) try
> to suspend to swap on md......

Yes... suspending to swap-on-md would probably be fairly easy.
Resuming from that same swap might be a bit more of a challenge.
If only I had more time...

but the patch looks good to me.  I'll see that it gets applied.
Thanks,

NeilBrown

