From: Shaohua Li <shli@kernel.org>
Subject: Re: [MD PATCH 1/1] Don't add nr_pending for resync requests
Date: Tue, 25 Apr 2017 10:10:34 -0700
Message-ID: <20170425171034.peeh6uuvwycqtise@kernel.org>
References: <1493023635-5652-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493023635-5652-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, neilb@suse.com, colyli@suse.de
List-Id: linux-raid.ids

Hi,
Cc: Coly and Neil.

On Mon, Apr 24, 2017 at 04:47:15PM +0800, Xiao Ni wrote:
> In newer barrier codes, raise_barrier waits if conf->nr_pending[idx] is not zero.
> After all the conditions are true, the resync request can go on be handling. But
> it adds conf->nr_pending[idx] again. The next resync request hit the same bucket
> idx need to wait the resync request which is submitted before. The performance
> of resync/recovery is degraded.
> 
> I did some tests:
> 1. Before removing the codes, the resync performance is:
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdc               0.00     0.00    0.00  164.00     0.00    10.13   126.46     0.95    5.80    0.00    5.80   5.82  95.40
> sdb               0.00     0.00  163.00    2.00    10.19     0.00   126.47     0.04    0.25    0.18    5.50   0.25   4.10
> 2. After removing the codes, the resync performance is:
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> sdc               0.00  2164.00    0.00  751.00     0.00   182.06   496.49     7.49    9.95    0.00    9.95   1.33 100.00
> sdb            2162.00     0.00  752.00    0.00   182.25     0.00   496.34     0.56    0.74    0.74    0.00   0.65  48.80

A big resync regression, thanks to check it! Your analysis makes sense to me,
but the patch doesn't. freeze_array() depends on nr_pending to wait for all
normal IO and resync. This change will make the wait for resync disappear.

I think the problem is we are abusing nr_pending here. freeze_array() waits for
a condition which doesn't need to be maintained by nr_pending. It makes sense
raise_barrier to wait for nr_pending caused by normal IO, but it doesn't make
sense to wait for other raise_barrier.

We could add another vairable, increase it in raise_barrier, decrease it in
lower_barrier and let freeze_array() check the new variable. That should fix
the problem and not expose race condition for freeze_array().

Thanks,
Shaohua
 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  drivers/md/raid1.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index a34f587..48567ea 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -869,7 +869,6 @@ static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
>  			     atomic_read(&conf->barrier[idx]) < RESYNC_DEPTH,
>  			    conf->resync_lock);
>  
> -	atomic_inc(&conf->nr_pending[idx]);
>  	spin_unlock_irq(&conf->resync_lock);
>  }
>  
> @@ -880,7 +879,6 @@ static void lower_barrier(struct r1conf *conf, sector_t sector_nr)
>  	BUG_ON(atomic_read(&conf->barrier[idx]) <= 0);
>  
>  	atomic_dec(&conf->barrier[idx]);
> -	atomic_dec(&conf->nr_pending[idx]);
>  	wake_up(&conf->wait_barrier);
>  }
>  
> -- 
> 2.7.4
> 
