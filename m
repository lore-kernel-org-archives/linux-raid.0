From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 1/8] md-cluster: call md_kick_rdev_from_array once ack
 failed
Date: Wed, 3 Aug 2016 10:15:50 +0800
Message-ID: <57A153D6.20606@suse.com>
References: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
 <20160801215828.GA18810@kernel.org> <579FF771.4060007@suse.com>
 <20160802221708.GB98613@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160802221708.GB98613@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 08/03/2016 06:17 AM, Shaohua Li wrote:
> On Mon, Aug 01, 2016 at 09:29:21PM -0400, Guoqing Jiang wrote:
>>
>> On 08/01/2016 05:58 PM, Shaohua Li wrote:
>>> On Thu, Jul 28, 2016 at 02:16:45AM -0400, Guoqing Jiang wrote:
>>>> The new_disk_ack could return failure if WAITING_FOR_NEWDISK
>>>> is not set, so we need to kick the dev from array in case
>>>> failure happened.
>>>>
>>>> Reviewed-by: NeilBrown <neilb@suse.com>
>>>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>>>> ---
>>>>   drivers/md/md.c | 8 +++++---
>>>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index 2ed547f..743cd21 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -6092,9 +6092,11 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
>>>>   			export_rdev(rdev);
>>>>   		if (mddev_is_clustered(mddev)) {
>>>> -			if (info->state & (1 << MD_DISK_CANDIDATE))
>>>> -				md_cluster_ops->new_disk_ack(mddev, (err == 0));
>>>> -			else {
>>>> +			if (info->state & (1 << MD_DISK_CANDIDATE)) {
>>> if err != 0, we already do export_rdev, do we need to do md_kick_rdev_from_array in that case?
>> I suppose you mean the export_rdev before new_disk_ack, it doesn't need to
>> call md_kick_rdev_from_array
>> since we don't bind rdev to array successfully.
>>
>>                   err = bind_rdev_to_array(rdev, mddev);
>>
>>                  if (err)
>> *export_rdev*(rdev);
> Let's assume bind_rdev_to_array fails, err != 0, we export_rdev
>>                  if (mddev_is_clustered(mddev)) {
>>                          if (info->state & (1 << MD_DISK_CANDIDATE))
>> md_cluster_ops->new_disk_ack(mddev, (err == 0));
>   
> we don't check err here, so we could call ->new_disk_ack, then if
> new_disk_ack() fails, we will call md_kick_rdev_from_array(rdev) again with
> your patch. we are kicking out rdev which isn't bound yet in this case.

Thanks, we should also check err before new_disk_ack for the case.
I will send a new patch for it.

Regards,
Guoqing

