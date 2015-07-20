From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V4 00/13] MD: a caching layer for raid5/6
Date: Mon, 20 Jul 2015 10:03:45 +1000
Message-ID: <20150720100345.63302007@noble>
References: <20150710040847.GA1408097@devbig257.prn2.facebook.com>
	<20150710143656.4ee7e647@noble>
	<20150715004455.GA1024035@devbig257.prn2.facebook.com>
	<20150715121234.22803890@noble>
	<20150715031615.GA1292235@devbig257.prn2.facebook.com>
	<20150715140641.3c61cf78@noble>
	<20150715194927.GA3502691@devbig257.prn2.facebook.com>
	<20150716091653.7b970b32@noble>
	<20150716000739.GA4041321@devbig257.prn2.facebook.com>
	<20150716112217.3e2e685f@noble>
	<20150716041305.GA283306@devbig257.prn2.facebook.com>
	<20150716160711.08c37fc1@noble>
	<21927.51382.8600.700720@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21927.51382.8600.700720@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com, Kernel-team@fb.com
List-Id: linux-raid.ids

On Thu, 16 Jul 2015 11:07:34 -0400 "John Stoffel" <john@stoffel.org>
wrote:

> 
> So.... how will wrapping of sequence numbers be handled in the cache
> metadata on disk?  They can't grow for ever...

Can't they?

A 64bit number incremented every millisecond can grow for half a
billion years.  As far as I'm concerned, that is forever.

But even if we used 32bit numbers, it is very easy to handle looping
providing you have few than half of the numbers in use at any time.
So as long as we don't have more than 2 billion active transactions in
the log at once, there is no problem.
The kernel does some internal time keeping using "jiffies" which, on
32bit systems, cycle about every fortnight.  A small amount of care is
enough that this doesn't cause problem.

NeilBrown
