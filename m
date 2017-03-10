From: Andrei Vagin <avagin@gmail.com>
Subject: linux-next: WARNING: CPU: 0 PID: 1 at lib/refcount.c:114 refcount_inc+0x37/0x40
Date: Fri, 10 Mar 2017 12:01:06 -0800
Message-ID: <CANaxB-xDKh+_0eR2p4rODObQPVFwNM1-vK=fmCV-jaBYpGkPAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Hello,

We run CRIU tests for linux-next kernels and here is a new issue:

All logs are here: https://api.travis-ci.org/jobs/209680974/log.txt?deansi=true
The kernel version is 4.11.0-rc1-next-20170310

[    2.324763] md: Waiting for all devices to be available before autodetect
[    2.331707] md: If you don't use raid, use raid=noautodetect
[    2.338189] ------------[ cut here ]------------
[    2.342965] WARNING: CPU: 0 PID: 1 at lib/refcount.c:114
refcount_inc+0x37/0x40
[    2.350427] refcount_t: increment on 0; use-after-free.
[    2.355794] Modules linked in:
[    2.358979] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
4.11.0-rc1-next-20170310 #1
[    2.362966] Hardware name: Google Google Compute Engine/Google
Compute Engine, BIOS Google 01/01/2011
[    2.362966] Call Trace:
[    2.362966]  dump_stack+0x85/0xc9
[    2.362966]  __warn+0xd1/0xf0
[    2.362966]  warn_slowpath_fmt+0x4f/0x60
[    2.362966]  refcount_inc+0x37/0x40
[    2.362966]  mddev_find+0x1f1/0x2b0
[    2.362966]  md_open+0x1a/0xd0
[    2.362966]  __blkdev_get+0x85/0x4c0
[    2.362966]  blkdev_get+0x1d3/0x340
[    2.362966]  ? _raw_spin_unlock+0x27/0x40
[    2.362966]  blkdev_open+0x5b/0x70
[    2.362966]  do_dentry_open+0x213/0x330
[    2.362966]  ? bd_acquire+0xd0/0xd0
[    2.362966]  vfs_open+0x4f/0x80
[    2.362966]  ? may_open+0x9b/0x100
[    2.362966]  path_openat+0x48a/0xd50
[    2.362966]  ? console_unlock+0x2f9/0x560
[    2.362966]  do_filp_open+0x7e/0xd0
[    2.362966]  ? _raw_spin_unlock+0x27/0x40
[    2.362966]  ? __alloc_fd+0xf7/0x210
[    2.362966]  do_sys_open+0x115/0x1f0
[    2.362966]  SyS_open+0x1e/0x20
[    2.362966]  md_run_setup+0x71/0x9a
[    2.362966]  prepare_namespace+0x36/0x1a4
[    2.362966]  kernel_init_freeable+0x254/0x269
[    2.362966]  ? set_debug_rodata+0x12/0x12
[    2.362966]  ? rest_init+0x140/0x140
[    2.362966]  kernel_init+0xe/0x100
[    2.362966]  ret_from_fork+0x31/0x40
[    2.482465] ---[ end trace a822b43a79b1f9f5 ]---
[    2.487353] md: Autodetecting RAID arrays.
[    2.491647] md: autorun ...
[    2.494592] md: ... autorun DONE.
[    2.503263] EXT4-fs (sda1): couldn't mount as ext3 due to feature
incompatibilities
[    2.511467] ------------[ cut here ]------------
[    2.511477] WARNING: CPU: 0 PID: 21 at lib/refcount.c:207
refcount_dec_not_one+0x75/0x80
[    2.511478] refcount_t: underflow; use-after-free.
[    2.511480] Modules linked in:
[    2.511485] CPU: 0 PID: 21 Comm: kworker/0:1 Tainted: G        W
   4.11.0-rc1-next-20170310 #1
[    2.511486] Hardware name: Google Google Compute Engine/Google
Compute Engine, BIOS Google 01/01/2011
[    2.511490] Workqueue: events delayed_fput
[    2.511492] Call Trace:
[    2.511496]  dump_stack+0x85/0xc9
[    2.511501]  __warn+0xd1/0xf0
[    2.511505]  warn_slowpath_fmt+0x4f/0x60
[    2.511509]  refcount_dec_not_one+0x75/0x80
[    2.511511]  refcount_dec_and_lock+0x16/0x50
[    2.511515]  mddev_put+0x22/0x150
[    2.511517]  md_release+0x21/0x30
[    2.511521]  __blkdev_put+0x2df/0x340
[    2.511526]  blkdev_put+0x50/0x150
[    2.511529]  blkdev_close+0x25/0x30
[    2.511531]  __fput+0xfa/0x230
[    2.511535]  delayed_fput+0x25/0x30
[    2.511538]  process_one_work+0x1e1/0x670
[    2.511539]  ? process_one_work+0x162/0x670
[    2.511544]  worker_thread+0x137/0x4b0
[    2.511546]  ? trace_hardirqs_on+0xd/0x10
[    2.511551]  kthread+0x10c/0x140
[    2.511552]  ? process_one_work+0x670/0x670
[    2.511554]  ? kthread_create_on_node+0x40/0x40
[    2.511558]  ret_from_fork+0x31/0x40
[    2.511566] ---[ end trace a822b43a79b1f9f6 ]---
