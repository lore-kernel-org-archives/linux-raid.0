From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/2] md/r5cache: disable write back for degraded raid6
Date: Sat, 21 Jan 2017 10:42:38 -0800
Message-ID: <20170121184238.ukp3i5f4i3wpz2tg@kernel.org>
References: <20170118235650.2430923-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170118235650.2430923-1-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

On Wed, Jan 18, 2017 at 03:56:49PM -0800, Song Liu wrote:
> raid6 handles write differently in degraded mode. Specifically,
> handle_stripe_fill() is called for writes. As a result, write
> back cache has very little performance benefit for degraded
> raid6. (On the other hand, write back cache does help sequential
> writes on degraded raid4 and raid5).

To be honest I really hate the idea of writeback for degraded array. It adds a
lot of complexity. It maybe improve write performance, but read performance is
always bad, so the disk performance is already bad. Improving write performance
doesn't change disk performance fully. Can't imagine who care about the
performance of degraded array. When a disk is broken, the first thing people
should do is to take action to avoid further disk loss. In other word, you are
optimizing the performance of a corner case. I hope we can delete the logic
later.

> Write back cache for degraded mode also introduces data integrity
> corner cases. This is mostly because handle_stripe_fill() is
> called on write. To avoid handling these corner cases, this patch
> disables write back cache for degraded raid6.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/md/raid5-cache.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 4957297..b31ae41 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2371,6 +2371,16 @@ int r5c_try_caching_write(struct r5conf *conf,
>  		set_bit(STRIPE_R5C_CACHING, &sh->state);
>  	}
>  
> +	/*
> +	 * When raid6 array runs in degraded mode, handle_stripe_fill() is
> +	 * called on every write. So write back cache doesn't help the
> +	 * performance. To simplify the code, do write-through.
> +	 */
> +	if (conf->level == 6 && s->failed) {
> +		r5c_make_stripe_write_out(sh);
> +		return -EAGAIN;
> +	}

Instead of this adhoc handling, why don't we fully switch to writethrough mode
after disk is broken?

Thanks,
Shaohua
