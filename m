From: Neil Brown <neilb@suse.de>
Subject: Re: [Resend] [PATCH] md: Fix rdev_size_store with size = 0
Date: Mon, 13 Oct 2008 11:54:13 +1100
Message-ID: <18674.39989.657486.681886@notabene.brown>
References: <18528.10590.221031.75420@notabene.brown>
	<20080624114706.GD9948@arachsys.com>
	<20080624231947.GG9948@arachsys.com>
	<20081007124059.GZ16020@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Webb on Tuesday October 7
Sender: linux-raid-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 7, chris@arachsys.com wrote:
> Hi Neil. You accepted a patch from me back at the end of June which allowed
> /sys/block/mdX/md/rdY/size to change on running arrays. It supported a value
> of zero to fill all the space on the underlying device. However, a later
> patch tidying up rdev_size_store broke the size = 0 functionality by testing
> for size < my_mddev->size slightly too early. The following patch fixes
> this.

Thanks - and sorry for breaking this :-(

I'll send this upstream soon and probably aim it for -stable too.

Thanks
NeilBrown


> 
> Best wishes,
> 
> Chris.
> 
> 
> From: Chris Webb <chris@arachsys.com>
> 
> Fix rdev_size_store with size = 0
> 
> Signed-off-by: Chris Webb <chris@arachsys.com>
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2109,8 +2109,6 @@
>  
>  	if (strict_strtoull(buf, 10, &size) < 0)
>  		return -EINVAL;
> -	if (size < my_mddev->size)
> -		return -EINVAL;
>  	if (my_mddev->pers && rdev->raid_disk >= 0) {
>  		if (my_mddev->persistent) {
>  			size = super_types[my_mddev->major_version].
> @@ -2121,9 +2119,9 @@
>  			size = (rdev->bdev->bd_inode->i_size >> 10);
>  			size -= rdev->data_offset/2;
>  		}
> -		if (size < my_mddev->size)
> -			return -EINVAL; /* component must fit device */
> -	}
> +	}
> +	if (size < my_mddev->size)
> +		return -EINVAL; /* component must fit device */
>  
>  	rdev->size = size;
>  	if (size > oldsize && my_mddev->external) {
