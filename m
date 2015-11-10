From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 4/6] md-cluster: Defer MD reloading to mddev->thread
Date: Mon, 9 Nov 2015 21:26:37 -0600
Message-ID: <564163ED.9090709@suse.de>
References: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de>
 <1446781819-25571-4-git-send-email-rgoldwyn@suse.de>
 <87egfyspiu.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87egfyspiu.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids



On 11/09/2015 05:48 PM, NeilBrown wrote:
> On Fri, Nov 06 2015, rgoldwyn@suse.de wrote:
>
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> Reloading of superblock must be performed under reconfig_mutex. However,
>> this cannot be done with md_reload_sb because it would deadlock with
>> the message DLM lock. So, we defer it in md_check_recovery() which is
>> executed by mddev->thread.
>>
>> This introduces a new flag, MD_RELOAD_SB, which if set, will reload the
>> superblock.
>
> I can see no justification for good_device_nr being atomic_t - if you
> can explain what you were trying to achieve I could possible suggest why
> it isn't needed.

Yes, I think it does not need to be atomic.

>
> Also good_device_nr is directly related to MD_RELOAD_SB, so it makes
> sense to put them both in 'struct mddev' - that would save creating a
> new cluster_operation which does very little.

Agree here as well. I got too carried away in keeping cluster-md as 
isolated as possible.


>
> so: not applied.
>
> Thanks,
> NeilBrown
>
>
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>   drivers/md/md-cluster.c | 12 +++++++++++-
>>   drivers/md/md-cluster.h |  1 +
>>   drivers/md/md.c         |  3 +++
>>   drivers/md/md.h         |  3 +++
>>   4 files changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>> index a681706..9a36ad6 100644
>> --- a/drivers/md/md-cluster.c
>> +++ b/drivers/md/md-cluster.c
>> @@ -71,6 +71,7 @@ struct md_cluster_info {
>>   	struct md_thread *recv_thread;
>>   	struct completion newdisk_completion;
>>   	unsigned long state;
>> +	atomic_t good_device_nr;
>>   };
>>
>>   enum msg_type {
>> @@ -434,8 +435,10 @@ static void process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
>>   static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg)
>>   {
>>   	struct md_cluster_info *cinfo = mddev->cluster_info;
>> -	md_reload_sb(mddev, le32_to_cpu(msg->raid_slot));
>> +	atomic_set(&cinfo->good_device_nr, le32_to_cpu(msg->raid_slot));
>> +	set_bit(MD_RELOAD_SB, &mddev->flags);
>>   	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
>> +	md_wakeup_thread(mddev->thread);
>>   }
>>
>>   static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
>> @@ -1047,6 +1050,12 @@ out:
>>   	return err;
>>   }
>>
>> +static int good_device_nr(struct mddev *mddev)
>> +{
>> +	struct md_cluster_info *cinfo = mddev->cluster_info;
>> +	return atomic_read(&cinfo->good_device_nr);
>> +}
>> +
>>   static struct md_cluster_operations cluster_ops = {
>>   	.join   = join,
>>   	.leave  = leave,
>> @@ -1063,6 +1072,7 @@ static struct md_cluster_operations cluster_ops = {
>>   	.new_disk_ack = new_disk_ack,
>>   	.remove_disk = remove_disk,
>>   	.gather_bitmaps = gather_bitmaps,
>> +	.good_device_nr = good_device_nr,
>>   };
>>
>>   static int __init cluster_init(void)
>> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
>> index e75ea26..c699c6c 100644
>> --- a/drivers/md/md-cluster.h
>> +++ b/drivers/md/md-cluster.h
>> @@ -24,6 +24,7 @@ struct md_cluster_operations {
>>   	int (*new_disk_ack)(struct mddev *mddev, bool ack);
>>   	int (*remove_disk)(struct mddev *mddev, struct md_rdev *rdev);
>>   	int (*gather_bitmaps)(struct md_rdev *rdev);
>> +	int (*good_device_nr)(struct mddev *mddev);
>>   };
>>
>>   #endif /* _MD_CLUSTER_H */
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 32ca592..65b6326 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -8184,6 +8184,7 @@ void md_check_recovery(struct mddev *mddev)
>>   		(mddev->flags & MD_UPDATE_SB_FLAGS & ~ (1<<MD_CHANGE_PENDING)) ||
>>   		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
>>   		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
>> +		test_bit(MD_RELOAD_SB, &mddev->flags) ||
>>   		(mddev->external == 0 && mddev->safemode == 1) ||
>>   		(mddev->safemode == 2 && ! atomic_read(&mddev->writes_pending)
>>   		 && !mddev->in_sync && mddev->recovery_cp == MaxSector)
>> @@ -8232,6 +8233,8 @@ void md_check_recovery(struct mddev *mddev)
>>   						rdev->raid_disk < 0)
>>   					md_kick_rdev_from_array(rdev);
>>   			}
>> +			if (test_and_clear_bit(MD_RELOAD_SB, &mddev->flags))
>> +				md_reload_sb(mddev, md_cluster_ops->good_device_nr(mddev));
>>   		}
>>
>>   		if (!mddev->external) {
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index db54341..f89866d 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -222,6 +222,9 @@ struct mddev {
>>   #define MD_STILL_CLOSED	4	/* If set, then array has not been opened since
>>   				 * md_ioctl checked on it.
>>   				 */
>> +#define MD_RELOAD_SB	5	/* Reload the superblock because another node
>> +				 * updated it.
>> +				 */
>>
>>   	int				suspended;
>>   	atomic_t			active_io;
>> --
>> 1.8.5.6

-- 
Goldwyn
