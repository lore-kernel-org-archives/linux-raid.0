From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: stripe cache question
Date: Sun, 6 Mar 2011 21:08:56 +0100
Message-ID: <20110306200856.GA6905@lazy.lzy>
References: <20110224210642.GA20306@lazy.lzy>
 <20110225145125.69dd4b9d@notabene.brown>
 <20110226102128.GA15074@lazy.lzy>
 <20110227154350.4448d731@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110227154350.4448d731@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Maybe you could try removing the limit and see what actually happens when
> you set a ridiculously large size.??

Actually, I tried (unintentionally) something similar.

The storage I've has 7 RAID-6 arrays, so I tried to
increase the stripe_cache_size to 32768 on each array.
Of course, while writing to the array...

The first 3 have 10, 10 and 9 HDDs, so with the third
array about 3.6GiB were allocated out of 4GiB the PC has.

At this point the PC was completely unresponsive, but
still working, i.e. it was still writing to the array.

Also ssh did not answer in time.

Nevertheless, it was not dead or locked, just extremely
slow, in fact, once the writing finished, the PC was
again working as before.

I guess there was a lot of swapping going on...

In any case, an upper limit seems to be necessary, but
it should be consistent with all available RAM.
It does not help, it seems, to limit arrays independently,
there should a be a "global" limit, so that the _sum_ of
the caches does no exceed this limit.

Hope this helps,

bye,

-- 

piergiorgio
