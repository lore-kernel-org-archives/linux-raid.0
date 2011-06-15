From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: [PATCH v2 1/5] md/raid10: optimize read_balance() for 'far offset' arrays
Date: Wed, 15 Jun 2011 08:51:44 +0200
Message-ID: <20110615065144.GA28174@www2.open-std.org>
References: <1308103324-2375-1-git-send-email-namhyung@gmail.com> <1308103324-2375-2-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1308103324-2375-2-git-send-email-namhyung@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 15, 2011 at 11:02:00AM +0900, Namhyung Kim wrote:
> If @conf->far_offset > 0, there is only 1 stripe so that we can treat
> the array same as 'near' arrays.

does it also work with more than 2 copies - eg 3 copies?
I think the original code just takes the available data blocks with the 
lowest address.

Best regards
keld

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/md/raid10.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 6e846688962f..fc56bdd8c3fb 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -531,7 +531,7 @@ retry:
>  			break;
>  
>  		/* for far > 1 always use the lowest address */
> -		if (conf->far_copies > 1)
> +		if (conf->far_copies > 1 && conf->far_offset == 0)
>  			new_distance = r10_bio->devs[slot].addr;
>  		else
>  			new_distance = abs(r10_bio->devs[slot].addr -
> -- 
> 1.7.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
