From: Xu Yuehai <raid.yuehai@gmail.com>
Subject: Re: Does raid5 have error handling while reading?
Date: Fri, 22 May 2009 17:13:59 +0800
Message-ID: <691c243c0905220213i603ba115ga6aea27b7c564c1d@mail.gmail.com>
References: <691c243c0905220110y541ab523v5998b8054c89da60@mail.gmail.com>
	 <2bf95d5420210a8cab4700798fb6030c.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2bf95d5420210a8cab4700798fb6030c.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, green.trace@gmail.com
List-Id: linux-raid.ids

>
> If chunk_aligned_read results in an error, then the request
> is re-tried through the stripe cache.  I would call that "error handling".

I think you mean that error() and raid5_align_endio are invoked and
the read request is sent to conf->retry_read_aligned_list, then the
raid5d will handle it.

> If the cache finds that a drives is failed, the data is calculated
> from the other drives, though the code is not a straight forward
> as it used to be.
> See fetch_block5 which sets STRIPE_OP_COMPUTE_BLK which causes
> ops_run_compute5 to do the work (or to schedule the work on separate
> hardware).
>
I notice that the bit STRIPE_OP_COMPUTE_BLK is set if only s->uptodate
== disks - 1, however, suppose there is just a single read request, I
fail to find out why this condition is satisfied.

Yuehai
