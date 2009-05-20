From: Neil Brown <neilb@suse.de>
Subject: Re: Subject: [PATCH 007/009]: raid10: chunk size check in run
Date: Wed, 20 May 2009 11:41:41 +1000
Message-ID: <18963.24533.807740.325472@notabene.brown>
References: <1242749294.3293.71.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from raz ben yehuda on Tuesday May 19
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>, ofer <ofer@bitband.com>, yaron <yaronp@bitband.com>
List-Id: linux-raid.ids

On Tuesday May 19, raziebe@gmail.com wrote:
> have raid10 check chunk size in run method instead of in md
>  raid10.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> Signed-off-by: raziebe@gmail.com
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 2405add..52ad64e 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2055,7 +2055,15 @@ static int run(mddev_t *mddev)
>  		       "at least PAGE_SIZE(%ld).\n", PAGE_SIZE);
>  		return -EINVAL;
>  	}
> -
> +	/*
> +	 * chunk-size has to be a power of 2
> +	 */
> +	if ((1 << ffz(~mddev->chunk_size)) != mddev->chunk_size) {
> +		printk(KERN_ERR "%s chunk_size of %d not valid\n",
> +			mdname(mddev),
> +			mddev->chunk_size);
> +		return -EINVAL;
> +	}
>  	nc = mddev->layout & 255;
>  	fc = (mddev->layout >> 8) & 255;
>  	fo = mddev->layout & (1<<16);
> 

I combined this with the other chunk_size check in run, so there
is only the one printk.

Thanks,
NeilBrown
