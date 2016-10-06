From: Joe Perches <coupons@perches.com>
Subject: Re: [PATCH 37/54] md/raid5: Replace a seq_printf() call by
 seq_puts() in raid5_status()
Date: Thu, 06 Oct 2016 09:34:59 -0700
Message-ID: <1475771699.1914.10.camel@perches.com>
References: <566ABCD9.1060404@users.sourceforge.net>
         <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
         <92c52f1d-d151-cea6-e9ac-31378e6862d0@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <92c52f1d-d151-cea6-e9ac-31378e6862d0@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

On Thu, 2016-10-06 at 11:37 +0200, SF Markus Elfring wrote:
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
[]
> @@ -7044,7 +7044,7 @@ static void raid5_status(struct seq_file *seq, struct mddev *mddev)
>  			   rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
>  	}
>  	rcu_read_unlock();
> -	seq_printf (seq, "]");
> +	seq_puts(seq, "]");

seq_putc
