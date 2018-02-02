From: yuyufen <yuyufen@huawei.com>
Subject: Re: [PATCH] [RFC] md raid10: use rcu to avoid NULL dereference in
 raid10d()
Date: Fri, 2 Feb 2018 21:49:33 +0800
Message-ID: <2d7921ce-6ebf-fad5-2029-f54bb896863f@huawei.com>
References: <20171117200326.xqchu3r3elzvkg7z@kernel.org>
 <45cfa4a5-fe04-8b02-531d-c642ad6e7b4c@huawei.com>
 <7b5cb7fa-2dfa-0fab-752d-16cdfedffbca@huawei.com>
 <87o9l82vun.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87o9l82vun.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, colyli@suse.de, shli@kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 2018/2/2 6:22, NeilBrown wrote:
> On Thu, Feb 01 2018, yuyufen wrote:
>
>> hi.
>>
>>> On Thu, Oct 19, 2017 at 10:06:56AM +1100, Neil Brown wrote:
>>>> On Wed, Oct 18 2017, NeilBrown wrote:
>>>>
>>>>> On Wed, Oct 18 2017, Coly Li wrote:
>>>>>
>>>>>> We have a bug report about NULL dereference in md raid10 code. The
>>>>>> operations are,
>>>>>>    - Create a raid10 device
>>>>>>    - add a spare disk
>>>>>>    - disconnect one of the online disks from the raid10 device
>>>>>>    - wait to the recovery happens on the spare disk
>>>>>>    - remove the spare disk which is recovering
>>>>>> And sometimes a kernel oops of NULL dereference in md raid10 module can
>>>>>> be observed, and crash tool reports the following information:
>>>>>>> (gdb) list *(raid10d+0xad6)
>>>>>>> 0x5de6 is in raid10d (../drivers/md/raid10.c:2300).
>>>>>>> 2295		 * the latter is free to free wbio2.
>>>>>>> 2296		 */
>>>>>>> 2297		if (wbio2 && !wbio2->bi_end_io)
>>>>>>> 2298			wbio2 = NULL;
>>>>>>> 2299		if (wbio->bi_end_io) {
>>>>>>> 2300			atomic_inc(&conf->mirrors[d].rdev->nr_pending);
>>>>>>> 2301			md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
>>>>>>> 2302			generic_make_request(wbio);
>>>>>>> 2303		}
>>>>>>> 2304		if (wbio2) {
>>>>>> At line 2300, conf->mirrors[d].rdev is NULL, this causes a NULL pointer
>>>>>> dereference to conf->mirrors[d].rdev->nr_pending. After reading previous
>>>>>> raid10 patches, I find conf->mirrors[d].rdev can be NULL at any point
>>>>>> unless,
>>>>>>    - a counted reference is held
>>>>>>    - ->reconfig_mutex is held, or
>>>>>>    - rcu_read_lock() is held
>> We have the same bug report about NULL dereference in md raid10 code.
>> operations are:
>>
>>       - create raid10, including 4 disk and 2 spare disk
>>           mdadm -C /dev/md1 -l 10 -n 4  /dev/sda /dev/sdb /dev/sdc
>> /dev/sdd -x 2 /dev/sde /dev/sdf -R
>>       - block and offline a disk in raid10
>>       - hot remove a disk by
>>           mdadm --manage /dev/md1 -r sdX
>>       - add disk
>>           mdadm --manage /dev/md1 -r sdX
>>
>> (gdb) l *(0xffffffff815daafd)
>> 0xffffffff815daafd is in rdev_clear_badblocks (drivers/md/md.c:8688).
>> 8683                             int is_new)
>> 8684    {
>> 8685            if (is_new)
>> 8686                    s += rdev->new_data_offset;
>> 8687            else
>> 8688                    s += rdev->data_offset; <====================
>> 8689            return md_clear_badblocks(&rdev->badblocks,
>> 8690                                      s, sectors);
>> 8691    }
>> 8692    EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
>>
>> Call Trace and crash tools show it is triggered as following:
>> raid10d() => handle_write_completed() => rdev_clear_badblocks()
>>
>>>>> There is one other condition: MD_RECOVERY_RUNNING is set (without
>>>>> MD_RECOVERY_DONE).
>>>>> mirrors[d].rdev is only set to NULL by ->hot_remove_disk() which is only
>>>>> called from remove_and_add_spares(), and that is never called while
>>>>> resync/recovery/reshape is happening.
>>>>> So there is no need for RCU protection here.
>>>>>
>>>>> Only ... remove_and_add_spares() *can* sometimes be called during
>>>>> resync -
>>>>> Commit: 8430e7e0af9a ("md: disconnect device from personality before trying to remove it.")
>>>>> added a called to remove_and_add_spares() when "remove" is written to
>>>>> the device/state attribute.  That was wrong.
>>>>> This:
>>>>>
>>>>>    	} else if (cmd_match(buf, "remove")) {
>>>>> -		if (rdev->mddev->pers) {
>>>>> +		if (rdev->mddev->pers &&
>>>>> +		    !test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
>>>>>    			clear_bit(Blocked, &rdev->flags);
>>>>>    			remove_and_add_spares(rdev->mddev, rdev);
>>>>>
>>>>> should fix it.
>>>> Actually, that doesn't even compile :-(
>>>>
>>>> I think this is a better fix.
>>>> Thanks,
>>>> NeilBrown
>>>>
>>>> From: NeilBrown <neilb@suse.com>
>>>> Date: Thu, 19 Oct 2017 09:58:19 +1100
>>>> Subject: [PATCH] md: only allow remove_and_add_spares() when no sync_thread running.
>>>>
>>>> The locking protocols in md assume that a device will
>>>> never be removed from an array during resync/recovery/reshape.
>>>> When that isn't happening, rcu or reconfig_mutex is needed
>>>> to protect an rdev pointer while taking a refcount.  When
>>>> it is happening, that protection isn't needed.
>>>>
>>>> Unfortuantely there is a case were remove_and_add_spares() is
>>>> called when recovery might be happening: when "remove" is
>>>> written to the device/state sysfs attribute.
>>>>
>>>> This call is an optimization and not essential so it doesn't
>>>> matter if it fails.
>>>> So change remove_and_add_spares() to abort early if
>>>> resync/recovery/reshape is happening.
>>>>
>>>> As this can result in a NULL dereference, the fix is suitable
>>>> for -stable.
>>>>
>>>> Cc: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
>>>> Fixes: 8430e7e0af9a ("md: disconnect device from personality before trying to remove it.")
>>>> Cc: stable@ver.kernel.org (v4.8+)
>>>> Signed-off-by: NeilBrown <neilb@suse.com>
>>>> ---
>>>>    drivers/md/md.c | 4 ++++
>>>>    1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index b3192943de7d..01eac0dbca98 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -8563,6 +8563,10 @@ static int remove_and_add_spares(struct mddev *mddev,
>>>>    	int removed = 0;
>>>>    	bool remove_some = false;
>>> Sorry, I missed this patch.
>>>
>>> I'd really appreciate if you can add the locking protocol into comments here,
>>> digging changelog is much painful.
>>>     > +	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>>>> +		/* Mustn't remove devices when resync thread is running */
>>>> +		return 0;
>>>> +
>>> This will bypass hotadd too, is it what we want?
>> After applying this patch, there is no more Oops, but the number of
>> disks will become less and less, which is not expected.
> Please explain what you mean by "the number of disks will become less
> and less"??  What is the sequence of events?
>
>
>> I think it's caused by bypassing of hotadd. Can we just add spare disk
>> without removing disk?
>>
>> Any suggestions for this fix or any progress on this patch?
> I had forgotten about this patch and will resend.  However I think the
> only change needs is adding some comments.  I still think the code is
> correct.
(1) When raid10 create, there are 4 disks in raid and 2 spare disks 
(sda5, sdd5)

[  100.473118] RAID10 conf printout:
[  100.473121]  --- wd:3 rd:4
[  100.473123]  disk 0, wo:0, o:1, dev:sdb5
[  100.473124]  disk 1, wo:1, o:0, dev:sdc5
[  100.473126]  disk 2, wo:0, o:1, dev:sde5
[  100.473127]  disk 3, wo:0, o:1, dev:sdf5

(2) mdadm: hot removed /dev/sdc5 from /dev/md5
[  100.473118] RAID10 conf printout:
[  110.390027]  --- wd:3 rd:4
[  110.390028]  disk 0, wo:0, o:1, dev:sdb5
[  110.390029]  disk 2, wo:0, o:1, dev:sde5
[  110.390030]  disk 3, wo:0, o:1, dev:sdf5

However, as there are 2 spare disks, we expect raid10 can hot add a disk.

(3)
mdadm: added /dev/sdc5
mdadm: hot removed /dev/sdc5 from /dev/md5
[  148.680032] RAID10 conf printout:
[  148.680035]  --- wd:2 rd:4
[  148.680037]  disk 0, wo:0, o:1, dev:sdb5
[  148.680038]  disk 2, wo:0, o:1, dev:sde5

Now, there are 3 spare disks (sda5, sdc5, sdd5)
Also, we expect hot add 2 disk, not just 2 disk in raid10.

I try to explain, but not sure:
The only place of the runtime to invoke mddev->pers->hot_add_disk(mddev, 
rdev) is md_check_recovery().
But, it will set MD_RECOVERY_RUNNING before invoking 
remove_and_add_spares():


8702 void md_check_recovery(struct mddev *mddev)
8703 {
……

8800         mddev->curr_resync_completed = 0;
8801         spin_lock(&mddev->lock);
8802         set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);   
<=======================
8803         spin_unlock(&mddev->lock);
8804         /* Clear some bits that don't mean anything, but
8805          * might be left set
8806          */
8807         clear_bit(MD_RECOVERY_INTR, &mddev->recovery);
8808         clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
8809
8810         if (!test_and_clear_bit(MD_RECOVERY_NEEDED, 
&mddev->recovery) ||
8811             test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
8812             goto not_running;
8813         /* no recovery is running.
8814          * remove any failed drives, then
8815          * add spares if possible.
8816          * Spares are also removed and re-added, to allow
8817          * the personality to fail the re-add.
8818          */
8819
8820         if (mddev->reshape_position != MaxSector) {
8821             if (mddev->pers->check_reshape == NULL ||
8822                 mddev->pers->check_reshape(mddev) != 0)
8823                 /* Cannot proceed */
8824                 goto not_running;
8825             set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
8826             clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
8827         } else if ((spares = remove_and_add_spares(mddev, NULL))) 
{   <=======================
8828             clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
……

8874 }
8875 EXPORT_SYMBOL(md_check_recovery);

That means, test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) always be true.
So it will bypass hot add.


+        if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+                /* Mustn't remove devices when resync thread is running */
+                return 0;


What's more, I found there some  D status fio processes (I use fio to test).
They seems to waiting for IO complete. But I can't explain reason.

[  463.085649] sysrq: SysRq : Show Blocked State
[  463.087764]   task                        PC stack   pid father
[  463.090151] fio             D ffff88012e45ba68     0  1420   1398 
0x00000000
[  463.095138]  ffff88012e45b9e8 ffff8800b5893ba0 ffff8800a55bf200 
0000000000015c40
[  463.098142]  ffffffff810d8698 ffff8800b58940f0 225383e5f11e4e2e 
ffff88012e45b9d8
[  463.102101]  ffff88012e45c000 ffff88013fcd5c40 7fffffffffffffff 
ffff88012e45b9f8
[  463.105651] Call Trace:
[  463.107430]  [<ffffffff810d8698>] ? __wake_up+0x48/0x60
[  463.110126]  [<ffffffff81745567>] schedule+0x37/0x90
[  463.112817]  [<ffffffff81747dd9>] schedule_timeout+0x1a9/0x200
[  463.116131]  [<ffffffff81745567>] ? schedule+0x37/0x90
[  463.119738]  [<ffffffff81747dd9>] ? schedule_timeout+0x1a9/0x200
[  463.123879]  [<ffffffff81108470>] ? ktime_get+0x40/0xb0
[  463.126737]  [<ffffffff81248896>] ? __blockdev_direct_IO+0xf46/0x1720
[  463.130833]  [<ffffffff81353b11>] ? bio_put+0x51/0x90
[  463.134180]  [<ffffffff817449a4>] ? io_schedule_timeout+0xa4/0x110
[  463.138207]  [<ffffffff81248896>] ? __blockdev_direct_IO+0xf46/0x1720
[  463.142740]  [<ffffffff81243340>] ? I_BDEV+0x10/0x10
[  463.146066]  [<ffffffff81243c7c>] ? blkdev_direct_IO+0x4c/0x50
[  463.149205]  [<ffffffff811942f0>] ? generic_file_read_iter+0x540/0x6f0
[  463.154051]  [<ffffffff8135dd48>] ? blk_finish_plug+0x18/0x50
[  463.156457]  [<ffffffff81244bc5>] ? blkdev_read_iter+0x35/0x50
[  463.159293]  [<ffffffff81207e0d>] ? __vfs_read+0xcd/0x110
[  463.162703]  [<ffffffff812086bc>] ? vfs_write+0x9c/0x1b0
[  463.166147]  [<ffffffff8120855a>] ? vfs_read+0x7a/0x140
[  463.168477]  [<ffffffff8120924a>] ? SyS_pread64+0x9a/0xc0
[  463.171970]  [<ffffffff811058d1>] ? SyS_clock_gettime+0x81/0xd0
[  463.175796]  [<ffffffff81748c57>] ? system_call_fastpath+0x12/0x6a

Thanks,
Yufen Yu
> Thanks,
> NeilBrown
>
>> Thanks a lot,
>> Yufen Yu
>>
>>> Thanks,
>>> Shaohua
>>>>    	rdev_for_each(rdev, mddev) {
>>>>    		if ((this == NULL || rdev == this) &&
>>>>    		    rdev->raid_disk >= 0 &&
>>>> -- 
>>>> 2.14.0.rc0.dirty
>>>>
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>> .
>>>
>>>
>>>
>>> .
>>>
>> .


