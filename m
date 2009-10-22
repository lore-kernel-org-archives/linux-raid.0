From: Rob Becker <Rob.Becker@riverbed.com>
Subject: Re: [PATCH] raid: improve MD/raid10 handling of correctable read
 errors.
Date: Wed, 21 Oct 2009 18:55:07 -0700
Message-ID: <6C38FBEB-66DB-4EE2-86B9-794FD08B17FF@riverbed.com>
References: <200910162047.n9GKli8F019956@oembuild64.lab.nbttech.com>
 <19167.44913.912890.407650@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19167.44913.912890.407650@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Rob Becker <Rob.Becker@riverbed.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

   Hey Neil,

    That sounds great.  I made the rdev->read_errors sysfs look like  
the rdev->corrected_errors attribute, which is also settable.  I would  
agree that there would be little need to set those values.

    As for the read_errors sysfs attribute itself, the it would be  
nice to have, as i would like to have that information handy when  
problems occur, so I could collect information from each rdev about  
the how close it is getting to the threshold and use that information  
to determine a better value for the maximum number of allowed read  
errors.

   I'll check out the md-scratch tree and resubmit if you agree.

   Thanks again for looking at this.

   Regards,
   Rob


On Oct 21, 2009, at 6:03 PM, Neil Brown wrote:

