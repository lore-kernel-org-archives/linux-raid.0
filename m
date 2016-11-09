From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 2/3] md: remove md_super_wait() call after
 bitmap_flush()
Date: Wed, 9 Nov 2016 12:51:20 -0800
Message-ID: <20161109205120.kodctkb5xn5x55rd@kernel.org>
References: <147864718560.1076.2148299631932240330.stgit@noble>
 <147864729285.1076.27654779060287129.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147864729285.1076.27654779060287129.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 09, 2016 at 10:21:32AM +1100, Neil Brown wrote:
> bitmap_flush() finishes with bitmap_update_sb(), and that finishes
> with write_page(..., 1), so write_page() will wait for all writes
> to complete.  So there is no point calling md_super_wait()
> immediately afterwards.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/md.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f389d8abe137..1f1c7f007b68 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5472,7 +5472,6 @@ static void __md_stop_writes(struct mddev *mddev)
>  	del_timer_sync(&mddev->safemode_timer);
>  
>  	bitmap_flush(mddev);
> -	md_super_wait(mddev);

bitmap_flush() could be null if there is no bitmap, is this safe?

Thanks,
Shaohua
