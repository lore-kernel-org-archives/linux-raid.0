From: Zhilong Liu <zlliu@suse.com>
Subject: tests/21raid5cache: tasks blocked for more than 480 seconds
Date: Fri, 1 Sep 2017 17:19:54 +0800
Message-ID: <39ebfb9e-d12a-bc10-eddb-c5302eb47431@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, songliubraving@fb.com
List-Id: linux-raid.ids

Hi, all;
   Please refer to the infos as follow.

# ps -ef:
... ... ..
root      2110  1724  0 03:52 pts/0    00:00:00 /bin/bash ./test 
--tests=21raid5cache
root      2162     2  0 03:52 ?        00:00:00 [loop0]
root      2168     2  0 03:52 ?        00:00:00 [loop1]
root      2174     2  0 03:52 ?        00:00:00 [loop2]
root      2179     2  0 03:52 ?        00:00:00 [loop3]
root      2184     2  0 03:52 ?        00:00:00 [loop4]
root      2189     2  0 03:52 ?        00:00:00 [loop5]
root      2194     2  0 03:52 ?        00:00:00 [loop6]
root      2199     2  0 03:52 ?        00:00:00 [loop7]
root      2204     2  0 03:52 ?        00:00:00 [loop8]
root      2209     2  0 03:52 ?        00:00:00 [loop9]
root      2214     2  0 03:52 ?        00:00:00 [loop10]
root      2219     2  0 03:52 ?        00:00:00 [loop11]
root      2224     2  0 03:52 ?        00:00:00 [loop12]
root      2229     2  0 03:52 ?        00:00:00 [loop13]
root      2238  2110  0 03:52 pts/0    00:00:00 /bin/bash ./test 
--tests=21raid5cache
root      2329     2  0 03:52 ?        00:00:00 [raid5wq]
root      2349     2  0 03:52 ?        00:00:00 [kworker/1:0]
root      2351     1  0 03:52 ?        00:00:00 /sbin/mdadm --monitor -d 
60 -m root@localhost --scan -c /etc/mdadm.conf
root      2356     2  0 03:52 ?        00:00:00 [kworker/0:0]
root      2379     2  0 03:52 ?        00:00:00 [kworker/u8:0]
root      2387     2  0 03:52 ?        00:00:00 [kworker/3:0]
root      2393     2  0 03:52 ?        00:00:00 [kworker/2:0]
root      2839     2  0 03:52 ?        00:00:00 [md0_raid5]
root      2840     2  0 03:52 ?        00:00:00 [md0_reclaim]
root      2876  2238  0 03:52 pts/0    00:00:00 dd if=/tmp/randfile 
of=/dev/md0 bs=4k count=1
root      2906     2  0 03:56 ?        00:00:00 [kworker/0:3]
root      2951     2  0 04:00 ?        00:00:00 [kworker/1:2]
root      2952     1  0 04:02 ?        00:00:00 
/usr/lib/systemd/systemd-udevd
root      2955  1603  0 04:05 ?        00:00:00 sshd: root@pts/2
root      2958  2955  0 04:05 pts/2    00:00:00 -bash
root      3005     2  0 04:06 ?        00:00:00 [kworker/u8:2]
root      3031     2  0 04:07 ?        00:00:00 [kworker/1:1]
root      3033  1917  0 04:07 pts/1    00:00:00 ps -ef

