From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: always set THREAD_WAKEUP and wake up wqueue if
 thread existed
Date: Sun, 8 Oct 2017 20:32:59 -0700
Message-ID: <20171009033259.qwf4mspwzgdmiqog@kernel.org>
References: <1507516368-6465-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1507516368-6465-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 09, 2017 at 10:32:48AM +0800, Guoqing Jiang wrote:
> Since commit 4ad23a976413 ("MD: use per-cpu counter for writes_pending"),
> the wait_queue is only got invoked if THREAD_WAKEUP is not set previously.
> 
> With above change, I can see process_metadata_update could always hang on
> the wait queue, because mddev->thread could stay on 'D' status and the
> THREAD_WAKEUP flag is not cleared since there are lots of place to wake up
> mddev->thread. Then deadlock happened as follows:
> 
> linux175:~ # ps aux|grep md|grep D
> root    20117   0.0 0.0         0   0 ? D   03:45   0:00 [md0_raid1]
> root    20125   0.0 0.0         0   0 ? D   03:45   0:00 [md0_cluster_rec]
> linux175:~ # cat /proc/20117/stack
> [<ffffffffa0635604>] dlm_lock_sync+0x94/0xd0 [md_cluster]
> [<ffffffffa0635674>] lock_token+0x34/0xd0 [md_cluster]
> [<ffffffffa0635804>] metadata_update_start+0x64/0x110 [md_cluster]
> [<ffffffffa04d985b>] md_update_sb.part.58+0x9b/0x860 [md_mod]
> [<ffffffffa04da035>] md_update_sb+0x15/0x30 [md_mod]
> [<ffffffffa04dc066>] md_check_recovery+0x266/0x490 [md_mod]
> [<ffffffffa06450e2>] raid1d+0x42/0x810 [raid1]
> [<ffffffffa04d2252>] md_thread+0x122/0x150 [md_mod]
> [<ffffffff81091741>] kthread+0x101/0x140
> linux175:~ # cat /proc/20125/stack
> [<ffffffffa0636679>] recv_daemon+0x3f9/0x5c0 [md_cluster]
> [<ffffffffa04d2252>] md_thread+0x122/0x150 [md_mod]
> [<ffffffff81091741>] kthread+0x101/0x140
> 
> So let's revert the part of code in the commit to resovle the problem since
> we can't get lots of benefits of previous change.
> 
> Fixes: 4ad23a976413 ("MD: use per-cpu counter for writes_pending")
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/md.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 8b2eb0f..707471e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7468,8 +7468,8 @@ void md_wakeup_thread(struct md_thread *thread)
>  {
>  	if (thread) {
>  		pr_debug("md: waking up MD thread %s.\n", thread->tsk->comm);
> -		if (!test_and_set_bit(THREAD_WAKEUP, &thread->flags))
> -			wake_up(&thread->wqueue);
> +		set_bit(THREAD_WAKEUP, &thread->flags);
> +		wake_up(&thread->wqueue);
>  	}
>  }
>  EXPORT_SYMBOL(md_wakeup_thread);

Applied, thanks!
