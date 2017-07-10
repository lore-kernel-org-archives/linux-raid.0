From: Shaohua Li <shli@kernel.org>
Subject: Re: [MD PATCH 1/1 -v2] Raid5 should update rdev->sectors after
 reshape
Date: Mon, 10 Jul 2017 10:43:30 -0700
Message-ID: <20170710174330.avznqdpakf4guiec@kernel.org>
References: <1499247244-4483-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1499247244-4483-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, tbskyd@gmail.com, gqjiang@suse.com
List-Id: linux-raid.ids

On Wed, Jul 05, 2017 at 05:34:04PM +0800, Xiao Ni wrote:
> The raid5 md device is created by the disks which we don't use the total size. For example,
> the size of the device is 5G and it just uses 3G of the devices to create one raid5 device.
> Then change the chunksize and wait reshape to finish. After reshape finishing stop the raid
> and assemble it again. It fails.
> mdadm -CR /dev/md0 -l5 -n3 /dev/loop[0-2] --size=3G --chunk=32 --assume-clean
> mdadm /dev/md0 --grow --chunk=64
> wait reshape to finish
> mdadm -S /dev/md0
> mdadm -As
> The error messages:
> [197519.814302] md: loop1 does not have a valid v1.2 superblock, not importing!
> [197519.821686] md: md_import_device returned -22
> 
> After reshape the data offset is changed. It selects backwards direction in this condition.
> In function super_1_load it compares the available space of the underlying device with
> sb->data_size. The new data offset gets bigger after reshape. So super_1_load returns -EINVAL.
> rdev->sectors is updated in md_finish_reshape. Then sb->data_size is set in super_1_sync based
> on rdev->sectors. So add md_finish_reshape in end_reshape.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>

Applied, thanks! Will add to stable too.

Can you also add the test to mdadm test suite?

> ---
>  drivers/md/raid5.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ec0f951..e7f527c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7947,12 +7947,10 @@ static void end_reshape(struct r5conf *conf)
>  {
>  
>  	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
> -		struct md_rdev *rdev;
>  
>  		spin_lock_irq(&conf->device_lock);
>  		conf->previous_raid_disks = conf->raid_disks;
> -		rdev_for_each(rdev, conf->mddev)
> -			rdev->data_offset = rdev->new_data_offset;
> +		md_finish_reshape(conf->mddev);
>  		smp_wmb();
>  		conf->reshape_progress = MaxSector;
>  		conf->mddev->reshape_position = MaxSector;
> -- 
> 2.7.4
> 
