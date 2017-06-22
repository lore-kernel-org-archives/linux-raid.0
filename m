From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH] md/bitmap: don't read page from device with Bitmap_sync
Date: Thu, 22 Jun 2017 14:45:10 +0800
Message-ID: <3e4cd32d-9044-bf20-7295-9b2f3392635e@suse.com>
References: <20170616091927.12959-1-gqjiang@suse.com>
 <20170616173613.c2cp6qt2hmoebgct@kernel.org>
 <87h8zc51t0.fsf@notabene.neil.brown.name>
 <20170620004158.lrry5ig5epvmcqfc@kernel.org>
 <87o9tj2tse.fsf@notabene.neil.brown.name>
 <20170621174719.dwih6qdk2a5nd7yl@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170621174719.dwih6qdk2a5nd7yl@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 06/22/2017 01:47 AM, Shaohua Li wrote:
> On Tue, Jun 20, 2017 at 01:59:45PM +1000, Neil Brown wrote:
>> On Mon, Jun 19 2017, Shaohua Li wrote:
>>
>>> On Mon, Jun 19, 2017 at 09:11:23AM +1000, Neil Brown wrote:
>>>> On Fri, Jun 16 2017, Shaohua Li wrote:
>>>>
>>>>> On Fri, Jun 16, 2017 at 05:19:27PM +0800, Guoqing Jiang wrote:
>>>>>> The device owns Bitmap_sync flag needs recovery
>>>>>> to become in sync, and read page from this type
>>>>>> device could get stale status.
>>>>>>
>>>>>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>>>>>> ---
>>>>>> When develop for clustered raid10 feature, if add a
>>>>>> disk under grow mode in master node, I could get
>>>>>> the "bitmap superblock UUID mismatch" warning due
>>>>>> to the page is read from Bitmap_sync device.
>>>>>>
>>>>>>   drivers/md/bitmap.c | 3 ++-
>>>>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
>>>>>> index bf7419a..bf34cd8 100644
>>>>>> --- a/drivers/md/bitmap.c
>>>>>> +++ b/drivers/md/bitmap.c
>>>>>> @@ -156,7 +156,8 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
>>>>>>   
>>>>>>   	rdev_for_each(rdev, mddev) {
>>>>>>   		if (! test_bit(In_sync, &rdev->flags)
>>>>> Why In_sync is set for the rdev? I think it shoudn't.
>>>> There are several states a device can be in.
>>>> If ->raid_disk is < 0, then the device is a spare, and doesn't contain
>>>>      and valid data.
>>>> Otherwise ->raid_disk >=0 and:
>>>>     In_sync is clear, which means that blocks before ->recovery_offset
>>>>         contain valid data, and blocks after there don't
>>>>     In_sync is set, which means ->recovery_offset is irrelevant and
>>>>         should be treated as MaxSector
>>>>     Bitmap_sync is set, which could apply in either of the above cases,
>>>>         and means blocks corresponding to bits that are set in the bitmap
>>>>         may not be up to date.
>>>>
>>>> Bitmap_sync is only relevant before a device has been handed to the
>>>> personality.  After it has been added, ->recovery_cp ensures that the
>>>> blocks that might be wrong are not read until until the bitmap-based
>>>> recovery has fixed them up.
>>>>
>>>> Bitmap_sync is only use to stop the device from being given to the
>>>> personality if a recovery won't be started because the array is
>>>> read-only.
>>>>
>>>> So it is perfectly valid for both In_sync and Bitmap_sync to be set.
>>>> If they are, it makes sense to avoid reading bitmap information from the
>>>> Bitmap_sync device, as that will be out-of-date.
>>>>
>>>> I'm not quite sure why Guoqing is getting a UUID mismatch ... it
>>>> suggests that the new device wasn't initialized properly.  So there
>>>> might be another bug.  But I think this is definitely a bug.
>>> Can you describe a scenario a disk has both bits set? I had hard time to
>>> imagine it.
>> An array with a bitmap has a device fail (cable break?).
>> So the bitmap stops clearing bits and ->events_cleared stays
>> where it was, with the same value as events in the superblock
>> of the failed device.
>>
>> The device then starts working (cable is replaced) and
>> it device is added back to the array.
>> super_1_validate notices that the array has a bitmap and that the event
>> count in the new device is >= mddev->bitmap->events_cleared, but <
>> mddev->events.
>> i.e. it is in the range for which a bitmap-based recovery is both
>> possible and needed.
>> So it sets Bitmap_sync.
>> Then it notices that the 'role' in a valid role for the array,
>> so that role is stored in rdev->saved_raid_disk and, as there is no
>> MD_FEATURE_RECOVERY_OFFSET, In_sync is set.
>> A similar sequence can happen in super_90_validate.
> This part is quite confusing actually. The failed device is kicked out, so the
> array is degraded. When we readd the device, we shouldn't set In_sync.
>
> Actually we set In_sync in super_1_validate, we then clear it in add_bound_rdev
> and reset it till recovery finishes. Set it till recovery finishes makes sense
> to me, the super_1_validate is confusing.
>   
>>> md_update_sb will update super and bitmap super at almost the same time. It's
>>> possible we update super but not bitmap super and there is power loss. Is this
>>> the case we have the both bits set? There seems no mechanism to prevent the
>>> first disk has older bitmap super than the second disk in this scenario.
>> This isn't really about the superblock and bitmap on the one device
>> being in sync or not.
>> It is the superblock on one (failed) device having a different event
>> count than the bitmap (on the other devices) that is actively being used
>> by the array.
> My point is we could use a disk's superblock, but its bitmap superblock is
> stale (even is old)
>
> Anyway, I still didn't understand when the problem could happen. Maybe Guoqing
> can clarify.

My case is not same as what Neil described. But if add a disk to cluster 
raid10 under grow
mode, I can see:

1. super_1_validate sets Bitmap_sync flag first, this is because the new 
added disk's event
is less than array's event. But for native raid, both of the events are 
0, so Bitmap_sync is
not set, this difference is caused by do_md_run only calls 
md_allow_write for clustered raid,
and IIRC we have to do it to resolve deadlock.

2.  In_sync is set by raid10_start_reshape.
This is called by either clustered raid or native raid, I don't think we 
can change it here ...

Based on the above, it is possible that both of the two flags can exist 
together.

Thanks,
Guoqing


