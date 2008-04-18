From: "David Lethe" <david@santools.com>
Subject: RE: RAID1 == two different ARRAY in scan, and Q on read error corrected
Date: Fri, 18 Apr 2008 18:49:13 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C087DAB@34093-C3-EVS3.exchange.rackspace.com>
References: <27567.1208547359@perkpartners.com> <48091A67.1090906@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <48091A67.1090906@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

You can't assume a disk is losing sectors and failing without running
some diagnostics. If you had an improper shutdown (i.e, power loss, not
a crash), and disks were writing, then you can get ECC errors.  That
does not indicate the disk is bad.

Of course, you must always have a backup, even if both drives are
perfectly fine, RAID1 doesn't protect you from entering rm -rf * tmp
instead of rm -rf *.tmp 

I strongly advise against using Richard's dd if=/dev/zero suggestion.
It puts you at risk as you only have one online copy of the data ..
unless you have current backup and it can easily do a cold-metal
restore.  Not worth the risk if you ask me.

Enter dd if=/dev/md0 of=/dev/null instead, and it will force parity
rebuild. You do this with both disks online in RAID1.   Furthermore, you
can get report of what blocks were bad.   There is likely also a mdadm
rescan or mdadm rebuild, but you'd have to look up syntax. They are
preferable to using the dd command.

Either technique won't technically check all physical blocks on both
disks, but they will take you considerably less clock time, and will
protect your data. 

Warning .. A block-level dd read on every block in md0 will not
necessarily rebuild parity for all kernels.  You probably have to do
something to temporarily disable cache, I don't know.

Good luck - 

David @ santools ^com
http://www.santools.com/smart/unix/manual



(Use a smaller blocksize to dd if you 

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Richard Scobie
Sent: Friday, April 18, 2008 5:02 PM
To: Linux RAID Mailing List
Subject: Re: RAID1 == two different ARRAY in scan, and Q on read error
corrected

Phil Lobbes wrote:
____________________________________________________________

> 
> Apr 15 11:07:14  kernel: raid1: sdc1: rescheduling sector 517365296
> Apr 15 11:07:54  kernel: raid1:md0: read error corrected (8 sectors at
517365296 on sdc1)
> Apr 15 11:07:54  kernel: raid1: sdc1: redirecting sector 517365296 to
another mirror
> Apr 15 11:08:32  kernel: raid1: sdc1: rescheduling sector 517365472
> Apr 15 11:09:09  kernel: raid1:md0: read error corrected (8 sectors at
517365472 on sdc1)
> Apr 15 11:09:09  kernel: raid1: sdc1: redirecting sector 517365472 to
another mirror

These entries,

> Apr 18 14:01:45  smartd[2104]: Device: /dev/sdc, 3 Currently
unreadable (pending) sectors

and this, indicate that sdc is losing sectors, so you probably want a 
backup of the array.

Depending on how important the array is you could fail and remove sdc 
from the array, dd if=/dev/zero of=/dev/sdc bs=1M and re-add it back.

It may then be fine for some time, but if it continues to gather pending

sectors in the short term, it is probably dying.

Otherwise just replace it with a new one.

Regards,

Richard
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


