From: yuyufen <yuyufen@huawei.com>
Subject: Re: [PATCH] [RFC] md raid10: use rcu to avoid NULL dereference in
 raid10d()
Date: Thu, 1 Feb 2018 20:26:57 +0800
Message-ID: <7b5cb7fa-2dfa-0fab-752d-16cdfedffbca@huawei.com>
References: <20171117200326.xqchu3r3elzvkg7z@kernel.org>
 <45cfa4a5-fe04-8b02-531d-c642ad6e7b4c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45cfa4a5-fe04-8b02-531d-c642ad6e7b4c@huawei.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com, colyli@suse.de, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi.

> On Thu, Oct 19, 2017 at 10:06:56AM +1100, Neil Brown wrote:
>> On Wed, Oct 18 2017, NeilBrown wrote:
>>
>>> On Wed, Oct 18 2017, Coly Li wrote:
>>>
>>>> We have a bug report about NULL dereference in md raid10 code. The
>>>> operations are,
>>>>   - Create a raid10 device
>>>>   - add a spare disk
>>>>   - disconnect one of the online disks from the raid10 device
>>>>   - wait to the recovery happens on the spare disk
>>>>   - remove the spare disk which is recovering
>>>> And sometimes a kernel oops of NULL dereference in md raid10 module can
>>>> be observed, and crash tool reports the following information:
>>>>> (gdb) list *(raid10d+0xad6)
>>>>> 0x5de6 is in raid10d (../drivers/md/raid10.c:2300).
>>>>> 2295		 * the latter is free to free wbio2.
>>>>> 2296		 */
>>>>> 2297		if (wbio2 && !wbio2->bi_end_io)
>>>>> 2298			wbio2 = NULL;
>>>>> 2299		if (wbio->bi_end_io) {
>>>>> 2300			atomic_inc(&conf->mirrors[d].rdev->nr_pending);
>>>>> 2301			md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
>>>>> 2302			generic_make_request(wbio);
>>>>> 2303		}
>>>>> 2304		if (wbio2) {
>>>> At line 2300, conf->mirrors[d].rdev is NULL, this causes a NULL pointer
>>>> dereference to conf->mirrors[d].rdev->nr_pending. After reading previous
>>>> raid10 patches, I find conf->mirrors[d].rdev can be NULL at any point
>>>> unless,
>>>>   - a counted reference is held
>>>>   - ->reconfig_mutex is held, or
>>>>   - rcu_read_lock() is held

We have the same bug report about NULL dereference in md raid10 code.
operations are:

     - create raid10, including 4 disk and 2 spare disk
         mdadm -C /dev/md1 -l 10 -n 4  /dev/sda /dev/sdb /dev/sdc 
/dev/sdd -x 2 /dev/sde /dev/sdf -R
     - block and offline a disk in raid10
     - hot remove a disk by
         mdadm --manage /dev/md1 -r sdX
     - add disk
         mdadm --manage /dev/md1 -r sdX

(gdb) l *(0xffffffff815daafd)
0xffffffff815daafd is in rdev_clear_badblocks (drivers/md/md.c:8688).
8683                             int is_new)
8684    {
8685            if (is_new)
8686                    s += rdev->new_data_offset;
8687            else
8688                    s += rdev->data_offset; <====================
8689            return md_clear_badblocks(&rdev->badblocks,
8690                                      s, sectors);
8691    }
8692    EXPORT_SYMBOL_GPL(rdev_clear_badblocks);

Call Trace and crash tools show it is triggered as following:
raid10d() => handle_write_completed() => rdev_clear_badblocks()

>>> There is one other condition: MD_RECOVERY_RUNNING is set (without
>>> MD_RECOVERY_DONE).
>>> mirrors[d].rdev is only set to NULL by ->hot_remove_disk() which is only
>>> called from remove_and_add_spares(), and that is never called while
>>> resync/recovery/reshape is happening.
>>> So there is no need for RCU protection here.
>>>
>>> Only ... remove_and_add_spares() *can* sometimes be called during
>>> resync -
>>> Commit: 8430e7e0af9a ("md: disconnect device from personality before trying to remove it.")
>>> added a called to remove_and_add_spares() when "remove" is written to
>>> the device/state attribute.  That was wrong.
>>> This:
>>>
>>>   	} else if (cmd_match(buf, "remove")) {
>>> -		if (rdev->mddev->pers) {
>>> +		if (rdev->mddev->pers &&
>>> +		    !test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
>>>   			clear_bit(Blocked, &rdev->flags);
>>>   			remove_and_add_spares(rdev->mddev, rdev);
>>>
>>> should fix it.
>> Actually, that doesn't even compile :-(
>>
>> I think this is a better fix.
>> Thanks,
>> NeilBrown
>>
>> From: NeilBrown <neilb@suse.com>
>> Date: Thu, 19 Oct 2017 09:58:19 +1100
>> Subject: [PATCH] md: only allow remove_and_add_spares() when no sync_thread running.
>>
>> The locking protocols in md assume that a device will
>> never be removed from an array during resync/recovery/reshape.
>> When that isn't happening, rcu or reconfig_mutex is needed
>> to protect an rdev pointer while taking a refcount.  When
>> it is happening, that protection isn't needed.
>>
>> Unfortuantely there is a case were remove_and_add_spares() is
>> called when recovery might be happening: when "remove" is
>> written to the device/state sysfs attribute.
>>
>> This call is an optimization and not essential so it doesn't
>> matter if it fails.
>> So change remove_and_add_spares() to abort early if
>> resync/recovery/reshape is happening.
>>
>> As this can result in a NULL dereference, the fix is suitable
>> for -stable.
>>
>> Cc: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
>> Fixes: 8430e7e0af9a ("md: disconnect device from personality before trying to remove it.")
>> Cc: stable@ver.kernel.org (v4.8+)
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>   drivers/md/md.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index b3192943de7d..01eac0dbca98 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -8563,6 +8563,10 @@ static int remove_and_add_spares(struct mddev *mddev,
>>   	int removed = 0;
>>   	bool remove_some = false;
> Sorry, I missed this patch.
>
> I'd really appreciate if you can add the locking protocol into comments here,
> digging changelog is much painful.
>    > +	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>> +		/* Mustn't remove devices when resync thread is running */
>> +		return 0;
>> +
> This will bypass hotadd too, is it what we want?

After applying this patch, there is no more Oops, but the number of 
disks will become less and less, which is not expected.
I think it's caused by bypassing of hotadd. Can we just add spare disk 
without removing disk?

Any suggestions for this fix or any progress on this patch?

Thanks a lot,
Yufen Yu

>
> Thanks,
> Shaohua
>>   	rdev_for_each(rdev, mddev) {
>>   		if ((this == NULL || rdev == this) &&
>>   		    rdev->raid_disk >= 0 &&
>> -- 
>> 2.14.0.rc0.dirty
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> .
>
>
>
> .
>
.