> On Friday October 16, Rob.Becker@riverbed.com wrote:
>> We've noticed severe lasting performance degradation of our raid
>> arrays when we have drives that yield large amounts of media errors.
>> The raid10 module will queue each failed read for retry, and also
>> will attempt call fix_read_error() to perform the read recovery.
>> Read recovery is performed while the array is frozen, so repeated
>> recovery attempts can degrade the performance of the array for
>> extended periods of time.
>>
>> With this patch I propose adding a per md device max number of
>> corrected read attempts.  Each rdev will maintain a count of
>> read correction attempts in the rdev->read_errors field (not
>> used currently for raid10). When we enter fix_read_error()
>> we'll check to see when the last read error occurred, and
>> divide the read error count by 2 for every hour since the
>> last read error. If at that point our read error count
>> exceeds the read error threshold, we'll fail the raid device.
>>
>> In addition in this patch I add sysfs nodes (get/set) for
>> the per md max_read_errors attribute, the rdev->read_errors
>> attribute, and added some printk's to indicate when
>> fix_read_error fails to repair an rdev.
>
> Thanks for this.
> I've split the "added some printk's" out into a separate patch as it
> really is an independent change.
> I've also removed the code that provides sysfs access to
> rdev->read_errors because I'm not convinced that it is needed
> (certainly not setting it) and the name isn't really an accurate
> description of the attribute (maybe 'recent_read_errors' .... or
> something).
>
> The rest I have added to my queue for 2.6.33.  You can see this in my
> 'md-scratch' branch at git://neil.brown.name/md, or at
>   http://neil.brown.name/git?p=md;a=shortlog;h=refs/heads/md-scratch
>
> I'm happy to listen to arguments for 'rdev->read_errors' to be
> exported via sysfs, with a more suitable name.
>
> Thanks,
> NeilBrown
>
>
>>
>> For testing I used debugfs->fail_make_request to inject
>> IO errors to the rdev while doing IO to the raid array.
>>
>> Signed-off-by: Robert Becker <Rob.Becker@riverbed.com>
>> ---
>> drivers/md/md.c     |   57 +++++++++++++++++++++++++++
>> drivers/md/md.h     |    5 ++-
>> drivers/md/raid10.c |  106 +++++++++++++++++++++++++++++++++++++++++ 
>> ++++++++-
>> 3 files changed, 164 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 641b211..1a837fa 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -68,6 +68,12 @@ static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
>> #define MD_BUG(x...) { printk("md: bug in file %s, line %d\n",  
>> __FILE__, __LINE__); md_print_devices(); }
>>
>> /*
>> + * Default number of read corrections we'll attempt on an rdev
>> + * before ejecting it from the array. We divide the read error
>> + * count by 2 for every hour elapsed between read errors.
>> + */
>> +#define MD_DEFAULT_MAX_CORRECTED_READ_ERRORS 20
>> +/*
>>  * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed  
>> limit'
>>  * is 1000 KB/sec, so the extra system load does not show up that  
>> much.
>>  * Increase it if you want to have more _guaranteed_ speed. Note that
>> @@ -2156,6 +2162,28 @@ static struct rdev_sysfs_entry rdev_errors =
>> __ATTR(errors, S_IRUGO|S_IWUSR, errors_show, errors_store);
>>
>> static ssize_t
>> +read_errors_show(mdk_rdev_t *rdev, char *page)
>> +{
>> +	return sprintf(page, "%d\n", atomic_read(&rdev->read_errors));
>> +}
>> +
>> +static ssize_t
>> +read_errors_store(mdk_rdev_t *rdev, const char *buf, size_t len)
>> +{
>> +	char *e;
>> +	unsigned long n = simple_strtoul(buf, &e, 10);
>> +
>> +	if (*buf && (*e == 0 || *e == '\n')) {
>> +		atomic_set(&rdev->read_errors, n);
>> +		return len;
>> +	}
>> +	return -EINVAL;
>> +}
>> +
>> +static struct rdev_sysfs_entry rdev_read_errors =
>> +__ATTR(read_errors, S_IRUGO, read_errors_show, read_errors_store);
>> +
>> +static ssize_t
>> slot_show(mdk_rdev_t *rdev, char *page)
>> {
>> 	if (rdev->raid_disk < 0)
>> @@ -2388,6 +2416,7 @@ static struct attribute *rdev_default_attrs[]  
>> = {
>> 	&rdev_slot.attr,
>> 	&rdev_offset.attr,
>> 	&rdev_size.attr,
>> +	&rdev_read_errors.attr,
>> 	NULL,
>> };
>> static ssize_t
>> @@ -2489,6 +2518,8 @@ static mdk_rdev_t *md_import_device(dev_t  
>> newdev, int super_format, int super_mi
>> 	rdev->flags = 0;
>> 	rdev->data_offset = 0;
>> 	rdev->sb_events = 0;
>> +	rdev->last_read_error.tv_sec  = 0;
>> +	rdev->last_read_error.tv_nsec = 0;
>> 	atomic_set(&rdev->nr_pending, 0);
>> 	atomic_set(&rdev->read_errors, 0);
>> 	atomic_set(&rdev->corrected_errors, 0);
>> @@ -3101,6 +3132,29 @@ static struct md_sysfs_entry md_array_state =
>> __ATTR(array_state, S_IRUGO|S_IWUSR, array_state_show,  
>> array_state_store);
>>
>> static ssize_t
>> +max_corrected_read_errors_show(mddev_t *mddev, char *page) {
>> +	return sprintf(page, "%d\n",
>> +		       atomic_read(&mddev->max_corr_read_errors));
>> +}
>> +
>> +static ssize_t
>> +max_corrected_read_errors_store(mddev_t *mddev, const char *buf,  
>> size_t len)
>> +{
>> +	char *e;
>> +	unsigned long n = simple_strtoul(buf, &e, 10);
>> +
>> +	if (*buf && (*e == 0 || *e == '\n')) {
>> +		atomic_set(&mddev->max_corr_read_errors, n);
>> +		return len;
>> +	}
>> +	return -EINVAL;
>> +}
>> +
>> +static struct md_sysfs_entry max_corr_read_errors =
>> +__ATTR(max_read_errors, S_IRUGO|S_IWUSR,  
>> max_corrected_read_errors_show,
>> +	max_corrected_read_errors_store);
>> +
>> +static ssize_t
>> null_show(mddev_t *mddev, char *page)
>> {
>> 	return -EINVAL;
>> @@ -3729,6 +3783,7 @@ static struct attribute *md_default_attrs[] = {
>> 	&md_array_state.attr,
>> 	&md_reshape_position.attr,
>> 	&md_array_size.attr,
>> +	&max_corr_read_errors.attr,
>> 	NULL,
>> };
>>
>> @@ -4183,6 +4238,8 @@ static int do_md_run(mddev_t * mddev)
>> 		mddev->ro = 0;
>>
>>  	atomic_set(&mddev->writes_pending,0);
>> +	atomic_set(&mddev->max_corr_read_errors,
>> +		   MD_DEFAULT_MAX_CORRECTED_READ_ERRORS);
>> 	mddev->safemode = 0;
>> 	mddev->safemode_timer.function = md_safemode_timeout;
>> 	mddev->safemode_timer.data = (unsigned long) mddev;
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 8227ab9..9dcfc67 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -104,6 +104,9 @@ struct mdk_rdev_s
>> 	atomic_t	read_errors;	/* number of consecutive read errors that
>> 					 * we have tried to ignore.
>> 					 */
>> +	struct timespec last_read_error;	/* monotonic time since our
>> +						 * last read error
>> +						 */
>> 	atomic_t	corrected_errors; /* number of corrected read errors,
>> 					   * for reporting to userspace and storing
>> 					   * in superblock.
>> @@ -285,7 +288,7 @@ struct mddev_s
>> 								* hot-adding a bitmap.  It should
>> 								* eventually be settable by sysfs.
>> 								*/
>> -
>> +	atomic_t 			max_corr_read_errors; /* max read retries */
>> 	struct list_head		all_mddevs;
>> };
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 499620a..791edb8 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1427,6 +1427,43 @@ static void recovery_request_write(mddev_t  
>> *mddev, r10bio_t *r10_bio)
>>
>>
>> /*
>> + * Used by fix_read_error() to decay the per rdev read_errors.
>> + * We halve the read error count for every hour that has elapsed
>> + * since the last recorded read error.
>> + *
>> + */
>> +static void check_decay_read_errors(mddev_t *mddev, mdk_rdev_t  
>> *rdev)
>> +{
>> +	struct timespec cur_time_mon;
>> +	unsigned long hours_since_last;
>> +	unsigned int read_errors = atomic_read(&rdev->read_errors);
>> +
>> +	ktime_get_ts(&cur_time_mon);
>> +
>> +	if (rdev->last_read_error.tv_sec == 0 &&
>> +	    rdev->last_read_error.tv_nsec == 0) {
>> +		/* first time we've seen a read error */
>> +		rdev->last_read_error = cur_time_mon;
>> +		return;
>> +	}
>> +
>> +	hours_since_last = (cur_time_mon.tv_sec -
>> +			    rdev->last_read_error.tv_sec) / 3600;
>> +
>> +	rdev->last_read_error = cur_time_mon;
>> +
>> +	/*
>> +	 * if hours_since_last is > the number of bits in read_errors
>> +	 * just set read errors to 0. We do this to avoid
>> +	 * overflowing the shift of read_errors by hours_since_last.
>> +	 */
>> +	if (hours_since_last >= 8 * sizeof(read_errors))
>> +		atomic_set(&rdev->read_errors, 0);
>> +	else
>> +		atomic_set(&rdev->read_errors, read_errors >> hours_since_last);
>> +}
>> +
>> +/*
>>  * This is a kernel thread which:
>>  *
>>  *	1.	Retries failed read operations on working mirrors.
>> @@ -1439,6 +1476,43 @@ static void fix_read_error(conf_t *conf,  
>> mddev_t *mddev, r10bio_t *r10_bio)
>> 	int sect = 0; /* Offset from r10_bio->sector */
>> 	int sectors = r10_bio->sectors;
>> 	mdk_rdev_t*rdev;
>> +	int max_read_errors = atomic_read(&mddev->max_corr_read_errors);
>> +
>> +	rcu_read_lock();
>> +	{
>> +		int d = r10_bio->devs[r10_bio->read_slot].devnum;
>> +		char b[BDEVNAME_SIZE];
>> +		int cur_read_error_count = 0;
>> +
>> +		rdev = rcu_dereference(conf->mirrors[d].rdev);
>> +		bdevname(rdev->bdev, b);
>> +
>> +		if (test_bit(Faulty, &rdev->flags)) {
>> +			rcu_read_unlock();
>> +			/* drive has already been failed, just ignore any
>> +			   more fix_read_error() attempts */
>> +			return;
>> +		}
>> +
>> +		check_decay_read_errors(mddev, rdev);
>> +		atomic_inc(&rdev->read_errors);
>> +		cur_read_error_count = atomic_read(&rdev->read_errors);
>> +		if (cur_read_error_count > max_read_errors) {
>> +			rcu_read_unlock();
>> +			printk(KERN_NOTICE
>> +			       "raid10: %s: Raid device exceeded "
>> +			       "read_error threshold "
>> +			       "[cur %d:max %d]\n",
>> +			       b, cur_read_error_count, max_read_errors);
>> +			printk(KERN_NOTICE
>> +			       "raid10: %s: Failing raid "
>> +			       "device\n", b);
>> +			md_error(mddev, conf->mirrors[d].rdev);
>> +			return;
>> +		}
>> +	}
>> +	rcu_read_unlock();
>> +
>> 	while(sectors) {
>> 		int s = sectors;
>> 		int sl = r10_bio->read_slot;
>> @@ -1483,6 +1557,7 @@ static void fix_read_error(conf_t *conf,  
>> mddev_t *mddev, r10bio_t *r10_bio)
>> 		/* write it back and re-read */
>> 		rcu_read_lock();
>> 		while (sl != r10_bio->read_slot) {
>> +			char b[BDEVNAME_SIZE];
>> 			int d;
>> 			if (sl==0)
>> 				sl = conf->copies;
>> @@ -1498,9 +1573,21 @@ static void fix_read_error(conf_t *conf,  
>> mddev_t *mddev, r10bio_t *r10_bio)
>> 						 r10_bio->devs[sl].addr +
>> 						 sect + rdev->data_offset,
>> 						 s<<9, conf->tmppage, WRITE)
>> -				    == 0)
>> +				    == 0) {
>> 					/* Well, this device is dead */
>> +					printk(KERN_NOTICE
>> +					       "raid10:%s: read correction "
>> +					       "write failed"
>> +					       " (%d sectors at %llu on %s)\n",
>> +					       mdname(mddev), s,
>> +					       (unsigned long long)(sect+
>> +					       rdev->data_offset),
>> +					       bdevname(rdev->bdev, b));
>> +					printk(KERN_NOTICE "raid10:%s: failing "
>> +					       "drive\n",
>> +					       bdevname(rdev->bdev, b));
>> 					md_error(mddev, rdev);
>> +				}
>> 				rdev_dec_pending(rdev, mddev);
>> 				rcu_read_lock();
>> 			}
>> @@ -1521,10 +1608,22 @@ static void fix_read_error(conf_t *conf,  
>> mddev_t *mddev, r10bio_t *r10_bio)
>> 				if (sync_page_io(rdev->bdev,
>> 						 r10_bio->devs[sl].addr +
>> 						 sect + rdev->data_offset,
>> -						 s<<9, conf->tmppage, READ) == 0)
>> +						 s<<9, conf->tmppage,
>> +						 READ) == 0) {
>> 					/* Well, this device is dead */
>> +					printk(KERN_NOTICE
>> +					       "raid10:%s: unable to read back "
>> +					       "corrected sectors"
>> +					       " (%d sectors at %llu on %s)\n",
>> +					       mdname(mddev), s,
>> +					       (unsigned long long)(sect+
>> +						    rdev->data_offset),
>> +					       bdevname(rdev->bdev, b));
>> +					printk(KERN_NOTICE "raid10:%s: failing drive\n",
>> +					       bdevname(rdev->bdev, b));
>> +
>> 					md_error(mddev, rdev);
>> -				else
>> +				} else {
>> 					printk(KERN_INFO
>> 					       "raid10:%s: read error corrected"
>> 					       " (%d sectors at %llu on %s)\n",
>> @@ -1532,6 +1631,7 @@ static void fix_read_error(conf_t *conf,  
>> mddev_t *mddev, r10bio_t *r10_bio)
>> 					       (unsigned long long)(sect+
>> 					            rdev->data_offset),
>> 					       bdevname(rdev->bdev, b));
>> +				}
>>
>> 				rdev_dec_pending(rdev, mddev);
>> 				rcu_read_lock();
>> -- 
>> 1.5.6.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

