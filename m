From: Coly Li <colyli@suse.de>
Subject: [BUG REPORT] suspicious deadlock when stopping md raid5 on 5.6-rc7
 kernel
Date: Thu, 26 Mar 2020 10:26:12 +0800
Message-ID: <4a0ac66e-3deb-313a-60bb-ae1a2d45b751@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, Song Liu <songliubraving@fb.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
List-Id: linux-raid.ids

Hi Song and Guoqing,

Here is the step how I encounter the lockdep warning (yes lockdep engine
enabled),

export IMSM_NO_PLATFORM=1
mdadm -CR imsm0 -e imsm -n 4 /dev/nvme{0,1,2,3}n1
mdadm -CR vol5 -l 5 -n 3 /dev/nvme{0,1,2}n1 --assume-clean
mdadm --manage --stop /dev/md126
(The warning message shows up when I run the above line to stop md126)
mdadm --manage --stop /dev/md127

The kernel is just upstream Linux kernel with 5.6-rc7 tag. I use 4 NVMe
SSD to reproduce another issue, and encounter the following warning by
the above steps,

[ 1604.255664] ======================================================
[ 1604.329616] WARNING: possible circular locking dependency detected
[ 1604.403579] 5.6.0-rc7-default #5 Tainted: G            E
[ 1604.471295] ------------------------------------------------------
[ 1604.545253] kworker/5:0/843 is trying to acquire lock:
[ 1604.606731] ffff8889ff2d11e8 (kn->count#256){++++}, at:
kernfs_remove+0x1f/0x30
[ 1604.694230]
[ 1604.694230] but task is already holding lock:
[ 1604.764026] ffff888a1d3b7e10
((work_completion)(&rdev->del_work)){+.+.}, at: process_one_work+0x42b/0xb30
[ 1604.878564]
[ 1604.878564] which lock already depends on the new lock.
[ 1604.878564]
[ 1604.976436]
[ 1604.976436] the existing dependency chain (in reverse order) is:
[ 1605.065993]
[ 1605.065993] -> #4 ((work_completion)(&rdev->del_work)){+.+.}:
[ 1605.152443]        process_one_work+0x4b5/0xb30
[ 1605.206643]        worker_thread+0x65/0x5a0
[ 1605.256688]        kthread+0x1d9/0x200
[ 1605.301535]        ret_from_fork+0x3a/0x50
[ 1605.350527]
[ 1605.350527] -> #3 ((wq_completion)md_misc){+.+.}:
[ 1605.424495]        flush_workqueue+0xfb/0x990
[ 1605.476653]        __md_stop_writes+0x34/0x1f0 [md_mod]
[ 1605.539206]        do_md_stop+0x2b8/0xb40 [md_mod]
[ 1605.596561]        array_state_store+0x297/0x450 [md_mod]
[ 1605.661196]        md_attr_store+0xb3/0x100 [md_mod]
[ 1605.720598]        kernfs_fop_write+0x1a0/0x240
[ 1605.774799]        vfs_write+0xff/0x280
[ 1605.820679]        ksys_write+0x120/0x170
[ 1605.868646]        do_syscall_64+0x78/0x330
[ 1605.918686]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 1605.985361]
[ 1605.985361] -> #2 (&mddev->open_mutex){+.+.}:
[ 1606.055161]        __mutex_lock+0x12f/0xd20
[ 1606.105233]        do_md_stop+0x1ee/0xb40 [md_mod]
[ 1606.162587]        array_state_store+0x297/0x450 [md_mod]
[ 1606.227219]        md_attr_store+0xb3/0x100 [md_mod]
[ 1606.286618]        kernfs_fop_write+0x1a0/0x240
[ 1606.340822]        vfs_write+0xff/0x280
[ 1606.386703]        ksys_write+0x120/0x170
[ 1606.434660]        do_syscall_64+0x78/0x330
[ 1606.484704]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 1606.551380]
[ 1606.551380] -> #1 (&mddev->reconfig_mutex){+.+.}:
[ 1606.625341]        __mutex_lock+0x12f/0xd20
[ 1606.675412]        rdev_attr_store+0x6f/0xf0 [md_mod]
[ 1606.735853]        kernfs_fop_write+0x1a0/0x240
[ 1606.790050]        vfs_write+0xff/0x280
[ 1606.835931]        ksys_write+0x120/0x170
[ 1606.883888]        do_syscall_64+0x78/0x330
[ 1606.933927]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 1607.000604]
[ 1607.000604] -> #0 (kn->count#256){++++}:
[ 1607.065213]        __lock_acquire+0x1ba8/0x1f50
[ 1607.119413]        lock_acquire+0xf3/0x240
[ 1607.168408]        __kernfs_remove+0x45b/0x4f0
[ 1607.221563]        kernfs_remove+0x1f/0x30
[ 1607.270564]        kobject_del+0x50/0xa0
[ 1607.317515]        md_delayed_delete+0x15/0x20 [md_mod]
[ 1607.380035]        process_one_work+0x50c/0xb30
[ 1607.434238]        worker_thread+0x65/0x5a0
[ 1607.484279]        kthread+0x1d9/0x200
[ 1607.529116]        ret_from_fork+0x3a/0x50
[ 1607.578110]
[ 1607.578110] other info that might help us debug this:
[ 1607.578110]
[ 1607.673903] Chain exists of:
[ 1607.673903]   kn->count#256 --> (wq_completion)md_misc -->
(work_completion)(&rdev->del_work)
[ 1607.673903]
[ 1607.827946]  Possible unsafe locking scenario:
[ 1607.827946]
[ 1607.898780]        CPU0                    CPU1
[ 1607.952980]        ----                    ----
[ 1608.007173]   lock((work_completion)(&rdev->del_work));
[ 1608.069690]                                lock((wq_completion)md_misc);
[ 1608.149887]
lock((work_completion)(&rdev->del_work));
[ 1608.242563]   lock(kn->count#256);
[ 1608.283238]
[ 1608.283238]  *** DEADLOCK ***
[ 1608.283238]
[ 1608.354078] 2 locks held by kworker/5:0/843:
[ 1608.405152]  #0: ffff8889eecc9948 ((wq_completion)md_misc){+.+.}, at:
process_one_work+0x42b/0xb30
[ 1608.512399]  #1: ffff888a1d3b7e10
((work_completion)(&rdev->del_work)){+.+.}, at: process_one_work+0x42b/0xb30
[ 1608.632130]
[ 1608.632130] stack backtrace:
[ 1608.684254] CPU: 5 PID: 843 Comm: kworker/5:0 Tainted: G            E
    5.6.0-rc7-default #5
[ 1608.787332] Hardware name: Lenovo ThinkSystem SR650
-[7X05CTO1WW]-/-[7X05CTO1WW]-, BIOS -[IVE148M-2.41]- 10/31/2019
[ 1608.912287] Workqueue: md_misc md_delayed_delete [md_mod]
[ 1608.976886] Call Trace:
[ 1609.006132]  dump_stack+0xb7/0x10b
[ 1609.046814]  check_noncircular+0x2c4/0x320
[ 1609.095818]  ? print_circular_bug.isra.36+0x240/0x240
[ 1609.156279]  ? __lockdep_free_key_range+0xb0/0xb0
[ 1609.212564]  ? __lock_acquire+0x1ba8/0x1f50
[ 1609.262606]  __lock_acquire+0x1ba8/0x1f50
[ 1609.310574]  ? register_lock_class+0x8c0/0x8c0
[ 1609.363741]  lock_acquire+0xf3/0x240
[ 1609.406501]  ? kernfs_remove+0x1f/0x30
[ 1609.451349]  __kernfs_remove+0x45b/0x4f0
[ 1609.498267]  ? kernfs_remove+0x1f/0x30
[ 1609.543106]  ? kernfs_fop_readdir+0x3b0/0x3b0
[ 1609.595240]  kernfs_remove+0x1f/0x30
[ 1609.638003]  kobject_del+0x50/0xa0
[ 1609.678721]  md_delayed_delete+0x15/0x20 [md_mod]
[ 1609.735005]  process_one_work+0x50c/0xb30
[ 1609.782974]  ? pwq_dec_nr_in_flight+0x120/0x120
[ 1609.837188]  worker_thread+0x65/0x5a0
[ 1609.880997]  ? process_one_work+0xb30/0xb30
[ 1609.931037]  kthread+0x1d9/0x200
[ 1609.969638]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[ 1610.030080]  ret_from_fork+0x3a/0x50
[ 1809.448921] md: md127 stopped.

Just FYI.
-- 

Coly Li
