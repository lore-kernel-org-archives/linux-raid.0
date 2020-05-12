From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: raid6check extremely slow ?
Date: Tue, 12 May 2020 20:16:27 +0200
Message-ID: <e24b0703-a599-45ef-f6b6-0a713cfa414c@cloud.ionos.com>
References: <20200510120725.20947240E1A@gemini.denx.de>
 <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com>
 <20200511064022.591C5240E1A@gemini.denx.de>
 <f003a8c7-e96d-ddc3-6d1d-42a13b70e0b6@cloud.ionos.com>
 <20200511161415.GA8049@lazy.lzy>
 <23d84744-9e3c-adc1-3af1-6498b9bcf750@cloud.ionos.com>
 <20200512160712.GB7261@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200512160712.GB7261@lazy.lzy>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/12/20 6:07 PM, Piergiorgio Sartor wrote:
> On Mon, May 11, 2020 at 11:07:31PM +0200, Guoqing Jiang wrote:
>> On 5/11/20 6:14 PM, Piergiorgio Sartor wrote:
>>> On Mon, May 11, 2020 at 10:58:07AM +0200, Guoqing Jiang wrote:
>>>> Hi Wolfgang,
>>>>
>>>>
>>>> On 5/11/20 8:40 AM, Wolfgang Denk wrote:
>>>>> Dear Guoqing Jiang,
>>>>>
>>>>> In message<2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com>  you wrote:
>>>>>> Seems raid6check is in 'D' state, what are the output of 'cat
>>>>>> /proc/19719/stack' and /proc/mdstat?
>>>>> # for i in 1 2 3 4 ; do  cat /proc/19719/stack; sleep 2; echo ; done
>>>>> [<0>] __wait_rcu_gp+0x10d/0x110
>>>>> [<0>] synchronize_rcu+0x47/0x50
>>>>> [<0>] mddev_suspend+0x4a/0x140
>>>>> [<0>] suspend_lo_store+0x50/0xa0
>>>>> [<0>] md_attr_store+0x86/0xe0
>>>>> [<0>] kernfs_fop_write+0xce/0x1b0
>>>>> [<0>] vfs_write+0xb6/0x1a0
>>>>> [<0>] ksys_write+0x4f/0xc0
>>>>> [<0>] do_syscall_64+0x5b/0xf0
>>>>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>>>
>>>>> [<0>] __wait_rcu_gp+0x10d/0x110
>>>>> [<0>] synchronize_rcu+0x47/0x50
>>>>> [<0>] mddev_suspend+0x4a/0x140
>>>>> [<0>] suspend_lo_store+0x50/0xa0
>>>>> [<0>] md_attr_store+0x86/0xe0
>>>>> [<0>] kernfs_fop_write+0xce/0x1b0
>>>>> [<0>] vfs_write+0xb6/0x1a0
>>>>> [<0>] ksys_write+0x4f/0xc0
>>>>> [<0>] do_syscall_64+0x5b/0xf0
>>>>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>>>
>>>>> [<0>] __wait_rcu_gp+0x10d/0x110
>>>>> [<0>] synchronize_rcu+0x47/0x50
>>>>> [<0>] mddev_suspend+0x4a/0x140
>>>>> [<0>] suspend_hi_store+0x44/0x90
>>>>> [<0>] md_attr_store+0x86/0xe0
>>>>> [<0>] kernfs_fop_write+0xce/0x1b0
>>>>> [<0>] vfs_write+0xb6/0x1a0
>>>>> [<0>] ksys_write+0x4f/0xc0
>>>>> [<0>] do_syscall_64+0x5b/0xf0
>>>>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>>>
>>>>> [<0>] __wait_rcu_gp+0x10d/0x110
>>>>> [<0>] synchronize_rcu+0x47/0x50
>>>>> [<0>] mddev_suspend+0x4a/0x140
>>>>> [<0>] suspend_hi_store+0x44/0x90
>>>>> [<0>] md_attr_store+0x86/0xe0
>>>>> [<0>] kernfs_fop_write+0xce/0x1b0
>>>>> [<0>] vfs_write+0xb6/0x1a0
>>>>> [<0>] ksys_write+0x4f/0xc0
>>>>> [<0>] do_syscall_64+0x5b/0xf0
>>>>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>> Looks raid6check keeps writing suspend_lo/hi node which causes mddev_suspend
>>>> is called,
>>>> means synchronize_rcu and other synchronize mechanisms are triggered in the
>>>> path ...
>>>>
>>>>> Interesting, why is it in ksys_write / vfs_write / kernfs_fop_write
>>>>> all the time?  I thought it was_reading_  the disks only?
>>>> I didn't read raid6check before, just find check_stripes has
>>>>
>>>>
>>>>       while (length > 0) {
>>>>               lock_stripe -> write suspend_lo/hi node
>>>>               ...
>>>>               unlock_all_stripes -> -> write suspend_lo/hi node
>>>>       }
>>>>
>>>> I think it explains the stack of raid6check, and maybe it is way that
>>>> raid6check works, lock
>>>> stripe, check the stripe then unlock the stripe, just my guess ...
>>> Hi again!
>>>
>>> I made a quick test.
>>> I disabled the lock / unlock in raid6check.
>>>
>>> With lock / unlock, I get around 1.2MB/sec
>>> per device component, with ~13% CPU load.
>>> Wihtout lock / unlock, I get around 15.5MB/sec
>>> per device component, with ~30% CPU load.
>>>
>>> So, it seems the lock / unlock mechanism is
>>> quite expensive.
>> Yes, since mddev_suspend/resume are triggered by the lock/unlock stripe.
>>
>>> I'm not sure what's the best solution, since
>>> we still need to avoid race conditions.
>> I guess there are two possible ways:
>>
>> 1. Per your previous reply, only call raid6check when array is RO, then
>> we don't need the lock.
>>
>> 2. Investigate if it is possible that acquire stripe_lock in
>> suspend_lo/hi_store
>> to avoid the race between raid6check and write to the same stripe. IOW,
>> try fine grained protection instead of call the expensive suspend/resume
>> in suspend_lo/hi_store. But I am not sure it is doable or not right now.
> Could you please elaborate on the
> "fine grained protection" thing?

