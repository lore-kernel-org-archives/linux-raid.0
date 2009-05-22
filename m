From: "NeilBrown" <neilb@suse.de>
Subject: Re: Does raid5 have error handling while reading?
Date: Fri, 22 May 2009 18:35:48 +1000 (EST)
Message-ID: <2bf95d5420210a8cab4700798fb6030c.squirrel@neil.brown.name>
References: <691c243c0905220110y541ab523v5998b8054c89da60@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <691c243c0905220110y541ab523v5998b8054c89da60@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xu Yuehai <raid.yuehai@gmail.com>
Cc: linux-raid@vger.kernel.org, Trace Green <green.trace@gmail.com>
List-Id: linux-raid.ids

On Fri, May 22, 2009 6:10 pm, Xu Yuehai wrote:
> I know that if the read request of raid5 is handled by
> chunk_aligned_read, there is no error handling in raid5. But, if this
> read request is not aligned, that's say, raid5 need stripe_head to
> deal with this request. I find in the code of 2.6.27 that there is no
> error handling if this read request fail, I remember in older kernel,
> some operations should be done such as compute_block. Am I right?

If chunk_aligned_read results in an error, then the request
is re-tried through the stripe cache.  I would call that "error handling".

If the cache finds that a drives is failed, the data is calculated
from the other drives, though the code is not a straight forward
as it used to be.
See fetch_block5 which sets STRIPE_OP_COMPUTE_BLK which causes
ops_run_compute5 to do the work (or to schedule the work on separate
hardware).

NeilBrown

