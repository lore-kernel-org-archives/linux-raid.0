From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: How to use --freeze-reshape and is it safe?
Date: Thu, 14 Aug 2014 10:59:01 -0500
Message-ID: <CABY_QbVSk0totc-z=7pZ9kV1RxV=qSZc2GnhM87YHfhYM5t6LA@mail.gmail.com>
References: <53EC4B63.90703@gmail.com>
	<20140814155633.567baece@notabene.brown>
	<53EC5658.3050708@gmail.com>
	<20140814173057.3913f5e1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140814173057.3913f5e1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> When you convert a raid5 to a raid6 it will assume that an extra drive is
> being added as well.
> Firstly the array is instantaneously converted from an optimal RAID5 in
> left-symmetric layout to a degraded RAID6 in left-symmetric-6 layout.
>
> Then the reshape process is started which reads each stripe in the
> left-symmetric-6 layout and writes it back in the raid6:left-symmetric layout.
>
> (if you specify a different number of final devices it all still works in one
> pass, but the dance is more complex).
>
> If this is done without changing the data offset, then every stripe is
> written on top of the old location of the same stripe so if the host crashed
> in the middle of the write, data would be lost.
> So mdadm copies each stripe to a backup-file before allowing the data to be
> relocated.  This causes a lot more IO than required to move the data, but is
> a lot safer.
>
> With newer kernels (v3.5) and mdadm (v3.3) a reshape can move the data_offset
> at the same time so that it is only ever writing to an unused area of the
> devices.  This should be much faster.
> However it requires that the data_offset is high enough that there is room to
> move it backwards.  mdadm 3.3 creates arrays with a reasonably large
> data_offset.  With arrays created earlier you might need to
>  - shrink the filesystem
>  - shrink the --size of the array
>
> md can either increase or decrease the data offset.
> The later requires free space at the start of the array so data_offset must
> be large.  The former requires free space at the end of the array, so size
> must be less than the maximum.  "mdadm --examine" will report "Unused space"
> both "before" and "after" which indicates how much data_offset can be moved.
> If either of these are larger than 1 chunk, then mdadm will make use of it.
>
> To answer you question: there is no "second pass".  The only way to make it
> faster is to have a recent kernel and mdadm and make sure there is sufficient
> Unused space, either "before" or "after".
>
> NeilBrown

I may be wrong here, but wouldn't going back and forth on the same
disk make the operation slow. I mean trying to compute Q and
distribute will require read followed by a write to several disk
making seek the bottleneck. Would it not be better to first build Q on
the new disk and do the distribution later as you may be able to read
multiple blocks, parallelize reads, and combine writes.  I am not
claiming deep knowledge of disk's inner working here. Just bouncing
thoughts.

Ramesh