Even raid6check checks stripe and locks stripe one by one, but the thing
is different in kernel space, locking of one stripe triggers mddev_suspend
and mddev_resume which affect all stripes ...

If kernel can expose interface to actually locking one stripe, then 
raid6check
could use it to actually lock only one stripe (this is what I call fine 
grained)
instead of trigger suspend/resume which are time consuming.

>   
>> BTW, seems there are build problems for raid6check ...
>>
>> mdadm$ make raid6check
>> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
>> -Wimplicit-fallthrough=0 -O2 -DSendmail=\""/usr/sbin/sendmail -t"\"
>> -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"
>> -DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
>> -DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM
>> -DVERSION=\"4.1-74-g5cfb79d\" -DVERS_DATE="\"2020-04-27\"" -DUSE_PTHREADS
>> -DBINDIR=\"/sbin\"  -o sysfs.o -c sysfs.c
>> gcc -O2  -o raid6check raid6check.o restripe.o sysfs.o maps.o lib.o
>> xmalloc.o dlink.o
>> sysfs.o: In function `sysfsline':
>> sysfs.c:(.text+0x2adb): undefined reference to `parse_uuid'
>> sysfs.c:(.text+0x2aee): undefined reference to `uuid_zero'
>> sysfs.c:(.text+0x2af5): undefined reference to `uuid_zero'
>> collect2: error: ld returned 1 exit status
>> Makefile:220: recipe for target 'raid6check' failed
>> make: *** [raid6check] Error 1
> I cannot see this problem.
> I could compile without issue.
> Maybe some library is missing somewhere,
> but I'm not sure where.

Do you try with the fastest mdadm tree? But could be environment issue ...

Thanks,
Guoqing
