From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] md: create new workqueue for object destruction
Date: Wed, 18 Oct 2017 13:21:59 +0200
Message-ID: <6454f28e-4728-a10d-f3c3-b68afedec8d9@intel.com>
References: <87mv4qjrez.fsf@notabene.neil.brown.name>
 <20171018062137.ssdhwkeoy6fdp7yq@kernel.org>
 <87h8uwj4mz.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h8uwj4mz.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/18/2017 09:29 AM, NeilBrown wrote:
> On Tue, Oct 17 2017, Shaohua Li wrote:
> 
>> On Tue, Oct 17, 2017 at 04:04:52PM +1100, Neil Brown wrote:
>>>
>>> lockdep currently complains about a potential deadlock
>>> with sysfs access taking reconfig_mutex, and that
>>> waiting for a work queue to complete.
>>>
>>> The cause is inappropriate overloading of work-items
>>> on work-queues.
>>>
>>> We currently have two work-queues: md_wq and md_misc_wq.
>>> They service 5 different tasks:
>>>
>>>   mddev->flush_work                       md_wq
>>>   mddev->event_work (for dm-raid)         md_misc_wq
>>>   mddev->del_work (mddev_delayed_delete)  md_misc_wq
>>>   mddev->del_work (md_start_sync)         md_misc_wq
>>>   rdev->del_work                          md_misc_wq
>>>
>>> We need to call flush_workqueue() for md_start_sync and ->event_work
>>> while holding reconfig_mutex, but mustn't hold it when
>>> flushing mddev_delayed_delete or rdev->del_work.
>>>
>>> md_wq is a bit special as it has WQ_MEM_RECLAIM so it is
>>> best to leave that alone.
>>>
>>> So create a new workqueue, md_del_wq, and a new work_struct,
>>> mddev->sync_work, so we can keep two classes of work separate.
>>>
>>> md_del_wq and ->del_work are used only for destroying rdev
>>> and mddev.
>>> md_misc_wq is used for event_work and sync_work.
>>>
>>> Also document the purpose of each flush_workqueue() call.
>>>
>>> This removes the lockdep warning.
>>
>> I had the exactly same patch queued internally,
> 
> Cool :-)
> 
>>                                                   but the mdadm test suite still
>> shows lockdep warnning. I haven't time to check further.
>>
> 
> The only other lockdep I've seen later was some ext4 thing, though I
> haven't tried the full test suite.  I might have a look tomorrow.

I'm also seeing a lockdep warning with or without this patch,
reproducible with:

export IMSM_NO_PLATFORM=1 # for platforms without IMSM
mdadm -C /dev/md/imsm0 -eimsm -n4 /dev/sd[a-d] -R
mdadm -C /dev/md/vol0 -l5 -n4 /dev/sd[a-d] -R --assume-clean
mdadm -Ss

