From: Martin Cracauer <cracauer@cons.org>
Subject: Re: making raid5 more robust after a crash?
Date: Mon, 20 Mar 2006 12:41:59 -0500
Message-ID: <20060320124159.A50675@cons.org>
References: <20060317130247.GA19878@cjx.com> <17435.9868.249413.113639@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17435.9868.249413.113639@cse.unsw.edu.au>; from neilb@suse.de on Sat, Mar 18, 2006 at 08:13:48AM +1100
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Chris Allen <chris@cjx.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote on Sat, Mar 18, 2006 at 08:13:48AM +1100: 
> On Friday March 17, chris@cjx.com wrote:
> > Dear All,
> > 
> > We have a number of machines running 4TB raid5 arrays.
> > Occasionally one of these machines will lock up solid and
> > will need power cycling. Often when this happens, the
> > array will refuse to restart with 'cannot start dirty
> > degraded array'. Usually  mdadm --assemble --force will
> > get the thing going again - although it will then do
> > a complete resync.

First of all you need to make sure you can see the kernel messages
from this.  If /var/log/messages lives on the array affected you won't
see messages explaining what happens even if the kernel printed them.

What you see here is probably similar to a problem I just had: by
using software RAID you are subject to errors below the RAID level
that are not disk errors.  In my case a BIOS problem on my board made
the SATA driver run out of space, on requests for two of the disks on
my RAID-5, simultaneously.  The driver had to report an error upstream
and the RAID software on top of it cannot tell such a non-disk error
from a disk error.  It treats everything as a disk error and drops the
disk out of the array because it has seen errors on requests for two
disks.

I have more info on my accident here:
http://forums.2cpu.com/showthread.php?t=73705

As I said, you need to have a logfile on a disk not in the array, or
(better) you need to be able to watch kernel messages on the console
when this happens.

It sounds to me you have a similar problem to what I had: a software
error above the disks but below the raid level.

> > 
> > 
> > My question is: Is there any way I can make the array
> > more robust? I don't mind it losing a single drive and
> > having to resync when we get a lockup - but having to
> > do a forced assemble always makes me nervous, and means
> > that this sort of crash has to be escalated to a senior
> > engineer.

The re-sync is actually a big problem because actually losing a drive
physically during the re-sync will kill your array (unless it is the
re-syncing disk).

Martin
-- 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Martin Cracauer <cracauer@cons.org>   http://www.cons.org/cracauer/
FreeBSD - where you want to go, today.      http://www.freebsd.org/
