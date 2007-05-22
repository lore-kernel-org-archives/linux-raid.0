From: Neil Brown <neilb@suse.de>
Subject: Re: Adding larger disks to RAID5
Date: Tue, 22 May 2007 10:40:15 +1000
Message-ID: <18002.15343.525501.64958@notabene.brown>
References: <465204AA.90301@dhp.com>
	<18002.11374.159035.143026@notabene.brown>
	<20070521235735.GA26776@ti88.telemetry-investments.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Rugolsky Jr. on Monday May 21
Sender: linux-raid-owner@vger.kernel.org
To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Cc: Christian <cjs@dhp.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 21, brugolsky@telemetry-investments.com wrote:
> Neil,
> 
> What seems desirable to me is a way to take a new (larger) spare drive and
> add it to a RAID1 for a particular RAID 4/5/6 component, and then when
> it's sync'd, replace the now redundant small drive with another larger
> drive.  Wash, rinse, repeat.  This way the array is never degraded.
> Though I imagine that this particular arrangement doesn't have the
> benefit of the stripe rewrite when encountering a latent error on the
> drive that is being migrated.  [Presumably the failing addresses could
> be cycled through the check from userland though, by doing a read above
> the stacked RAID.]
> 
> One could start a RAID 4/5/6 array over a degraded RAID1 for each
> component, (i.e., a degraded RAID1).
> 
> I haven't been following the metadata changes closely.  Is it possible
> to do this with external MD metadata?  It can also be done with
> device-mapper, but dm-mirror is very immature compared to MD RAID1.
> 
> Comments?

This doesn't really have anything to do with the metadata used - it is
primarily an implementation issue (though you would need to be careful
picking up the pieces after a crash).

If we could freeze an array (so that all writes block), then we could
do much of what you suggest:
  - freeze the array
  - remove the target device
  - create a raid1 of the target and the new
  - re-add the raid1
  - unfreeze the array.

The issue of dealing with read errors on the target device is much
more awkward to deal with.  The approach that seems right to me is:

  - create a raid1 variant which does a passive resync:  When the
    next-needed block is read or written, write it to the second
    device and advance the "next-needed" pointer.
  - Get this raid1 to simply return read errors (which might be OK
    already) so that a read-error won't be fatal.  But a read request
    that be behind the "next-needed" pointer gets served from the
    second device if the first does fail.
  - Implement a 'check-one-disk' operation on raid5 (and others) so
    that instead of reading all devices, it just reads all through
    one.  If this one is really a raid1-variant, doing that read will
    effect a resync on the raid1, and any read error will be handled
    correctly.

So it is all quite possible, and I agree that it could be valuable.
It just needs someone to do it, and work out all the fine details.

Anyone want to try some coding ????

NeilBrown
