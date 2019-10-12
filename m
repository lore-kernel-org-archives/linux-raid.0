From: Yufen Yu <yuyufen@huawei.com>
Subject: Re: [PATCH v2] md: no longer compare spare disk superblock events in
 super_load
Date: Sat, 12 Oct 2019 09:25:06 +0800
Message-ID: <5bce906d-3493-982e-63b1-66d1b9813e1e@huawei.com>
References: <20190925055449.30091-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190925055449.30091-1-yuyufen@huawei.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: songliubraving@fb.com
Cc: linux-raid@vger.kernel.org, neilb@suse.de, stable@vger.kernel.org
List-Id: linux-raid.ids

ping


On 2019/9/25 13:54, Yufen Yu wrote:
> We have a test case as follow:
>
>    mdadm -CR /dev/md1 -l 1 -n 4 /dev/sd[a-d] --assume-clean --bitmap=internal
>    mdadm -S /dev/md1
>    mdadm -A /dev/md1 /dev/sd[b-c] --run --force
>
>    mdadm --zero /dev/sda
>    mdadm /dev/md1 -a /dev/sda
>
>    echo offline > /sys/block/sdc/device/state
>    echo offline > /sys/block/sdb/device/state
>    sleep 5
>    mdadm -S /dev/md1
>
>    echo running > /sys/block/sdb/device/state
>    echo running > /sys/block/sdc/device/state
>    mdadm -A /dev/md1 /dev/sd[a-c] --run --force
>
> When we readd /dev/sda to the array, it started to do recovery.
> After offline the other two disks in md1, the recovery have
> been interrupted and superblock update info cannot be written
> to the offline disks. While the spare disk (/dev/sda) can continue
> to update superblock info.
>
> After stopping the array and assemble it, we found the array
> run fail, with the follow kernel message:
>
> [  172.986064] md: kicking non-fresh sdb from array!
> [  173.004210] md: kicking non-fresh sdc from array!
> [  173.022383] md/raid1:md1: active with 0 out of 4 mirrors
> [  173.022406] md1: failed to create bitmap (-5)
> [  173.023466] md: md1 stopped.
>
> Since both sdb and sdc have the value of 'sb->events' smaller than
> that in sda, they have been kicked from the array. However, the only
> remained disk sda is in 'spare' state before stop and it cannot be
> added to conf->mirrors[] array. In the end, raid array assemble and run fail.
>
> In fact, we can use the older disk sdb or sdc to assemble the array.
> That means we should not choose the 'spare' disk as the fresh disk in
> analyze_sbs().
>
> To fix the problem, we do not compare superblock events when it is
> a spare disk, as same as validate_super.
>
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
>
> v1->v2:
>    fix wrong return value in super_90_load
> ---
>   drivers/md/md.c | 44 ++++++++++++++++++++++++--------------------
>   1 file changed, 24 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1be7abeb24fd..0a91c20071b3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1097,7 +1097,7 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
>   {
>   	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
>   	mdp_super_t *sb;
> -	int ret;
> +	int ret = 0;
>   
>   	/*
>   	 * Calculate the position of the superblock (512byte sectors),
> @@ -1111,14 +1111,12 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
>   	if (ret)
>   		return ret;
>   
> -	ret = -EINVAL;
> -
>   	bdevname(rdev->bdev, b);
>   	sb = page_address(rdev->sb_page);
>   
>   	if (sb->md_magic != MD_SB_MAGIC) {
>   		pr_warn("md: invalid raid superblock magic on %s\n", b);
> -		goto abort;
> +		return -EINVAL;
>   	}
>   
>   	if (sb->major_version != 0 ||
> @@ -1126,15 +1124,15 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
>   	    sb->minor_version > 91) {
>   		pr_warn("Bad version number %d.%d on %s\n",
>   			sb->major_version, sb->minor_version, b);
> -		goto abort;
> +		return -EINVAL;
>   	}
>   
>   	if (sb->raid_disks <= 0)
> -		goto abort;
> +		return -EINVAL;
>   
>   	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
>   		pr_warn("md: invalid superblock checksum on %s\n", b);
> -		goto abort;
> +		return -EINVAL;
>   	}
>   
>   	rdev->preferred_minor = sb->md_minor;
> @@ -1156,19 +1154,22 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
>   		if (!md_uuid_equal(refsb, sb)) {
>   			pr_warn("md: %s has different UUID to %s\n",
>   				b, bdevname(refdev->bdev,b2));
> -			goto abort;
> +			return -EINVAL;
>   		}
>   		if (!md_sb_equal(refsb, sb)) {
>   			pr_warn("md: %s has same UUID but different superblock to %s\n",
>   				b, bdevname(refdev->bdev, b2));
> -			goto abort;
> +			return -EINVAL;
>   		}
>   		ev1 = md_event(sb);
>   		ev2 = md_event(refsb);
> -		if (ev1 > ev2)
> -			ret = 1;
> -		else
> -			ret = 0;
> +
> +		/* Insist on good event counter while assembling, except
> +		 * for spares (which don't need an event count) */
> +		if (sb->disks[rdev->desc_nr].state & (
> +			(1<<MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE)))
> +			if (ev1 > ev2)
> +				ret = 1;
>   	}
>   	rdev->sectors = rdev->sb_start;
>   	/* Limit to 4TB as metadata cannot record more than that.
> @@ -1180,9 +1181,8 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
>   
>   	if (rdev->sectors < ((sector_t)sb->size) * 2 && sb->level >= 1)
>   		/* "this cannot possibly happen" ... */
> -		ret = -EINVAL;
> +		return -EINVAL;
>   
> - abort:
>   	return ret;
>   }
>   
> @@ -1520,7 +1520,7 @@ static __le32 calc_sb_1_csum(struct mdp_superblock_1 *sb)
>   static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_version)
>   {
>   	struct mdp_superblock_1 *sb;
> -	int ret;
> +	int ret = 0;
>   	sector_t sb_start;
>   	sector_t sectors;
>   	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
> @@ -1676,10 +1676,14 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
>   		ev1 = le64_to_cpu(sb->events);
>   		ev2 = le64_to_cpu(refsb->events);
>   
> -		if (ev1 > ev2)
> -			ret = 1;
> -		else
> -			ret = 0;
> +		/* Insist of good event counter while assembling, except for
> +		 * spares (which don't need an event count) */
> +		if (rdev->desc_nr >= 0 &&
> +		    rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
> +		    (le16_to_cpu(sb->dev_roles[rdev->desc_nr]) < MD_DISK_ROLE_MAX ||
> +		     le16_to_cpu(sb->dev_roles[rdev->desc_nr]) == MD_DISK_ROLE_JOURNAL))
> +			if (ev1 > ev2)
> +				ret = 1;
>   	}
>   	if (minor_version) {
>   		sectors = (i_size_read(rdev->bdev->bd_inode) >> 9);
