From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid5, media scans and stripe-wise resync
Date: Mon, 25 Oct 2004 16:56:19 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410252056.i9PKuON26989@www.watkins-home.com>
References: <1098736532.5399.52.camel@duxeon.cobite.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1098736532.5399.52.camel@duxeon.cobite.com>
To: 'David Mansfield' <md@dm.cobite.com>
Cc: 'Jure Pe_ar' <pegasus@nerv.eu.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I understand your point.  The bad sector issue has been talked about here
many times.  Bad sectors have been a pain in the @$$ for me for 2 years.  If
you search the archives I am sure you would find a message from me with very
similar concerns.  I guess I was just pointing out the RAID6 will help.  I
think I have been lucky and have not had bad blocks on 2 disks at the same
time (not sure).  But I do understand that md can't deal with them.  Marking
a disk as failed when only 1 sector has failed is not a good solution.

And yes, most (maybe all) hardware RAID systems "correct" bad sectors.  Some
count them and predict the drive is bad based on too many "corrected" bad
sectors.  EMC's big RAID systems copy the failing disk to a spare and place
an auto service call.  The failing disk is not taken out of service until it
is physically replaced, since it still does have data and is working.  By
doing it this way the data is redundant during the whole process.  Very
clever.

Sorry if I went off topic.

Guy


-----Original Message-----
From: David Mansfield [mailto:md@dm.cobite.com] 
Sent: Monday, October 25, 2004 4:36 PM
To: Guy
Cc: 'Jure Pe_ar'; linux-raid@vger.kernel.org
Subject: RE: raid5, media scans and stripe-wise resync

On Mon, 2004-10-25 at 16:29, Guy wrote:
> Someone said:
> "In a hardware raid solution, you would only die if both bad sectors were
in
> the same stripe, because when it encounters the bad sector, it doesn't
eject
> the disk from the array.  It reassigns the bad block, and resyncs just
that
> stripe."
> 
> Is a hardware solution, if 1 disk has a bad sector and another disk fails,
> game over.  The only way I know to avoid this is RAID6.  I hope RAID6
> becomes stable some day.
> 

This is true, but has nothing to do with what I'm talking about. 
Everyone is missing my point.

The point is that NEITHER DRIVE 'FAILS'.  They just have unrecoverable
read errors, or bad sectors.  As long as the two bad sectors are not in
the same stripe, you have not lost any data (theoretically, for s/w and
realistically for h/w).

It is a FACT that if a h/w raid controller encounters a bad sector, it
will *immediately* reassign it a reconstruct the stripe before moving
on.  If there are no other bad sectors in that stripe, you are FINE. 
Think about it.  If later, (say 5 seconds later) another unrecoverable
error is encountered on a different disk, different stripe, it will be
handled fine, just as above.

Compare this to the S/W raid where the entire disk is ejected from the
array when the first bad sector is encountered.  It cannot recover from
the 'two bad sectors on two disks in two different stripes' failure
scenario.  H/W raid can.

David


> Guy
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Mansfield
> Sent: Monday, October 25, 2004 3:43 PM
> To: Jure Pe_ar
> Cc: linux-raid@vger.kernel.org
> Subject: Re: raid5, media scans and stripe-wise resync
> 
> On Mon, 2004-10-25 at 13:19, Jure Pe_ar wrote:
> > On Mon, 25 Oct 2004 11:36:33 -0400
> > David Mansfield <md@dm.cobite.com> wrote:
> > 
> > > 2) how can we force (or manually perform) a stripe-wise resync? is it
> > > possible to take the raid offline completely, read the data with dd,
> > > compute the parity manually, reassign the bad block using SCU and
> > > rewrite the parity block with dd then put the raid online again?
> > 
> > In raid5 there's no real need for that. When you add disk back into
array,
> > it should get fully resynced anyway.
> > 
> 
> Not quite.  If disk 0 has a bad sector in stripe 0, and disk 1 has a bad
> sector in stripe 1, you will totally kill your array.  It happens.  It
> happened to us.  Two bad sectors on two separate disks, but not on the
> same stripes.
> 
> In a hardware raid solution, you would only die if both bad sectors were
> in the same stripe, because when it encounters the bad sector, it
> doesn't eject the disk from the array.  It reassigns the bad block, and
> resyncs just that stripe.
> 
> In the software situation, the entire disk will be ejected from the
> array after the first bad sector is detected.  During resync, you will
> encounter the second bad sector (other drive), but because the
> information on the old disk 0 has been destroyed (the disk has been
> ejected from the array) your array is now dead.  
> 
> Does this make sense?
> 
> 
> > I've written a short blurb in my blog about a rather rude method to
handle
> > misbehaving disks. Basically take it out of the array, run badblocks -w
on
> > it for a week and if it's ok, put it back :)
> > 
> 
> Won't work if there are any bad sectors on any of the other disks.  Even
> one other bad sector and your array is toast.
> 
> David
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

