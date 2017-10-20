From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] md: create new workqueue for object destruction
Date: Fri, 20 Oct 2017 16:00:35 +0200
Message-ID: <06d5ab0c-f669-6c9f-3f0a-930cea5c893b@intel.com>
References: <87mv4qjrez.fsf@notabene.neil.brown.name>
 <20171018062137.ssdhwkeoy6fdp7yq@kernel.org>
 <87h8uwj4mz.fsf@notabene.neil.brown.name>
 <6454f28e-4728-a10d-f3c3-b68afedec8d9@intel.com>
 <87376ghyms.fsf@notabene.neil.brown.name>
 <9759b574-2d3f-de45-0840-c84d9cc10528@intel.com>
 <87wp3qg4bi.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wp3qg4bi.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/20/2017 12:28 AM, NeilBrown wrote:
> On Thu, Oct 19 2017, Artur Paszkiewicz wrote:
> 
>> On 10/19/2017 12:36 AM, NeilBrown wrote:
>>> On Wed, Oct 18 2017, Artur Paszkiewicz wrote:
>>>
>>>> On 10/18/2017 09:29 AM, NeilBrown wrote:
>>>>> On Tue, Oct 17 2017, Shaohua Li wrote:
>>>>>
>>>>>> On Tue, Oct 17, 2017 at 04:04:52PM +1100, Neil Brown wrote:
>>>>>>>
>>>>>>> lockdep currently complains about a potential deadlock
>>>>>>> with sysfs access taking reconfig_mutex, and that
>>>>>>> waiting for a work queue to complete.
>>>>>>>
>>>>>>> The cause is inappropriate overloading of work-items
>>>>>>> on work-queues.
>>>>>>>
>>>>>>> We currently have two work-queues: md_wq and md_misc_wq.
>>>>>>> They service 5 different tasks:
>>>>>>>
>>>>>>>   mddev->flush_work                       md_wq
>>>>>>>   mddev->event_work (for dm-raid)         md_misc_wq
>>>>>>>   mddev->del_work (mddev_delayed_delete)  md_misc_wq
>>>>>>>   mddev->del_work (md_start_sync)         md_misc_wq
>>>>>>>   rdev->del_work                          md_misc_wq
>>>>>>>
>>>>>>> We need to call flush_workqueue() for md_start_sync and ->event_work
>>>>>>> while holding reconfig_mutex, but mustn't hold it when
>>>>>>> flushing mddev_delayed_delete or rdev->del_work.
>>>>>>>
>>>>>>> md_wq is a bit special as it has WQ_MEM_RECLAIM so it is
>>>>>>> best to leave that alone.
>>>>>>>
>>>>>>> So create a new workqueue, md_del_wq, and a new work_struct,
>>>>>>> mddev->sync_work, so we can keep two classes of work separate.
>>>>>>>
>>>>>>> md_del_wq and ->del_work are used only for destroying rdev
>>>>>>> and mddev.
>>>>>>> md_misc_wq is used for event_work and sync_work.
>>>>>>>
>>>>>>> Also document the purpose of each flush_workqueue() call.
>>>>>>>
>>>>>>> This removes the lockdep warning.
>>>>>>
>>>>>> I had the exactly same patch queued internally,
>>>>>
>>>>> Cool :-)
>>>>>
>>>>>>                                                   but the mdadm test suite still
>>>>>> shows lockdep warnning. I haven't time to check further.
>>>>>>
>>>>>
>>>>> The only other lockdep I've seen later was some ext4 thing, though I
>>>>> haven't tried the full test suite.  I might have a look tomorrow.
>>>>
>>>> I'm also seeing a lockdep warning with or without this patch,
>>>> reproducible with:
>>>>
>>>
>>> Thanks!
>>> Looks like using one workqueue for mddev->del_work and rdev->del_work
>>> causes problems.
>>> Can you try with this addition please?
>>
>> It helped for that case but now there is another warning triggered by:
>>
>> export IMSM_NO_PLATFORM=1 # for platforms without IMSM
>> mdadm -C /dev/md/imsm0 -eimsm -n4 /dev/sd[a-d] -R
>> mdadm -C /dev/md/vol0 -l5 -n4 /dev/sd[a-d] -R --assume-clean
>> mdadm -If sda
>> mdadm -a /dev/md127 /dev/sda
>> mdadm -Ss
> 
> I tried that ... and mdmon gets a SIGSEGV.
> imsm_set_disk() calls get_imsm_disk() and gets a NULL back.
> It then passes the NULL to mark_failure() and that dereferences it.

Interesting... I can't reproduce this. Can you show the output from
mdadm -E for all disks after mdmon crashes? And maybe a debug log from
mdmon?

> (even worse things happen if "CREATE names=yes" appears in mdadm.conf.
> I should fix that).
> 
> I added
>   if (!disk)
>      return;
> 
> and ran it in a loop, and got the lockdep warning.
> 
> This patch gets rid of it for me.  I need to think about it some more
> before I commit to it though.

This fixes the warning for me too. No other issues so far.

Thanks,
Artur
