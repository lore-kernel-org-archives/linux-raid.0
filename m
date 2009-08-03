From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH] md: avoid use of broken kzalloc mempool
Date: Tue, 4 Aug 2009 08:03:52 +1000 (EST)
Message-ID: <8604b01355a1ff1ec6397d223c28b1d5.squirrel@neil.brown.name>
References: <1249332888-13440-1-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1249332888-13440-1-git-send-email-sage@newdream.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sage Weil <sage@newdream.net>, linux-raid@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

On Tue, August 4, 2009 6:54 am, Sage Weil wrote:
> The kzalloc mempool does not re-zero items that have been used and then
> returned to the pool.  Manually zero the allocated multipath_bh instead.
>
> CC: linux-raid@vger.kernel.org
> CC: Neil Brown <neilb@suse.de>

Acked-by: NeilBrown <neilb@suse.de>

Thanks.

In fact, you don't even need the memset.  After allocation
no assumptions are made about the content of the structure.
Every field is immediately initialised except retry_list, which
is never accessed until after the object is placed on a list.h list.

So this code never needed kzalloc_pool.

Thanks,
NeilBrown

> CC: <stable@kernel.org>
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  drivers/md/multipath.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
> index 237fe3f..151ce69 100644
> --- a/drivers/md/multipath.c
> +++ b/drivers/md/multipath.c
> @@ -150,6 +150,7 @@ static int multipath_make_request (struct
> request_queue *q, struct bio * bio)
>  	}
>
>  	mp_bh = mempool_alloc(conf->pool, GFP_NOIO);
> +	memset(mp_bh, 0, sizeof(*mp_bh));
>
>  	mp_bh->master_bio = bio;
>  	mp_bh->mddev = mddev;
> @@ -490,7 +491,7 @@ static int multipath_run (mddev_t *mddev)
>  	}
>  	mddev->degraded = conf->raid_disks - conf->working_disks;
>
> -	conf->pool = mempool_create_kzalloc_pool(NR_RESERVED_BUFS,
> +	conf->pool = mempool_create_kmalloc_pool(NR_RESERVED_BUFS,
>  						 sizeof(struct multipath_bh));
>  	if (conf->pool == NULL) {
>  		printk(KERN_ERR
> --
> 1.5.6.5
>

