From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH] md-cluster: choose correct label when clustered layout is
 not supported
Date: Wed, 24 Jan 2018 09:50:55 +0800
Message-ID: <66502b0c-3bf4-d995-1af0-47dd05b7f7ad@suse.com>
References: <20180123150612.7325-1-lzhong@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180123150612.7325-1-lzhong@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lzhong@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 01/23/2018 11:06 PM, Lidong Zhong wrote:
> r10conf is already successfully allocated before checking the layout
>
> Signed-off-by: Lidong Zhong <lzhong@suse.com>
> ---
>   drivers/md/raid10.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index c131835cf008..c2b2fbeec7b2 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3770,7 +3770,7 @@ static int raid10_run(struct mddev *mddev)
>   		if (fc > 1 || fo > 0) {
>   			pr_err("only near layout is supported by clustered"
>   				" raid10\n");
> -			goto out;
> +			goto out_free_conf;
>   		}
>   	}
>   

Thanks for catch it.
Reviewed-by: Guoqing Jiang <gqjiang@suse.com>

Regards,
Guoqing
