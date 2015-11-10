From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 1/6] md-cluster: Protect communication with mutexes
Date: Mon, 9 Nov 2015 21:23:11 -0600
Message-ID: <5641631F.2080000@suse.de>
References: <1446781819-25571-1-git-send-email-rgoldwyn@suse.de>
 <87mvumsqbp.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87mvumsqbp.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids



On 11/09/2015 05:31 PM, NeilBrown wrote:
> On Fri, Nov 06 2015, rgoldwyn@suse.de wrote:
>
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> Communication can happen through multiple threads. It is possible that
>> one thread steps over another threads sequence. So, we use mutexes to
>> protect both the send and receive sequences.
>>
>> We use a new flag CLUSTER_MD_COMM_LOCKED which is used to detect
>> if communication is already locked. This is useful for cases where we need to
>> take and hold the token DLM lock for a while. This bit is set only
>> after locking communication.
>
> I don't understand what this flag is trying to achieve, but I'm fairly
> sure it doesn't achieve it.

Lets consider three specific cases of locking communication channels to 
show the conflict:

1. resync_info_update(): communication is locked and release for sending 
a message.
2. A regular md_update_sb(): communication is locked in 
metadata_update_start() and unlocked in metadata_update_finish() after 
writing to disk. In metadata_update_finish(), the sendmsg is called to 
send METADATA_UPDATED.
3. An add operation which culminates in a md_update_sb(): Here the 
communication is locked before initiating add. If the add is successful, 
it results in md_update_sb(). In md_update_sb(), metadata_update_start() 
has to check if the communication is already locked. If locked, it 
should not lock again.

The flag is used only for case 3. If the communication is already 
locked, it should not lock again. This flag is set only after 
lock_comm() has executed, but is checked for in metadata_update_start(). 
This should insure that any of the operations 1, 2 or 3 do not interfere 
with each other.

I am not sure if I have made the best effort to explain this. I had a 
tough time getting it right (which may or may not be complete).

>
> Maybe if it was test_and_set_bit in metadata_update_start, it might make
> sense.  But then I would suggest that clearing the bit be moved to
> unlock_comm()
>
> Do you just want to use mutex_try_lock() to detect if communication is
> already locked?

Consider a race between md_update_sb() and sendmsg() [Case 1. and 2]

mutex_try_lock() may not work in this situation because lock_comm() 
could have been called by sendmsg(), which will release it as soon as 
the message is sent. In the meantime (while the lock is locked), if a 
metadata_update_sb() operation executes. It will not relock the 
communication. This will result in the WARN_ON in unlock_comm() since 
sendmsg() sequence had already unlocked it.


