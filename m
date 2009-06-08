From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: How to un-degrade an array after a totally spurious failure?
Date: Sun, 7 Jun 2009 20:43:59 -0500
Message-ID: <20090608014354722.FGFJ26412@cdptpa-omta03.mail.rr.com>
References: <a2ada9611479c051e268a76df8b45b40.squirrel@neil.brown.name>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a2ada9611479c051e268a76df8b45b40.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >> -----Original Message-----
> >> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> >> owner@vger.kernel.org] On Behalf Of NeilBrown
> >> Sent: Wednesday, May 20, 2009 9:49 PM
> >> To: Nix
> >> Cc: linux-raid@vger.kernel.org
> >> Subject: Re: How to un-degrade an array after a totally spurious
> >> failure?
> >>
> >> On Thu, May 21, 2009 9:10 am, Nix wrote:
> >>
> >> > So, anyone got a command that would help? I'm not even sure if this
> is
> >> > assembly or growth: it doesn't quite fit into either of those
> >> > categories. There must be a way to do this, surely?
> >>
> >> It is neither.  It is management.
> >>
> >>  mdadm --manage /dev/mdX --remove /dev/sdb6
> >>  mdadm --manage /dev/mdX --add /dev/sdb6
> >>
> >> (The --manage is not actually needed, but it doesn't hurt).
> >>
> >> NeilBrown
> >
> > 	I have exactly the same situation, except there are two "failed"
> > disks on a RAID5 array.  As for the OP, the "failures" are spurious.
> > Running the remove and then the add command puts the disks back in as
> > spare
> > disks, not live ones, and then the array just sits there, doing nothing.
> > I
> > tried the trick of doing
> >
> > echo repair > /sys/block/md0/md/sync_action
> >
> > but the array still just sits there saying it is "clean, degraded", with
> 2
> > spare and 5 working devices.
> >
> 
> No such a good option when you have two failures.
> If you have two failures you need to stop the array, then assemble
> it again using --force.
> It is now too late for that:  adding them with "--add" will have erased
> the old metadata.

OK, what about a RAID 6 array with one failed disk?  Is the remove & add the
best option there, or should one apply a different method?

