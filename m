From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata
 without
Date: Tue, 10 Oct 2017 14:05:15 +0800
Message-ID: <ebf97c38-c8e0-aa87-be84-efc8d56802f0@redhat.com>
References: <150518076229.32691.13542756562323866921.stgit@noble>
 <87o9qe9p3j.fsf@notabene.neil.brown.name>
 <446747392.10694917.1505364915884.JavaMail.zimbra@redhat.com>
 <871sn9alrh.fsf@notabene.neil.brown.name>
 <393232447.10845976.1505375841983.JavaMail.zimbra@redhat.com>
 <87vaju18dc.fsf@notabene.neil.brown.name>
 <c0e9b424-05d2-df6e-71ce-240a8141a2fd@redhat.com>
 <874lrc28x8.fsf@notabene.neil.brown.name>
 <1345780738.18087591.1507512089744.JavaMail.zimbra@redhat.com>
 <87a810zznc.fsf@notabene.neil.brown.name>
 <441ae9fe-fd73-2aac-8bb1-c64da28cda27@redhat.com>
 <871smczx4j.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------0279E369CFBEEF45E671703E"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871smczx4j.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------0279E369CFBEEF45E671703E
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit



On 10/09/2017 01:52 PM, NeilBrown wrote:
> On Mon, Oct 09 2017, Xiao Ni wrote:
>
>> On 10/09/2017 12:57 PM, NeilBrown wrote:
>>> It would if you had applied
>>>      [PATCH 3/4] md: use mddev_suspend/resume instead of ->quiesce()
>>>
>>> Did you apply all 4 patches?
>> Sorry, it's my mistake. I insmod the wrong module. I'll apply the four
>> patches
>> and do test again.
>>> Thanks.  I looks suspend_lo_store() is calling raid5_quiesce() directly
>>> as you say - so a patch is missing.
>> Yes, thanks for pointing about this.

Hi Neil

I applied the four patches and one patch "md: fix deadlock error in 
recent patch."
There is a new stuck. It's stuck at suspend_hi_store this time. I add 
the calltrace
as an attachment.

I added some printk to print some information.

[12695.993329] mddev suspend : 1
[12695.996270] mddev ro : 0
[12695.998790] mddev insync : 0
[12696.001641] mddev active io: 1

mddev->flags doesn't have MD_SB_CHANGE_PENDING.

