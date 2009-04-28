From: Neil Brown <neilb@suse.de>
Subject: Re: Query regarding stripe management in linux md-raid
Date: Wed, 29 Apr 2009 09:15:52 +1000
Message-ID: <18935.36392.65600.930716@notabene.brown>
References: <fbae8f520904280702h736197d6ibfdf0212bf1923d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kunal Kushwaha on Tuesday April 28
Sender: linux-raid-owner@vger.kernel.org
To: Kunal Kushwaha <kunal.kushwaha@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 28, kunal.kushwaha@gmail.com wrote:
> Hi,
> 
> I am trying to put Linux raid in Box with 256 MB of RAM. The kernel is
> compiled with non-swappable memory management option. I looked into
> raid5.c and found, it allocates one page for each chunk.  I am using 5
> disks for 64k chunk size. considering my kernel is within 30 MB.

That isn't quite right.   It is not 1 page per chunk.
raid5 maintains a stripe cache.  Each entry in the cache has one page
per device, and there are 256 entries by default.
So for a 5-disk array, that is 5*256 == 1280 pages or 5MB (plus
overhead).

> 
> 1. If one page is allocated for one chunk instead of actual buffer
> size, isn't memory lot of memory is wasted?

It depends on what you mean by "wasted".  The memory is used to
provide adequate performance with manageable code complexity.
Possibly the same performance could be achieved using less memory, but
I suspect the code would be much more complex and so probably more
buggy.  It is a trade off.

If the 5MB eats in to you 256MB too much, you can reduce it be writing
a number to /sys/block/mdX/md/stripe_cache_size.
You could probably get away with as little as '4', but I suspect that
would really kill performance.  With a 64K chunk size you want at
least 16 entries, so 32 or 64 might be a suitable compromise for you. 

> 2. It will restrict the no. of stripes in memory (in case of
> non-swappable memory, no will be very less) will effect performance of
> IO badly.

The number of (page-wide) stripes in memory is fixed by the cache
size.  It defaults to 256, but you can change it.  A smaller size
would be likely to negatively affect performance.  A larger cache can
improve performance depending on workload.

> 
> Please correct me, if I am wrong, also any suggestion to overcome this
> problem is most welcomed.

Do you have an actual observed problem, or are you just trying to
discover what problems you might eventually run in to?

NeilBrown