[   42.489474] md/raid:md126: device sdd operational as raid disk 3
[   42.490731] md/raid:md126: device sdc operational as raid disk 2
[   42.492363] md/raid:md126: device sdb operational as raid disk 1
[   42.494177] md/raid:md126: device sda operational as raid disk 0
[   42.500864] md/raid:md126: raid level 5 active with 4 out of 4 devices, algorithm 0
[   42.503740] md126: detected capacity change from 0 to 3208642560
[   45.177525] md126: detected capacity change from 3208642560 to 0
[   45.179136] md: md126 still in use.
[   45.185846] md: md126 stopped.
[   45.211960] 
[   45.212081] ======================================================
[   45.212081] WARNING: possible circular locking dependency detected
[   45.212081] 4.14.0-rc3+ #391 Not tainted
[   45.212081] ------------------------------------------------------
[   45.212081] kworker/1:0/17 is trying to acquire lock:
[   45.212081]  (kn->count#89){++++}, at: [<ffffffff812514f3>] kernfs_remove+0x23/0x40
[   45.212081] 
[   45.212081] but task is already holding lock:
[   45.212081]  ((&mddev->del_work)){+.+.}, at: [<ffffffff810783d0>] process_one_work+0x1c0/0x630
[   45.212081] 
[   45.212081] which lock already depends on the new lock.
[   45.212081] 
[   45.212081] 
[   45.212081] the existing dependency chain (in reverse order) is:
[   45.212081] 
[   45.212081] -> #2 ((&mddev->del_work)){+.+.}:
[   45.212081]        __lock_acquire+0xc48/0x1140
[   45.212081]        lock_acquire+0x19d/0x1d0
[   45.212081]        process_one_work+0x212/0x630
[   45.212081]        worker_thread+0x211/0x400
[   45.212081]        kthread+0x172/0x180
[   45.212081]        ret_from_fork+0x27/0x40
[   45.212081] 
[   45.212081] -> #1 ("md_del"){+.+.}:
[   45.212081]        __lock_acquire+0xc48/0x1140
[   45.212081]        lock_acquire+0x19d/0x1d0
[   45.212081]        flush_workqueue+0xbb/0x460
[   45.212081]        new_dev_store+0xb2/0x1e0 [md_mod]
[   45.212081]        md_attr_store+0x90/0xc0 [md_mod]
[   45.212081]        sysfs_kf_write+0x42/0x50
[   45.212081]        kernfs_fop_write+0x119/0x180
[   45.212081]        __vfs_write+0x28/0x110
[   45.212081]        vfs_write+0xb4/0x1a0
[   45.212081]        SyS_write+0x49/0xa0
[   45.212081]        entry_SYSCALL_64_fastpath+0x18/0xad
[   45.212081] 
[   45.212081] -> #0 (kn->count#89){++++}:
[   45.212081]        check_prev_add+0x125/0x690
[   45.212081]        __lock_acquire+0xc48/0x1140
[   45.212081]        lock_acquire+0x19d/0x1d0
[   45.212081]        __kernfs_remove+0x15e/0x270
[   45.212081]        kernfs_remove+0x23/0x40
[   45.212081]        sysfs_remove_dir+0x53/0x60
[   45.212081]        kobject_del+0x18/0x50
[   45.212081]        mddev_delayed_delete+0x28/0x40 [md_mod]
[   45.212081]        process_one_work+0x330/0x630
[   45.212081]        worker_thread+0x211/0x400
[   45.212081]        kthread+0x172/0x180
[   45.212081]        ret_from_fork+0x27/0x40
[   45.212081] 
[   45.212081] other info that might help us debug this:
[   45.212081] 
[   45.212081] Chain exists of:
[   45.212081]   kn->count#89 --> "md_del" --> (&mddev->del_work)
[   45.212081] 
[   45.212081]  Possible unsafe locking scenario:
[   45.212081] 
[   45.212081]        CPU0                    CPU1
[   45.212081]        ----                    ----
[   45.212081]   lock((&mddev->del_work));
[   45.212081]                                lock("md_del");
[   45.212081]                                lock((&mddev->del_work));
[   45.212081]   lock(kn->count#89);
[   45.212081] 
[   45.212081]  *** DEADLOCK ***
[   45.212081] 
[   45.212081] 2 locks held by kworker/1:0/17:
[   45.212081]  #0:  ("md_del"){+.+.}, at: [<ffffffff810783d0>] process_one_work+0x1c0/0x630
[   45.212081]  #1:  ((&mddev->del_work)){+.+.}, at: [<ffffffff810783d0>] process_one_work+0x1c0/0x630
[   45.212081] 
[   45.212081] stack backtrace:
[   45.212081] CPU: 1 PID: 17 Comm: kworker/1:0 Not tainted 4.14.0-rc3+ #391
[   45.212081] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[   45.212081] Workqueue: md_del mddev_delayed_delete [md_mod]
[   45.212081] Call Trace:
[   45.212081]  dump_stack+0x70/0x9a
[   45.212081]  print_circular_bug+0x2d3/0x2f0
[   45.212081]  ? __print_lock_name+0x80/0x80
[   45.212081]  check_prev_add+0x125/0x690
[   45.212081]  ? ret_from_fork+0x27/0x40
[   45.212081]  __lock_acquire+0xc48/0x1140
[   45.212081]  ? __lock_acquire+0xc48/0x1140
[   45.212081]  ? __print_lock_name+0x80/0x80
[   45.212081]  lock_acquire+0x19d/0x1d0
[   45.212081]  ? kernfs_remove+0x23/0x40
[   45.212081]  __kernfs_remove+0x15e/0x270
[   45.212081]  ? kernfs_remove+0x23/0x40
[   45.212081]  kernfs_remove+0x23/0x40
[   45.212081]  sysfs_remove_dir+0x53/0x60
[   45.212081]  kobject_del+0x18/0x50
[   45.212081]  mddev_delayed_delete+0x28/0x40 [md_mod]
[   45.212081]  process_one_work+0x330/0x630
[   45.212081]  worker_thread+0x211/0x400
[   45.212081]  kthread+0x172/0x180
[   45.212081]  ? process_one_work+0x630/0x630
[   45.212081]  ? kthread_stop+0x250/0x250
[   45.212081]  ret_from_fork+0x27/0x40
[   45.295721] md: md127 stopped.

Thanks,
Artur
