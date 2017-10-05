From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: fix deadlock error in recent patch.
Date: Thu, 5 Oct 2017 10:00:48 -0700
Message-ID: <20171005170048.7kirlvlvbnqtx4me@kernel.org>
References: <87shey183f.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87shey183f.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
List-Id: linux-raid.ids

On Thu, Oct 05, 2017 at 04:23:16PM +1100, Neil Brown wrote:
> 
> A recent patch aimed to cause md_write_start() to fail (rather than
> block) when the mddev was suspending, so as to avoid deadlocks.
> Unfortunately the test in wait_event() was wrong, and it didn't change
> behaviour at all.
> 
> We wait_event() must wait until the metadata is written OR the array is
> suspending.

Ouch, probably suspended isn't set normally, so it doesn't get caught. Applied, thanks Neil and Xiao!
 
> Fixes: cc27b0c78c79 ("md: fix deadlock between mddev_suspend() and md_write_start()")
> Cc: stable@vger.kernel.org
> Reported-by: Xiao Ni <xni@redhat.com>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/md.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0ff1bbf6c90e..8b2eb0f4122f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8039,7 +8039,8 @@ bool md_write_start(struct mddev *mddev, struct bio *bi)
>  	if (did_change)
>  		sysfs_notify_dirent_safe(mddev->sysfs_state);
>  	wait_event(mddev->sb_wait,
> -		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) && !mddev->suspended);
> +		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
> +		   mddev->suspended);
>  	if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags)) {
>  		percpu_ref_put(&mddev->writes_pending);
>  		return false;
> -- 
> 2.14.0.rc0.dirty
> 