linux-apta:~ # cat /proc/2876/stack
[<ffffffffa042f63c>] md_write_start+0xdc/0x200 [md_mod]
[<ffffffffa055c5aa>] raid5_make_request+0x7a/0x860 [raid456]
[<ffffffffa042a096>] md_make_request+0xe6/0x240 [md_mod]
[<ffffffff8134247f>] generic_make_request+0xff/0x2d0
[<ffffffff813426c5>] submit_bio+0x75/0x150
[<ffffffff81270f20>] submit_bh_wbc+0x140/0x170
[<ffffffff8127109f>] __block_write_full_page+0x14f/0x3b0
[<ffffffff812714ba>] block_write_full_page+0xda/0xf0
[<ffffffff81273d18>] blkdev_writepage+0x18/0x20
[<ffffffff811b3387>] __writepage+0x17/0x50
[<ffffffff811b464b>] write_cache_pages+0x25b/0x4e0
[<ffffffff811b4913>] generic_writepages+0x43/0x60
[<ffffffff81273ccf>] blkdev_writepages+0x2f/0x40
[<ffffffff811b55ec>] do_writepages+0x1c/0x70
[<ffffffff811a74aa>] __filemap_fdatawrite_range+0xaa/0xe0
[<ffffffff811a754d>] filemap_write_and_wait+0x3d/0x80
[<ffffffff8127511f>] __sync_blockdev+0x1f/0x40
[<ffffffff81275474>] __blkdev_put+0x74/0x200
[<ffffffff81275dbc>] blkdev_put+0x4c/0xd0
[<ffffffff81275e65>] blkdev_close+0x25/0x30
[<ffffffff812392f1>] __fput+0xe1/0x210
[<ffffffff8123945e>] ____fput+0xe/0x10
[<ffffffff8109e683>] task_work_run+0x83/0xb0
[<ffffffff81003c5b>] exit_to_usermode_loop+0x6c/0xb1
[<ffffffff81003665>] syscall_return_slowpath+0x85/0xa0
[<ffffffff816a9e00>] entry_SYSCALL_64_fastpath+0xa3/0xa5
[<ffffffffffffffff>] 0xffffffffffffffff

linux-apta:~ # cat /proc/2238/stack
[<ffffffff81084077>] do_wait+0x1c7/0x240
[<ffffffff81085363>] kernel_wait4+0x83/0x130
[<ffffffff8108546b>] SYSC_wait4+0x5b/0x60
[<ffffffff810854de>] SyS_wait4+0xe/0x10
[<ffffffff816a9d77>] entry_SYSCALL_64_fastpath+0x1a/0xa5
[<ffffffffffffffff>] 0xffffffffffffffff

dmesg:

