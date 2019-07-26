From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v1] md: Convert to use int_pow()
Date: Fri, 26 Jul 2019 19:48:23 +0300
Message-ID: <20190726164823.GB9224@smile.fi.intel.com>
References: <20190723204155.71531-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190723204155.71531-1-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Coly Li <colyli@suse.de>, Mikulas Patocka <mpatocka@redhat.com>, Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 23, 2019 at 11:41:55PM +0300, Andy Shevchenko wrote:
> Instead of linear approach to calculate power of 10, use generic int_pow()
> which does it better.

I took into Cc drivers/dm guys as they might have known something about md raid
state of affairs. Sorry if I mistakenly added somebody.

Who is doing this?
Should it be orphaned?

(I got a bounce from Shaohua address)

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/md/md.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 24638ccedce4..3f1252440ad0 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3664,11 +3664,7 @@ int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale)
>  		return -EINVAL;
>  	if (decimals < 0)
>  		decimals = 0;
> -	while (decimals < scale) {
> -		result *= 10;
> -		decimals ++;
> -	}
> -	*res = result;
> +	*res = result * int_pow(10, scale - decimals);
>  	return 0;
>  }
>  
> -- 
> 2.20.1
> 

-- 
With Best Regards,
Andy Shevchenko
