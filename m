From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] md: create new workqueue for object destruction
Date: Thu, 19 Oct 2017 10:27:43 +0200
Message-ID: <9759b574-2d3f-de45-0840-c84d9cc10528@intel.com>
References: <87mv4qjrez.fsf@notabene.neil.brown.name>
 <20171018062137.ssdhwkeoy6fdp7yq@kernel.org>
 <87h8uwj4mz.fsf@notabene.neil.brown.name>
 <6454f28e-4728-a10d-f3c3-b68afedec8d9@intel.com>
 <87376ghyms.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87376ghyms.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/19/2017 12:36 AM, NeilBrown wrote:
> On Wed, Oct 18 2017, Artur Paszkiewicz wrote:
> 
>> On 10/18/2017 09:29 AM, NeilBrown wrote:
>>> On Tue, Oct 17 2017, Shaohua Li wrote:
>>>
>>>> On Tue, Oct 17, 2017 at 04:04:52PM +1100, Neil Brown wrote:
>>>>>
>>>>> lockdep currently complains about a potential deadlock
>>>>> with sysfs access taking reconfig_mutex, and that
>>>>> waiting for a work queue to complete.
>>>>>
>>>>> The cause is inappropriate overloading of work-items
>>>>> on work-queues.
>>>>>
>>>>> We currently have two work-queues: md_wq and md_misc_wq.
>>>>> They service 5 different tasks:
>>>>>
>>>>>   mddev->flush_work                       md_wq
>>>>>   mddev->event_work (for dm-raid)         md_misc_wq
>>>>>   mddev->del_work (mddev_delayed_delete)  md_misc_wq
>>>>>   mddev->del_work (md_start_sync)         md_misc_wq
>>>>>   rdev->del_work                          md_misc_wq
>>>>>
>>>>> We need to call flush_workqueue() for md_start_sync and ->event_work
>>>>> while holding reconfig_mutex, but mustn't hold it when
>>>>> flushing mddev_delayed_delete or rdev->del_work.
>>>>>
>>>>> md_wq is a bit special as it has WQ_MEM_RECLAIM so it is
>>>>> best to leave that alone.
>>>>>
>>>>> So create a new workqueue, md_del_wq, and a new work_struct,
>>>>> mddev->sync_work, so we can keep two classes of work separate.
>>>>>
>>>>> md_del_wq and ->del_work are used only for destroying rdev
>>>>> and mddev.
>>>>> md_misc_wq is used for event_work and sync_work.
>>>>>
>>>>> Also document the purpose of each flush_workqueue() call.
>>>>>
>>>>> This removes the lockdep warning.
>>>>
>>>> I had the exactly same patch queued internally,
>>>
>>> Cool :-)
>>>
>>>>                                                   but the mdadm test suite still
>>>> shows lockdep warnning. I haven't time to check further.
>>>>
>>>
>>> The only other lockdep I've seen later was some ext4 thing, though I
>>> haven't tried the full test suite.  I might have a look tomorrow.
>>
>> I'm also seeing a lockdep warning with or without this patch,
>> reproducible with:
>>
> 
> Thanks!
> Looks like using one workqueue for mddev->del_work and rdev->del_work
> causes problems.
> Can you try with this addition please?

It helped for that case but now there is another warning triggered by:

export IMSM_NO_PLATFORM=1 # for platforms without IMSM
mdadm -C /dev/md/imsm0 -eimsm -n4 /dev/sd[a-d] -R
mdadm -C /dev/md/vol0 -l5 -n4 /dev/sd[a-d] -R --assume-clean
mdadm -If sda
mdadm -a /dev/md127 /dev/sda
mdadm -Ss

