From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: change the initialization value for a spare device
 spot to MD_DISK_ROLE_SPARE
Date: Tue, 13 Jun 2017 10:17:08 -0700
Message-ID: <20170613171708.roims6ja6vtuwwlo@kernel.org>
References: <20170612024555.1120-1-lzhong@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170612024555.1120-1-lzhong@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lzhong@suse.com>, jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 12, 2017 at 10:45:55AM +0800, Lidong Zhong wrote:
> The value for spare spot of sb->dev_roles is changed from
> MD_DISK_ROLE_FAULTY to MD_DISK_ROLE_SPARE to keep align
> with the value when the superblock is firstly created in
> userspace.

Could you point out where mdadm does this?

I'm wondering what's the impact here. If there is a disk, we will set correct
role at the end of super_1_sync(), otherwise faulty sounds more reasonable.

Jes,
Could you help check this?

Thanks,
Shaohua
 
> Signed-off-by: Lidong Zhong <lzhong@suse.com>
> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 87edc342ccb3..a9aacedefbca 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1852,7 +1852,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
>  		max_dev = le32_to_cpu(sb->max_dev);
>  
>  	for (i=0; i<max_dev;i++)
> -		sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_FAULTY);
> +		sb->dev_roles[i] = cpu_to_le16(MD_DISK_ROLE_SPARE);
>  
>  	if (test_bit(MD_HAS_JOURNAL, &mddev->flags))
>  		sb->feature_map |= cpu_to_le32(MD_FEATURE_JOURNAL);
> -- 
> 2.12.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
