From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md: remove ro check in md_check_recovery()
Date: Thu, 14 Jul 2011 13:54:38 +1000
Message-ID: <20110714135438.24e26684@notabene.brown>
References: <1309984866-2228-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1309984866-2228-1-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu,  7 Jul 2011 05:41:06 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> Commit c89a8eee6154 ("Allow faulty devices to be removed from a
> readonly array.") added some work on ro array in the function,
> but it couldn't be done since we didn't allow the ro array to be
> handled from the beginning. Fix it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/md/md.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 53e8d75314c3..a4022e679b63 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7179,9 +7179,6 @@ void md_check_recovery(mddev_t *mddev)
>  	if (mddev->bitmap)
>  		bitmap_daemon_work(mddev);
>  
> -	if (mddev->ro)
> -		return;
> -
>  	if (signal_pending(current)) {
>  		if (mddev->pers->sync_request && !mddev->external) {
>  			printk(KERN_INFO "md: %s in immediate safe mode\n",


Applied, thanks.

NeilBrown
