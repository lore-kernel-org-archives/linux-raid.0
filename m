From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH V3 2/2] RAID1: avoid unnecessary spin locks in I/O barrier
 code
Date: Thu, 16 Feb 2017 01:15:18 +0800
Message-ID: <bd673146-34ee-8069-b68b-b606bdb7b5b1@suse.de>
References: <1487176523-109075-1-git-send-email-colyli@suse.de>
 <1487176523-109075-2-git-send-email-colyli@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1487176523-109075-2-git-send-email-colyli@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, Hannes Reinecke <hare@suse.com>, Neil Brown <neilb@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On 2017/2/16 上午12:35, colyli@suse.de wrote:
[snip]
>  
> @@ -955,11 +1014,14 @@ static int get_unqueued_pending(struct r1conf *conf)
>  	int idx, ret;
>  
>  	for (ret = 0, idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
> -		ret += conf->nr_pending[idx] - conf->nr_queued[idx];
> +		ret += atomic_read(&conf->nr_pending[idx]) -
> +			conf->nr_queued[idx];
>  
>  	return ret;
>  }
>  
> +#define FREEZE_TIMEOUT_JIFFIES 10
> +

The above line will be removed in next version, please ignore it.

[snip]

Coly
