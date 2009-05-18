From: Neil Brown <neilb@suse.de>
Subject: Re: Subject: [PATCH 1/6] md: raid0 to compile when MD DEBUG  is on
Date: Tue, 19 May 2009 09:43:01 +1000
Message-ID: <18961.62085.805711.386224@notabene.brown>
References: <20090516115726.14596.58766.stgit@notabene.brown>
	<20090516115731.14596.16948.stgit@notabene.brown>
	<1242687604.21201.7.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from raz ben yehuda on Tuesday May 19
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 19, raziebe@gmail.com wrote:
> Because of the removal the device list from 
> the strips raid0 did not compile with MD_DEBUG flag on.

Thanks, I had forgotten to check that!

>  
> -static void raid0_status (struct seq_file *seq, mddev_t *mddev)
> +static void raid0_status(struct seq_file *seq, mddev_t *mddev)
>  {
>  #undef MD_DEBUG
>  #ifdef MD_DEBUG
>  	int j, k, h;
>  	char b[BDEVNAME_SIZE];
>  	raid0_conf_t *conf = mddev->private;
> -
> +	sector_t zone_size;
> +	sector_t zone_start = 0;
>  	h = 0;
>  	for (j = 0; j < conf->nr_strip_zones; j++) {
>  		seq_printf(seq, "      z%d", j);
>  		seq_printf(seq, "=[");
>  		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
>  			seq_printf(seq, "%s/", bdevname(
> -				conf->strip_zone[j].dev[k]->bdev,b));
> -
> -		seq_printf(seq, "] ze=%d ds=%d s=%d\n",
> -				conf->strip_zone[j].zone_end,
> -				conf->strip_zone[j].dev_start,
> -				conf->strip_zone[j].sectors);
> +				conf->devlist[k]->bdev, b));
                                              ^

This doesn't look right.  There should a 'j' in there shouldn't there?
something like
                               conf->devlist[j*mddev->raid_disks + k]->bdev
??

> +
> +		zone_size  = conf->strip_zone[j].zone_end - zone_start;
> +		seq_printf(seq, "] ze=%lld ds=%lld s=%lld\n",
> +			(unsigned long long)zone_start>>1,
> +			(unsigned long long)conf->strip_zone[j].dev_start>>1,
> +			(unsigned long long)zone_size>>1);
> +		zone_start = conf->strip_zone[j].zone_end;

The rest looks fine.

Thanks,
NeilBrown


>  	}
>  #endif
>  	seq_printf(seq, " %dk chunks", mddev->chunk_size/1024);
> 
