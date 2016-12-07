From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5-cache: no recovery is required when create
 super-block
Date: Wed, 7 Dec 2016 09:26:53 -0800
Message-ID: <20161207172653.keer2kabdu6xgrqa@kernel.org>
References: <20161206061317.4388-1-liuyun01@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161206061317.4388-1-liuyun01@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: JackieLiu <liuyun01@kylinos.cn>
Cc: songliubraving@fb.com, liuzhengyuan@kylinos.cn, shli@fb.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 06, 2016 at 02:13:17PM +0800, JackieLiu wrote:
> When create the super-block information, We do not need to do this
> recovery stage, only need to initialize some variables.

This makes sense.

please do look at Documentation/SubmittingPatches. I can't apply patch without
'signed-off-by'.

> ---
>  drivers/md/raid5-cache.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index c3b3124..96f25df 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2545,7 +2545,13 @@ static int r5l_load_log(struct r5l_log *log)
>  
>  	__free_page(page);
>  
> -	ret = r5l_recovery_log(log);
> +	if (create_super) {
> +		log->log_start = r5l_ring_add(log, cp, BLOCK_SECTORS);
> +		log->seq = log->last_cp_seq + 1;
> +		log->next_checkpoint = cp;

must set ret = 0 here. Next time please make sure there isn't compiling
warnning.

Thanks,
Shaohua
