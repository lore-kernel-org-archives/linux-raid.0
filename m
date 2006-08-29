From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 001 of 4] md: Define backing_dev_info.congested_fn for
 raid0 and linear
Date: Mon, 28 Aug 2006 22:59:08 -0700
Message-ID: <20060828225908.af114751.akpm@osdl.org>
References: <20060829153414.6475.patches@notabene>
	<1060829053924.6610@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751189AbWH2F7O@vger.kernel.org>
In-Reply-To: <1060829053924.6610@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 29 Aug 2006 15:39:24 +1000
NeilBrown <neilb@suse.de> wrote:

> 
> Each backing_dev needs to be able to report whether it is congested,
> either by modulating BDI_*_congested in ->state, or by
> defining a ->congested_fn.
> md/raid did neither of these.  This patch add a congested_fn
> which simply checks all component devices to see if they are
> congested.
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> +static int linear_congested(void *data, int bits)
> +{
> +	mddev_t *mddev = data;
> +	linear_conf_t *conf = mddev_to_conf(mddev);
> +	int i, ret = 0;
> +
> +	for (i = 0; i < mddev->raid_disks && !ret ; i++) {
> +		request_queue_t *q = bdev_get_queue(conf->disks[i].rdev->bdev);
> +		ret |= bdi_congested(&q->backing_dev_info, bits);

nit: `ret = ' would suffice here.

> +static int raid0_congested(void *data, int bits)
> +{
> +	mddev_t *mddev = data;
> +	raid0_conf_t *conf = mddev_to_conf(mddev);
> +	mdk_rdev_t **devlist = conf->strip_zone[0].dev;
> +	int i, ret = 0;
> +
> +	for (i = 0; i < mddev->raid_disks && !ret ; i++) {
> +		request_queue_t *q = bdev_get_queue(devlist[i]->bdev);
> +
> +		ret |= bdi_congested(&q->backing_dev_info, bits);

And here.

> +	}
> +	return ret;
> +}
> +
>  
>  static int create_strip_zones (mddev_t *mddev)
>  {
> @@ -236,6 +251,8 @@ static int create_strip_zones (mddev_t *
>  	mddev->queue->unplug_fn = raid0_unplug;
>  
>  	mddev->queue->issue_flush_fn = raid0_issue_flush;
> +	mddev->queue->backing_dev_info.congested_fn = raid0_congested;
> +	mddev->queue->backing_dev_info.congested_data = mddev;
>  
>  	printk("raid0: done.\n");
>  	return 0;
