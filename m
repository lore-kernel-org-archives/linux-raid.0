From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 1/2]RAID5: make stripe size configurable
Date: Fri, 11 Jul 2014 19:16:56 +0800
Message-ID: <20140711111656.GA4570@kernel.org>
References: <20140708010018.GA8941@kernel.org>
 <20140710153936.6f042277@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140710153936.6f042277@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 10, 2014 at 03:39:36PM +1000, NeilBrown wrote:
> On Tue, 8 Jul 2014 09:00:18 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > 
> > stripe size is 4k default. Bigger stripe size is considered harmful, because if
> > IO size is small, big stripe size can cause a lot of unnecessary IO/parity
> > calculation. But if upper layer always sends full stripe write to RAID5 array,
> > this drawback goes away. And bigger stripe size can improve performance
> > actually in this case because of bigger size IO and less stripes to handle. In
> > my full stripe write test case, 16k stripe size can improve throughput 40% -
> > 120% depending on RAID5 configuration.
> 
> Hi,
>  certainly interesting.
>  I'd really like to see more precise numbers though.  What config gives 40%,
>  what config gives 120% etc.

A 7-disk raid5 array gives 40%, and a 16-disk PCIe raid5 array gives 120. All
use pcie SSD and do full stripe write. And I observed cpu usage drops too. For
example, in the 7-disk array, cpu utilization drops about 20%.

On the other hand, small size write performance drops a lot, which isn't a surprise.

>  I'm not keen on adding a number that has to be tuned though.  I'd really
>  like to understand exactly where the performance gain comes from.
>  Is it that the requests being sent down are larger, or just better managed -
>  or is it some per-stripe_head overhead that is being removed.

From perf, I saw handle_stripe overhead drops, and some lock contentions get
reduced too because we have less stripes. From iostat, I saw request size gets
bigger.

> 
>  e.g. if we sorted the stripe_heads and handled them in batches of adjacent
>  addresses, might that provide the same speed up?

I tried before. Increasing batch in handle_active_stripes can increase request
size, but we still have big overhead to handle stripes.

>  I'm certain there  is remove for improving the scheduling of the
>  stripe_heads, I'm just not sure what the right approach is though.
>  I'd like to explore that more before make the stripe_heads bigger.
> 
>  Also I really don't like depending on multi-page allocations.  If we were
>  going to go this way I think I'd want an array of single pages, not a
>  multi-page.

Yep, that's easy to fix. I'm using multi-page and hope IO segment size is
bigger. Maybe not worthy, considering we have skip_copy?

Thanks,
Shaohua
