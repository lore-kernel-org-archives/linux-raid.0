From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] md: fix a build warning
Date: Wed, 10 Jun 2015 19:07:22 +0300
Message-ID: <20150610160722.GF28762@mwanda>
References: <1433949658-8455-1-git-send-email-firogm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433949658-8455-1-git-send-email-firogm@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Firo Yang <firogm@gmail.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 10, 2015 at 11:20:58PM +0800, Firo Yang wrote:
> By the way, I also fixed a line over 80 characters warning outputed
> by ./scripts/checkpatch.pl

Don't do this.  It's not on the same line, it's not really related at
all.

>  	    mddev->chunk_sectors != info->chunk_size >> 9 ||
> -	    /* ignore bottom 8 bits of state, and allow SB_BITMAP_PRESENT to change */
> +	    /* ignore bottom 8 bits of state, and allow SB_BITMAP_PRESENT
> +		to change */

The new comment style isn't correct.

regards,
dan carpenter

