From: Chris Allen <chris@cjx.com>
Subject: Re: making raid5 more robust after a crash?
Date: Wed, 29 Mar 2006 14:19:07 +0100
Message-ID: <20060329131907.GA14133@cjx.com>
References: <20060317130247.GA19878@cjx.com> <17435.9868.249413.113639@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17435.9868.249413.113639@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 18, 2006 at 08:13:48AM +1100, Neil Brown wrote:
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
> > 
> > 
> > My question is: Is there any way I can make the array
> > more robust? I don't mind it losing a single drive and
> > having to resync when we get a lockup - but having to
> > do a forced assemble always makes me nervous, and means
> > that this sort of crash has to be escalated to a senior
> > engineer.
> 
> Why is the array degraded?
> 
> Having a crash while the array is degraded can cause undetectable data
> loss.  That is why md won't assemble the array itself: you need to
> know there could be a problem.
> 
> But a crash with a degraded array should be fairly unusual.  If it is
> happening a lot, then there must be something wrong with your config:
> either you are running degraded a lot (which is not safe, don't do
> it), or md cannot find all the devices to assemble.


Thanks for your reply. As you guessed, this was a problem
with our hardware/config and nothing to do with the raid software.

After much investigation we found that we had two separate problems.
The first of these was a SATA driver problem. This would occasionally
return hard errors for a drive in the array, after which it would
get kicked. The second was XFS over NFS using up too much kernel
stack and hanging the machine. If both happened before we noticed
(say during the night), the result would be one drive dirty because
of the SATA driver and one dirty because of the lockup.

The real sting in the tail is that (for some reason) the drive lost through the SATA
problem would not be marked as dirty - so if the array was force rebuilt it
would be used in place of the more recent failure - causing horrible
synchronisation problems.

Can anybody point me to the syntax I could use for saying:

"force rebuild the array using drives ABCD but not E, even though
E looks fresh and D doesn't".

?



> > 
> > Typical syslog:
> > 
> > 
> > Mar 17 10:45:24 snap27 kernel: md: Autodetecting RAID arrays.
> > Mar 17 10:45:24 snap27 kernel: raid5: cannot start dirty degraded
> > array for md0
> 
> So where is 'disk 1' ??  Presumably it should be 'sdb1'.  Does that
> drive exist?  Is is marked for auto-detect like the others?

Ok, this syslog was a complete red herring for the above problem - 
and you hit the nail right on the head - in this particular case I
had installed a new sdb1 and forgot to set the autodetect flag :-)


Chris.


