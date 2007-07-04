From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH 0/2] raid5: 65% sequential-write performance improvement, stripe-queue take2
Date: 04 Jul 2007 13:41:26 +0200
Message-ID: <p73wsxg2y6x.fsf@bingen.suse.de>
References: <20070703231838.17500.34505.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070703231838.17500.34505.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, raziebe@gmail.com, akpm@linux-foundation.org, davidsen@tmr.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Williams <dan.j.williams@intel.com> writes:

> The write performance numbers are better than I expected and would seem
> to address the concerns raised in the thread "Odd (slow) RAID
> performance"[2].  The read performance drop was not expected.  However,
> the numbers suggest some additional changes to be made to the queuing
> model.

Have you considered supporting copy-xor in MD for non accelerated
RAID? I've been looking at fixing the old dubious slow crufty x86 SSE
XOR functions. One thing I discovered is that it seems fairly
pointless to make them slower with cache avoidance when most of the data is
copied before anyways. I think much more advantage could be gotten by
supporting copy-xor because XORing during a copy should be nearly
free.

On the other hand ext3 write() also uses a cache avoiding copy now
and for the XOR it would need to load the data from memory again.
Perhaps this could be also optimized somehow (e.g. setting a flag
somewhere and using a normal copy for the RAID-5 case)

-Andi

