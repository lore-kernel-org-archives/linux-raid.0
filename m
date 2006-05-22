From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 resize in 2.6.17 - how will it be different from raidreconf?
Date: Mon, 22 May 2006 21:34:43 +1000
Message-ID: <17521.41427.663924.925861@cse.unsw.edu.au>
References: <200605220034.49858.Dexter.Filmore@gmx.de>
	<17520.61194.529436.322401@cse.unsw.edu.au>
	<200605221317.37083.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dexter Filmore on Monday May 22
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 22, Dexter.Filmore@gmx.de wrote:
> > > Will it be less risky to grow an array that way?
> >
> > It should be.  In particular it will survive an unexpected reboot (as
> > long as you don't lose and drives at the same time) which I don't
> > think raidreconf would.
> > Testing results so far are quite positive.
> 
> Write cache comes to mind - did you test power fail scenarios?
> 

I haven't done any tests involving power-cycling the machine, but I
doubt they would show anything.

When a reshape restarts after a crash, at least the last few stripes
are re-written, which should catch anything that was pending at the
moment of power failure.

> > > (And while talking of that: can I add for example two disks and grow
> > > *and* migrate to raid6 in one sweep or will I have to go raid6 and then
> > > add more disks?)
> >
> > Adding two disks would be the preferred way to do it.
> > Add only one disk and going to raid6 is problematic because the
> > reshape process will be over-writing live data the whole time, making
> > crash protection quite expensive.
> > By contrast, when you are expanding the size of the array, after the
> > first few stripes you are writing to an area of the drives where there
> > is no live data.
> 
> Let me see if I got this right: if I add *two* disks and go from raid 5 to 6 
> with raidreconf, no live data needs to be overwritten and in case something 
> fails I will still be able to assemble the "old" array..?

I cannot speak for raidreconf, though my understanding is that it
doesn't support raid6.

If you mean md/reshape, then what will happen (raid5->raid6 isn't
implemented yet) is this

The raid5 is converted to raid6 with more space incrementally.
Once the process has been underway for a little while, there will
be:
   - a region of the drives that is laid out out as raid6 - the new
     layout
   - a region of the drives that is not in use at all
   - finally a region of the drives that is still laid out as raid5.

Data from the start of the last region is constantly copied into the
start of the middle region, and the two region boundaries are moved
forward regularly.  While this happens the middle region grows.

If there is a crash, on restart this layout (part raid5, part raid6)
will be picked up and the reshaping process continued.

There is a 'critical' section at the very beginning where the middle
region is non-existent. To handle this we copy the first few blocks to
somewhere safe (a file or somewhere on the new drives) and use that
space as the middle region to copy data to.  If the system reboots
during this critical section, mdadm will restore the data from the
backup that it made before assembling the array.

If you want to convert a raid5 to a raid6 and only add one drive, it
shouldn't be hard to see that the middle region never exists.
To cope with this safely, mdadm would need to be constantly backing up
sections of the array before allowing the kernel to reshape that
section.  This is certainly quite possible and may well be implemented
one day, but can be expected to be quite slow.

I hope that clarifies the situation.

NeilBrown

