From: Neil Brown <neilb@suse.de>
Subject: Re: Subject: [PATCH 008/009]: raid5: chunk size check in run
Date: Wed, 20 May 2009 11:39:25 +1000
Message-ID: <18963.24397.244498.927721@notabene.brown>
References: <1242749263.3293.67.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from raz ben yehuda on Tuesday May 19
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>, yaron <yaronp@bitband.com>, ofer <ofer@bitband.com>
List-Id: linux-raid.ids

On Tuesday May 19, raziebe@gmail.com wrote:
> have raid5 check chunk size in run method instead of in md
>  raid5.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> Signed-Off-by:raziebe@gmail.com
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e4608d6..0c688ee 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4452,7 +4452,15 @@ static int run(mddev_t *mddev)
>  	raid5_conf_t *conf;
>  	int working_disks = 0;
>  	mdk_rdev_t *rdev;
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
>  	if (mddev->reshape_position != MaxSector) {
>  		/* Check that we can continue the reshape.
>  		 * Currently only disks can change, it must
> 

I've moved this test from 'run' to 'setup_conf' which is called by run
and also by the reshape code, and already has a test on chunk_size.

Thanks,
NeilBrown
