From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] md: fix device size calculation with non-persistent superblock
Date: Tue, 24 Feb 2004 12:13:35 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16442.42303.445148.394516@notabene.cse.unsw.edu.au>
References: <20040223024124.GA1590@psilocybus>
	<16441.33071.218049.163976@notabene.cse.unsw.edu.au>
	<403A30F9.D54AAC68@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Monday February 23
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 23, Paul.Clements@SteelEye.com wrote:
> Neil,
> 
> Currently, the device size calculation is not correct when hot-adding
> devices to arrays with non-persistent superblocks. Device size is always
> calculated as if there were a physical superblock on every device. The
> attached simple change to hot_add_disk() fixes the problem.


Hmm.. I had always assumed that non-persistent superblocks only worked
for linear and raid0.  I'm not sure I would trust any other
configuration.

Are you seriously using raid1 with non-persistent superblocks?  How do
you ensure reliable re-assembly after a device failure followed by
shutdown?

NeilBrown

> 
> Thanks,
> Paul--- 2_6_3_rc2/drivers/md/md.c.PRISTINE	Mon Feb 23 11:01:57 2004
> +++ 2_6_3_rc2/drivers/md/md.c	Mon Feb 23 11:29:10 2004
> @@ -2365,7 +2365,12 @@ static int hot_add_disk(mddev_t * mddev,
>  		return -EINVAL;
>  	}
>  
> -	rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
> +	if (mddev->persistent)
> +		rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
> +	else
> +		rdev->sb_offset = rdev->bdev->bd_inode->i_size
> +							>> BLOCK_SIZE_BITS;
> +
>  	size = calc_dev_size(rdev, mddev->chunk_size);
>  	rdev->size = size;
>  