[  633.456024] raid6: sse2x1   gen()  7536 MB/s
[  633.524030] raid6: sse2x1   xor()  5991 MB/s
[  633.592029] raid6: sse2x2   gen()  9502 MB/s
[  633.660031] raid6: sse2x2   xor()  6871 MB/s
[  633.728033] raid6: sse2x4   gen() 11134 MB/s
[  633.796026] raid6: sse2x4   xor()  8470 MB/s
[  633.796027] raid6: using algorithm sse2x4 gen() 11134 MB/s
[  633.796028] raid6: .... xor() 8470 MB/s, rmw enabled
[  633.796029] raid6: using ssse3x2 recovery algorithm
[  633.797238] xor: automatically using best checksumming function avx
[  633.798326] async_tx: api initialized (async)
[  633.803866] md/raid:md0: device loop8 operational as raid disk 8
[  633.803868] md/raid:md0: device loop11 operational as raid disk 7
[  633.803869] md/raid:md0: device loop6 operational as raid disk 6
[  633.803869] md/raid:md0: device loop5 operational as raid disk 5
[  633.803870] md/raid:md0: device loop4 operational as raid disk 4
[  633.803871] md/raid:md0: device loop3 operational as raid disk 3
[  633.803871] md/raid:md0: device loop2 operational as raid disk 2
[  633.803872] md/raid:md0: device loop1 operational as raid disk 1
[  633.803873] md/raid:md0: device loop0 operational as raid disk 0
[  633.804514] md/raid:md0: raid level 5 active with 9 out of 10 
devices, algorithm 2
[  633.915743] md0: detected capacity change from 0 to 174882816
[  633.916249] md: recovery of RAID array md0
[  636.776097] md: md0: recovery done.
[  637.548666] md0: detected capacity change from 174882816 to 0
[  637.548671] md: md0 stopped.
[  638.324275] md: md0 stopped.
[  638.601280] md/raid:md0: device loop0 operational as raid disk 0
[  638.601281] md/raid:md0: device loop9 operational as raid disk 9
[  638.601282] md/raid:md0: device loop8 operational as raid disk 8
[  638.601283] md/raid:md0: device loop11 operational as raid disk 7
[  638.601284] md/raid:md0: device loop6 operational as raid disk 6
[  638.601284] md/raid:md0: device loop5 operational as raid disk 5
[  638.601285] md/raid:md0: device loop4 operational as raid disk 4
[  638.601285] md/raid:md0: device loop3 operational as raid disk 3
[  638.601286] md/raid:md0: device loop2 operational as raid disk 2
[  638.601287] md/raid:md0: device loop1 operational as raid disk 1
[  638.601933] md/raid:md0: raid level 5 active with 10 out of 10 
devices, algorithm 2
[  638.738933] md0: detected capacity change from 0 to 174882816
[  638.812634] md0: detected capacity change from 174882816 to 0
[  638.812640] md: md0 stopped.
[  639.584252] md: md0 stopped.
[  639.829648] md/raid:md0: device loop0 operational as raid disk 0
[  639.829650] md/raid:md0: device loop9 operational as raid disk 9
[  639.829650] md/raid:md0: device loop8 operational as raid disk 8
[  639.829651] md/raid:md0: device loop11 operational as raid disk 7
[  639.829652] md/raid:md0: device loop6 operational as raid disk 6
[  639.829652] md/raid:md0: device loop5 operational as raid disk 5
[  639.829653] md/raid:md0: device loop4 operational as raid disk 4
[  639.829654] md/raid:md0: device loop3 operational as raid disk 3
[  639.829654] md/raid:md0: device loop2 operational as raid disk 2
[  639.829655] md/raid:md0: device loop1 operational as raid disk 1
[  639.830327] md/raid:md0: raid level 5 active with 10 out of 10 
devices, algorithm 2
[  640.041339] md0: detected capacity change from 0 to 174882816
[  640.556757] md0: detected capacity change from 174882816 to 0
[  640.556763] md: md0 stopped.
[  641.316276] md: md0 stopped.
[  641.553709] md/raid:md0: device loop0 operational as raid disk 0
[  641.553711] md/raid:md0: device loop9 operational as raid disk 9
[  641.553712] md/raid:md0: device loop8 operational as raid disk 8
[  641.553713] md/raid:md0: device loop11 operational as raid disk 7
[  641.553714] md/raid:md0: device loop6 operational as raid disk 6
[  641.553714] md/raid:md0: device loop5 operational as raid disk 5
[  641.553715] md/raid:md0: device loop4 operational as raid disk 4
[  641.553716] md/raid:md0: device loop3 operational as raid disk 3
[  641.553717] md/raid:md0: device loop2 operational as raid disk 2
[  641.553717] md/raid:md0: device loop1 operational as raid disk 1
[  641.554456] md/raid:md0: raid level 5 active with 10 out of 10 
devices, algorithm 2
[  641.690739] md0: detected capacity change from 0 to 174882816
[  641.752698] md0: detected capacity change from 174882816 to 0
[  641.752703] md: md0 stopped.
[  642.516271] md: md0 stopped.
[  642.757331] md/raid:md0: device loop0 operational as raid disk 0
[  642.757333] md/raid:md0: device loop9 operational as raid disk 9
[  642.757334] md/raid:md0: device loop8 operational as raid disk 8
[  642.757335] md/raid:md0: device loop11 operational as raid disk 7
[  642.757335] md/raid:md0: device loop6 operational as raid disk 6
[  642.757336] md/raid:md0: device loop5 operational as raid disk 5
[  642.757337] md/raid:md0: device loop4 operational as raid disk 4
[  642.757337] md/raid:md0: device loop3 operational as raid disk 3
[  642.757338] md/raid:md0: device loop2 operational as raid disk 2
[  642.757339] md/raid:md0: device loop1 operational as raid disk 1
[  642.758146] md/raid:md0: raid level 5 active with 10 out of 10 
devices, algorithm 2
[  642.891300] md0: detected capacity change from 0 to 174882816
[  643.364727] md0: detected capacity change from 174882816 to 0
[  643.364733] md: md0 stopped.
[  645.159168] md/raid:md0: device loop8 operational as raid disk 8
[  645.159171] md/raid:md0: device loop11 operational as raid disk 7
[  645.159171] md/raid:md0: device loop6 operational as raid disk 6
[  645.159172] md/raid:md0: device loop5 operational as raid disk 5
[  645.159173] md/raid:md0: device loop4 operational as raid disk 4
[  645.159173] md/raid:md0: device loop3 operational as raid disk 3
[  645.159174] md/raid:md0: device loop2 operational as raid disk 2
[  645.159175] md/raid:md0: device loop1 operational as raid disk 1
[  645.159175] md/raid:md0: device loop0 operational as raid disk 0
[  645.159820] md/raid:md0: raid level 5 active with 9 out of 10 
devices, algorithm 2
[  645.311195] md0: detected capacity change from 0 to 174882816
[  645.311380] md: recovery of RAID array md0
[  647.956075] md: md0: recovery done.
[  648.558139] md/raid:md0: Disk failure on loop0, disabling device.
                md/raid:md0: Operation continuing on 9 devices.
