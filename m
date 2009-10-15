From: Rob Becker <Rob.Becker@riverbed.com>
Subject: Re: [PATCH] Improve MD/raid10 handling of correctable read errors.
Date: Thu, 15 Oct 2009 08:24:01 -0700
Message-ID: <BB9CF145-9831-48E4-AA5D-344A5676020D@riverbed.com>
References: <20091014182919.AFB5B59E9B9@snarf.localhost>
 <3dd505fc97e61da283ea90b7f0c71c52.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3dd505fc97e61da283ea90b7f0c71c52.squirrel@neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Rob Becker <Rob.Becker@riverbed.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

   Hi Neil,

   The approach sounds pretty good.  When I was considering whether to  
do rate tracking I originally opted to not, as from the case data I  
looked the slow rate correctable errors actually seem pretty rare.   
But your proposal is a pretty simple way to measure the rate and it  
makes a lot of sense to me.

   I'll rework the patch and resubmit.

   Thanks and sorry if I spammed the list with my initial patch, I had  
some issues getting my account registered and wasn't sure if it was  
working properly.

   Regards,
   Rob


On Oct 14, 2009, at 7:07 PM, NeilBrown wrote:

> On Wed, October 14, 2009 11:14 am, Rob Becker wrote:
>> We've noticed severe lasting performance degradation of our raid  
>> arrays
>> when we have drives that yield large amounts of media errors. The  
>> raid10
>> module will queue each failed read for retry, and also will attempt  
>> call
>> fix_read_error() to perform the read recovery.  Read recovery is  
>> performed
>> while the array is frozen, so repeated recovery attempts can  
>> degrade the
>> performance of the array for extended periods of time.
>>
>> With this patch I propose adding a per md device max number of  
>> corrected
>> read attempts.  Each rdev will maintain a count of read correction
>> attempts in the rdev->read_errors field (not used currently for  
>> raid10).
>> When we enter fix_read_error() we'll check the rdev associated with  
>> the
>> r10_bio and if it exceeds the read_error threshold, we'll fail the  
>> rdev.
>
> Thanks for this.  I think it is a very useful improvement.
>
> One thought though.  It is actually the 'rate' of read errors that is
> causing you a problem, where as you are measure the total number of
> read errors.  If these occurred once per day, it would not seem  
> appropriate
> to fail the device (though alerting the admin might be appropriate).
>
> Maybe we should keep a count of 'recent' read errors, which is decayed
> by halving it each hour.  Then when we get a read error we make sure  
> the
> 'recent' count is decayed properly and compare it against the maximum
> that has been set, and fail the device if it is too large.
>
> What do you think of that?
>
> NeilBrown
>
>>
>> In addition in this patch I add sysfs nodes (get/set) for the per md
>> max_read_errors attribute, the rdev->read_errors attribute, and  
>> added some
>> printk's to indicate when fix_read_error fails to repair an rdev.
>>
>> For testing I used debugfs->fail_make_request to inject IO errors  
>> to the
>> rdev while doing IO to the raid array.
>>
>> Steps to reproduce:
>> 1. create a 4 drive raid-10 array (md0 with rdev sd[abcd]2)
>> 2. set up fail_make_request to inject 2 errors with 100 probability  
>> to
>> /dev/sda
>> 3. use sg_dd iflag=direct if=/dev/md0 of=/dev/null bs=512 count=1
>> 4. verify that the IO is redirected to the other mirror, and the  
>> sector is
>> repaired.
>> 5. repeat the process MD will not fail the drive.
>>
>> with the changes above, when we hit 51 corrected read errors, md  
>> will fail
>> sda2.
>> ---
>> drivers/md/md.c     |   51 +++++++++++++++++++++++++++++++++++++++++ 
>> ++
>> drivers/md/md.h     |    4 +++
>> drivers/md/raid10.c |   60
>> ++++++++++++++++++++++++++++++++++++++++++++++++--
>> 3 files changed, 112 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 26ba42a..498b68c 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -68,6 +68,11 @@ static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
>> #define MD_BUG(x...) { printk("md: bug in file %s, line %d\n",  
>> __FILE__,
>> __LINE__); md_print_devices(); }
>>
>> /*
>> + * Default number of read corrections we'll attempt on an rdev
>> + * before ejecting it from the array.
>> + */
>> +#define MD_DEFAULT_MAX_CORRECTED_READ_ERRORS 50
>> +/*
>>  * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed  
>> limit'
>>  * is 1000 KB/sec, so the extra system load does not show up that  
>> much.
>>  * Increase it if you want to have more _guaranteed_ speed. Note that
>> @@ -2195,6 +2200,27 @@ static struct rdev_sysfs_entry rdev_errors =
>> __ATTR(errors, S_IRUGO|S_IWUSR, errors_show, errors_store);
>>
>> static ssize_t
>> +read_errors_show(mdk_rdev_t *rdev, char *page)
>> +{
>> +        return sprintf(page, "%d\n", atomic_read(&rdev- 
>> >read_errors));
>> +}
>> +
>> +static ssize_t
>> +read_errors_store(mdk_rdev_t *rdev, const char *buf, size_t len)
>> +{
>> +        char *e;
>> +        unsigned long n = simple_strtoul(buf, &e, 10);
>> +        if (*buf && (*e == 0 || *e == '\n')) {
>> +                atomic_set(&rdev->read_errors, n);
>> +                return len;
>> +        }
>> +        return -EINVAL;
>> +}
>> +
>> +static struct rdev_sysfs_entry rdev_read_errors =
>> +__ATTR(read_errors, S_IRUGO, read_errors_show, read_errors_store);
>> +
>> +static ssize_t
>> slot_show(mdk_rdev_t *rdev, char *page)
>> {
>> 	if (rdev->raid_disk < 0)
>> @@ -2427,6 +2453,7 @@ static struct attribute *rdev_default_attrs[]  
>> = {
>> 	&rdev_slot.attr,
>> 	&rdev_offset.attr,
>> 	&rdev_size.attr,
>> +	&rdev_read_errors.attr,
>> 	NULL,
>> };
>> static ssize_t
>> @@ -3144,6 +3171,27 @@ array_state_store(mddev_t *mddev, const char  
>> *buf,
>> size_t len)
>> static struct md_sysfs_entry md_array_state =
>> __ATTR(array_state, S_IRUGO|S_IWUSR, array_state_show,
>> array_state_store);
>>
>> +static ssize_t
>> +max_corrected_read_errors_show(mddev_t *mddev, char *page){
>> +        return sprintf(page, "%d\n",
>> atomic_read(&mddev->max_corrected_read_errors));
>> +}
>> +
>> +static ssize_t
>> +max_corrected_read_errors_store(mddev_t *mddev, const char *buf,  
>> size_t
>> len)
>> +{
>> +        char *e;
>> +        unsigned long n = simple_strtoul(buf, &e, 10);
>> +        if (*buf && (*e == 0 || *e == '\n')) {
>> +                atomic_set(&mddev->max_corrected_read_errors, n);
>> +                return len;
>> +        }
>> +        return -EINVAL;
>> +}
>> +
>> +static struct md_sysfs_entry max_corr_read_errors =
>> +__ATTR(max_read_errors, S_IRUGO|S_IWUSR,  
>> max_corrected_read_errors_show,
>> +       max_corrected_read_errors_store);
>> +
>> static ssize_t
>> null_show(mddev_t *mddev, char *page)
>> {
>> @@ -3769,6 +3817,7 @@ static struct attribute *md_default_attrs[] = {
>> 	&md_array_state.attr,
>> 	&md_reshape_position.attr,
>> 	&md_array_size.attr,
>> +	&max_corr_read_errors.attr,
>> 	NULL,
>> };
>>
>> @@ -4185,6 +4234,8 @@ static int do_md_run(mddev_t * mddev)
>> 		mddev->ro = 0;
>>
>>  	atomic_set(&mddev->writes_pending,0);
>> +        atomic_set(&mddev->max_corrected_read_errors,
>> +                   MD_DEFAULT_MAX_CORRECTED_READ_ERRORS);
>> 	mddev->safemode = 0;
>> 	mddev->safemode_timer.function = md_safemode_timeout;
>> 	mddev->safemode_timer.data = (unsigned long) mddev;
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index f184b69..526d1d9 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -290,6 +290,10 @@ struct mddev_s
>> 								* eventually be settable by sysfs.
>> 								*/
>>
>> +	atomic_t 			max_corrected_read_errors; /* per md device value
>> +								      indicating the maximum number of
>> +								      read retries on an rd */
>> +
>> 	struct list_head		all_mddevs;
>> };
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 51c4c5c..471b161 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1444,6 +1444,38 @@ static void fix_read_error(conf_t *conf,  
>> mddev_t
>> *mddev, r10bio_t *r10_bio)
>> 	int sect = 0; /* Offset from r10_bio->sector */
>> 	int sectors = r10_bio->sectors;
>> 	mdk_rdev_t*rdev;
>> +	int max_read_errors = atomic_read(&mddev- 
>> >max_corrected_read_errors);
>> +
>> +        rcu_read_lock();
>> +        {
>> +                int d = r10_bio->devs[r10_bio->read_slot].devnum;
>> +		unsigned int cur_read_error_count = 0;
>> +                char b[BDEVNAME_SIZE];
>> +
>> +                rdev = rcu_dereference(conf->mirrors[d].rdev);
>> +                atomic_inc(&rdev->read_errors);
>> +		bdevname(rdev->bdev, b);
>> +
>> +                cur_read_error_count = atomic_read(&rdev- 
>> >read_errors);
>> +		if (test_bit(Faulty, &rdev->flags)) {
>> +			rcu_read_unlock();
>> +			/* drive has already been failed, just ignore any
>> +			   more fix_read_error() attempts */
>> +			return;
>> +		}
>> +
>> +                if (cur_read_error_count > max_read_errors) {
>> +			rcu_read_unlock();
>> +                        printk (KERN_NOTICE "raid10:%s: Raid device
>> exceeded read_error threshold [cur %d:max %d]\n",
>> +                                b, cur_read_error_count,
>> max_read_errors);
>> +			printk (KERN_NOTICE "raid10:%s: Failing raid device\n", b);
>> +                        md_error(mddev, conf->mirrors[d].rdev);
>> +			return;
>> +                }
>> +
>> +        }
>> +        rcu_read_unlock();
>> +
>> 	while(sectors) {
>> 		int s = sectors;
>> 		int sl = r10_bio->read_slot;
>> @@ -1488,6 +1520,7 @@ static void fix_read_error(conf_t *conf,  
>> mddev_t
>> *mddev, r10bio_t *r10_bio)
>> 		/* write it back and re-read */
>> 		rcu_read_lock();
>> 		while (sl != r10_bio->read_slot) {
>> +			char b[BDEVNAME_SIZE];
>> 			int d;
>> 			if (sl==0)
>> 				sl = conf->copies;
>> @@ -1503,9 +1536,19 @@ static void fix_read_error(conf_t *conf,  
>> mddev_t
>> *mddev, r10bio_t *r10_bio)
>> 						 r10_bio->devs[sl].addr +
>> 						 sect + rdev->data_offset,
>> 						 s<<9, conf->tmppage, WRITE)
>> -				    == 0)
>> +				    == 0) {
>> 					/* Well, this device is dead */
>> +                                        printk(KERN_NOTICE
>> +                                               "raid10:%s: read
>> correction write failed"
>> +                                               " (%d sectors at  
>> %llu on
>> %s)\n",
>> +                                               mdname(mddev), s,
>> +                                               (unsigned long long) 
>> (sect+
>> +                                                    rdev- 
>> >data_offset),
>> +                                               bdevname(rdev- 
>> >bdev, b));
>> +                                        printk(KERN_NOTICE  
>> "raid10:%s:
>> failing drive\n",
>> +                                               bdevname(rdev- 
>> >bdev, b));
>> 					md_error(mddev, rdev);
>> +				}
>> 				rdev_dec_pending(rdev, mddev);
>> 				rcu_read_lock();
>> 			}
>> @@ -1526,10 +1569,20 @@ static void fix_read_error(conf_t *conf,  
>> mddev_t
>> *mddev, r10bio_t *r10_bio)
>> 				if (sync_page_io(rdev->bdev,
>> 						 r10_bio->devs[sl].addr +
>> 						 sect + rdev->data_offset,
>> -						 s<<9, conf->tmppage, READ) == 0)
>> +						 s<<9, conf->tmppage, READ) == 0) {
>> 					/* Well, this device is dead */
>> +					printk(KERN_NOTICE
>> +                                               "raid10:%s: unable  
>> to read
>> back corrected sectors"
>> +                                               " (%d sectors at  
>> %llu on
>> %s)\n",
>> +                                               mdname(mddev), s,
>> +                                               (unsigned long long) 
>> (sect+
>> +                                                    rdev- 
>> >data_offset),
>> +                                               bdevname(rdev- 
>> >bdev, b));
>> +					printk(KERN_NOTICE "raid10:%s: failing drive\n",
>> +					       bdevname(rdev->bdev, b));
>> +
>> 					md_error(mddev, rdev);
>> -				else
>> +				} else {
>> 					printk(KERN_INFO
>> 					       "raid10:%s: read error corrected"
>> 					       " (%d sectors at %llu on %s)\n",
>> @@ -1537,6 +1590,7 @@ static void fix_read_error(conf_t *conf,  
>> mddev_t
>> *mddev, r10bio_t *r10_bio)
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
>>
>

