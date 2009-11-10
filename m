From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 17:56:26 -0500
Message-ID: <yq1ocnam1k5.fsf@sermon.lab.mkp.net>
References: <4AF7066C.1040507@tmr.com>
	<70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	<f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	<70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	<f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	<yq1ljienxql.fsf@sermon.lab.mkp.net>
	<f3177b9e0911100922u435993behd0889ae284cf0ec4@mail.gmail.com>
	<yq11vk6nnrh.fsf@sermon.lab.mkp.net>
	<87f94c370911101301v4b71ce74hbd4ebd20e7ce2419@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370911101301v4b71ce74hbd4ebd20e7ce2419@mail.gmail.com>
	(Greg Freemyer's message of "Tue, 10 Nov 2009 16:01:44 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Chris Worley <worleys@gmail.com>, "Majed B." <majedb@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Greg" == Greg Freemyer <greg.freemyer@gmail.com> writes:

Greg> I'm not sure where it ended up, but the big SSD / discard
Greg> discussion of a few months ago talked about 3 kinds of solutions,
Greg> and I thought the plan was to support all 3.

We don't design for the past.


Greg> 1) optimization 1 - A white-listed instant discard feature.  In
Greg>    this methodology, the filesystems would immediately send
Greg>    discard calls down to the block layer would send them on down
Greg>    the block stack to the physical devices with very minimal
Greg>    buffering.

There's no whitelist.  That's just how it works.

Yes, there were a few crappy devices out there.  Windows 7 issuing TRIM
commands in realtime made them instantly obsolete.  If future devices
suck with Windows 7 nobody will buy them.


Greg> 2) optimization 2 - The block layer would accept those small
Greg>    discards, but accumulate them for a short period.  (less than a
Greg>    second was my impression).  Then coalesce them into larger
Greg>    discards and send them down the block stack and eventually to
Greg>    the physical device.

SSDs are special in that they actually track map state on a per-logical
block basis.  Other thinly provisioned devices track space in units
ranging from 16-32-64KB up to megabytes.

It's up to each block device to track the map space.  The way most
arrays work is that they'll ignore the portions of the request that are
not aligned to and a multiple of their internal allocation unit.

The same applies to MD.  IOW, MD would only unmap the portions of the
discard request that constitute entire stripes.  No keeping state
required.

Jens just queued my patch which allows block devices to communicate
their unmap granularity and alignment to the filesystems.  This means we
can potentially use this to influence filesystem allocators.  For SCSI
arrays these values are queried and passed up the stack.  MD can choose
to manually set the granularity to its stripe size.


Greg> 3) optimization 3 - a background freespace scanner would run from
Greg> time to time that scanned a filesystem for free blocks and send a
Greg> discard / trim command down to the device.  This is what Mark Lord
Greg> was working on.  His solution was primarily in user space and was
Greg> controlled by cron.

I think that's a fine approach for legacy devices.  But as I said I
think Windows 7 will root out all devices with poor TRIM performance
pretty quickly.

-- 
Martin K. Petersen	Oracle Linux Engineering
