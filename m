From: David Mansfield <md@dm.cobite.com>
Subject: Re: raid5, media scans and stripe-wise resync
Date: Mon, 25 Oct 2004 15:43:00 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1098733380.5399.39.camel@duxeon.cobite.com>
References: <1098718593.5399.29.camel@duxeon.cobite.com>
	 <20041025191900.713ae4b1.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041025191900.713ae4b1.pegasus@nerv.eu.org>
To: Jure Pe_ar <pegasus@nerv.eu.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2004-10-25 at 13:19, Jure Pe_ar wrote:
> On Mon, 25 Oct 2004 11:36:33 -0400
> David Mansfield <md@dm.cobite.com> wrote:
> 
> > 2) how can we force (or manually perform) a stripe-wise resync? is it
> > possible to take the raid offline completely, read the data with dd,
> > compute the parity manually, reassign the bad block using SCU and
> > rewrite the parity block with dd then put the raid online again?
> 
> In raid5 there's no real need for that. When you add disk back into array,
> it should get fully resynced anyway.
> 

Not quite.  If disk 0 has a bad sector in stripe 0, and disk 1 has a bad
sector in stripe 1, you will totally kill your array.  It happens.  It
happened to us.  Two bad sectors on two separate disks, but not on the
same stripes.

In a hardware raid solution, you would only die if both bad sectors were
in the same stripe, because when it encounters the bad sector, it
doesn't eject the disk from the array.  It reassigns the bad block, and
resyncs just that stripe.

In the software situation, the entire disk will be ejected from the
array after the first bad sector is detected.  During resync, you will
encounter the second bad sector (other drive), but because the
information on the old disk 0 has been destroyed (the disk has been
ejected from the array) your array is now dead.  

Does this make sense?


> I've written a short blurb in my blog about a rather rude method to handle
> misbehaving disks. Basically take it out of the array, run badblocks -w on
> it for a week and if it's ok, put it back :)
> 

Won't work if there are any bad sectors on any of the other disks.  Even
one other bad sector and your array is toast.

David


