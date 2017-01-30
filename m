From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/2] md: add bad block flag to disk state
Date: Mon, 30 Jan 2017 15:33:41 -0800
Message-ID: <20170130233341.l5eiars5lbgowrht@kernel.org>
References: <1485259419-2308-1-git-send-email-tomasz.majchrzak@intel.com>
 <1485259419-2308-2-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485259419-2308-2-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, jes.sorensen@gmail.com
List-Id: linux-raid.ids

On Tue, Jan 24, 2017 at 01:03:38PM +0100, Tomasz Majchrzak wrote:
> Add a new flag to report that bad blocks are present on a disk. It will
> allow userspace to notify the user of the problem.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  drivers/md/md.c                | 2 ++
>  include/uapi/linux/raid/md_p.h | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0abb147..1a807ec 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6034,6 +6034,8 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
>  			info.state |= (1<<MD_DISK_WRITEMOSTLY);
>  		if (test_bit(FailFast, &rdev->flags))
>  			info.state |= (1<<MD_DISK_FAILFAST);
> +		if (rdev->badblocks.count)
> +			info.state |= (1<<MD_DISK_BB_PRESENT);

Userspace can find if a disk has badblocks by reading the bad_blocks sysfs
file. Why adds another interface?

Thanks,
Shaohua

>  	} else {
>  		info.major = info.minor = 0;
>  		info.raid_disk = -1;
> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
> index 9930f3e..b151e93 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -93,6 +93,7 @@
>  				   * read requests will only be sent here in
>  				   * dire need
>  				   */
> +#define MD_DISK_BB_PRESENT	11 /* disk has bad blocks */
>  #define MD_DISK_JOURNAL		18 /* disk is used as the write journal in RAID-5/6 */
>  
>  #define MD_DISK_ROLE_SPARE	0xffff
> -- 
> 1.8.3.1
> 
