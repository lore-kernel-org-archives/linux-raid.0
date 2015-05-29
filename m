From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [PATCH 4/4] raid5: fix wakeup condition
Date: Fri, 29 May 2015 13:42:05 +0800
Message-ID: <20150529054205.GA10378@yliu-dev.sh.intel.com>
References: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
 <de048e4f0889e59ffb452f8b5f704bd888fcc1c1.1432859513.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <de048e4f0889e59ffb452f8b5f704bd888fcc1c1.1432859513.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Hi Shaohua,

On Thu, May 28, 2015 at 05:33:48PM -0700, Shaohua Li wrote:
> Since we have several stripe hash list, the conf->active_stripes doesn't
> determine if there is free stripe in a specific hash list, so delete the

I happened to have considered something similar but with slight different
before. The stuff I came up with is to make active_stripes per stripe hash
as well, with which your above concerns could be eliminated.

I even wrote the code, and it became a bit uglier than I thought, what's
more, I see no obvious performance benifit from it. I then gave it up
and didn't sent it out for bothering you guys.

Well, I wrote that code before I came up with this lock contention fix[0],
it might be a different story if I wrote such code based on the fix. If you
are interested, I guess I could cook it up again and do some tests.

[0]: http://git.neil.brown.name/?p=md.git;a=commit;h=970e1a16559e1865b429e0ec408c9a06f2f83795


BTW, the reason I want to make active_stripes per stripe hash is to
keep the semantics of holding on to wake up processes before we get
1/4 stripes available, which, IMO, is for performance consideration.

And to be honest, I don't have too much clue how the performance will
behave differently in such two cases. I'm gonna to do some test to
figure it out, if you think that's necessary.

	--yliu

> check. After this, the R5_INACTIVE_BLOCKED check is inappropriate. There
> is no point not to wakeup a task if there is free stripe.
> 
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 67626f3..4b5a03c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -687,11 +687,7 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
>  					&conf->cache_state);
>  				wait_event_lock_irq(
>  					conf->wait_for_stripe,
> -					!list_empty(conf->inactive_list + hash) &&
> -					(atomic_read(&conf->active_stripes)
> -					 < (conf->max_nr_stripes * 3 / 4)
> -					 || !test_bit(R5_INACTIVE_BLOCKED,
> -						      &conf->cache_state)),
> +					!list_empty(conf->inactive_list + hash),
>  					*(conf->hash_locks + hash));
>  				clear_bit(R5_INACTIVE_BLOCKED,
>  					  &conf->cache_state);
> -- 
> 1.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
