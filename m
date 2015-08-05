From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/9] md: override md superblock recovery_offset for
 cache device
Date: Wed, 5 Aug 2015 11:08:54 +1000
Message-ID: <20150805110854.41b938e5@noble>
References: <cover.1438215986.git.shli@fb.com>
	<42ac39ae4466dda63b1dee827c2bd3741d669860.1438215986.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42ac39ae4466dda63b1dee827c2bd3741d669860.1438215986.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, 29 Jul 2015 17:38:42 -0700 Shaohua Li <shli@fb.com> wrote:

> Cache device stores data in a log structure. We need record the log
> start. Here we override md superblock recovery_offset for this purpose.
> This field of a cache device is meaningless otherwise.
> 
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/md.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index fd84f16..9861f34 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1664,6 +1664,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *rdev)
>  				  "cache feature, ignoring the device\n");
>  				return -EINVAL;
>  			}
> +			rdev->recovery_offset = le64_to_cpu(sb->recovery_offset);
>  			set_bit(WriteCache, &rdev->flags);
>  			break;
>  		default:
> @@ -1830,6 +1831,9 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
>  			sb->dev_roles[i] = cpu_to_le16(0xffff);
>  	}
>  
> +	if (test_bit(WriteCache, &rdev->flags))
> +		sb->recovery_offset = cpu_to_le64(rdev->recovery_offset);
> +

I would much rather this was a little earlier in the function,
near where recovery_offset is set  for non-InSync devices.
i.e. immediately after:

	if (rdev->raid_disk >= 0 &&
	    !test_bit(In_sync, &rdev->flags)) {
		sb->feature_map |=
			cpu_to_le32(MD_FEATURE_RECOVERY_OFFSET);
		sb->recovery_offset =
			cpu_to_le64(rdev->recovery_offset);
		if (rdev->saved_raid_disk >= 0 && mddev->bitmap)
			sb->feature_map |=
				cpu_to_le32(MD_FEATURE_RECOVERY_BITMAP);
	}

Maybe we could always copy recovery_offset from rdev to sb, and then
just set whichever feature flags are relevant - if any.  Or maybe not.

Thanks,
NeilBrown


>  	sb->sb_csum = calc_sb_1_csum(sb);
>  }
>  

