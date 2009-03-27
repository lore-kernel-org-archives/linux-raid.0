From: "NeilBrown" <neilb@suse.de>
Subject: Re: [md PATCH 5/6] md: allow number of drives in raid5 to be
     reduced
Date: Sat, 28 Mar 2009 06:39:43 +1100 (EST)
Message-ID: <cbc6f987b12110745c531d111144ed83.squirrel@neil.brown.name>
References: <20090324084629.15383.10271.stgit@notabene.brown>
    <20090324085332.15383.76701.stgit@notabene.brown>
    <20090327161942.GR17185@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090327161942.GR17185@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, March 28, 2009 3:19 am, Andre Noll wrote:
> On 19:53, NeilBrown wrote:
>
>> Never allow the size to be reduced below the minimum (4 doe raid6,
>> 3 otherwise).
>
> doe?

Left hand was one column too far left. d->f e->r.
Fixed.

>
>> @@ -3723,6 +3723,7 @@ static sector_t reshape_request(mddev_t *mddev,
>> sector_t sector_nr, int *skipped
>>  	int i;
>>  	int dd_idx;
>>  	sector_t writepos, safepos, gap;
>> +	sector_t stripe_addr;
>>
>>  	if (sector_nr == 0) {
>>  		/* If restarting in the middle, skip the initial sectors */
>> @@ -3779,10 +3780,21 @@ static sector_t reshape_request(mddev_t *mddev,
>> sector_t sector_nr, int *skipped
>>  		wake_up(&conf->wait_for_overlap);
>>  	}
>>
>> +	if (mddev->delta_disks < 0) {
>> +		BUG_ON(conf->reshape_progress == 0);
>> +		stripe_addr = writepos;
>> +		BUG_ON((mddev->dev_sectors &
>> +			~((sector_t)mddev->chunk_size / 512 - 1))
>> +		       - (conf->chunk_size / 512) - stripe_addr
>> +		       != sector_nr);
>> +	} else {
>> +		BUG_ON(writepos != sector_nr + conf->chunk_size / 512);
>> +		stripe_addr = writepos;
>> +	}
>
> What's the point of the new stripe_addr variable? Isn't it equal to
> writepos in any case?

Yes, but it shouldn't be.  In the second branch of the if, it should be
    stripe_addr = sector_nr;
as I discovered yesterday while testing.


>
>> @@ -4738,14 +4755,25 @@ static int raid5_check_reshape(mddev_t *mddev)
>>  	raid5_conf_t *conf = mddev_to_conf(mddev);
>>  	int err;
>>
>> -	if (mddev->delta_disks < 0 ||
>> -	    mddev->new_level != mddev->level)
>> -		return -EINVAL; /* Cannot shrink array or change level yet */
>>  	if (mddev->delta_disks == 0)
>>  		return 0; /* nothing to do */
>>  	if (mddev->bitmap)
>>  		/* Cannot grow a bitmap yet */
>>  		return -EBUSY;
>> +	if (mddev->degraded > conf->max_degraded)
>> +		return -EINVAL;
>> +	if (mddev->delta_disks < 0) {
>> +		/* We might be able to shrink, but the devices must
>> +		 * be made bigger first.
>> +		 * For raid6, 4 is the minimum size.
>> +		 * Otherwise 2 is the minimum
>> +		 */
>> +		int min = 2;
>> +		if (mddev->level == 6)
>> +			min = 4;
>> +		if (mddev->raid_disks + mddev->delta_disks < min)
>> +			return -EINVAL;
>> +	}
>
> Hm, this code doesn't seem to do what the comment suggests. IMHO,
> we must check that
>
> 	(a) (raid_disks + delta_disks) * sizeof(smallest) is big enough
> and
> 	(b) raid_disks + delta_disks >= minimal admissible number of disks
>
> The comment says the devices must be made bigger (to satisfy (a))
> but the code only checks (b).

Yes, the comment could probably be improved.
The check for 'a' happens later when start_reshape is called.

>
>> @@ -4862,21 +4905,38 @@ static void raid5_finish_reshape(mddev_t *mddev)
>>  	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>>
>>  		conf->previous_raid_disks = conf->raid_disks;
>> -		md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
>> -		set_capacity(mddev->gendisk, mddev->array_sectors);
>> -		mddev->changed = 1;
>> -
>> -		bdev = bdget_disk(mddev->gendisk, 0);
>> -		if (bdev) {
>> -			mutex_lock(&bdev->bd_inode->i_mutex);
>> -			i_size_write(bdev->bd_inode,
>> -				     (loff_t)mddev->array_sectors << 9);
>> -			mutex_unlock(&bdev->bd_inode->i_mutex);
>> -			bdput(bdev);
>> -		}
>>  		spin_lock_irq(&conf->device_lock);
>>  		conf->reshape_progress = MaxSector;
>>  		spin_unlock_irq(&conf->device_lock);
>> +		if (mddev->delta_disks > 0) {
>> +			conf->previous_raid_disks = conf->raid_disks;
>
> previous_raid_disks was already assigned earlier, so this can go away,
> imo.

Thanks.  It is actually the first one that needs to go.
The 'else' branch of that 'if' needs to have access to the
original value of previous_raid_disks.

Thanks a lot for the review.

NeilBrown

