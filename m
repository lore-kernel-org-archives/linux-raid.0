From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: I/O hangs after resuming from suspend-to-ram
Date: Sat, 26 Aug 2017 15:32:25 +0200
Message-ID: <4530731.pIzNTb4XdV@natalenko.name>
References: <3926917.BCSovyVWdL@natalenko.name> <2602983.s9jWEo5DpR@natalenko.name> <1579257.t1hTzJa9iD@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1579257.t1hTzJa9iD@natalenko.name>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Recompiled v4.13-rc6 with debug info and lockdep.

Unfortunately, still cannot use crash utility because 7.1.9 does not suppor=
t=20
v4.13 (and git HEAD with required fix for 5-level pagetable does not compil=
e=20
for me).

But I've got much nicer stacktrace + lockdep output (check paste below).

Looks like kernel is blocked on device mutex here:

1510 void scsi_rescan_device(struct device *dev)
1511 {
1512     struct scsi_device *sdev =3D to_scsi_device(dev);
1513=20
1514     device_lock(dev); // here

and md0_raid10 kthread is blocked on I/O scheduling point in blk_mq_get_tag=
().

Again, with blk-mq this issue is not reproducible.

=3D=3D=3D
[   62.789665] INFO: task kworker/2:1:36 blocked for more than 20 seconds.
[   62.793858]       Not tainted 4.13.0-rc6 #3
[   62.796537] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[   62.800467] kworker/2:1     D13856    36      2 0x00000000
[   62.802934] Workqueue: events ata_scsi_dev_rescan
[   62.805207] Call Trace:
[   62.806957]  __schedule+0x8d7/0x930
[   62.809956]  schedule+0x73/0x90
[   62.812677]  schedule_preempt_disabled+0x13/0x20
[   62.816012]  __mutex_lock+0x54f/0x820
[   62.819050]  ? scsi_rescan_device+0x21/0x90
[   62.821930]  ? mark_held_locks+0x58/0x80
[   62.823994]  mutex_lock_nested+0x16/0x20
[   62.825984]  ? mutex_lock_nested+0x16/0x20
[   62.828032]  scsi_rescan_device+0x21/0x90
[   62.830174]  ata_scsi_dev_rescan+0xa1/0x110
[   62.832732]  process_one_work+0x32a/0x620
[   62.835328]  worker_thread+0x221/0x3f0
[   62.837553]  kthread+0x124/0x130
[   62.839215]  ? process_one_work+0x620/0x620
[   62.841293]  ? kthread_stop+0x260/0x260
[   62.843887]  ret_from_fork+0x2a/0x40
[   62.846664] INFO: task kworker/0:1:37 blocked for more than 20 seconds.
[   62.849751]       Not tainted 4.13.0-rc6 #3
[   62.851724] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[   62.856832] kworker/0:1     D13664    37      2 0x00000000
[   62.859750] Workqueue: events ata_scsi_dev_rescan
[   62.862611] Call Trace:
[   62.864213]  __schedule+0x8d7/0x930
[   62.866859]  schedule+0x73/0x90
[   62.869507]  schedule_preempt_disabled+0x13/0x20
[   62.871662]  __mutex_lock+0x54f/0x820
[   62.873541]  ? scsi_rescan_device+0x21/0x90
[   62.875580]  ? mark_held_locks+0x58/0x80
[   62.877871]  mutex_lock_nested+0x16/0x20
[   62.880760]  ? mutex_lock_nested+0x16/0x20
[   62.883544]  scsi_rescan_device+0x21/0x90
[   62.886288]  ata_scsi_dev_rescan+0xa1/0x110
[   62.888766]  process_one_work+0x32a/0x620
[   62.891593]  worker_thread+0x221/0x3f0
[   62.894223]  kthread+0x124/0x130
[   62.895974]  ? process_one_work+0x620/0x620
[   62.898643]  ? kthread_stop+0x260/0x260
[   62.902062]  ret_from_fork+0x2a/0x40
[   62.905109] INFO: task kworker/1:1:40 blocked for more than 20 seconds.
[   62.908068]       Not tainted 4.13.0-rc6 #3
[   62.910115] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[   62.913326] kworker/1:1     D13888    40      2 0x00000000
[   62.915904] Workqueue: events ata_scsi_dev_rescan
[   62.918133] Call Trace:
[   62.919958]  __schedule+0x8d7/0x930
[   62.922615]  schedule+0x73/0x90
[   62.925042]  schedule_preempt_disabled+0x13/0x20
[   62.928377]  __mutex_lock+0x54f/0x820
[   62.930915]  ? scsi_rescan_device+0x21/0x90
[   62.933510]  ? mark_held_locks+0x58/0x80
[   62.936079]  mutex_lock_nested+0x16/0x20
[   62.938122]  ? mutex_lock_nested+0x16/0x20
[   62.940394]  scsi_rescan_device+0x21/0x90
[   62.942405]  ata_scsi_dev_rescan+0xa1/0x110
[   62.944491]  process_one_work+0x32a/0x620
[   62.946580]  worker_thread+0x221/0x3f0
[   62.948719]  kthread+0x124/0x130
[   62.950708]  ? process_one_work+0x620/0x620
[   62.953185]  ? kthread_stop+0x260/0x260
[   62.955792]  ret_from_fork+0x2a/0x40
[   62.958235] INFO: task md0_raid10:1716 blocked for more than 20 seconds.
[   62.962058]       Not tainted 4.13.0-rc6 #3
[   62.965328] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[   62.970630] md0_raid10      D13696  1716      2 0x00000000
[   62.972990] Call Trace:
[   62.975155]  __schedule+0x8d7/0x930
[   62.977618]  ? sbitmap_get+0x4e/0xa0
[   62.979601]  schedule+0x73/0x90
[   62.981206]  io_schedule+0x11/0x40
[   62.982862]  blk_mq_get_tag+0x13e/0x250
[   62.984641]  ? blk_mq_get_request+0xdb/0x400
[   62.986555]  ? do_wait_intr_irq+0x80/0x80
[   62.988503]  blk_mq_get_request+0x1a8/0x400
[   62.990636]  blk_mq_make_request+0x22f/0x7c0
[   62.992783]  ? generic_make_request+0xcb/0x360
[   62.995084]  generic_make_request+0xf8/0x360
[   62.997735]  submit_bio+0x10f/0x120
[   62.999500]  ? submit_bio+0x10f/0x120
[   63.002395]  md_super_write+0xc8/0xe0
[   63.005273]  md_update_sb+0x533/0x6e0
[   63.007286]  md_check_recovery+0x1ee/0x4b0
[   63.010229]  raid10d+0x4b/0x15e0
[   63.012121]  ? finish_wait+0x57/0x60
[   63.015065]  ? trace_hardirqs_on_caller+0x178/0x1a0
[   63.018147]  ? trace_hardirqs_on+0xd/0x10
[   63.020969]  md_thread+0xd9/0x120
[   63.023033]  ? md_thread+0xd9/0x120
[   63.025723]  ? do_wait_intr_irq+0x80/0x80
[   63.028288]  kthread+0x124/0x130
[   63.029947]  ? find_pers+0x60/0x60
[   63.031410]  ? kthread_stop+0x260/0x260
[   63.032922]  ? umh_complete+0x40/0x40
[   63.034415]  ? call_usermodehelper_exec_async+0x12f/0x160
[   63.037659]  ret_from_fork+0x2a/0x40
[   63.039245] INFO: task md0_resync:1720 blocked for more than 20 seconds.
[   63.042346]       Not tainted 4.13.0-rc6 #3
[   63.044393] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[   63.048591] md0_resync      D13104  1720      2 0x00000000
[   63.051279] Call Trace:
[   63.053335]  __schedule+0x8d7/0x930
[   63.056151]  ? blk_flush_plug_list+0xd5/0x250
[   63.058725]  schedule+0x73/0x90
[   63.060382]  io_schedule+0x11/0x40
[   63.062212]  blk_mq_get_tag+0x13e/0x250
[   63.064222]  ? blk_mq_get_request+0xdb/0x400
[   63.066339]  ? do_wait_intr_irq+0x80/0x80
[   63.068875]  blk_mq_get_request+0x1a8/0x400
[   63.071329]  blk_mq_make_request+0x22f/0x7c0
[   63.073599]  ? generic_make_request+0xcb/0x360
[   63.076392]  generic_make_request+0xf8/0x360
[   63.078033]  raid10_sync_request+0x214a/0x2290
[   63.080008]  ? raid10_sync_request+0x214a/0x2290
[   63.081820]  ? find_held_lock+0x35/0xa0
[   63.083345]  ? rcu_read_unlock+0x3e/0x5d
[   63.086222]  ? is_mddev_idle+0x101/0x113
[   63.088684]  md_do_sync+0x960/0xe90
[   63.090960]  ? do_wait_intr_irq+0x80/0x80
[   63.093329]  md_thread+0xd9/0x120
[   63.095277]  ? md_thread+0xd9/0x120
[   63.097438]  ? trace_hardirqs_on+0xd/0x10
[   63.100310]  kthread+0x124/0x130
[   63.102471]  ? find_pers+0x60/0x60
[   63.104895]  ? kthread_stop+0x260/0x260
[   63.107208]  ? umh_complete+0x40/0x40
[   63.110149]  ? call_usermodehelper_exec_async+0x12f/0x160
[   63.113570]  ret_from_fork+0x2a/0x40
[   63.138339] INFO: task systemd-sleep:2599 blocked for more than 20 secon=
ds.
[   63.141320]       Not tainted 4.13.0-rc6 #3
[   63.143560] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[   63.147738] systemd-sleep   D12640  2599      1 0x00000080
[   63.150645] Call Trace:
[   63.152842]  __schedule+0x8d7/0x930
[   63.156430]  schedule+0x73/0x90
[   63.158521]  async_synchronize_cookie_domain+0x6c/0xa0
[   63.161252]  ? do_wait_intr_irq+0x80/0x80
[   63.163461]  async_synchronize_full+0x12/0x20
[   63.166359]  dpm_resume+0x303/0x480
[   63.168656]  ? rcu_read_lock_sched_held+0x78/0xa0
[   63.171555]  dpm_resume_end+0xc/0x20
[   63.174369]  suspend_devices_and_enter+0x62f/0x990
[   63.177177]  ? printk+0x3e/0x46
[   63.179845]  ? rcu_read_lock_sched_held+0x78/0xa0
[   63.182931]  pm_suspend+0x2a8/0x490
[   63.185463]  state_store+0xaf/0xe0
[   63.187429]  kobj_attr_store+0xf/0x20
[   63.190402]  sysfs_kf_write+0x3d/0x50
[   63.192772]  kernfs_fop_write+0x114/0x180
[   63.195435]  __vfs_write+0x23/0x110
[   63.197935]  ? rcu_read_lock_sched_held+0x78/0xa0
[   63.201616]  ? rcu_sync_lockdep_assert+0x27/0x50
[   63.204820]  ? __sb_start_write+0x95/0x1f0
[   63.207522]  vfs_write+0xc0/0x180
[   63.209411]  SyS_write+0x44/0xa0
[   63.211155]  do_syscall_64+0x64/0x120
[   63.212996]  entry_SYSCALL64_slow_path+0x25/0x25
[   63.215264] RIP: 0033:0x7f160e214bf0
[   63.217244] RSP: 002b:00007fffa8f08e08 EFLAGS: 00000246 ORIG_RAX:=20
0000000000000001
[   63.222682] RAX: ffffffffffffffda RBX: 0000000000000004 RCX:=20
00007f160e214bf0
[   63.226774] RDX: 0000000000000004 RSI: 0000565398088390 RDI:=20
0000000000000004
[   63.231227] RBP: 0000565398088390 R08: 0000565398088240 R09:=20
00007f160e6e28c0
[   63.234773] R10: 00007f160e4d5ad8 R11: 0000000000000246 R12:=20
0000000000000004
[   63.237877] R13: 0000000000000001 R14: 0000565398088160 R15:=20
0000000000000004
[   63.240832] INFO: task kworker/u8:20:2615 blocked for more than 20 secon=
ds.
[   63.243874]       Not tainted 4.13.0-rc6 #3
[   63.246036] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[   63.249754] kworker/u8:20   D14128  2615      2 0x00000080
[   63.252260] Workqueue: events_unbound async_run_entry_fn
[   63.254765] Call Trace:
[   63.256338]  __schedule+0x8d7/0x930
[   63.258270]  schedule+0x73/0x90
[   63.260107]  async_synchronize_cookie_domain+0x6c/0xa0
[   63.262473]  ? do_wait_intr_irq+0x80/0x80
[   63.264494]  ? async_sdev_thaw+0x20/0x20
[   63.266467]  ? scsi_bus_thaw+0x20/0x20
[   63.268372]  async_synchronize_full_domain+0x13/0x20
[   63.271074]  scsi_bus_resume_common+0x95/0x140
[   63.274168]  scsi_bus_resume+0x10/0x20
[   63.277058]  dpm_run_callback+0x142/0x290
[   63.279259]  device_resume+0x192/0x1e0
[   63.280883]  async_resume+0x18/0x40
[   63.282321]  async_run_entry_fn+0x32/0xd0
[   63.283856]  process_one_work+0x32a/0x620
[   63.285390]  worker_thread+0x221/0x3f0
[   63.286885]  kthread+0x124/0x130
[   63.288515]  ? process_one_work+0x620/0x620
[   63.290482]  ? kthread_stop+0x260/0x260
[   63.292203]  ret_from_fork+0x2a/0x40
[   63.294060] INFO: task kworker/u8:21:2616 blocked for more than 20 secon=
ds.
[   63.296818]       Not tainted 4.13.0-rc6 #3
[   63.299821] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[   63.305221] kworker/u8:21   D14392  2616      2 0x00000080
[   63.308313] Workqueue: events_unbound async_run_entry_fn
[   63.312513] Call Trace:
[   63.314752]  __schedule+0x8d7/0x930
[   63.317683]  schedule+0x73/0x90
[   63.319485]  async_synchronize_cookie_domain+0x6c/0xa0
[   63.321883]  ? do_wait_intr_irq+0x80/0x80
[   63.323875]  ? async_sdev_thaw+0x20/0x20
[   63.325848]  ? scsi_bus_thaw+0x20/0x20
[   63.328287]  async_synchronize_full_domain+0x13/0x20
[   63.330451]  scsi_bus_resume_common+0x95/0x140
[   63.332381]  scsi_bus_resume+0x10/0x20
[   63.334129]  dpm_run_callback+0x142/0x290
[   63.336353]  device_resume+0x192/0x1e0
[   63.338854]  async_resume+0x18/0x40
[   63.341101]  async_run_entry_fn+0x32/0xd0
[   63.343197]  process_one_work+0x32a/0x620
[   63.345300]  worker_thread+0x221/0x3f0
[   63.347356]  kthread+0x124/0x130
[   63.349463]  ? process_one_work+0x620/0x620
[   63.352192]  ? kthread_stop+0x260/0x260
[   63.354697]  ret_from_fork+0x2a/0x40
[   63.357611] INFO: task kworker/u8:22:2617 blocked for more than 20 secon=
ds.
[   63.361106]       Not tainted 4.13.0-rc6 #3
[   63.363990] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[   63.367847] kworker/u8:22   D14392  2617      2 0x00000080
[   63.370561] Workqueue: events_unbound async_run_entry_fn
[   63.374235] Call Trace:
[   63.376351]  __schedule+0x8d7/0x930
[   63.379545]  schedule+0x73/0x90
[   63.382199]  async_synchronize_cookie_domain+0x6c/0xa0
[   63.385132]  ? do_wait_intr_irq+0x80/0x80
[   63.387533]  ? async_sdev_thaw+0x20/0x20
[   63.389684]  ? scsi_bus_thaw+0x20/0x20
[   63.391849]  async_synchronize_full_domain+0x13/0x20
[   63.395454]  scsi_bus_resume_common+0x95/0x140
[   63.397842]  scsi_bus_resume+0x10/0x20
[   63.399883]  dpm_run_callback+0x142/0x290
[   63.402873]  device_resume+0x192/0x1e0
[   63.405915]  async_resume+0x18/0x40
[   63.408723]  async_run_entry_fn+0x32/0xd0
[   63.411627]  process_one_work+0x32a/0x620
[   63.413672]  worker_thread+0x221/0x3f0
[   63.415661]  kthread+0x124/0x130
[   63.417452]  ? process_one_work+0x620/0x620
[   63.419750]  ? kthread_stop+0x260/0x260
[   63.421781]  ret_from_fork+0x2a/0x40
[   63.423653] INFO: task kworker/u8:24:2619 blocked for more than 20 secon=
ds.
[   63.426647]       Not tainted 4.13.0-rc6 #3
[   63.428599] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables=
=20
this message.
[   63.431762] kworker/u8:24   D14416  2619      2 0x00000080
[   63.433650] Workqueue: events_unbound async_run_entry_fn
[   63.435956] Call Trace:
[   63.437711]  __schedule+0x8d7/0x930
[   63.440567]  ? sbitmap_get+0x4e/0xa0
[   63.442571]  schedule+0x73/0x90
[   63.444331]  io_schedule+0x11/0x40
[   63.446731]  blk_mq_get_tag+0x13e/0x250
[   63.448974]  ? blk_mq_get_request+0xdb/0x400
[   63.451208]  ? do_wait_intr_irq+0x80/0x80
[   63.453716]  blk_mq_get_request+0x1a8/0x400
[   63.455700]  blk_mq_alloc_request+0x56/0xc0
[   63.457883]  blk_get_request+0x29/0x100
[   63.459658]  scsi_execute+0x3b/0x230
[   63.461536]  sd_start_stop_device+0x93/0x120
[   63.463616]  sd_resume+0x67/0x70
[   63.465310]  do_scsi_resume+0x16/0x20
[   63.467217]  scsi_dev_type_resume+0x26/0x70
[   63.469287]  async_sdev_resume+0x10/0x20
[   63.471178]  async_run_entry_fn+0x32/0xd0
[   63.473197]  process_one_work+0x32a/0x620
[   63.474939]  worker_thread+0x221/0x3f0
[   63.476752]  kthread+0x124/0x130
[   63.478406]  ? process_one_work+0x620/0x620
[   63.480031]  ? kthread_stop+0x260/0x260
[   63.481579]  ret_from_fork+0x2a/0x40
[   63.483548]=20
               Showing all locks held in the system:
[   63.487087] 4 locks held by kworker/2:1/36:
[   63.489578]  #0:  ("events"){.+.+.+}, at: [<ffffffff8109f083>]=20
process_one_work+0x1b3/0x620
[   63.494571]  #1:  ((&ap->scsi_rescan_task)){+.+...}, at:=20
[<ffffffff8109f083>] process_one_work+0x1b3/0x620
[   63.499045]  #2:  (&ap->scsi_scan_mutex){+.+...}, at: [<ffffffff816f9074=
>]=20
ata_scsi_dev_rescan+0x34/0x110
[   63.505049]  #3:  (&dev->mutex){......}, at: [<ffffffff816d4b41>]=20
scsi_rescan_device+0x21/0x90
[   63.510159] 4 locks held by kworker/0:1/37:
[   63.512237]  #0:  ("events"){.+.+.+}, at: [<ffffffff8109f083>]=20
process_one_work+0x1b3/0x620
[   63.516225]  #1:  ((&ap->scsi_rescan_task)){+.+...}, at:=20
[<ffffffff8109f083>] process_one_work+0x1b3/0x620
[   63.520622]  #2:  (&ap->scsi_scan_mutex){+.+...}, at: [<ffffffff816f9074=
>]=20
ata_scsi_dev_rescan+0x34/0x110
[   63.524931]  #3:  (&dev->mutex){......}, at: [<ffffffff816d4b41>]=20
scsi_rescan_device+0x21/0x90
[   63.528790] 4 locks held by kworker/1:1/40:
[   63.530879]  #0:  ("events"){.+.+.+}, at: [<ffffffff8109f083>]=20
process_one_work+0x1b3/0x620
[   63.536187]  #1:  ((&ap->scsi_rescan_task)){+.+...}, at:=20
[<ffffffff8109f083>] process_one_work+0x1b3/0x620
[   63.540720]  #2:  (&ap->scsi_scan_mutex){+.+...}, at: [<ffffffff816f9074=
>]=20
ata_scsi_dev_rescan+0x34/0x110
[   63.544863]  #3:  (&dev->mutex){......}, at: [<ffffffff816d4b41>]=20
scsi_rescan_device+0x21/0x90
[   63.549947] 1 lock held by khungtaskd/461:
[   63.552274]  #0:  (tasklist_lock){.+.+..}, at: [<ffffffff810ce5da>]=20
debug_show_all_locks+0x4a/0x170
[   63.557027] 1 lock held by md0_raid10/1716:
[   63.559209]  #0:  (&mddev->reconfig_mutex){+.+.+.}, at:=20
[<ffffffff81832cc7>] md_check_recovery+0xe7/0x4b0
[   63.587846] 2 locks held by btrfs-transacti/1867:
[   63.590223]  #0:  (&fs_info->transaction_kthread_mutex){+.+...}, at:=20
[<ffffffff81372779>] transaction_kthread+0x49/0x190
[   63.595024]  #1:  (&fs_info->tree_log_mutex){+.+...}, at:=20
[<ffffffff81377c1a>] btrfs_commit_transaction+0x3aa/0x910
[   63.600911] 5 locks held by systemd-sleep/2599:
[   63.603394]  #0:  (sb_writers#5){.+.+.+}, at: [<ffffffff811eaeaf>]=20
vfs_write+0xaf/0x180
[   63.607819]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff8126bf99>]=20
kernfs_fop_write+0xb9/0x180
[   63.612001]  #2:  (s_active#146){.+.+.+}, at: [<ffffffff8126bfa1>]=20
kernfs_fop_write+0xc1/0x180
[   63.616079]  #3:  (pm_mutex){+.+.+.}, at: [<ffffffff810d89f2>] pm_suspend
+0x472/0x490
[   63.621514]  #4:  (acpi_scan_lock){+.+.+.}, at: [<ffffffff814e53e2>]=20
acpi_scan_lock_acquire+0x12/0x20
[   63.627617] 3 locks held by kworker/u8:20/2615:
[   63.629583]  #0:  ("events_unbound"){.+.+.+}, at: [<ffffffff8109f083>]=20
process_one_work+0x1b3/0x620
[   63.633125]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff8109f083>]=20
process_one_work+0x1b3/0x620
[   63.636934]  #2:  (&dev->mutex){......}, at: [<ffffffff816ae8f9>]=20
device_resume+0x89/0x1e0
[   63.641510] 3 locks held by kworker/u8:21/2616:
[   63.643984]  #0:  ("events_unbound"){.+.+.+}, at: [<ffffffff8109f083>]=20
process_one_work+0x1b3/0x620
[   63.649344]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff8109f083>]=20
process_one_work+0x1b3/0x620
[   63.655669]  #2:  (&dev->mutex){......}, at: [<ffffffff816ae8f9>]=20
device_resume+0x89/0x1e0
[   63.660176] 3 locks held by kworker/u8:22/2617:
[   63.662542]  #0:  ("events_unbound"){.+.+.+}, at: [<ffffffff8109f083>]=20
process_one_work+0x1b3/0x620
[   63.668704]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff8109f083>]=20
process_one_work+0x1b3/0x620
[   63.674307]  #2:  (&dev->mutex){......}, at: [<ffffffff816ae8f9>]=20
device_resume+0x89/0x1e0
[   63.678492] 2 locks held by kworker/u8:24/2619:
[   63.680737]  #0:  ("events_unbound"){.+.+.+}, at: [<ffffffff8109f083>]=20
process_one_work+0x1b3/0x620
[   63.685153]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff8109f083>]=20
process_one_work+0x1b3/0x620
[   63.689648]=20
[   63.691151] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D=3D

On sobota 26. srpna 2017 12:48:01 CEST Oleksandr Natalenko wrote:
> Quick update: reproduced on both v4.12.7 and v4.13.0-rc6.
> =E2=80=A6SNIP=E2=80=A6