[  143.610826] ======================================================
[  143.611111] WARNING: possible circular locking dependency detected
[  143.611111] 4.14.0-rc3+ #391 Not tainted
[  143.611111] ------------------------------------------------------
[  143.611111] mdmon/3635 is trying to acquire lock:
[  143.611111]  ("md_del"){+.+.}, at: [<ffffffff810758a4>] flush_workqueue+0x94/0x460
[  143.611111]
[  143.611111] but task is already holding lock:
[  143.611111]  (&bdev->bd_mutex){+.+.}, at: [<ffffffff8120da08>] __blkdev_get+0x58/0x410
[  143.611111]
[  143.611111] which lock already depends on the new lock.
[  143.611111]
[  143.611111]
[  143.611111] the existing dependency chain (in reverse order) is:
[  143.611111]
[  143.611111] -> #4 (&bdev->bd_mutex){+.+.}:
[  143.611111]        __lock_acquire+0xc48/0x1140
[  143.611111]        lock_acquire+0x19d/0x1d0
[  143.611111]        __mutex_lock+0x70/0x8f0
[  143.611111]        mutex_lock_nested+0x1b/0x20
[  143.611111]        __blkdev_get+0x58/0x410
[  143.611111]        blkdev_get+0x2e3/0x370
[  143.611111]        blkdev_get_by_dev+0x36/0x50
[  143.611111]        lock_rdev+0x32/0x70 [md_mod]
[  143.611111]        md_import_device+0x83/0x1a0 [md_mod]
[  143.611111]        new_dev_store+0x15a/0x1e0 [md_mod]
[  143.611111]        md_attr_store+0x90/0xc0 [md_mod]
[  143.611111]        sysfs_kf_write+0x42/0x50
[  143.611111]        kernfs_fop_write+0x119/0x180
[  143.611111]        __vfs_write+0x28/0x110
[  143.611111]        vfs_write+0xb4/0x1a0
[  143.611111]        SyS_write+0x49/0xa0
[  143.611111]        entry_SYSCALL_64_fastpath+0x18/0xad
[  143.611111]
[  143.611111] -> #3 (&mddev->reconfig_mutex){+.+.}:
[  143.611111]        __lock_acquire+0xc48/0x1140
[  143.611111]        lock_acquire+0x19d/0x1d0
[  143.611111]        __mutex_lock+0x70/0x8f0
[  143.611111]        mutex_lock_interruptible_nested+0x1b/0x20
[  143.611111]        layout_store+0x3e/0x110 [md_mod]
[  143.611111]        md_attr_store+0x90/0xc0 [md_mod]
[  143.611111]        sysfs_kf_write+0x42/0x50
[  143.611111]        kernfs_fop_write+0x119/0x180
[  143.611111]        __vfs_write+0x28/0x110
[  143.611111]        vfs_write+0xb4/0x1a0
[  143.611111]        SyS_write+0x49/0xa0
[  143.611111]        entry_SYSCALL_64_fastpath+0x18/0xad
[  143.611111]
[  143.611111] -> #2 (kn->count#99){++++}:
[  143.611111]        __lock_acquire+0xc48/0x1140
[  143.611111]        lock_acquire+0x19d/0x1d0
[  143.611111]        __kernfs_remove+0x15e/0x270
[  143.611111]        kernfs_remove+0x23/0x40
[  143.611111]        sysfs_remove_dir+0x53/0x60
[  143.611111]        kobject_del+0x18/0x50
[  143.611111]        mddev_delayed_delete+0x28/0x40 [md_mod]
[  143.611111]        process_one_work+0x330/0x630
[  143.611111]        worker_thread+0x211/0x400
[  143.611111]        kthread+0x172/0x180
[  143.611111]        ret_from_fork+0x27/0x40
[  143.611111]
[  143.611111] -> #1 ((&mddev->del_work)){+.+.}:
[  143.611111]        __lock_acquire+0xc48/0x1140
[  143.611111]        lock_acquire+0x19d/0x1d0
[  143.611111]        process_one_work+0x212/0x630
[  143.611111]        worker_thread+0x211/0x400
[  143.611111]        kthread+0x172/0x180
[  143.611111]        ret_from_fork+0x27/0x40
[  143.611111]
[  143.611111] -> #0 ("md_del"){+.+.}:
[  143.611111]        check_prev_add+0x125/0x690
[  143.611111]        __lock_acquire+0xc48/0x1140
[  143.611111]        lock_acquire+0x19d/0x1d0
[  143.611111]        flush_workqueue+0xbb/0x460
[  143.611111]        md_open+0x4e/0xc0 [md_mod]
[  143.611111]        __blkdev_get+0xe0/0x410
[  143.611111]        blkdev_get+0x2e3/0x370
[  143.611111]        blkdev_open+0x9f/0xb0
[  143.611111]        do_dentry_open.isra.17+0x1b2/0x2e0
[  143.611111]        vfs_open+0x5f/0x70
[  143.611111]        path_openat+0x7d6/0xb80
[  143.611111]        do_filp_open+0x8e/0xe0
[  143.611111]        do_sys_open+0x183/0x220
[  143.611111]        SyS_open+0x1e/0x20
[  143.611111]        entry_SYSCALL_64_fastpath+0x18/0xad
[  143.611111]
[  143.611111] other info that might help us debug this:
[  143.611111]
[  143.611111] Chain exists of:
[  143.611111]   "md_del" --> &mddev->reconfig_mutex --> &bdev->bd_mutex
[  143.611111]
[  143.611111]  Possible unsafe locking scenario:
[  143.611111]
[  143.611111]        CPU0                    CPU1
[  143.611111]        ----                    ----
[  143.611111]   lock(&bdev->bd_mutex);
[  143.611111]                                lock(&mddev->reconfig_mutex);
[  143.611111]                                lock(&bdev->bd_mutex);
[  143.611111]   lock("md_del");
[  143.611111]
[  143.611111]  *** DEADLOCK ***
[  143.611111]
[  143.611111] 1 lock held by mdmon/3635:
[  143.611111]  #0:  (&bdev->bd_mutex){+.+.}, at: [<ffffffff8120da08>] __blkdev_get+0x58/0x410
[  143.611111]
[  143.611111] stack backtrace:
[  143.611111] CPU: 1 PID: 3635 Comm: mdmon Not tainted 4.14.0-rc3+ #391
[  143.611111] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[  143.611111] Call Trace:
[  143.611111]  dump_stack+0x70/0x9a
[  143.611111]  print_circular_bug+0x2d3/0x2f0
[  143.611111]  ? __print_lock_name+0x80/0x80
[  143.611111]  check_prev_add+0x125/0x690
[  143.611111]  ? __module_address+0x2c/0xe0
[  143.611111]  ? md_open+0x1a/0xc0 [md_mod]
[  143.611111]  ? md_open+0x1a/0xc0 [md_mod]
[  143.611111]  __lock_acquire+0xc48/0x1140
[  143.611111]  ? __lock_acquire+0xc48/0x1140
[  143.611111]  ? __print_lock_name+0x80/0x80
[  143.611111]  lock_acquire+0x19d/0x1d0
[  143.611111]  ? flush_workqueue+0x94/0x460
[  143.611111]  flush_workqueue+0xbb/0x460
[  143.611111]  ? flush_workqueue+0x94/0x460
[  143.611111]  md_open+0x4e/0xc0 [md_mod]
[  143.611111]  ? md_open+0x4e/0xc0 [md_mod]
[  143.611111]  __blkdev_get+0xe0/0x410
[  143.611111]  blkdev_get+0x2e3/0x370
[  143.611111]  ? bd_acquire+0xd0/0xd0
[  143.611111]  ? _raw_spin_unlock+0x27/0x40
[  143.611111]  ? bd_acquire+0xd0/0xd0
[  143.611111]  blkdev_open+0x9f/0xb0
[  143.611111]  do_dentry_open.isra.17+0x1b2/0x2e0
[  143.611111]  vfs_open+0x5f/0x70
[  143.611111]  path_openat+0x7d6/0xb80
[  143.611111]  do_filp_open+0x8e/0xe0
[  143.611111]  ? _raw_spin_unlock+0x27/0x40
[  143.611111]  ? __alloc_fd+0x1be/0x1e0
[  143.611111]  do_sys_open+0x183/0x220
[  143.611111]  ? do_sys_open+0x183/0x220
[  143.611111]  SyS_open+0x1e/0x20
[  143.611111]  entry_SYSCALL_64_fastpath+0x18/0xad
[  143.611111] RIP: 0033:0x7f5a8bcb91ad
[  143.611111] RSP: 002b:00007f5a8b900d10 EFLAGS: 00000293 ORIG_RAX: 0000000000000002
[  143.611111] RAX: ffffffffffffffda RBX: 000000000101f08c RCX: 00007f5a8bcb91ad
[  143.611111] RDX: 000000000000097f RSI: 0000000000004080 RDI: 00007f5a8b900d40
[  143.611111] RBP: 0000000000000006 R08: 00007f5a8b900d40 R09: 00007f5a8bca3440
[  143.611111] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000006
[  143.611111] R13: 000000000101f08c R14: 0000000000000000 R15: 00007f5a8b901700

Thanks,
Artur