root      8653  0.0  0.0   9688  4752 ?        DLs  00:52   0:00 
/usr/sbin/mdadm --grow --continue /dev/md0
[root@dell-pr1700-02 md]# cat /proc/8653/stack
[<ffffffffa080d64c>] mddev_suspend+0x12c/0x160 [md_mod]
[<ffffffffa081090c>] suspend_hi_store+0x7c/0xe0 [md_mod]
[<ffffffffa0814450>] md_attr_store+0x80/0xc0 [md_mod]
[<ffffffff812ec8da>] sysfs_kf_write+0x3a/0x50
[<ffffffff812ec39f>] kernfs_fop_write+0xff/0x180
[<ffffffff81260457>] __vfs_write+0x37/0x170
[<ffffffff812619e2>] vfs_write+0xb2/0x1b0
[<ffffffff81263015>] SyS_write+0x55/0xc0
[<ffffffff810037c7>] do_syscall_64+0x67/0x150
[<ffffffff81777527>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

root      1234  0.0  0.0 106008  7280 ?        Ss   Oct09   0:00 
/usr/sbin/sshd -D
root      8655  0.1  0.0 108996  2752 pts/0    D+   00:52   0:04 
|           \_ dd if=/dev/urandom of=/mnt/md_test/testfile bs=1M count=1000
[root@dell-pr1700-02 md]# cat /proc/8655/stack
[<ffffffffa097b09a>] wait_transaction_locked+0x8a/0xd0 [jbd2]
[<ffffffffa097b2d4>] add_transaction_credits+0x1c4/0x2a0 [jbd2]
[<ffffffffa097b587>] start_this_handle+0x197/0x400 [jbd2]
[<ffffffffa097ba3b>] jbd2__journal_start+0xeb/0x1f0 [jbd2]
[<ffffffffa0a26dfd>] __ext4_journal_start_sb+0x6d/0xf0 [ext4]
[<ffffffffa0a45a10>] ext4_da_write_begin+0x140/0x410 [ext4]
[<ffffffff811c4dee>] generic_perform_write+0xbe/0x1b0
[<ffffffff811c812b>] __generic_file_write_iter+0x19b/0x1e0
[<ffffffffa0a32c7f>] ext4_file_write_iter+0x28f/0x3f0 [ext4]
[<ffffffff81260513>] __vfs_write+0xf3/0x170
[<ffffffff812619e2>] vfs_write+0xb2/0x1b0
[<ffffffff81263015>] SyS_write+0x55/0xc0
[<ffffffff810037c7>] do_syscall_64+0x67/0x150
[<ffffffff81777527>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

root      8143  0.0  0.0      0     0 ?        D    00:40   0:00  \_ 
[kworker/u8:4]
[root@dell-pr1700-02 md]# cat /proc/8143/stack
[<ffffffffa080d131>] md_make_request+0xb1/0x260 [md_mod]
[<ffffffff81376427>] generic_make_request+0x117/0x2f0
[<ffffffff81376675>] submit_bio+0x75/0x150
[<ffffffffa0a5e21c>] ext4_io_submit+0x4c/0x60 [ext4]
[<ffffffffa0a5e3f4>] ext4_bio_write_page+0x1a4/0x3b0 [ext4]
[<ffffffffa0a3e4f7>] mpage_submit_page+0x57/0x70 [ext4]
[<ffffffffa0a3e778>] mpage_map_and_submit_buffers+0x168/0x290 [ext4]
[<ffffffffa0a443f2>] ext4_writepages+0x852/0xe80 [ext4]
[<ffffffff811d6bec>] do_writepages+0x1c/0x70
[<ffffffff81293895>] __writeback_single_inode+0x45/0x320
[<ffffffff812940c0>] writeback_sb_inodes+0x280/0x570
[<ffffffff8129443c>] __writeback_inodes_wb+0x8c/0xc0
[<ffffffff812946e6>] wb_writeback+0x276/0x310
[<ffffffff81294f9c>] wb_workfn+0x19c/0x3b0
[<ffffffff810c0ff9>] process_one_work+0x149/0x360
[<ffffffff810c177d>] worker_thread+0x4d/0x3c0
[<ffffffff810c73f9>] kthread+0x109/0x140
[<ffffffff817776c5>] ret_from_fork+0x25/0x30
[<ffffffffffffffff>] 0xffffffffffffffff




>> Hmm, so it's the first question. Why can't call md_check_recovery when
>> MD_SB_CHANGE_PENDING
>> is set. It needs to update the superblock too when MD_SB_CHANGE_PENDING
>> is set. I can't
>> understand this part.
>>
>> Can it be:
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -6299,7 +6299,7 @@ static void raid5d(struct md_thread *thread)
>>                           break;
>>                   handled += batch_size;
>>
>> -               if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
>> +               if (mddev->sb_flags) {
>>
> Maybe it could, but there is a test in md_check_recovery()
>
> 	if ( ! (
> 		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
>
> and it makes sense to match that.  There is no point dropping the
> spinlock and reclaiming it if md_check_recovery() isn't going to do
> anything useful.
It's introduced by:
commit 126925c090155f13e90b9e7e8c4010e96027c00a
Author: NeilBrown <neilb@suse.de>
Date:   Tue Sep 7 17:02:47 2010 +1000

     md: call md_update_sb even for 'external' metadata arrays.

For external metadata we don't want to take mddev lock if only
MD_SB_CHANGE_PENDING is set. But it also reduce the opportunity
to update superblock for internal metadata if only MD_SB_CHANGE_PENDING
is set.

Can it be:
diff --git a/drivers/md/md.c b/drivers/md/md.c
index b6b7a28..55e9280 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7777,7 +7777,7 @@ void md_check_recovery(struct mddev *mddev)
         if (mddev->ro && !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
                 return;
         if ( ! (
-               (mddev->flags & ~ (1<<MD_CHANGE_PENDING)) ||
+               (mddev->flags & (mddev->external == 1 &&  ~ 
(1<<MD_CHANGE_PENDING))) ||
                 test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
                 test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
                 (mddev->external == 0 && mddev->safemode == 1) ||

Best Regards
Xiao






--------------0279E369CFBEEF45E671703E
Content-Type: text/plain; charset=UTF-8;
 name="calltrace"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="calltrace"

[11302.691461] INFO: task kworker/u8:4:8143 blocked for more than 120 seconds.
[11302.698364]       Tainted: G           OE   4.13.0-rc5 #1
[11302.703719] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11302.711482] kworker/u8:4    D    0  8143      2 0x00000080
[11302.711488] Workqueue: writeback wb_workfn (flush-9:0)
[11302.711489] Call Trace:
[11302.713914]  __schedule+0x28d/0x890
[11302.717370]  schedule+0x36/0x80
[11302.720485]  md_make_request+0xb1/0x260 [md_mod]
[11302.725064]  ? remove_wait_queue+0x60/0x60
[11302.729123]  generic_make_request+0x117/0x2f0
[11302.733442]  submit_bio+0x75/0x150
[11302.736812]  ? __test_set_page_writeback+0xc6/0x320
[11302.741660]  ext4_io_submit+0x4c/0x60 [ext4]
[11302.745896]  ext4_bio_write_page+0x1a4/0x3b0 [ext4]
[11302.750733]  mpage_submit_page+0x57/0x70 [ext4]
[11302.755231]  mpage_map_and_submit_buffers+0x168/0x290 [ext4]
[11302.760845]  ext4_writepages+0x852/0xe80 [ext4]
[11302.765340]  ? account_entity_enqueue+0xd8/0x100
[11302.769916]  do_writepages+0x1c/0x70
[11302.773462]  __writeback_single_inode+0x45/0x320
[11302.778040]  writeback_sb_inodes+0x280/0x570
[11302.782273]  __writeback_inodes_wb+0x8c/0xc0
[11302.786508]  wb_writeback+0x276/0x310
[11302.790137]  wb_workfn+0x19c/0x3b0
[11302.793509]  process_one_work+0x149/0x360
[11302.797483]  worker_thread+0x4d/0x3c0
[11302.801109]  kthread+0x109/0x140
[11302.804307]  ? rescuer_thread+0x380/0x380
[11302.808280]  ? kthread_park+0x60/0x60
[11302.811913]  ? do_syscall_64+0x67/0x150
[11302.815715]  ret_from_fork+0x25/0x30
[11302.819257] INFO: task jbd2/md0-8:8635 blocked for more than 120 seconds.
[11302.825990]       Tainted: G           OE   4.13.0-rc5 #1
[11302.831338] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11302.839100] jbd2/md0-8      D    0  8635      2 0x00000080
[11302.839101] Call Trace:
[11302.841527]  __schedule+0x28d/0x890
[11302.844985]  schedule+0x36/0x80
[11302.848097]  jbd2_journal_commit_transaction+0x275/0x19e0 [jbd2]
[11302.854052]  ? account_entity_dequeue+0xaa/0xe0
[11302.858541]  ? dequeue_entity+0xed/0x460
[11302.862428]  ? ttwu_do_activate+0x7a/0x90
[11302.866400]  ? dequeue_task_fair+0x565/0x820
[11302.870632]  ? __switch_to+0x229/0x440
[11302.874350]  ? remove_wait_queue+0x60/0x60
[11302.878409]  ? lock_timer_base+0x7d/0xa0
[11302.882299]  ? try_to_del_timer_sync+0x53/0x80
[11302.886704]  kjournald2+0xd2/0x260 [jbd2]
[11302.890676]  ? remove_wait_queue+0x60/0x60
[11302.894740]  kthread+0x109/0x140
[11302.897940]  ? commit_timeout+0x10/0x10 [jbd2]
[11302.902346]  ? kthread_park+0x60/0x60
[11302.905973]  ret_from_fork+0x25/0x30
[11302.909514] INFO: task mdadm:8653 blocked for more than 120 seconds.
[11302.915812]       Tainted: G           OE   4.13.0-rc5 #1
[11302.921160] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11302.928923] mdadm           D    0  8653      1 0x00000080
[11302.928924] Call Trace:
[11302.931347]  __schedule+0x28d/0x890
[11302.934807]  schedule+0x36/0x80
[11302.937923]  mddev_suspend+0x12c/0x160 [md_mod]
[11302.942416]  ? remove_wait_queue+0x60/0x60
[11302.946476]  suspend_hi_store+0x7c/0xe0 [md_mod]
[11302.951052]  md_attr_store+0x80/0xc0 [md_mod]
[11302.955375]  sysfs_kf_write+0x3a/0x50
[11302.959002]  kernfs_fop_write+0xff/0x180
[11302.962894]  __vfs_write+0x37/0x170
[11302.966351]  ? selinux_file_permission+0xe5/0x120
[11302.971013]  ? security_file_permission+0x3b/0xc0
[11302.975679]  vfs_write+0xb2/0x1b0
[11302.978961]  ? syscall_trace_enter+0x1d0/0x2b0
[11302.983366]  SyS_write+0x55/0xc0
[11302.986564]  do_syscall_64+0x67/0x150
[11302.990193]  entry_SYSCALL64_slow_path+0x25/0x25
[11302.994769] RIP: 0033:0x7f016632a840
[11302.998308] RSP: 002b:00007ffdcb5f1d88 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[11303.005811] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f016632a840
[11303.012883] RDX: 0000000000000005 RSI: 00007ffdcb5f1e30 RDI: 0000000000000003
[11303.019953] RBP: 00007ffdcb5f1e30 R08: 00007ffdcb5f1e30 R09: 000000000000001d
[11303.027027] R10: 000000000000000a R11: 0000000000000246 R12: 00000000004699b1
[11303.034101] R13: 0000000000000000 R14: 00000000004dd000 R15: 0000000000000001
[11303.041173] INFO: task dd:8655 blocked for more than 120 seconds.
[11303.047213]       Tainted: G           OE   4.13.0-rc5 #1
[11303.052564] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11303.060325] dd              D    0  8655   2687 0x00000080
[11303.060326] Call Trace:
[11303.062752]  __schedule+0x28d/0x890
[11303.066206]  schedule+0x36/0x80
[11303.069317]  wait_transaction_locked+0x8a/0xd0 [jbd2]
[11303.074326]  ? remove_wait_queue+0x60/0x60
[11303.078385]  add_transaction_credits+0x1c4/0x2a0 [jbd2]
[11303.083567]  start_this_handle+0x197/0x400 [jbd2]
[11303.088229]  ? __add_to_page_cache_locked+0x11c/0x1f0
[11303.093236]  ? kmem_cache_alloc+0x194/0x1a0
[11303.097384]  jbd2__journal_start+0xeb/0x1f0 [jbd2]
[11303.102142]  ? ext4_da_write_begin+0x140/0x410 [ext4]
[11303.107151]  __ext4_journal_start_sb+0x6d/0xf0 [ext4]
[11303.112164]  ext4_da_write_begin+0x140/0x410 [ext4]
[11303.116997]  generic_perform_write+0xbe/0x1b0
[11303.121316]  ? file_update_time+0x5e/0x110
[11303.125380]  __generic_file_write_iter+0x19b/0x1e0
[11303.130130]  ? _crng_backtrack_protect+0x63/0x80
[11303.134712]  ext4_file_write_iter+0x28f/0x3f0 [ext4]
[11303.139630]  __vfs_write+0xf3/0x170
[11303.143087]  vfs_write+0xb2/0x1b0
[11303.146369]  ? syscall_trace_enter+0x1d0/0x2b0
[11303.150772]  SyS_write+0x55/0xc0
[11303.153971]  do_syscall_64+0x67/0x150
[11303.157598]  entry_SYSCALL64_slow_path+0x25/0x25
[11303.162177] RIP: 0033:0x7f951dfa0840
[11303.165720] RSP: 002b:00007fff82316978 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[11303.173226] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f951dfa0840
[11303.180296] RDX: 0000000000100000 RSI: 00007f951e38a000 RDI: 0000000000000001
[11303.187369] RBP: 0000000000100000 R08: ffffffffffffffff R09: 0000000000102003
[11303.194445] R10: 00007fff82316690 R11: 0000000000000246 R12: 0000000000100000
[11303.201520] R13: 00007f951e38a000 R14: 00007f951e48a000 R15: 0000000000000000
[11425.569412] INFO: task kworker/u8:4:8143 blocked for more than 120 seconds.
[11425.576313]       Tainted: G           OE   4.13.0-rc5 #1
[11425.581666] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11425.589428] kworker/u8:4    D    0  8143      2 0x00000080
[11425.589434] Workqueue: writeback wb_workfn (flush-9:0)
[11425.589435] Call Trace:
[11425.591862]  __schedule+0x28d/0x890
[11425.595317]  schedule+0x36/0x80
[11425.598433]  md_make_request+0xb1/0x260 [md_mod]
[11425.603015]  ? remove_wait_queue+0x60/0x60
[11425.607074]  generic_make_request+0x117/0x2f0
[11425.611392]  submit_bio+0x75/0x150
[11425.614763]  ? __test_set_page_writeback+0xc6/0x320
[11425.619607]  ext4_io_submit+0x4c/0x60 [ext4]
[11425.623845]  ext4_bio_write_page+0x1a4/0x3b0 [ext4]
[11425.628682]  mpage_submit_page+0x57/0x70 [ext4]
[11425.633177]  mpage_map_and_submit_buffers+0x168/0x290 [ext4]
[11425.638791]  ext4_writepages+0x852/0xe80 [ext4]
[11425.643283]  ? account_entity_enqueue+0xd8/0x100
[11425.647856]  do_writepages+0x1c/0x70
[11425.651400]  __writeback_single_inode+0x45/0x320
[11425.655972]  writeback_sb_inodes+0x280/0x570
[11425.660206]  __writeback_inodes_wb+0x8c/0xc0
[11425.664436]  wb_writeback+0x276/0x310
[11425.668065]  wb_workfn+0x19c/0x3b0
[11425.671439]  process_one_work+0x149/0x360
[11425.675410]  worker_thread+0x4d/0x3c0
[11425.679036]  kthread+0x109/0x140
[11425.682236]  ? rescuer_thread+0x380/0x380
[11425.686207]  ? kthread_park+0x60/0x60
[11425.689837]  ? do_syscall_64+0x67/0x150
[11425.693637]  ret_from_fork+0x25/0x30
[11425.697180] INFO: task jbd2/md0-8:8635 blocked for more than 120 seconds.
[11425.703907]       Tainted: G           OE   4.13.0-rc5 #1
[11425.709253] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11425.717011] jbd2/md0-8      D    0  8635      2 0x00000080
[11425.717012] Call Trace:
[11425.719436]  __schedule+0x28d/0x890
[11425.722891]  schedule+0x36/0x80
[11425.726006]  jbd2_journal_commit_transaction+0x275/0x19e0 [jbd2]
[11425.731960]  ? account_entity_dequeue+0xaa/0xe0
[11425.736448]  ? dequeue_entity+0xed/0x460
[11425.740337]  ? ttwu_do_activate+0x7a/0x90
[11425.744309]  ? dequeue_task_fair+0x565/0x820
[11425.748538]  ? __switch_to+0x229/0x440
[11425.752253]  ? remove_wait_queue+0x60/0x60
[11425.756313]  ? lock_timer_base+0x7d/0xa0
[11425.760201]  ? try_to_del_timer_sync+0x53/0x80
[11425.764605]  kjournald2+0xd2/0x260 [jbd2]
[11425.768575]  ? remove_wait_queue+0x60/0x60
[11425.772636]  kthread+0x109/0x140
[11425.775832]  ? commit_timeout+0x10/0x10 [jbd2]
[11425.780236]  ? kthread_park+0x60/0x60
[11425.783863]  ret_from_fork+0x25/0x30
[11425.787406] INFO: task mdadm:8653 blocked for more than 120 seconds.
[11425.793704]       Tainted: G           OE   4.13.0-rc5 #1
[11425.799053] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11425.806815] mdadm           D    0  8653      1 0x00000080
[11425.806816] Call Trace:
[11425.809237]  __schedule+0x28d/0x890
[11425.812694]  schedule+0x36/0x80
[11425.815807]  mddev_suspend+0x12c/0x160 [md_mod]
[11425.820297]  ? remove_wait_queue+0x60/0x60
[11425.824357]  suspend_hi_store+0x7c/0xe0 [md_mod]
[11425.828933]  md_attr_store+0x80/0xc0 [md_mod]
[11425.833253]  sysfs_kf_write+0x3a/0x50
[11425.836881]  kernfs_fop_write+0xff/0x180
[11425.840771]  __vfs_write+0x37/0x170
[11425.844228]  ? selinux_file_permission+0xe5/0x120
[11425.848888]  ? security_file_permission+0x3b/0xc0
[11425.853552]  vfs_write+0xb2/0x1b0
[11425.856836]  ? syscall_trace_enter+0x1d0/0x2b0
[11425.861242]  SyS_write+0x55/0xc0
[11425.864438]  do_syscall_64+0x67/0x150
[11425.868063]  entry_SYSCALL64_slow_path+0x25/0x25
[11425.872639] RIP: 0033:0x7f016632a840
[11425.876177] RSP: 002b:00007ffdcb5f1d88 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[11425.883680] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f016632a840
[11425.890752] RDX: 0000000000000005 RSI: 00007ffdcb5f1e30 RDI: 0000000000000003
[11425.897824] RBP: 00007ffdcb5f1e30 R08: 00007ffdcb5f1e30 R09: 000000000000001d
[11425.904895] R10: 000000000000000a R11: 0000000000000246 R12: 00000000004699b1
[11425.911966] R13: 0000000000000000 R14: 00000000004dd000 R15: 0000000000000001
[11425.919038] INFO: task dd:8655 blocked for more than 120 seconds.
[11425.925076]       Tainted: G           OE   4.13.0-rc5 #1
[11425.930424] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11425.938181] dd              D    0  8655   2687 0x00000080
[11425.938182] Call Trace:
[11425.940604]  __schedule+0x28d/0x890
[11425.944059]  schedule+0x36/0x80
[11425.947170]  wait_transaction_locked+0x8a/0xd0 [jbd2]
[11425.952178]  ? remove_wait_queue+0x60/0x60
[11425.956238]  add_transaction_credits+0x1c4/0x2a0 [jbd2]
[11425.961418]  start_this_handle+0x197/0x400 [jbd2]
[11425.966079]  ? __add_to_page_cache_locked+0x11c/0x1f0
[11425.971086]  ? kmem_cache_alloc+0x194/0x1a0
[11425.975232]  jbd2__journal_start+0xeb/0x1f0 [jbd2]
[11425.979987]  ? ext4_da_write_begin+0x140/0x410 [ext4]
[11425.984997]  __ext4_journal_start_sb+0x6d/0xf0 [ext4]
[11425.990009]  ext4_da_write_begin+0x140/0x410 [ext4]
[11425.994840]  generic_perform_write+0xbe/0x1b0
[11425.999156]  ? file_update_time+0x5e/0x110
[11426.003217]  __generic_file_write_iter+0x19b/0x1e0
[11426.007963]  ? _crng_backtrack_protect+0x63/0x80
[11426.012546]  ext4_file_write_iter+0x28f/0x3f0 [ext4]
[11426.017464]  __vfs_write+0xf3/0x170
[11426.020921]  vfs_write+0xb2/0x1b0
[11426.024204]  ? syscall_trace_enter+0x1d0/0x2b0
[11426.028606]  SyS_write+0x55/0xc0
[11426.031806]  do_syscall_64+0x67/0x150
[11426.035432]  entry_SYSCALL64_slow_path+0x25/0x25
[11426.040010] RIP: 0033:0x7f951dfa0840
[11426.043550] RSP: 002b:00007fff82316978 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[11426.051054] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f951dfa0840
[11426.058126] RDX: 0000000000100000 RSI: 00007f951e38a000 RDI: 0000000000000001
[11426.065200] RBP: 0000000000100000 R08: ffffffffffffffff R09: 0000000000102003
[11426.072273] R10: 00007fff82316690 R11: 0000000000000246 R12: 0000000000100000
[11426.079345] R13: 00007f951e38a000 R14: 00007f951e48a000 R15: 0000000000000000
[11548.447362] INFO: task kworker/u8:4:8143 blocked for more than 120 seconds.
[11548.454261]       Tainted: G           OE   4.13.0-rc5 #1
[11548.459616] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11548.467378] kworker/u8:4    D    0  8143      2 0x00000080
[11548.467383] Workqueue: writeback wb_workfn (flush-9:0)
[11548.467384] Call Trace:
[11548.469811]  __schedule+0x28d/0x890
[11548.473266]  schedule+0x36/0x80
[11548.476379]  md_make_request+0xb1/0x260 [md_mod]
[11548.480956]  ? remove_wait_queue+0x60/0x60
[11548.485014]  generic_make_request+0x117/0x2f0
[11548.489331]  submit_bio+0x75/0x150
[11548.492702]  ? __test_set_page_writeback+0xc6/0x320
[11548.497550]  ext4_io_submit+0x4c/0x60 [ext4]
[11548.501786]  ext4_bio_write_page+0x1a4/0x3b0 [ext4]
[11548.506624]  mpage_submit_page+0x57/0x70 [ext4]
[11548.511119]  mpage_map_and_submit_buffers+0x168/0x290 [ext4]
[11548.516731]  ext4_writepages+0x852/0xe80 [ext4]
[11548.521222]  ? account_entity_enqueue+0xd8/0x100
[11548.525796]  do_writepages+0x1c/0x70
[11548.529340]  __writeback_single_inode+0x45/0x320
[11548.533913]  writeback_sb_inodes+0x280/0x570
[11548.538146]  __writeback_inodes_wb+0x8c/0xc0
[11548.542375]  wb_writeback+0x276/0x310
[11548.546001]  wb_workfn+0x19c/0x3b0
[11548.549373]  process_one_work+0x149/0x360
[11548.553344]  worker_thread+0x4d/0x3c0
[11548.556972]  kthread+0x109/0x140
[11548.560172]  ? rescuer_thread+0x380/0x380
[11548.564142]  ? kthread_park+0x60/0x60
[11548.567770]  ? do_syscall_64+0x67/0x150
[11548.571571]  ret_from_fork+0x25/0x30
[11548.575111] INFO: task jbd2/md0-8:8635 blocked for more than 120 seconds.
[11548.581839]       Tainted: G           OE   4.13.0-rc5 #1
[11548.587186] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11548.594948] jbd2/md0-8      D    0  8635      2 0x00000080
[11548.594949] Call Trace:
[11548.597372]  __schedule+0x28d/0x890
[11548.600825]  schedule+0x36/0x80
[11548.603937]  jbd2_journal_commit_transaction+0x275/0x19e0 [jbd2]
[11548.609892]  ? account_entity_dequeue+0xaa/0xe0
[11548.614379]  ? dequeue_entity+0xed/0x460
[11548.618268]  ? ttwu_do_activate+0x7a/0x90
[11548.622240]  ? dequeue_task_fair+0x565/0x820
[11548.626469]  ? __switch_to+0x229/0x440
[11548.630187]  ? remove_wait_queue+0x60/0x60
[11548.634245]  ? lock_timer_base+0x7d/0xa0
[11548.638133]  ? try_to_del_timer_sync+0x53/0x80
[11548.642536]  kjournald2+0xd2/0x260 [jbd2]
[11548.646506]  ? remove_wait_queue+0x60/0x60
[11548.650564]  kthread+0x109/0x140
[11548.653763]  ? commit_timeout+0x10/0x10 [jbd2]
[11548.658168]  ? kthread_park+0x60/0x60
[11548.661794]  ret_from_fork+0x25/0x30


--------------0279E369CFBEEF45E671703E--
