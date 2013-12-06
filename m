From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: Creating new raid5 or 6 with --assume-clean
Date: Fri, 6 Dec 2013 17:52:52 -0500
Message-ID: <20131206225252.GE15060@animx.eu.org>
References: <20131202030707.GB19621@animx.eu.org>
 <20131202084859.GA26327@cthulhu.home.robinhill.me.uk>
Reply-To: Wakko Warner <wakko@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131202084859.GA26327@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill wrote:
> On Sun Dec 01, 2013 at 10:07:07PM -0500, Wakko Warner wrote:
> 
> > This is a general question, but I'll give a specific.
> > 
> > If I create an array with assume clean and proceed to write to the device,
> > what happens with the parity?
> > 
> Doing that specifically should result in all parity being correct, yes.
> Providing the writes are not going to a single disk in a stripe (in
> which case read-modify-write may be used to update the parity rather
> than a full stripe read and parity recalculation) then any write should
> result in the parity for that stripe being written correctly. I think
> RMW is only used in RAID5 currently though.

I tested with raid6 as I mentioned in the command in the original mail.  I
ran a check and there were no mismatches.

I also created a raid5 on the same amount of disks and tried again.  I only
wrote about 4gb and the mismatch count was 0 until it passed the 4gb mark.

I was fairly certain that it would be correct, but I wanted to check.

> Changing the stripe cache size won't affect the parity calculation at
> all (except in terms of performance/throughput).

I wasn't sure if that would make a difference or not.  Doesn't hurt to ask.

Thanks for the response.

I must say that I've been a user of mdadm/linux software raid for some time
now and I've only once lost an entire array.  I appreciate seeing all the
responses I've seen on the list over the years about how helpful everyone
has been.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