>
>>
>> Also, Remove stray/ununsed sb_mutex.
>
> I already removed that it mainline - I should have mentioned.
>
> Thanks,
> NeilBrown
>
>
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>   drivers/md/md-cluster.c | 26 +++++++++++++++++++++-----
>>   1 file changed, 21 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>> index b73729b..a93734e 100644
>> --- a/drivers/md/md-cluster.c
>> +++ b/drivers/md/md-cluster.c
>> @@ -47,6 +47,7 @@ struct resync_info {
>>   #define		MD_CLUSTER_WAITING_FOR_NEWDISK		1
>>   #define		MD_CLUSTER_SUSPEND_READ_BALANCING	2
>>   #define		MD_CLUSTER_BEGIN_JOIN_CLUSTER		3
>> +#define		MD_CLUSTER_COMM_LOCKED			4
>>
>>
>>   struct md_cluster_info {
>> @@ -54,7 +55,8 @@ struct md_cluster_info {
>>   	dlm_lockspace_t *lockspace;
>>   	int slot_number;
>>   	struct completion completion;
>> -	struct mutex sb_mutex;
>> +	struct mutex recv_mutex;
>> +	struct mutex send_mutex;
>>   	struct dlm_lock_resource *bitmap_lockres;
>>   	struct dlm_lock_resource *resync_lockres;
>>   	struct list_head suspend_list;
>> @@ -503,6 +505,7 @@ static void recv_daemon(struct md_thread *thread)
>>   	struct cluster_msg msg;
>>   	int ret;
>>
>> +	mutex_lock(&cinfo->recv_mutex);
>>   	/*get CR on Message*/
>>   	if (dlm_lock_sync(message_lockres, DLM_LOCK_CR)) {
>>   		pr_err("md/raid1:failed to get CR on MESSAGE\n");
>> @@ -529,6 +532,7 @@ static void recv_daemon(struct md_thread *thread)
>>   	ret = dlm_unlock_sync(message_lockres);
>>   	if (unlikely(ret != 0))
>>   		pr_info("unlock msg failed return %d\n", ret);
>> +	mutex_unlock(&cinfo->recv_mutex);
>>   }
>>
>>   /* lock_comm()
>> @@ -542,20 +546,22 @@ static int lock_comm(struct md_cluster_info *cinfo)
>>   {
>>   	int error;
>>
>> -	if (cinfo->token_lockres->mode == DLM_LOCK_EX)
>> -		return 0;
>> +	mutex_lock(&cinfo->send_mutex);
>>
>>   	error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
>>   	if (error)
>>   		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
>>   				__func__, __LINE__, error);
>> +	mutex_lock(&cinfo->recv_mutex);
>>   	return error;
>>   }
>>
>>   static void unlock_comm(struct md_cluster_info *cinfo)
>>   {
>>   	WARN_ON(cinfo->token_lockres->mode != DLM_LOCK_EX);
>> +	mutex_unlock(&cinfo->recv_mutex);
>>   	dlm_unlock_sync(cinfo->token_lockres);
>> +	mutex_unlock(&cinfo->send_mutex);
>>   }
>>
>>   /* __sendmsg()
>> @@ -709,7 +715,8 @@ static int join(struct mddev *mddev, int nodes)
>>   	init_completion(&cinfo->completion);
>>   	set_bit(MD_CLUSTER_BEGIN_JOIN_CLUSTER, &cinfo->state);
>>
>> -	mutex_init(&cinfo->sb_mutex);
>> +	mutex_init(&cinfo->send_mutex);
>> +	mutex_init(&cinfo->recv_mutex);
>>   	mddev->cluster_info = cinfo;
>>
>>   	memset(str, 0, 64);
>> @@ -839,7 +846,12 @@ static int slot_number(struct mddev *mddev)
>>
>>   static int metadata_update_start(struct mddev *mddev)
>>   {
>> -	return lock_comm(mddev->cluster_info);
>> +	struct md_cluster_info *cinfo = mddev->cluster_info;
>> +	int ret;
>> +	if (test_and_clear_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state))
>> +		return 0;
>> +	ret = lock_comm(cinfo);
>> +	return ret;
>>   }
>>
>>   static int metadata_update_finish(struct mddev *mddev)
>> @@ -864,6 +876,7 @@ static int metadata_update_finish(struct mddev *mddev)
>>   		ret = __sendmsg(cinfo, &cmsg);
>>   	} else
>>   		pr_warn("md-cluster: No good device id found to send\n");
>> +	clear_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state);
>>   	unlock_comm(cinfo);
>>   	return ret;
>>   }
>> @@ -871,6 +884,7 @@ static int metadata_update_finish(struct mddev *mddev)
>>   static void metadata_update_cancel(struct mddev *mddev)
>>   {
>>   	struct md_cluster_info *cinfo = mddev->cluster_info;
>> +	clear_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state);
>>   	unlock_comm(cinfo);
>>   }
>>
>> @@ -945,6 +959,7 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
>>   	memcpy(cmsg.uuid, uuid, 16);
>>   	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
>>   	lock_comm(cinfo);
>> +	set_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state);
>>   	ret = __sendmsg(cinfo, &cmsg);
>>   	if (ret)
>>   		return ret;
>> @@ -964,6 +979,7 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
>>   static void add_new_disk_cancel(struct mddev *mddev)
>>   {
>>   	struct md_cluster_info *cinfo = mddev->cluster_info;
>> +	clear_bit(MD_CLUSTER_COMM_LOCKED, &cinfo->state);
>>   	unlock_comm(cinfo);
>>   }
>>
>> --
>> 1.8.5.6

-- 
Goldwyn
