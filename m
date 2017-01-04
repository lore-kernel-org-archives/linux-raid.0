From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/r5cache: fix spelling mistake on "recoverying"
Date: Wed, 4 Jan 2017 10:20:24 -0800
Message-ID: <20170104182024.5ar27t5pft2kbwxc@kernel.org>
References: <20161223005230.7731-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161223005230.7731-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 23, 2016 at 12:52:30AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake "recoverying" to "recovering" in
> pr_dbg message.

applied, thanks
 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/md/raid5-cache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index bff1b4a..0e8ed2c 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2170,7 +2170,7 @@ static int r5l_recovery_log(struct r5l_log *log)
>  		pr_debug("md/raid:%s: starting from clean shutdown\n",
>  			 mdname(mddev));
>  	else {
> -		pr_debug("md/raid:%s: recoverying %d data-only stripes and %d data-parity stripes\n",
> +		pr_debug("md/raid:%s: recovering %d data-only stripes and %d data-parity stripes\n",
>  			 mdname(mddev), ctx.data_only_stripes,
>  			 ctx.data_parity_stripes);
>  
> -- 
> 2.10.2
> 
