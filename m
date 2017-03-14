From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v1] md:fix a trivial typo in comments
Date: Tue, 14 Mar 2017 16:23:13 +0800
Message-ID: <7987b2bb-844e-a70d-34d4-a23fc5294559@suse.de>
References: <1489384407-12672-1-git-send-email-zlliu@suse.com>
 <1489477946-4202-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489477946-4202-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, shli@fb.com
Cc: linux-raid@vger.kernel.org, Jack Wang <jack.wang.usish@gmail.com>, Guoqing Jiang <gqjiang@suse.com>, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids

On 2017/3/14 下午3:52, Zhilong Liu wrote:
> raid1.c: fix a trivial typo in comments of freeze_array().
> 
> Cc: Jack Wang <jack.wang.usish@gmail.com>
> Cc: Guoqing Jiang <gqjiang@suse.com>
> Cc: John Stoffel <john@stoffel.org>
> Cc: Coly Li <colyli@suse.de>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>

Acked-by: Coly Li <colyli@suse.de>

> ---
>  drivers/md/raid1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index fbc2d78..92ca6de 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1027,7 +1027,7 @@ static int get_unqueued_pending(struct r1conf *conf)
>  static void freeze_array(struct r1conf *conf, int extra)
>  {
>  	/* Stop sync I/O and normal I/O and wait for everything to
> -	 * go quite.
> +	 * go quiet.
>  	 * This is called in two situations:
>  	 * 1) management command handlers (reshape, remove disk, quiesce).
>  	 * 2) one normal I/O request failed.
> 

