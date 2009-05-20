From: Neil Brown <neilb@suse.de>
Subject: Re: Subject: [PATCH 001/009]: have raid0 compile with MD_DEBUG on
Date: Wed, 20 May 2009 11:26:21 +1000
Message-ID: <18963.23613.407538.894982@notabene.brown>
References: <1242749175.3293.57.camel@raz>
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
> Because of the removal the device list from 
> the strips raid0 did not compile with MD_DEBUG flag on
> -		seq_printf(seq, "] ze=%d ds=%d s=%d\n",
> -				conf->strip_zone[j].zone_end,
> -				conf->strip_zone[j].dev_start,
> -				conf->strip_zone[j].sectors);
> +				conf->devlist[j*mddesk->raid_disks + k]
                                                ^^^^^^

You didn't compile test this, did you :-)
I've replaced that with mddev, and applied it.

Thanks.

NeilBrown
> +						->bdev, b));
> +
> +		zone_size  = conf->strip_zone[j].zone_end - zone_start;
> +		seq_printf(seq, "] ze=%lld ds=%lld s=%lld\n",
> +			(unsigned long long)zone_start>>1,
> +			(unsigned long long)conf->strip_zone[j].dev_start>>1,
> +			(unsigned long long)zone_size>>1);
> +		zone_start = conf->strip_zone[j].zone_end;
>  	}
>  #endif
>  	seq_printf(seq, " %dk chunks", mddev->chunk_size/1024);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
