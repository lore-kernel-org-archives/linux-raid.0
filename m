From: misty-@charter.net
Subject: Re: RAID 5 questions
Date: Tue, 3 Aug 2004 01:19:46 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040803051946.GA8781@roll>
References: <1091325475.2374.11.camel@localhost> <20040801102430.GC28625@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040801102430.GC28625@janus>
To: Frank van Maarseveen <frankvm@xs4all.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Aug 01, 2004 at 12:24:30PM +0200, Frank van Maarseveen wrote:
> On Sun, Aug 01, 2004 at 11:27:56AM +0930, Ninti Systems wrote:
> > 
> > Q1: Is it true that Linux can't/shouldn't boot off a RAID 5 array?
> 
> >From software RAID it can't.
> 
> USB storage devices (memory stick) are incredibly useful for this --
> I've even booted a webserver from a digital camera ;-). The only catch
> may be the latency of the USB code when you don't want to use initrd:
> The kernel panics (no root dev) because it takes noticeable time before
> the kernel sees an USB storage device. But there are several tiny patches
> for this, it's merely a nuisance.

Personally I use sw raid5 as my /, and as I messed up and now can't fix it
to work with a /boot, I instead use a lilo'ed 3.5 inch bootdisk, which loads
the kernel and mounts root. *shrugs* it works fairly well, I can't complain
much.

Tim McGrath
