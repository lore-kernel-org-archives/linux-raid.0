From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 1/8] md-cluster: call md_kick_rdev_from_array once ack
 failed
Date: Mon, 1 Aug 2016 23:21:14 -0400
Message-ID: <57A011AA.3000801@suse.com>
References: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
 <20160801215828.GA18810@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160801215828.GA18810@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 08/01/2016 05:58 PM, Shaohua Li wrote:
> On Thu, Jul 28, 2016 at 02:16:45AM -0400, Guoqing Jiang wrote:
>> The new_disk_ack could return failure if WAITING_FOR_NEWDISK
>> is not set, so we need to kick the dev from array in case
>> failure happened.
>>
>> Reviewed-by: NeilBrown <neilb@suse.com>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>>   drivers/md/md.c | 8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 2ed547f..743cd21 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -6092,9 +6092,11 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
>>   			export_rdev(rdev);
>>   
>>   		if (mddev_is_clustered(mddev)) {
>> -			if (info->state & (1 << MD_DISK_CANDIDATE))
>> -				md_cluster_ops->new_disk_ack(mddev, (err == 0));
>> -			else {
>> +			if (info->state & (1 << MD_DISK_CANDIDATE)) {
> if err != 0, we already do export_rdev, do we need to do md_kick_rdev_from_array in that case?

I suppose you mean the export_rdev before new_disk_ack, it doesn't need 
to call md_kick_rdev_from_array
since we don't bind rdev to array successfully.

                  err = bind_rdev_to_array(rdev, mddev);

                 if (err)
*export_rdev*(rdev);

                 if (mddev_is_clustered(mddev)) {
                         if (info->state & (1 << MD_DISK_CANDIDATE))
md_cluster_ops->new_disk_ack(mddev, (err == 0));

But it is possible that new_disk_ack returns -EINVAL, and the rdev is 
binded with array, so we should call
md_kick_rdev_from_array for the case.

Thanks,
Guoqing
