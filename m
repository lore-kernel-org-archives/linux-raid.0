From: Neil Brown <neilb@suse.de>
Subject: Re: Linux Software RAID a bit of a weakness?
Date: Tue, 27 Feb 2007 08:22:17 +1100
Message-ID: <17891.20361.634717.178466@notabene.brown>
References: <1172258378.21648.51.camel@cowie>
	<45DF46B7.3040707@maine.edu>
	<1172406243.3765.29.camel@cowie>
	<45E1E051.1020908@sauce.co.nz>
	<72dbd3150702260856p5053d028je85cacffb15a5536@mail.gmail.com>
	<1172510818.11898.33.camel@cowie>
	<72dbd3150702261313o88c1dd6tf910049e69708868@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Rees on Monday February 26
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Colin Simpson <csimpson@csl.co.uk>, Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday February 26, drees76@gmail.com wrote:
> On 2/26/07, Colin Simpson <csimpson@csl.co.uk> wrote:
> > If I say,
> >
> > dd if=/dev/sda2 of=/dev/null
> >
> > where /dev/sda2 is a component of an active md device.
> >
> > Will the RAID subsystem get upset that someone else is fiddling with the
> > disk (even in just a read only way)? And will a read error on this dd
> > (caused by a bad block) cause md to knock out that device?
> 
> The MD subsystem doesn't care if someone else is reading the disk, and

Correct.  It doesn't care if someone writes either.  The thing you
cannot do is open the device with O_EXCL.  Mounting effectively uses
O_EXCL, as does adding a swap device, fsck, and various other things
that want to think they have exclusive access.

> I'm pretty sure that rear errors will be noticed by the MD system,
> either.

:-)  Your typing is nearly as bad as mine often is, but your intent is
correct.  If you independently read from a device in an MD array and get an
error, MD won't notice.  MD only notices errors for requests that it
makes of the devices itself.

NeilBrown
