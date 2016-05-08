From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: make the code more readable in the for-loop
Date: Sun, 8 May 2016 16:03:17 -0700
Message-ID: <20160508230317.GB8100@kernel.org>
References: <318e71b0.3d4e.1549071292b.Coremail.kernelpatch@126.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <318e71b0.3d4e.1549071292b.Coremail.kernelpatch@126.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tiezhu Yang <kernelpatch@126.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 08, 2016 at 08:56:55PM +0800, Tiezhu Yang wrote:
> This patch modifies raid1.c, raid10.c and raid5.c
> to make the code more readable in the for-loop
> and also fixes the scripts/checkpatch.pl error:
> ERROR: trailing statements should be on next line.
> 
> Signed-off-by: Tiezhu Yang <kernelpatch@126.com>
> @@ -3573,7 +3573,8 @@ static void handle_stripe_dirtying(struct r5conf *conf,
>  		pr_debug("force RCW rmw_level=%u, recovery_cp=%llu sh->sector=%llu\n",
>  			 conf->rmw_level, (unsigned long long)recovery_cp,
>  			 (unsigned long long)sh->sector);
> -	} else for (i = disks; i--; ) {
> +	} else
> +	for (i = disks - 1; i >= 0; i--) {
>  		/* would I have to read this buffer for read_modify_write */
>  		struct r5dev *dev = &sh->dev[i];
>  		if ((dev->towrite || i == sh->pd_idx || i == sh->qd_idx) &&

Applied. I move the for statement to be in a {} of else statement.
