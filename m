From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] MD-RAID: Use seq_putc() in three status functions
Date: Sun, 16 Oct 2016 18:58:22 +0200
Message-ID: <688764a4-072d-2faf-37ba-a222b190a5d9@suse.de>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
 <92c52f1d-d151-cea6-e9ac-31378e6862d0@users.sourceforge.net>
 <1475771699.1914.10.camel@perches.com>
 <77fb6fdc-7480-8607-0af1-42f73c125b9d@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <77fb6fdc-7480-8607-0af1-42f73c125b9d@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Joe Perches <coupons@perches.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On 10/16/2016 10:20 AM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 16 Oct 2016 10:10:28 +0200
>
> A single character (a closing square bracket) should be put into a sequence
> at the end in these functions.
> Thus use the corresponding function "seq_putc".
>
> This issue was detected also by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/md/raid1.c  | 2 +-
>  drivers/md/raid10.c | 2 +-
>  drivers/md/raid5.c  | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 1961d82..fd97f65 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1418,7 +1418,7 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>  			   rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
>  	}
>  	rcu_read_unlock();
> -	seq_printf(seq, "]");
> +	seq_putc(seq, ']');
>  }
>
>  static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index be1a9fc..7490b28 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1499,7 +1499,7 @@ static void raid10_status(struct seq_file *seq, struct mddev *mddev)
>  		seq_printf(seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
>  	}
>  	rcu_read_unlock();
> -	seq_printf(seq, "]");
> +	seq_putc(seq, ']');
>  }
>
>  /* check if there are enough drives for
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 92ac251..9eb45c4 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7077,7 +7077,7 @@ static void raid5_status(struct seq_file *seq, struct mddev *mddev)
>  		seq_printf (seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
>  	}
>  	rcu_read_unlock();
> -	seq_printf (seq, "]");
> +	seq_putc(seq, ']');
>  }
>
>  static void print_raid5_conf (struct r5conf *conf)
>
The point of this patch being ... what?
Does it improve code? Does it improve anything?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
