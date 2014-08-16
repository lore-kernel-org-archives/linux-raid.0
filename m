From: mdraid.pkoch@dfgh.net (Peter Koch)
Subject: Re: memory leak with linux-3.14.16
Date: Sat, 16 Aug 2014 15:45:05 +0200
Message-ID: <201408161345.s7GDj5gR027016@portal.naev.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 
References: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Neil,

> The only bug I know of was fixed in 3.14.6.
> I said 3.14.16 before - sorry about typo.

No wonder 3.14.16 behaves exactly as 3.14.12 did

My server now has reshaped 2.28TB and lost 9.14GB of RAM
so memory is still leaking at 4GB per TB

> Hmm... don't know about that bug.
> Does /proc/slabinfo show some slab much bigger than the rest?

I'm not a memory expert, so I made a copy of /proc/slabinfo and
compared this copy with /proc/slabinfo in an endless loop.

There are two values which are unusually high and
are going up constantly:

radix_tree_node   403942
kmalloc-256       38283576

38283576 chunks of 256 bytes are exactly those 9.14GB of
RAM that have leaked so far.

> If you gracefully shutdown and reboot it should keep pick up where it left
> off but with more memory free.

Last time my machine crashed when about 10TB of data was reshaped.
And my machine has 32GB of RAM plus 8GB of swap. According to my
calculations I need 13TB * 4GB/TB = 52GB of RAM, so adding another
20GB of swapspace should keep my server running until the reshape
has finished.

Kind regards

Peter
