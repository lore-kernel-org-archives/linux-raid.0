From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [patch] linear does not need chunksize
Date: Sun, 17 Jul 2005 03:50:48 +0400
Message-ID: <42D99D58.6080207@tls.msk.ru>
References: <20050716231236.1851A8DC9@gandalf.tls.msk.ru> <17113.38562.489541.760889@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17113.38562.489541.760889@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Sunday July 17, mjt@tls.msk.ru wrote:
[]
>>Note chunk size is never used on linear array.  The
>>only usage of chunk_size member is in /proc/mdstat,
>>as "rounding" parameter (linear.c) - looks like it
>>should be removed too.
> 
> This statement isn't entirely true, though it took me a little while
> to remind myself exactly how linear.c does use chunk_size.
> 
> linear_run in linear.c uses rdev->size for each devices.
> in md.c rdev->size is set by a call to calc_dev_size()
> calc_dev_size *does* use chunk_size (if it is non-zero)

Aha.

Well, in that case, the whole stuff around that check should
be reviewed.  At least, all the various raid levels should
have device size to be at least PAGE_SIZE (as checked in the
code fragment surrounded by this if() statement).

BTW, I don't really know how we got zero chunksize in the
superblock in the first place.  It was evms who screwed up
3-components linear array somehow (which worked before),
and, since I for one know nothing about evms, we tried to
assemble it with mdadm, which failed due to this very check
in kernel.  So we were forced to re-create the array to
work around this in-kernel check (since for linear array
recreate operation is safe and leaves the data intact).

So maybe the whole issue is moot: how often do you see
an array with zero chunk-size?

Thanks.

/mjt
