From: Art -kwaak- van Breemen <ard@telegraafnet.nl>
Subject: Re: Multiple SSDs - RAID-1, -10, or stacked? TRIM?
Date: Thu, 10 Oct 2013 18:18:59 +0200
Message-ID: <20131010161859.GA21439@telegraafnet.nl>
References: <20131009123135.GT1779@bitfolk.com>
 <l33q8a$da4$1@ger.gmane.org>
 <5255827B.8090309@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5255827B.8090309@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Wed, Oct 09, 2013 at 06:21:15PM +0200, David Brown wrote:
> Do you have any references for these claims?

A vertex 2 + intel M25 combo on a dell sas 6/i controller (I
know, sas controllers are bad, but you can't get blades with a
reliable ahci interface):
The vertex2 occasionally gets rejected by the controller.
This needs a power cycle on the ssd before it works again.
Doing a raid check doesn't reveal any data corruption on the
vertex 2.

So compatability bugs are a reason.

> I would believe that /if/ an SSD was going to die, it is likely to do so
> without warning - it is likely to be the controller that has died.  But
> I can think of no reason why the controller on an SSD is more likely to
> die than the controller on an HD - and HD's have so many more ways to
> die (often slowly and noisily).
> 
> Modern SSDs are not going to suffer from wear in any realistic
> environment.  You have to be intentionally abusive - a decent SSD will
> be fine with /years/ of continuous high-speed writes.  Even then, you
> will get write failures long before you have read failures.
> 
> That leaves firmware bugs as a possible explanation for such worries -
> and that also applies to HD's.

We had those too, but usually they are no that destructive. The
amount of problems with vertex 2 rejects are pretty high. The
intel SSD's were rejected once. And normal sas disk firmware
hangups were about 2 or so, fixed with a harddisk firmware
upgrade. In usage percentage, the sas disks are more stable than
the sata SSD's.

> But with that aside, having different manufacturers and models for the
> two halves of a raid1 pair is not a bad idea regardless of whether you
> have SSD's or HD's - it avoids the risk of a double failure due to a bad
> production batch.

Yes, completely correct: I had a bunch of WD-RE2 on my home nas,
with raid1 with an old kernel.
They all had media errors at the same time, and md-raid1 at that
time could only reject the whole disk :-(.

Any way: my biggest fear with SSD is that the meta data get's
corrupted and so the blocks get shuffled. I've never seen it
happen on an SSD, only rejects of the drive and from hearsay a
total failure of the drive.
