From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Starting RAID 5
Date: Thu, 14 May 2009 22:58:14 -0500
Message-ID: <20090515035816892.ZJVZ15274@cdptpa-omta02.mail.rr.com>
References: <adb53d3552334dd6c949c4c029ae7135.squirrel@neil.brown.name>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <adb53d3552334dd6c949c4c029ae7135.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> > OK, I've torn down the LVM backup arraqy and am rebuilding it as a RAID
> 5.
> > I've had problems with this before, and I'm having them, again.  I
> created
> > the array with:
> >
> > mdadm --create /dev/md0 --raid-devices=7 --metadata=1.2 --chunk=256
> > --level=5 /dev/sd[a-g]
> >
> > whereupon it creates the array and then immediately removes /dev/sdg and
> > makes it a spare.  I think I may have read where this is normal
> behavior.
> 
> Correct. Maybe you read it in the mdadm man page.

That's what I thought.  I breezed through the MAN page to try to find it
again, but one of my baby chicks (technicians who work for me) was having a
major melt-down over some minor problems he was experiencing in the network
while trying to prepare for a maintenance window, so I had to break off.

> > I can't get it to do an initial resync or promote the spare, however.
> 
> So it doesn't start recovery straight away? That is odd...

No, and it's happened before, on the other system.  Version 2.6.7.2-1  It
didn't do it when I created the RAID 6 array.

> Maybe it is in read-auto mode.  I should probably get mdadm to poke
> it out of that.
> 
> If it is just start creating the filesystem or whatever you want to
> do, that will prod it into action.

Umph.  Well, that was easy.  I kept messing with mdadm, not mkfs.  Generally
speaking, when I'm working on something I don't move on to subsequent
processes until the current process is functioning properly, so I was loathe
to move on.  Silly me, I guess, but I still say it's usually the best
practice.  Sometimes even good habits get you in trouble, I suppose.

> If not (check /proc/mdstat), what kernel log messages are them from the
> time when you created the array.

Yeah, that was the first thing I did.  There was nothing out of the
ordinary.  Mdadm reported to stdout that it was removing the 7th disk, but
put nothing about it in the log except to say it was active on 6 of 7
devices.

