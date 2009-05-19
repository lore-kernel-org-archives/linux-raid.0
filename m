From: Neil Brown <neilb@suse.de>
Subject: Re: Subject : [ md PATCHE 5/6] : 1K *n chunks.
Date: Tue, 19 May 2009 10:48:50 +1000
Message-ID: <18962.498.101162.146118@notabene.brown>
References: <1242688081.21201.19.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from raz ben yehuda on Tuesday May 19
Sender: linux-raid-owner@vger.kernel.org
To: raz ben yehuda <raziebe@gmail.com>
Cc: linux raid <linux-raid@vger.kernel.org>, yaronp@bitband.com
List-Id: linux-raid.ids

On Tuesday May 19, raziebe@gmail.com wrote:
> md to support 1K*n chunks only in the case of raid 0
> Signed-off-by: raziebe@gmail.com
> ---
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aab183e..75a3634 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4011,9 +4011,9 @@ static int do_md_run(mddev_t * mddev)
>  			return -EINVAL;
>  		}
>  		/*
> -		* raid0 chunk size has to divide by a page
> +		* raid0 chunk size has to divide by a 1K
>  		*/
> -		if (mddev->level == 0 && (chunk_size % PAGE_SIZE)) {
> +		if (mddev->level == 0 && (chunk_size % 1024)) {
>  			printk(KERN_ERR "chunk_size of %d not valid\n",
>  				chunk_size);
>  			return -EINVAL;
> 

Ah... 1K is the minimum now.  I cannot see why this is a separate
patch, or why 1K is an appropriate limit.

NeilBrown
