From: Maarten van den Berg <maarten@ultratux.net>
Subject: Re: Raid5 Construction Question
Date: Thu, 19 Aug 2004 23:50:35 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408192350.35339.maarten@ultratux.net>
References: <200408191730.i7JHUd313659@watkins-home.com> <200408192224.06572.maarten@ultratux.net> <20040819202601.GA14858@mutsumi.mindwaresystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040819202601.GA14858@mutsumi.mindwaresystems.com>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 19 August 2004 22:26, Kourosh wrote:
> On Thu, Aug 19, 2004 at 10:24:06PM +0200, Maarten van den Berg wrote:
> > On Thursday 19 August 2004 19:52, PAulN wrote:

> I've found that one of the better ways of varifying a disk is to run
> the disk manufacturers disk utilities on it.  They all provide a
> bootable disk to run the utilities.  Several times I've had problems
> similar to this and each time it ended up being a disk that was
> failing.  Run the utility as all the vendors I've dealt with require
> the error code from the utility to process an RMA, so might as well do
> it sooner, rather than later.

I did not do this for multiple reasons.
The first -and by far the most important one- was that I desperately needed 
the data that was on the broken array (it all stemmed from a two-disk raid5 
failure).  I do not trust these vendor-diskettes to leave my data intact.

Secondly it was far easier for me to run this dd test under linux than find a 
loose floppydrive, connect it to my server, reinstate IRQ 6 and run various 
floppies against it.

And third, as the system had multiple identical promise addon controllers and 
7 mostly identical ide disks, I figured I couldn't be totally sure the disk 
linux saw as /dev/hdm was disk ??? on controller ?? as reported by such 
floppies.

I do recommend those utilities for a final go / no-go verdict, but you better 
run them on standalone systems on single disks.  
Or maybe I'm just being too paranoid is all...?

Maarten

