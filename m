From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Two degraded mirror segments recombined out of sync for massive
 data loss
Date: Thu, 8 Apr 2010 09:56:36 -0400
Message-ID: <4BBDE094.2040308@cfl.rr.com>
References: <4BBCEEEC.4030606@cfl.rr.com> <20100408094909.2339c330@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100408094909.2339c330@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/7/2010 7:49 PM, Neil Brown wrote:
> I can only imagine two circumstances in which this could happen.
> 1/ You have a write-intent-bitmap configured.
> 2/ The event count on the two devices incremented by exactly the same
>    about while they were in use separately.
> 
> The second seems very improbably, but is certainly possible.
> 
> Please confirm whether or not you had a bitmap configured.

No write intent bitmap configured, and yes, the event count appears to
be the same on both legs.

> There is no important difference between "missing" and "faulty".  If md
> cannot access a device there is no way for it to know whether you, the admin,
> considers that device to have failed or to simply have been removed
> temporarily (e.g. as part of some backup regime).

Yes, but if a disk is faulty,removed, then either you explicitly told
mdadm to fail the disk and remove it, or it was failed and removed
during degraded activation.  In this case, shouldn't it require an mdadm
--add to re-insert it into the array?

If you had manually failed and removed the disk, then their metadata
would both agree that the second disk was removed, and it would require
an explicit --add to return it.  This problem seems to stem from the
fact that their metadata disagree about which disk is removed.  In this
case, shouldn't the data in the already active array taken from the
first disk override the metadata in the second disk when it is
incrementally added?

In other words, mdadm --incremental should update the metadata on the
second disk to agree with the first, showing the second disk is the one
that is removed, and not activate the disk without an mdadm --add.

> No.  Just because the device was removed from the array doesn't mean you
> don't want to to be part of the array any more.  And seeing the device is
> still plugged in...

What?  Of course it does.  If you explicitly remove the device it means
you don't want it being part of the array any more.

> mdadm --incremental should only included both disks in the array if
> 1/ their event counts are the same, or +/- 1, or
> 2/ there is a write-intent bitmap and the older event count is within
>    the range recorded in the write-intent bitmap.

I'm not familiar with the meaning of the event count.  Why should it
matter?  And shouldn't the only effect the write-intent bitmap has is to
speed up resyncing when you manually re-add the disk?

> You should understand that what you have done is at least undefined.
> If you break a mirror, change both halves, then put it together again there
> is no clearly "right" answer as to what will appear.

Yes, which version you get is undefined and I would think would come
down to which disk was discovered first, but you certainly should get
one version, or the other, not a mismash of both.  If the second disk
were left as removed and required manual intervention to use, then the
administrator could examine it and recover any data written to that disk
but not the first, before manually re-inserting it into the array
causing a resync.
