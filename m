From: NeilBrown <neilb@suse.de>
Subject: Re: Help with recovering resized raid where machine crashed while
 PENDING
Date: Wed, 6 Jul 2011 09:39:17 +1000
Message-ID: <20110706093917.28cafc31@notabene.brown>
References: <2flfwmpdpw2.fsf@login1.uio.no>
	<20110705104923.4779e295@notabene.brown>
	<20110705162433.GB18875@login1.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110705162433.GB18875@login1.uio.no>
Sender: linux-raid-owner@vger.kernel.org
To: Petter Reinholdtsen <pere@hungry.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 5 Jul 2011 18:24:33 +0200 Petter Reinholdtsen <pere@hungry.com> wrote:

> [Neil Brown]
> > I probably wouldn't have helped.  It is supposed to write backup
> > stuff to the spares and if it didn't do that, it probably wouldn't
> > have written it to a file either.
> 
> Right.  Is this a bug or the way it is supposed to work?

Bug I expect... though actually it might be a different one to what I was
thinking.

Try to assemble the array normally with --verbose.
i.e.

  mdadm --assemble /dev/md3 --verbose /dev/sd[abcde]2
(or whatever the right list of devices is).

If this fails with something like

   mdadm: too-old timestamp on backup-metadata on ....

then you can assemble the array by 

   export MDADM_GROW_ALLOW_OLD=1
   mdadm --assemble ....(same command as above).

This requires mdadm-3.1.2 or newer.

> 
> > The easiest fix for now is to recreate the array.
> > 
> > mdadm -CR /dev/md3 --metadata=0.90 -n3 -l5 -c64 /dev/sdb2 /dev/sdc2
> > /dev/sdf2 --assume-clean
> >
> > should do it.
> 
> Thank you.  How did you determine which devices to use and which order
> to list them in?  I've since rebooted and want to make sure I do not
> pick the wrong devices.

You only need this if the above doesn't work:

In the --examine output for a particular device, look at the 'RaidDevice'
column of the 'this' row.
That number tells you the position in the array.  The three devices to list
are the three that have the numbers '0', '1', and '2', and you want to list
them in that order.

NeilBrown


> 
> > Then if that looks good, add the extra devices and grow the array
> > again.
> 
> Will try when md2 is done growing tomorrow. :)
> 
> Happy hacking,

