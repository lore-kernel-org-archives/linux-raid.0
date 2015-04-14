From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 2/4] md-cluster: remove capabilities
Date: Tue, 14 Apr 2015 06:26:34 -0500
Message-ID: <552CF96A.7000306@suse.de>
References: <20150408192247.GA9682@shrek.lan> <552B2978.5000305@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <552B2978.5000305@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <GQJiang@suse.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/12/2015 09:27 PM, Guoqing Jiang wrote:
> Goldwyn Rodrigues wrote:
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>   drivers/md/md-cluster.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>>   drivers/md/md-cluster.h |  1 +
>>   drivers/md/md.c         | 24 +++++++++++++++---------
>>   drivers/md/md.h         |  1 +
>>   4 files changed, 64 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>> index 96679b2..d036c83 100644
>> --- a/drivers/md/md-cluster.c
>> +++ b/drivers/md/md-cluster.c
>> @@ -72,6 +72,7 @@ enum msg_type {
>>   	METADATA_UPDATED = 0,
>>   	RESYNCING,
>>   	NEWDISK,
>> +	REMOVE,
>>   };
>>
>>   struct cluster_msg {
>> @@ -186,6 +187,20 @@ static char *pretty_uuid(char *dest, char *src)
>>   	return dest;
>>   }
>>
>> +static struct md_rdev *find_rdev_uuid(struct mddev *mddev, char *uuid)
>> +{
>> +	struct md_rdev *rdev;
>> +	struct mdp_superblock_1 *sb;
>> +
>> +	rdev_for_each_rcu(rdev, mddev) {
>> +		sb = page_address(rdev->sb_page);
>> +		if (!strncmp(uuid, sb->device_uuid, 16)) {
>> +			return rdev;
>> +		}
>> +	}
>> +	return NULL;
>> +}
>> +
>>   static void add_resync_info(struct mddev *mddev, struct dlm_lock_resource *lockres,
>>   		sector_t lo, sector_t hi)
>>   {
>> @@ -401,6 +416,17 @@ static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg
>>   	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
>>   }
>>
>> +static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
>> +{
>> +	struct md_rdev *rdev = find_rdev_uuid(mddev, msg->uuid);
>> +	char uuid[32];
>> +
>> +	if (rdev)
>> +		md_kick_rdev_from_array(rdev);
>> +	else
>> +		pr_warn("%s: %d Could not find disk with uuid: %s", __func__, __LINE__, pretty_uuid(uuid, msg->uuid));
>> +}
>> +
>>   static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
>>   {
>>   	switch (msg->type) {
>> @@ -419,6 +445,15 @@ static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
>>   		pr_info("%s: %d Received message: NEWDISK from %d\n",
>>   			__func__, __LINE__, msg->slot);
>>   		process_add_new_disk(mddev, msg);
>> +		break;
>> +	case REMOVE:
>> +		pr_info("%s: %d Received REMOVE from %d\n",
>> +			__func__, __LINE__, msg->slot);
>> +		process_remove_disk(mddev, msg);
>> +		break;
>> +	default:
>> +		pr_warn("%s:%d Received unknown message from %d\n",
>> +			__func__, __LINE__, msg->slot);
>>   	};
>>   }
>>
>> @@ -854,6 +889,17 @@ static int new_disk_ack(struct mddev *mddev, bool ack)
>>   	return 0;
>>   }
>>
>> +static int remove_disk(struct mddev *mddev, struct md_rdev *rdev)
>> +{
>> +	struct cluster_msg cmsg;
>> +	struct md_cluster_info *cinfo = mddev->cluster_info;
>> +	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
>> +	char *uuid = sb->device_uuid;
>> +	cmsg.type = REMOVE;
>> +	memcpy(cmsg.uuid, uuid, 16);
>> +	return __sendmsg(cinfo, &cmsg);
>> +}
>> +
>>   static struct md_cluster_operations cluster_ops = {
>>   	.join   = join,
>>   	.leave  = leave,
>> @@ -868,6 +914,7 @@ static struct md_cluster_operations cluster_ops = {
>>   	.add_new_disk_start = add_new_disk_start,
>>   	.add_new_disk_finish = add_new_disk_finish,
>>   	.new_disk_ack = new_disk_ack,
>> +	.remove_disk = remove_disk,
>>   };
>>
>>   static int __init cluster_init(void)
>> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
>> index 7417133..71e5143 100644
>> --- a/drivers/md/md-cluster.h
>> +++ b/drivers/md/md-cluster.h
>> @@ -22,6 +22,7 @@ struct md_cluster_operations {
>>   	int (*add_new_disk_start)(struct mddev *mddev, struct md_rdev *rdev);
>>   	int (*add_new_disk_finish)(struct mddev *mddev);
>>   	int (*new_disk_ack)(struct mddev *mddev, bool ack);
>> +	int (*remove_disk)(struct mddev *mddev, struct md_rdev *rdev);
>>   };
>>
>>   #endif /* _MD_CLUSTER_H */
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index bc11551..0c65e51 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -2291,11 +2291,12 @@ static void export_rdev(struct md_rdev * rdev)
>>   	kobject_put(&rdev->kobj);
>>   }
>>
>> -static void kick_rdev_from_array(struct md_rdev * rdev)
>> +void md_kick_rdev_from_array(struct md_rdev * rdev)
>>   {
>>   	unbind_rdev_from_array(rdev);
>>   	export_rdev(rdev);
>>   }
>> +EXPORT_SYMBOL_GPL(md_kick_rdev_from_array);
>>
>>   static void export_array(struct mddev *mddev)
>>   {
>> @@ -2306,7 +2307,7 @@ static void export_array(struct mddev *mddev)
>>   			MD_BUG();
>>   			continue;
>>   		}
>> -		kick_rdev_from_array(rdev);
>> +		md_kick_rdev_from_array(rdev);
>>   	}
>>   	if (!list_empty(&mddev->disks))
>>   		MD_BUG();
>> @@ -2750,9 +2751,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>>   			err = -EBUSY;
>>   		else {
>>   			struct mddev *mddev = rdev->mddev;
>> -			if (mddev_is_clustered(mddev))
>> +			if (mddev_is_clustered(mddev)) {
>>   				md_cluster_ops->metadata_update_start(mddev);
>> -			kick_rdev_from_array(rdev);
>> +				md_cluster_ops->remove_disk(mddev, rdev);
>> +			}
>> +			md_kick_rdev_from_array(rdev);
>>
> For md-cluster, seems it is possible that md_kick_rdev_from_array could
> be called twice,
> is this what you want? Thanks.


No, it would be called only once. There are two types of nodes in this 
case: one is  sender and other received. The sender calls 
md_kick_rdev_from_array() in the regular flow of 
state_store/hot_remove_disk() while the receiver calls 
md_kick_rdev_from_array() in the process_remove_disk().

Or am I missing something?

-- 
Goldwyn
