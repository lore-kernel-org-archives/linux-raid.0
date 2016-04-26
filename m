From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH V2 08/13] md: set MD_CHANGE_PENDING in a spinlocked region
Date: Tue, 26 Apr 2016 11:19:01 +0800
Message-ID: <571EDE25.8030305@suse.com>
References: <1461218294-4960-9-git-send-email-gqjiang@suse.com>
 <1461221895-20688-1-git-send-email-gqjiang@suse.com>
 <20160425173201.GA11993@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160425173201.GA11993@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/26/2016 01:32 AM, Shaohua Li wrote:
> On Thu, Apr 21, 2016 at 02:58:15PM +0800, Guoqing Jiang wrote:
>> Some code waits for a metadata update by:
>>
>> 1. flagging that it is needed (MD_CHANGE_DEVS or MD_CHANGE_CLEAN)
>> 2. setting MD_CHANGE_PENDING and waking the management thread
>> 3. waiting for MD_CHANGE_PENDING to be cleared
>>
>> If the first two are done without locking, the code in md_update_sb()
>> which checks if it needs to repeat might test if an update is needed
>> before step 1, then clear MD_CHANGE_PENDING after step 2, resulting
>> in the wait returning early.
>>
>> So make sure all places that set MD_CHANGE_PENDING are protected by
>> mddev->lock.
>>
>> Reviewed-by: NeilBrown <neilb@suse.com>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>> Changes:
>> 1. s/write_lock/lock which is reported by auto build
>>
>>   drivers/md/md.c          | 22 +++++++++++++++++-----
>>   drivers/md/raid1.c       |  2 ++
>>   drivers/md/raid10.c      |  6 +++++-
>>   drivers/md/raid5-cache.c |  2 ++
>>   drivers/md/raid5.c       |  2 ++
>>   5 files changed, 28 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index bf2b74d..e74657e 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -2293,12 +2293,18 @@ repeat:
>>   	if (mddev_is_clustered(mddev)) {
>>   		if (test_and_clear_bit(MD_CHANGE_DEVS, &mddev->flags))
>>   			force_change = 1;
>> +		if (test_and_clear_bit(MD_CHANGE_CLEAN, &mddev->flags))
>> +			nospares = 1;
>>   		ret = md_cluster_ops->metadata_update_start(mddev);
>>   		/* Has someone else has updated the sb */
>>   		if (!does_sb_need_changing(mddev)) {
>>   			if (ret == 0)
>>   				md_cluster_ops->metadata_update_cancel(mddev);
>> -			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
>> +			spin_lock(&mddev->lock);
>> +			if (!test_bit(MD_CHANGE_DEVS, &mddev->flags) &&
>> +			    !test_bit(MD_CHANGE_CLEAN, &mddev->flags))
>> +				clear_bit(MD_CHANGE_PENDING, &mddev->flags);
>> +			spin_unlock(&mddev->lock);
>>   			return;
>>   		}
>>   	}
>> @@ -2434,7 +2440,8 @@ repeat:
>>   
>>   	spin_lock(&mddev->lock);
>>   	if (mddev->in_sync != sync_req ||
>> -	    test_bit(MD_CHANGE_DEVS, &mddev->flags)) {
>> +	    test_bit(MD_CHANGE_DEVS, &mddev->flags) ||
>> +	    test_bit(MD_CHANGE_CLEAN, &mddev->flags)) {
>>   		/* have to write it out again */
>>   		spin_unlock(&mddev->lock);
>>   		goto repeat;
>> @@ -8145,18 +8152,20 @@ void md_do_sync(struct md_thread *thread)
>>   		}
>>   	}
>>    skip:
>> -	set_bit(MD_CHANGE_DEVS, &mddev->flags);
>> -
>>   	if (mddev_is_clustered(mddev) &&
>>   	    ret == 0) {
>>   		/* set CHANGE_PENDING here since maybe another
>>   		 * update is needed, so other nodes are informed */
>> +		spin_lock(&mddev->lock);
>> +		set_bit(MD_CHANGE_DEVS, &mddev->flags);
>>   		set_bit(MD_CHANGE_PENDING, &mddev->flags);
>> +		spin_unlock(&mddev->lock);
>>   		md_wakeup_thread(mddev->thread);
>>   		wait_event(mddev->sb_wait,
>>   			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
>>   		md_cluster_ops->resync_finish(mddev);
>> -	}
>> +	} else
>> +		set_bit(MD_CHANGE_DEVS, &mddev->flags);
>>   
>>   	spin_lock(&mddev->lock);
>>   	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>> @@ -8548,6 +8557,7 @@ EXPORT_SYMBOL(md_finish_reshape);
>>   int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
>>   		       int is_new)
>>   {
>> +	struct mddev *mddev = rdev->mddev;
>>   	int rv;
>>   	if (is_new)
>>   		s += rdev->new_data_offset;
>> @@ -8557,8 +8567,10 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
>>   	if (rv == 0) {
>>   		/* Make sure they get written out promptly */
>>   		sysfs_notify_dirent_safe(rdev->sysfs_state);
>> +		spin_lock(&mddev->lock);
>>   		set_bit(MD_CHANGE_CLEAN, &rdev->mddev->flags);
>>   		set_bit(MD_CHANGE_PENDING, &rdev->mddev->flags);
>> +		spin_unlock(&mddev->lock);
>>   		md_wakeup_thread(rdev->mddev->thread);
>>   		return 1;
>>   	} else
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index a7f2b9c..985fa07 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1474,8 +1474,10 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>   	 * if recovery is running, make sure it aborts.
>>   	 */
>>   	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>> +	spin_lock(&mddev->lock);
>>   	set_bit(MD_CHANGE_DEVS, &mddev->flags);
>>   	set_bit(MD_CHANGE_PENDING, &mddev->flags);
>> +	spin_unlock(&mddev->lock);
>>   	printk(KERN_ALERT
>>   	       "md/raid1:%s: Disk failure on %s, disabling device.\n"
>>   	       "md/raid1:%s: Operation continuing on %d devices.\n",
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index e3fd725..98a4cf1 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1102,8 +1102,10 @@ static void __make_request(struct mddev *mddev, struct bio *bio)
>>   		bio->bi_iter.bi_sector < conf->reshape_progress))) {
>>   		/* Need to update reshape_position in metadata */
>>   		mddev->reshape_position = conf->reshape_progress;
>> +		spin_lock(&mddev->lock);
>>   		set_bit(MD_CHANGE_DEVS, &mddev->flags);
>>   		set_bit(MD_CHANGE_PENDING, &mddev->flags);
>> +		spin_unlock(&mddev->lock);
>>   		md_wakeup_thread(mddev->thread);
>>   		wait_event(mddev->sb_wait,
>>   			   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
>> @@ -1585,15 +1587,17 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>>   	}
>>   	if (test_and_clear_bit(In_sync, &rdev->flags))
>>   		mddev->degraded++;
>> +	spin_unlock_irqrestore(&conf->device_lock, flags);
>>   	/*
>>   	 * If recovery is running, make sure it aborts.
>>   	 */
>>   	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>   	set_bit(Blocked, &rdev->flags);
>>   	set_bit(Faulty, &rdev->flags);
>> +	spin_lock(&mddev->lock);
>>   	set_bit(MD_CHANGE_DEVS, &mddev->flags);
>>   	set_bit(MD_CHANGE_PENDING, &mddev->flags);
>> -	spin_unlock_irqrestore(&conf->device_lock, flags);
>> +	spin_unlock(&mddev->lock);
>>   	printk(KERN_ALERT
>>   	       "md/raid10:%s: Disk failure on %s, disabling device.\n"
>>   	       "md/raid10:%s: Operation continuing on %d devices.\n",
>> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
>> index 9531f5f..2ba9366 100644
>> --- a/drivers/md/raid5-cache.c
>> +++ b/drivers/md/raid5-cache.c
>> @@ -712,8 +712,10 @@ static void r5l_write_super_and_discard_space(struct r5l_log *log,
>>   	 * in_teardown check workaround this issue.
>>   	 */
>>   	if (!log->in_teardown) {
>> +		spin_lock(&mddev->lock);
>>   		set_bit(MD_CHANGE_DEVS, &mddev->flags);
>>   		set_bit(MD_CHANGE_PENDING, &mddev->flags);
>> +		spin_unlock(&mddev->lock);
>>   		md_wakeup_thread(mddev->thread);
>>   		wait_event(mddev->sb_wait,
>>   			!test_bit(MD_CHANGE_PENDING, &mddev->flags) ||
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 8ab8b65..d4a1e37 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -2514,8 +2514,10 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
>>   
>>   	set_bit(Blocked, &rdev->flags);
>>   	set_bit(Faulty, &rdev->flags);
>> +	spin_lock(&mddev->lock);
>>   	set_bit(MD_CHANGE_DEVS, &mddev->flags);
>>   	set_bit(MD_CHANGE_PENDING, &mddev->flags);
>> +	spin_unlock(&mddev->lock);
>>   	printk(KERN_ALERT
>>   	       "md/raid:%s: Disk failure on %s, disabling device.\n"
>>   	       "md/raid:%s: Operation continuing on %d devices.\n",
> The .error_handler is called by md_error, called by .bio_endio, which is called
> in softirq. So the lock should be hold with irq disabled.

Thanks, I will change them to spin_lock_irqsave/restore.

Thanks,
Guoqing