[  648.558155] md/raid:md0: Disabling writeback cache for degraded array.
[ 1463.260122] INFO: task systemd-udevd:466 blocked for more than 480 
seconds.
[ 1463.260125]       Tainted: G            E 4.13.0-rc7-git-latest+ #2
[ 1463.260125] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 1463.260127] systemd-udevd   D    0   466      1 0x00000004
[ 1463.260131] Call Trace:
[ 1463.260140]  __schedule+0x28f/0x880
[ 1463.260143]  schedule+0x36/0x80
[ 1463.260145]  schedule_preempt_disabled+0xe/0x10
[ 1463.260148]  __mutex_lock.isra.6+0x22b/0x4c0
[ 1463.260153]  ? disk_map_sector_rcu+0x70/0x70
[ 1463.260157]  __mutex_lock_slowpath+0x13/0x20
[ 1463.260159]  mutex_lock+0x23/0x30
[ 1463.260163]  __blkdev_get+0x5f/0x440
[ 1463.260166]  blkdev_get+0x190/0x2e0
[ 1463.260169]  blkdev_open+0x72/0x90
[ 1463.260173]  do_dentry_open+0x20f/0x330
[ 1463.260176]  ? bd_acquire+0xd0/0xd0
[ 1463.260178]  vfs_open+0x4f/0x70
[ 1463.260181]  ? may_open+0x9b/0x100
[ 1463.260183]  path_openat+0x51e/0x1360
[ 1463.260186]  ? arch_tlb_finish_mmu+0x47/0x80
[ 1463.260189]  do_filp_open+0x7e/0xd0
[ 1463.260192]  ? __alloc_fd+0x46/0x170
[ 1463.260194]  do_sys_open+0x115/0x1f0
[ 1463.260195]  SyS_open+0x1e/0x20
[ 1463.260198]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[ 1463.260200] RIP: 0033:0x7f513c74e410
[ 1463.260201] RSP: 002b:00007ffe3b70bab8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000002
[ 1463.260203] RAX: ffffffffffffffda RBX: 000055fa7b2a9420 RCX: 
00007f513c74e410
[ 1463.260204] RDX: 000055fa7a3c63b0 RSI: 00000000000a0800 RDI: 
000055fa7b2a5ce0
[ 1463.260206] RBP: 0000000000000000 R08: 000000000000006d R09: 
0000000000000003
[ 1463.260207] R10: 00000000000000f0 R11: 0000000000000246 R12: 
0000000000000000
[ 1463.260208] R13: 00007ffe3b70bb10 R14: 00007ffe3b70bc10 R15: 
000055fa7b2a7c10
[ 1463.260232] INFO: task mdadm:2351 blocked for more than 480 seconds.
[ 1463.260234]       Tainted: G            E 4.13.0-rc7-git-latest+ #2
[ 1463.260234] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 1463.260235] mdadm           D    0  2351      1 0x00000000
[ 1463.260237] Call Trace:
[ 1463.260240]  __schedule+0x28f/0x880
[ 1463.260242]  schedule+0x36/0x80
[ 1463.260244]  schedule_preempt_disabled+0xe/0x10
[ 1463.260247]  __mutex_lock.isra.6+0x22b/0x4c0
[ 1463.260250]  ? disk_map_sector_rcu+0x70/0x70
[ 1463.260252]  __mutex_lock_slowpath+0x13/0x20
[ 1463.260255]  mutex_lock+0x23/0x30
[ 1463.260257]  __blkdev_get+0x5f/0x440
[ 1463.260259]  blkdev_get+0x190/0x2e0
[ 1463.260262]  blkdev_open+0x72/0x90
[ 1463.260265]  do_dentry_open+0x20f/0x330
[ 1463.260267]  ? bd_acquire+0xd0/0xd0
[ 1463.260269]  vfs_open+0x4f/0x70
[ 1463.260271]  ? may_open+0x9b/0x100
[ 1463.260273]  path_openat+0x51e/0x1360
[ 1463.260281]  ? mddev_put+0x24/0x140 [md_mod]
[ 1463.260284]  do_filp_open+0x7e/0xd0
[ 1463.260286]  ? __alloc_fd+0x46/0x170
[ 1463.260288]  do_sys_open+0x115/0x1f0
[ 1463.260290]  SyS_open+0x1e/0x20
[ 1463.260291]  entry_SYSCALL_64_fastpath+0x1a/0xa5
[ 1463.260293] RIP: 0033:0x7f3ddd26a2c0
[ 1463.260293] RSP: 002b:00007ffd766ce0d8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000002
[ 1463.260295] RAX: ffffffffffffffda RBX: 00000000011d00a8 RCX: 
00007f3ddd26a2c0
[ 1463.260296] RDX: 000000000000000a RSI: 0000000000000000 RDI: 
00000000011cf010
[ 1463.260298] RBP: 0000000000000003 R08: 00007ffd766ce091 R09: 
0000000000000020
[ 1463.260299] R10: 00000000011d00a8 R11: 0000000000000246 R12: 
00000000011d00a0
[ 1463.260300] R13: 00000000011cf7b0 R14: 00007ffd766da180 R15: 
0000000000000014
[ 1463.260302] INFO: task kworker/0:0:2356 blocked for more than 480 
seconds.
[ 1463.260303]       Tainted: G            E 4.13.0-rc7-git-latest+ #2
[ 1463.260304] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 1463.260305] kworker/0:0     D    0  2356      2 0x00000000
[ 1463.260313] Workqueue: events r5c_disable_writeback_async [raid456]
[ 1463.260314] Call Trace:
[ 1463.260316]  __schedule+0x28f/0x880
[ 1463.260319]  schedule+0x36/0x80
[ 1463.260323]  mddev_suspend+0xa8/0xd0 [md_mod]
[ 1463.260327]  ? wait_woken+0x80/0x80
[ 1463.260331]  r5c_disable_writeback_async+0x68/0xc0 [raid456]
[ 1463.260333]  ? wait_woken+0x80/0x80
[ 1463.260336]  process_one_work+0x138/0x370
[ 1463.260338]  worker_thread+0x4d/0x3b0
[ 1463.260341]  kthread+0x109/0x140
[ 1463.260343]  ? rescuer_thread+0x320/0x320
[ 1463.260345]  ? kthread_park+0x60/0x60
[ 1463.260347]  ret_from_fork+0x25/0x30
[ 1463.260351] INFO: task dd:2876 blocked for more than 480 seconds.
[ 1463.260352]       Tainted: G            E 4.13.0-rc7-git-latest+ #2
[ 1463.260353] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[ 1463.260353] dd              D    0  2876   2238 0x00000000
[ 1463.260355] Call Trace:
[ 1463.260358]  __schedule+0x28f/0x880
[ 1463.260360]  schedule+0x36/0x80
[ 1463.260365]  md_write_start+0xdc/0x200 [md_mod]
[ 1463.260367]  ? wait_woken+0x80/0x80
[ 1463.260371]  raid5_make_request+0x7a/0x860 [raid456]
[ 1463.260374]  ? wait_woken+0x80/0x80
[ 1463.260379]  md_make_request+0xe6/0x240 [md_mod]
[ 1463.260382]  generic_make_request+0xff/0x2d0
[ 1463.260385]  submit_bio+0x75/0x150
[ 1463.260387]  ? bio_alloc_bioset+0x186/0x2a0
[ 1463.260390]  submit_bh_wbc+0x140/0x170
[ 1463.260392]  __block_write_full_page+0x14f/0x3b0
[ 1463.260394]  ? I_BDEV+0x20/0x20
[ 1463.260396]  ? end_buffer_async_read+0x120/0x120
[ 1463.260398]  ? I_BDEV+0x20/0x20
[ 1463.260400]  block_write_full_page+0xda/0xf0
[ 1463.260403]  blkdev_writepage+0x18/0x20
[ 1463.260405]  __writepage+0x17/0x50
[ 1463.260407]  write_cache_pages+0x25b/0x4e0
[ 1463.260409]  ? __wb_calc_thresh+0x120/0x120
[ 1463.260412]  ? ep_poll_callback+0x11d/0x250
[ 1463.260414]  generic_writepages+0x43/0x60
[ 1463.260417]  blkdev_writepages+0x2f/0x40
[ 1463.260419]  do_writepages+0x1c/0x70
[ 1463.260422]  __filemap_fdatawrite_range+0xaa/0xe0
[ 1463.260424]  filemap_write_and_wait+0x3d/0x80
[ 1463.260427]  __sync_blockdev+0x1f/0x40
[ 1463.260429]  __blkdev_put+0x74/0x200
[ 1463.260432]  blkdev_put+0x4c/0xd0
[ 1463.260434]  blkdev_close+0x25/0x30
[ 1463.260437]  __fput+0xe1/0x210
[ 1463.260439]  ____fput+0xe/0x10
[ 1463.260441]  task_work_run+0x83/0xb0
[ 1463.260444]  exit_to_usermode_loop+0x6c/0xb1
[ 1463.260447]  syscall_return_slowpath+0x85/0xa0
[ 1463.260448]  entry_SYSCALL_64_fastpath+0xa3/0xa5
[ 1463.260449] RIP: 0033:0x7f451c79ab20
[ 1463.260450] RSP: 002b:00007fff37729ba8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000003
[ 1463.260452] RAX: 0000000000000000 RBX: 00000000006113c0 RCX: 
00007f451c79ab20
[ 1463.260453] RDX: 0000000000001000 RSI: 0000000000000000 RDI: 
0000000000000001
[ 1463.260454] RBP: 0000000000000001 R08: 0000000000000003 R09: 
00007f451ca5a678
[ 1463.260455] R10: 0000000010a8b550 R11: 0000000000000246 R12: 
0000000000000000
[ 1463.260456] R13: 0000000000000000 R14: 00007fff37729e00 R15: 
00007fff3772a783


Thanks,
-Zhilong
