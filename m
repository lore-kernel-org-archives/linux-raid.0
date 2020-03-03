From: Vitaly Mayatskikh <vmayatskikh@digitalocean.com>
Subject: [PATCH 0/1] Fix deadlock in raid10 recovery
Date: Tue,  3 Mar 2020 13:14:39 -0500
Message-ID: <1583259280-124995-1-git-send-email-vmayatskikh@digitalocean.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We see a relatively high rate of RAID-10 array lockups on active drive
failure with the following "blocked task" messages seen in logs:

[74061.470754] blk_update_request: I/O error, dev sde, sector 37125 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[74061.470754] md/raid10:md0: sde: rescheduling sector 65797
[74061.470757] md/raid10:md0: sde: rescheduling sector 65892
[74061.485420] md/raid10:md0: read correction write failed (1 sectors at 4096 on sde)
[74061.485422] md/raid10:md0: sde: failing drive
[74061.485433] md/raid10:md0: sdc: redirecting sector 55899 to another mirror
[74061.495539] md: super_written gets error=10
[74061.496573] sd 6:0:0:1: [sde] Synchronizing SCSI cache
[74061.497395] md/raid10:md0: Disk failure on sde, disabling device.
               md/raid10:md0: Operation continuing on 3 devices.
[74061.500270] md: super_written gets error=10
[74061.509780] md: recovery of RAID array md0
[74061.510141] md/raid10:md0: sdc: redirecting sector 55921 to another mirror
[74218.192284] INFO: task md0_raid10:14069 blocked for more than 122 seconds.
[74218.193000]       Not tainted 5.6.0-rc3+ #11
[74218.193582] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[74218.194551] md0_raid10      D    0 14069      2 0x80004080
[74218.194556] Call Trace:
[74218.194564]  __schedule+0x2ca/0x6e0
[74218.194567]  schedule+0x4f/0xc0
[74218.194574]  wait_barrier+0x14e/0x1b0 [raid10]
[74218.194578]  ? remove_wait_queue+0x60/0x60
[74218.194582]  regular_request_wait.isra.36+0x39/0x180 [raid10]
[74218.194585]  ? disk_name+0x9b/0xb0
[74218.194588]  raid10_read_request+0x9d/0x3b0 [raid10]
[74218.194592]  raid10d+0xca0/0x1700 [raid10]
[74218.194594]  ? finish_task_switch+0x75/0x2a0
[74218.194598]  ? __switch_to_asm+0x40/0x70
[74218.194600]  ? schedule+0x4f/0xc0
[74218.194601]  ? remove_wait_queue+0x60/0x60
[74218.194606]  md_thread+0x138/0x180
[74218.194607]  ? remove_wait_queue+0x60/0x60
[74218.194610]  kthread+0x105/0x140
[74218.194613]  ? md_rdev_clear+0x100/0x100
[74218.194615]  ? kthread_bind+0x20/0x20
[74218.194617]  ret_from_fork+0x22/0x40
[74218.194622] INFO: task fio:14127 blocked for more than 122 seconds.
[74218.195271]       Not tainted 5.6.0-rc3+ #11
[74218.195831] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[74218.196811] fio             D    0 14127  14123 0x00004080
[74218.196814] Call Trace:
[74218.196819]  __schedule+0x2ca/0x6e0
[74218.196823]  schedule+0x4f/0xc0
[74218.196828]  wait_barrier+0x14e/0x1b0 [raid10]
[74218.196830]  ? remove_wait_queue+0x60/0x60
[74218.196833]  regular_request_wait.isra.36+0x39/0x180 [raid10]
[74218.196836]  ? __kmalloc+0x186/0x270
[74218.196839]  ? r10bio_pool_alloc+0x24/0x30 [raid10]
[74218.196843]  raid10_read_request+0x37d/0x3b0 [raid10]
[74218.196845]  ? mempool_alloc+0x73/0x170
[74218.196848]  raid10_make_request+0x104/0x150 [raid10]
[74218.196852]  md_handle_request+0xc4/0x130
[74218.196855]  md_make_request+0x85/0x1d0
[74218.196858]  generic_make_request+0x112/0x2e0
[74218.196860]  submit_bio+0xaf/0x1a0
[74218.196863]  ? set_page_dirty_lock+0x3c/0x60
[74218.196866]  ? bio_set_pages_dirty+0x76/0xb0
[74218.196869]  blkdev_direct_IO+0x3f3/0x4a0
[74218.196873]  generic_file_read_iter+0xbf/0xdc0
[74218.196877]  ? security_file_permission+0xbe/0x120
[74218.196880]  blkdev_read_iter+0x37/0x40
[74218.196883]  aio_read+0xf6/0x150
[74218.196887]  ? __slab_alloc+0x50/0x5f
[74218.196889]  ? io_submit_one+0x7e/0xbb0
[74218.196892]  ? io_submit_one+0x7e/0xbb0
[74218.196894]  io_submit_one+0x199/0xbb0
[74218.196896]  ? remove_wait_queue+0x60/0x60
[74218.196900]  __x64_sys_io_submit+0xb3/0x1a0
[74218.196903]  ? __audit_syscall_exit+0x1e3/0x290
[74218.196907]  do_syscall_64+0x60/0x1e0
[74218.196909]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[74218.196912] RIP: 0033:0x7f7abbd41d0d
[74218.196917] Code: Bad RIP value.
[74218.196919] RSP: 002b:00007f7a8a32c3c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
[74218.196921] RAX: ffffffffffffffda RBX: 00007f7a8a32db60 RCX: 00007f7abbd41d0d
[74218.196922] RDX: 00007f7a84021bd0 RSI: 0000000000000001 RDI: 00007f7abe2a7000
[74218.196923] RBP: 00007f7abe2a7000 R08: 00007f7a84013f60 R09: 0000000000000020
[74218.196924] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000001
[74218.196925] R13: 0000000000000000 R14: 00007f7a84021bd0 R15: 00007f7a8ab31000
[74218.200153] INFO: task mdadm:14139 blocked for more than 122 seconds.
[74218.200439]       Not tainted 5.6.0-rc3+ #11
[74218.200686] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[74218.201102] mdadm           D    0 14139  14138 0x000001a0
[74218.201103] Call Trace:
[74218.201105]  __schedule+0x2ca/0x6e0
[74218.201106]  schedule+0x4f/0xc0
[74218.201107]  md_set_readonly+0x20a/0x2c0
[74218.201107]  ? remove_wait_queue+0x60/0x60
[74218.201108]  array_state_store+0x2f7/0x360
[74218.201109]  md_attr_store+0x85/0xd0
[74218.201111]  sysfs_kf_write+0x3f/0x50
[74218.201112]  kernfs_fop_write+0x130/0x1c0
[74218.201113]  __vfs_write+0x1b/0x40
[74218.201114]  vfs_write+0xb2/0x1b0
[74218.201115]  ksys_write+0x61/0xd0
[74218.201116]  __x64_sys_write+0x1a/0x20
[74218.201117]  do_syscall_64+0x60/0x1e0
[74218.201118]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[74218.201119] RIP: 0033:0x7fb834c87168
[74218.201120] Code: Bad RIP value.
[74218.201120] RSP: 002b:00007ffcc47fd258 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[74218.201121] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fb834c87168
[74218.201121] RDX: 0000000000000009 RSI: 00005652b38643dc RDI: 0000000000000003
[74218.201122] RBP: 00005652b38643dc R08: 00005652b3864620 R09: 00007ffcc47fcbc0
[74218.201122] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[74218.201123] R13: 00007ffcc47fea91 R14: 00007ffcc47fd700 R15: 00007ffcc47fd340
[74218.201124] INFO: task md0_resync:14140 blocked for more than 122 seconds.
[74218.201415]       Not tainted 5.6.0-rc3+ #11
[74218.201662] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[74218.202075] md0_resync      D    0 14140      2 0x80004080
[74218.202076] Call Trace:
[74218.202078]  __schedule+0x2ca/0x6e0
[74218.202079]  schedule+0x4f/0xc0
[74218.202080]  raise_barrier+0xa1/0x1a0 [raid10]
[74218.202081]  ? remove_wait_queue+0x60/0x60
[74218.202083]  raid10_sync_request+0x36c/0x16e0 [raid10]
[74218.202084]  ? insert_work+0x87/0xa0
[74218.202085]  md_do_sync+0x927/0x1050
[74218.202086]  ? 0xffffffff81000000
[74218.202087]  ? __switch_to_asm+0x34/0x70
[74218.202088]  ? __switch_to_asm+0x40/0x70
[74218.202089]  ? __switch_to_asm+0x34/0x70
[74218.202090]  ? __switch_to_asm+0x40/0x70
[74218.202091]  ? __switch_to_asm+0x34/0x70
[74218.202091]  ? __switch_to_asm+0x40/0x70
[74218.202093]  md_thread+0x138/0x180
[74218.202094]  kthread+0x105/0x140
[74218.202096]  ? md_rdev_clear+0x100/0x100
[74218.202096]  ? kthread_bind+0x20/0x20
[74218.202098]  ret_from_fork+0x22/0x40

Upon investigation it turned out that md resync thread deadlocks with
md retry thread. Hang does not happen without a spare drive or when
the failed drive is configured as failfast.

Steps to reproduce:

mdadm -C /dev/md0 --assume-clean -l 10 -n 4 /dev/sd[abcd]
mdadm /dev/md0 --add /dev/sde
mdadm --detail /dev/md0
fio --thread --direct=1 --rw=randread --ioengine=libaio --bs=512 --iodepth=128 --numjobs=4 --name=foo --time_based --timeout=1500 --group_reporting --filename=/dev/md0
echo 1 > /sys/block/sda/device/delete

Vitaly Mayatskikh (1):
  md/raid10: avoid deadlock on recovery.

 drivers/md/raid10.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

-- 
1.8.3.1
