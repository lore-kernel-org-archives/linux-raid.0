From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [patch] md superblock update failures
Date: Wed, 16 Mar 2005 17:01:59 +0300
Message-ID: <42383C57.7090702@tls.msk.ru>
References: <20050316130512.GK5305@marowsky-bree.de> <20050316132246.GM5305@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050316132246.GM5305@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree wrote:
[]
>  	err = 0;
> +	frdev = 0;
>  	ITERATE_RDEV(mddev,rdev,tmp) {
>  		char b[BDEVNAME_SIZE];
>  		dprintk(KERN_INFO "md: ");
> @@ -1296,13 +1298,21 @@ repeat:
>  
>  		dprintk("%s ", bdevname(rdev->bdev,b));
>  		if (!rdev->faulty) {
> -			err += write_disk_sb(rdev);
> +			int ret;
> +			ret = write_disk_sb(rdev);
> +			if (ret) {
> +				frdev = rdev;	/* Save failed device */
> +				err += ret;
> +			}

Why not
  +			int ret;
  +			ret = write_disk_sb(rdev);
  +			if (ret) {
  +				md_error(mddev, rdev);
  +				err += ret;
  +			}

instead (and remove frdev entirely)?

I mean, in theory, multiple disks may fail...
But wait.. will md_error() call this routine again?

/mjt
