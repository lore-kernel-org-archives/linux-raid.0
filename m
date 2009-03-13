From: David Rees <drees76@gmail.com>
Subject: Re: High IO Wait with RAID 1
Date: Fri, 13 Mar 2009 11:37:02 -0700
Message-ID: <72dbd3150903131137m1106e302oa6b36d1270bb10f@mail.gmail.com>
References: <7d86ddb90903121646q485ad12y90824a4c3fcc2dfd@mail.gmail.com>
	 <20090313004802.GB29989@mint.phcomp.co.uk>
	 <7d86ddb90903122021y5f4f0868na3f1944f87f77f4a@mail.gmail.com>
	 <49BA8855.1030904@tmr.com>
	 <7d86ddb90903131042i2bd6aba9o9bae3a99fdcdae5f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90903131042i2bd6aba9o9bae3a99fdcdae5f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Alain Williams <addw@phcomp.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 13, 2009 at 10:42 AM, Ryan Wagoner <rswagoner@gmail.com> wrote:
> Yeah I understand the basics to RAID and the effect cache has on
> performance. It just seems that RAID 1 should offer better write
> performance than a 3 drive RAID 5 array. However I haven't run the
> numbers so I could be wrong.

If we just look at best case scenario write throughput where N is the
number of disks in the array:

RAID1 = 1
RAID5 = N-1

So for your case, your RAID5 array should be able to write up to twice
as fast as your RAID1 array.  This could be enough to explain the
difference in load.

Where RAID5 writes slow down significantly is if you are writing
chunks smaller than the stripe size and the affected stripe isn't in
cache and a read has to be performed before the write to recalculate
the parity.

But for your use case of transferring large VM images, this is
unlikely to be the case.

In otherwords, what you are experiencing (high IO wait writing to the
RAID1 arrays) is to be expected.  From the stats you posted earlier,
it looks like you are maxing out the write speed of the RAID1 arrays -
thus you end up with high IO wait times.

> It could be just that I expect too much from RAID 1. I'm debating
> about reloading the box with RAID 10 across 160GB of the 4 drives
> (160GB and 320GB) and a mirror on the remaining space. In theory this
> should gain me write performance.

Yes, a RAID10 with 4 disks will get you up to twice the write
performance and up to 4 times the read performance without the
drawback of small writes losing performance due to parity reads.

-Dave
