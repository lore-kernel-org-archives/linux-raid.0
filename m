From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 that used parity for reads only when degraded
Date: Fri, 24 Mar 2006 15:38:45 +1100
Message-ID: <17443.30677.822868.981690@cse.unsw.edu.au>
References: <loom.20060323T003324-767@post.gmane.org>
	<17441.59458.918847.175664@cse.unsw.edu.au>
	<1143175107.7404.88.camel@starfire>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alex Izvorski on Thursday March 23
Sender: linux-raid-owner@vger.kernel.org
To: Alex Izvorski <aizvorski@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 23, aizvorski@gmail.com wrote:
> Neil - Thank you very much for the response.  
> 
> In my tests with identically configured raid0 and raid5 arrays, raid5
> initially had much lower throughput during reads.  I had assumed that
> was because raid5 did parity-checking all the time.  It turns out that
> raid5 throughput can get fairly close to raid0 throughput
> if /sys/block/md0/md/stripe_cache_size is set to a very high value,
> 8192-16384.  However the cpu load is still very much higher during raid5
> reads.  I'm not sure why?

Probably all the memcpys.
For a raid5 read, the data is DMAed from the device into the
stripe_cache, and then memcpy is used to move it to the filesystem (or
other client) buffer.  Worse: this memcpy happens on only one CPU so a
multiprocessor won't make it go any after.

I would be possible to bypass the stripe_cache for reads from a
non-degraded array (I did it for 2.4) but it is somewhat more complex
in 2.6 and I haven't attempted it yet (there have always been other
more interesting things to do).

To test is this is the problem you could probably just comment-out the
memcpy (the copy_data in handle_stripe) and see if the reads go
faster.  Obviously you will be getting garbage back, but it should
give you a reasonably realistic measure of the cost.

NeilBrown
