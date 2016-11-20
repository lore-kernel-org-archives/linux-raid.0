From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [BUG 4.4.26] bio->bi_bdev == NULL in raid6 return_io()
Date: Sun, 20 Nov 2016 13:55:43 +0300
Message-ID: <c7f3d4e3-0ef6-a6d8-7c8b-bbdb903af7a9@yandex-team.ru>
References: <251e243a-ebcd-ae83-0850-a2143d2423ca@yandex-team.ru>
 <20161107194627.hsdk7zqoxznxdixl@kernel.org>
 <CALYGNiMSEH-tnfzYMKuYe4KRaY6+s8KeKgUUSZRK5fQiwv3y_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CALYGNiMSEH-tnfzYMKuYe4KRaY6+s8KeKgUUSZRK5fQiwv3y_g@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>, Shaohua Li <shli@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Neil Brown <neilb@suse.com>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-raid.ids

On 07.11.2016 23:34, Konstantin Khlebnikov wrote:
> On Mon, Nov 7, 2016 at 10:46 PM, Shaohua Li <shli@kernel.org> wrote:
>> On Sat, Nov 05, 2016 at 01:48:45PM +0300, Konstantin Khlebnikov wrote:
>>> return_io() resolves request_queue even if trace point isn't active:
>>>
>>> static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
>>> {
>>>       return bdev->bd_disk->queue;    /* this is never NULL */
>>> }
>>>
>>> static void return_io(struct bio_list *return_bi)
>>> {
>>>       struct bio *bi;
>>>       while ((bi = bio_list_pop(return_bi)) != NULL) {
>>>               bi->bi_iter.bi_size = 0;
>>>               trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
>>>                                        bi, 0);
>>>               bio_endio(bi);
>>>       }
>>> }
>>
>> I can't see how this could happen. What kind of tests/environment are these running?
>
> That was a random piece of production somewhere.
> Cording to time all crashes happened soon after reboot.
> There're several raids, probably some of them were still under resync.
>
> For now we have only few machines with this kernel. But I'm sure that
> I'll get much more soon =)

I've added this debug patch for catching overflow of active stripes in bio

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -164,6 +164,7 @@ static inline void raid5_inc_bi_active_stripes(struct bio *bio)
  {
         atomic_t *segments = (atomic_t *)&bio->bi_phys_segments;
         atomic_inc(segments);
+       BUG_ON(!(atomic_read(segments) & 0xffff));
  }

And got this. Counter in %edx = 0x00010000

So, looks like one bio (discard?) can cover more than 65535 stripes

<2>[97201.226871] kernel BUG at drivers/md/raid5.c:167!
<4>[97201.232128] invalid opcode: 0000 [#1] SMP
<4>[97201.236735] Modules linked in: netconsole configfs ip6table_filter ip6_tables tcp_diag iptable_filter inet_diag ip_tables unix_diag 
x_tables ipmi_devintf 8021q mrp garp stp llc cls_u32 sch_prio ipmi_ssif nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc grace intel_rapl 
iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crc32_pclmul serio_raw joydev input_leds sb_edac edac_core 
mei_me lpc_ich mei ioatdma ipmi_si ipmi_msghandler 8250_fintek wmi shpchp mac_hid ip6_tunnel tunnel6 ipip ip_tunnel tunnel4 xfs raid10 
raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c hid_generic usbhid igb hid i2c_algo_bit raid1 isci 
dca raid0 libsas ahci ptp psmouse multipath libahci scsi_transport_sas pps_core fjes linear
<4>[97201.313832] CPU: 0 PID: 667624 Comm: kworker/0:0H Not tainted 4.4.32-11 #1
<4>[97201.321519] Hardware name: Aquarius Aquarius Server/X9DRW, BIOS 3.0c 10/30/2014
<4>[97201.329739] Workqueue: xfs-log/dm-0 xfs_buf_ioend_work [xfs]
<4>[97201.336083] task: ffff88084a27ec00 ti: ffff8808f70a8000 task.ti: ffff8808f70a8000
<4>[97201.344448] RIP: raid5_inc_bi_active_stripes.part.34 (drivers/md/raid5.c:589) raid456
<4>[97201.356423] RSP: 0018:ffff8808f70ab948  EFLAGS: 00010046
<4>[97201.362388] RAX: 0000000000000002 RBX: ffff8810356a6000 RCX: ffff8810356a6290
<4>[97201.370392] RDX: 0000000000010000 RSI: 0000000000000087 RDI: 0000000000000087
<4>[97201.378395] RBP: ffff8808f70ab948 R08: ffff8808f70ab638 R09: 000000001a7a8400
<4>[97201.386398] R10: 0000000000000006 R11: 0000000000000006 R12: ffff881efd418000
<4>[97201.394401] R13: 000000001a7a84b0 R14: ffff881034edec00 R15: 000000001a7c8400
<4>[97201.402406] FS:  0000000000000000(0000) GS:ffff88103fa00000(0000) knlGS:0000000000000000
<4>[97201.411500] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[97201.417949] CR2: 000055acd2d2bb10 CR3: 00000010364f3000 CR4: 00000000000406f0
<4>[97201.425953] Stack:
<4>[97201.428224]  ffff8808f70aba48 ffffffffa01b54fa ffff881034edec00 ffff88084a27ec00
<4>[97201.436589]  ffff8808f70ab998 ffff881034edec00 0000000000000081 ffff88084a27ec00
<4>[97201.444952]  ffff8808f70ab9f0 ffff881038a37800 ffff8810356a6288 ffff881efd418068
<4>[97201.453317] Call Trace:
<4>[97201.456078] make_request (drivers/md/raid5.c:4792 drivers/md/raid5.c:4882 drivers/md/raid5.c:5177) raid456
<4>[97201.463209] ? add_wait_queue (kernel/sched/wait.c:292)
<4>[97201.469562] ? add_wait_queue (kernel/sched/wait.c:292)
<4>[97201.475915] md_make_request (./arch/x86/include/asm/preempt.h:69 include/linux/rcupdate.h:301 include/linux/rcupdate.h:859 
drivers/md/md.c:300)
<4>[97201.482365] ? dm_make_request (drivers/md/dm.c:1785)
<4>[97201.488814] generic_make_request (./arch/x86/include/asm/preempt.h:69 include/linux/rcupdate.h:975 include/linux/percpu-refcount.h:273 
include/linux/percpu-refcount.h:294 block/blk-core.c:674 block/blk-core.c:2069 block/blk-core.c:2022)
<4>[97201.495643] submit_bio (block/blk-core.c:2132)
<4>[97201.501510] blkdev_issue_discard (block/blk-lib.c:119)
<4>[97201.508461] xfs_discard_extents (fs/xfs/xfs_discard.c:228) xfs
<4>[97201.515803] xlog_cil_committed (fs/xfs/xfs_log_cil.c:410) xfs
<4>[97201.523142] xlog_state_do_callback (fs/xfs/xfs_log.c:2756) xfs
<4>[97201.530875] xlog_state_done_syncing (fs/xfs/xfs_log.c:2881) xfs
<4>[97201.538604] ? xfs_buf_ioend_work (fs/xfs/xfs_buf.c:1053) xfs
<4>[97201.545941] xlog_iodone (fs/xfs/xfs_log.c:1218) xfs
<4>[97201.552404] xfs_buf_ioend (fs/xfs/xfs_buf.c:1043) xfs
<4>[97201.559157] xfs_buf_ioend_work (fs/xfs/xfs_buf.c:1053) xfs
<4>[97201.566286] process_one_work (./arch/x86/include/asm/jump_label.h:21 include/linux/jump_label.h:138 
include/trace/events/workqueue.h:111 kernel/workqueue.c:2074)
<4>[97201.572832] worker_thread (kernel/workqueue.c:2202)
<4>[97201.579080] ? create_worker (kernel/workqueue.c:2146)
<4>[97201.585522] kthread (kernel/kthread.c:209)
<4>[97201.591000] ? flush_kthread_worker (kernel/kthread.c:178)
<4>[97201.597936] ret_from_fork (arch/x86/entry/entry_64.S:469)
<4>[97201.603997] ? flush_kthread_worker (kernel/kthread.c:178)
<4>[97201.610937] Code: 01 00 00 48 83 ec 08 e8 83 21 4c e1 48 8b bb 50 01 00 00 e8 97 8d 01 e1 48 89 df e8 9f 01 05 e1 48 83 c4 08 5b 5d c3 
55 48 89 e5 <0f> 0b 55 48 89 e5 41 54 49 89 cc 53 48 03 77 58 48 89 fb 48 8d
All code
========
    0:	01 00                	add    %eax,(%rax)
    2:	00 48 83             	add    %cl,-0x7d(%rax)
    5:	ec                   	in     (%dx),%al
    6:	08 e8                	or     %ch,%al
    8:	83 21 4c             	andl   $0x4c,(%rcx)
    b:	e1 48                	loope  0x55
    d:	8b bb 50 01 00 00    	mov    0x150(%rbx),%edi
   13:	e8 97 8d 01 e1       	callq  0xffffffffe1018daf
   18:	48 89 df             	mov    %rbx,%rdi
   1b:	e8 9f 01 05 e1       	callq  0xffffffffe10501bf
   20:	48 83 c4 08          	add    $0x8,%rsp
   24:	5b                   	pop    %rbx
   25:	5d                   	pop    %rbp
   26:	c3                   	retq
   27:	55                   	push   %rbp
   28:	48 89 e5             	mov    %rsp,%rbp
   2b:*	0f 0b                	ud2    		<-- trapping instruction
   2d:	55                   	push   %rbp
   2e:	48 89 e5             	mov    %rsp,%rbp
   31:	41 54                	push   %r12
   33:	49 89 cc             	mov    %rcx,%r12
   36:	53                   	push   %rbx
   37:	48 03 77 58          	add    0x58(%rdi),%rsi
   3b:	48 89 fb             	mov    %rdi,%rbx
   3e:	48                   	rex.W
   3f:	8d                   	.byte 0x8d

Code starting with the faulting instruction
===========================================
    0:	0f 0b                	ud2
    2:	55                   	push   %rbp
    3:	48 89 e5             	mov    %rsp,%rbp
    6:	41 54                	push   %r12
    8:	49 89 cc             	mov    %rcx,%r12
    b:	53                   	push   %rbx
    c:	48 03 77 58          	add    0x58(%rdi),%rsi
   10:	48 89 fb             	mov    %rdi,%rbx
   13:	48                   	rex.W
   14:	8d                   	.byte 0x8d
<1>[97201.632944] RIP raid5_inc_bi_active_stripes.part.34 (drivers/md/raid5.c:589) raid456
<4>[97201.642343]  RSP <ffff8808f70ab948>
<5>[97201.646732] ---[ now 2016-11-19 14:36:20+03 ]---
<4>[97201.653089] ---[ end trace 77df1d3ea4bbcda7 ]---

I'm not sure what's going on here - xfs sening siscard but

in make_request() stack trace points to this branch

	if (rw == READ && mddev->degraded == 0 &&
	    mddev->reshape_position == MaxSector) {
		bi = chunk_aligned_read(mddev, bi);
		if (!bi)
			return;
	}

probably this is error in debug-info because line of raid5_inc_bi_active_stripes is completely wrong too.

and it actually execures next branch

	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
		make_discard_request(mddev, bi);
		return;
	}


>
>>
>> Thanks,
>> Shaohua
>>
>>> kernel build with gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) from ubuntu precise
>>>
>>> <6>[ 1659.710716] md: md2: resync done.
>>> <6>[ 1659.968273] md: resync of RAID array md0
>>> <6>[ 1659.968281] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>>> <6>[ 1659.968284] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
>>> <6>[ 1659.968310] md: using 128k window, over a total of 16770816k.
>>> <6>[ 1659.968311] md: resuming resync of md0 from checkpoint.
>>> <7>[ 1659.968674] RAID conf printout:
>>> <7>[ 1659.968678]  --- level:6 rd:6 wd:6
>>> <7>[ 1659.968680]  disk 0, o:1, dev:sda3
>>> <7>[ 1659.968682]  disk 1, o:1, dev:sdc3
>>> <7>[ 1659.968683]  disk 2, o:1, dev:sdb3
>>> <7>[ 1659.968684]  disk 3, o:1, dev:sdd3
>>> <7>[ 1659.968685]  disk 4, o:1, dev:sde3
>>> <7>[ 1659.968686]  disk 5, o:1, dev:sdf3
>>> <7>[ 1779.468199] RAID conf printout:
>>> <7>[ 1779.468204]  --- level:6 rd:6 wd:6
>>> <7>[ 1779.468206]  disk 0, o:1, dev:sda1
>>> <7>[ 1779.468208]  disk 1, o:1, dev:sdc1
>>> <7>[ 1779.468209]  disk 2, o:1, dev:sdb1
>>> <7>[ 1779.468210]  disk 3, o:1, dev:sdd1
>>> <7>[ 1779.468211]  disk 4, o:1, dev:sde1
>>> <7>[ 1779.468212]  disk 5, o:1, dev:sdf1
>>> <1>[ 4658.730260] IP: return_io (include/linux/blkdev.h:825 drivers/md/raid5.c:231) raid456
>>> <4>[ 4658.737189] PGD 0
>>> <4>[ 4658.739452] Oops: 0000 [#1] SMP
>>> <4>[ 4658.743080] Modules linked in: netconsole(E) configfs(E) unix_diag(E)
>>> tcp_diag(E) inet_diag(E) ip6t_REJECT(E) nf_reject_ipv6(E) ip6table_filter(E)
>>> ip6table_mangle(E) ip6_tables(E) ipt_R
>>> EJECT(E) nf_reject_ipv4(E) iptable_filter(E) iptable_mangle(E) ip_tables(E)
>>> x_tables(E) ipmi_devintf(E) nfsd(E) nfs_acl(E) auth_rpcgss(E) nfs(E)
>>> fscache(E) lockd(E) sunrpc(E) grace(E) cls_u32
>>> (E) sch_prio(E) ipmi_ssif(E) intel_rapl(E) iosf_mbi(E)
>>> x86_pkg_temp_thermal(E) intel_powerclamp(E) 8021q(E) coretemp(E) mrp(E)
>>> garp(E) stp(E) kvm_intel(E) llc(E) kvm(E) irqbypass(E) crc32_pcl
>>> mul(E) sb_edac(E) serio_raw(E) joydev(E) input_leds(E) edac_core(E)
>>> mei_me(E) mei(E) ioatdma(E) lpc_ich(E) ipmi_si(E) 8250_fintek(E)
>>> ipmi_msghandler(E) shpchp(E) wmi(E) mac_hid(E) ip6_tunnel(
>>> E) tunnel6(E) ipip(E) ip_tunnel(E) tunnel4(E) xfs(E)<4>[ 4658.822823]
>>> raid10(E) raid456(E) async_raid6_recov(E) async_memcpy(E) async_pq(E)
>>> async_xor(E) async_tx(E) xor(E) hid_generic(E) usb
>>> hid(E) raid6_pq(E) libcrc32c(E) hid(E) igb(E) i2c_algo_bit(E) raid1(E)
>>> isci(E) dca(E) raid0(E) ptp(E) multipath(E) libsas(E) ahci(E) pps_core(E)
>>> scsi_transport_sas(E) psmouse(E) libahci(E) fj
>>> es(E) linear(E)
>>> <4>[ 4658.855131] CPU: 14 PID: 501 Comm: md2_raid6 Tainted: G            E   4.4.26-9 #1
>>> <4>[ 4658.863621] Hardware name: Supermicro X9DRW/X9DRW, BIOS 3.00 07/05/2013
>>> <4>[ 4658.871041] task: ffff882035781a80 ti: ffff882033c08000 task.ti: ffff882033c08000
>>> <4>[ 4658.879455] RIP: return_io (include/linux/blkdev.h:825 drivers/md/raid5.c:231) raid456
>>> <4>[ 4658.889155] RSP: 0018:ffff882033c0bb18  EFLAGS: 00010246
>>> <4>[ 4658.895118] RAX: 0000000000000000 RBX: ffff881ff22af2c0 RCX: ffff881ff22af4e0
>>> <4>[ 4658.903122] RDX: 0000000000000000 RSI: ffff881ff22af2c0 RDI: ffff882033c0bc28
>>> <4>[ 4658.911127] RBP: ffff882033c0bb48 R08: 0000000000000000 R09: 0000000000000000
>>> <4>[ 4658.919130] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88203643db00
>>> <4>[ 4658.927134] R13: 0000000000000006 R14: 0000000000000004 R15: ffff882033c0bc28
>>> <4>[ 4658.935139] FS:  0000000000000000(0000) GS:ffff88203f380000(0000) knlGS:0000000000000000
>>> <4>[ 4658.944233] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> <4>[ 4658.950683] CR2: 0000000000000098 CR3: 0000000001e0b000 CR4: 00000000000406e0
>>> <4>[ 4658.958682] Stack:
>>> <4>[ 4658.960952]  ffff882033c0bb78 ffff881ff22af2c0 ffff8820354b0800 0000000000000006
>>> <4>[ 4658.969329]  0000000000000004 0000000000000006 ffff882033c0bc88 ffffffffa015c0dd
>>> <4>[ 4658.977697]  0000000000000000 ffff8820354b0a78 0000000000000000 0000000000000000
>>> <4>[ 4658.986067] Call Trace:
>>> <4>[ 4658.988827] handle_stripe (drivers/md/raid5.c:4635) raid456
>>> <4>[ 4658.996156] ? default_wake_function (kernel/sched/core.c:3376)
>>> <4>[ 4659.003190] ? autoremove_wake_function (kernel/sched/wait.c:295)
>>> <4>[ 4659.010516] ? __wake_up_common (kernel/sched/wait.c:73)
>>> <4>[ 4659.017065] handle_active_stripes.isra.49 (drivers/md/raid5.c:5776) raid456
>>> <4>[ 4659.025877] raid5d (drivers/md/raid5.c:5889) raid456
>>> <4>[ 4659.032428] ? _raw_spin_lock_irqsave
>>> (./arch/x86/include/asm/paravirt.h:696 ./arch/x86/include/asm/qspinlock.h:28
>>> include/asm-generic/qspinlock.h:102 include/linux/spinlock.h:155
>>> include/linux/spinlock_api_smp.h:121 kernel/locking/spinlock.c:159)
>>> <4>[ 4659.039559] md_thread (drivers/md/md.c:7099)
>>> <4>[ 4659.045434] ? add_wait_queue (kernel/sched/wait.c:292)
>>> <4>[ 4659.051786] ? md_rdev_init (drivers/md/md.c:7083)
>>> <4>[ 4659.058140] kthread (kernel/kthread.c:209)
>>> <4>[ 4659.063618] ? flush_kthread_worker (kernel/kthread.c:178)
>>> <4>[ 4659.070554] ret_from_fork (arch/x86/entry/entry_64.S:469)
>>> <4>[ 4659.076619] ? flush_kthread_worker (kernel/kthread.c:178)
>>> <4>[ 4659.083553] Code: 83 ec 08 eb 41 49 8b 04 24 48 85 c0 49 89 07 0f 84
>>> a3 00 00 00 49 8b 44 24 08 49 c7 04 24 00 00 00 00 41 c7 44 24 28 00 00 00
>>> 00 <48> 8b 80 98 00 00 00 4c 8b a8 c0 03 00 00 66 66 66 66 90 4c 89
>>> All code
>>> ========
>>>    0: 83 ec 08                sub    $0x8,%esp
>>>    3: eb 41                   jmp    0x46
>>>    5: 49 8b 04 24             mov    (%r12),%rax
>>>    9: 48 85 c0                test   %rax,%rax
>>>    c: 49 89 07                mov    %rax,(%r15)
>>>    f: 0f 84 a3 00 00 00       je     0xb8
>>>   15: 49 8b 44 24 08          mov    0x8(%r12),%rax
>>>   1a: 49 c7 04 24 00 00 00    movq   $0x0,(%r12)
>>>   21: 00
>>>   22: 41 c7 44 24 28 00 00    movl   $0x0,0x28(%r12)
>>>   29: 00 00
>>>   2b:*        48 8b 80 98 00 00 00    mov    0x98(%rax),%rax          <-- trapping instruction
>>>   32: 4c 8b a8 c0 03 00 00    mov    0x3c0(%rax),%r13
>>>   39: 66 66 66 66 90          data32 data32 data32 xchg %ax,%ax
>>>   3e: 4c                      rex.WR
>>>   3f: 89                      .byte 0x89
>>>
>>> Code starting with the faulting instruction
>>> ===========================================
>>>    0: 48 8b 80 98 00 00 00    mov    0x98(%rax),%rax
>>>    7: 4c 8b a8 c0 03 00 00    mov    0x3c0(%rax),%r13
>>>    e: 66 66 66 66 90          data32 data32 data32 xchg %ax,%ax
>>>   13: 4c                      rex.WR
>>>   14: 89                      .byte 0x89
>>> <1>[ 4659.105577] RIP return_io (include/linux/blkdev.h:825 drivers/md/raid5.c:231) raid456
>>>
>>>
>>> Couple times kernel failed second dereference
>>>
>>> <6>[ 1815.549178] md: md2: resync done.
>>> <7>[ 1815.675433] RAID conf printout:
>>> <7>[ 1815.675439]  --- level:6 rd:6 wd:6
>>> <7>[ 1815.675441]  disk 0, o:1, dev:sda3
>>> <7>[ 1815.675442]  disk 1, o:1, dev:sdb3
>>> <7>[ 1815.675443]  disk 2, o:1, dev:sdc3
>>> <7>[ 1815.675444]  disk 3, o:1, dev:sdd3
>>> <7>[ 1815.675445]  disk 4, o:1, dev:sde3
>>> <7>[ 1815.675446]  disk 5, o:1, dev:sdf3
>>>
>>> <1>[ 2698.718595] IP: return_io (include/linux/blkdev.h:825 drivers/md/raid5.c:231) raid456
>>> <4>[ 2698.725521] PGD 0
>>> <4>[ 2698.727774] Oops: 0000 [#1] SMP
>>> <4>[ 2698.731409] Modules linked in: netconsole(E) configfs(E) unix_diag(E)
>>> tcp_diag(E) inet_diag(E) ip6table_filter(E) ip6_tables(E) iptable_filter(E)
>>> ip_tables(E) x_tables(E) ipmi_devintf(E
>>> ) nfsd(E) nfs_acl(E) auth_rpcgss(E) nfs(E) fscache(E) lockd(E) sunrpc(E)
>>> grace(E) cls_u32(E) sch_prio(E) ipmi_ssif(E) intel_rapl(E) iosf_mbi(E)
>>> x86_pkg_temp_thermal(E) intel_powerclamp(E) cor
>>> etemp(E) kvm_intel(E) kvm(E) 8021q(E) irqbypass(E) mrp(E) garp(E)
>>> crc32_pclmul(E) stp(E) llc(E) serio_raw(E) input_leds(E) joydev(E)
>>> sb_edac(E) edac_core(E) mei_me(E) lpc_ich(E) mei(E) ipmi_s
>>> i(E) ioatdma(E) ipmi_msghandler(E) 8250_fintek(E) shpchp(E) wmi(E)
>>> mac_hid(E) ip6_tunnel(E) tunnel6(E) ipip(E) ip_tunnel(E) tunnel4(E) xfs(E)
>>> raid10(E) raid456(E) async_raid6_recov(E) async_m
>>> emcpy(E) async_pq(E) async_xor(E) async_tx(E) xor(E)<4>[ 2698.811146]
>>> hid_generic(E) raid6_pq(E) libcrc32c(E) usbhid(E) igb(E) hid(E)
>>> i2c_algo_bit(E) raid1(E) isci(E) dca(E) raid0(E) libsas(
>>> E) ahci(E) ptp(E) multipath(E) psmouse(E) libahci(E) scsi_transport_sas(E) pps_core(E) linear(E) fjes(E)
>>> <4>[ 2698.833480] CPU: 2 PID: 514 Comm: md2_raid6 Tainted: G            E   4.4.26-9 #1
>>> <4>[ 2698.841845] Hardware name: Supermicro X9DRW/X9DRW, BIOS 3.0c 10/30/2014
>>> <4>[ 2698.849241] task: ffff882033ec1a80 ti: ffff882033ef4000 task.ti: ffff882033ef4000
>>> <4>[ 2698.857656] RIP: return_io (include/linux/blkdev.h:825 drivers/md/raid5.c:231) raid456
>>> <4>[ 2698.867346] RSP: 0018:ffff882033ef7b18  EFLAGS: 00010246
>>> <4>[ 2698.873307] RAX: 0000000000000000 RBX: ffff881fef26afd0 RCX: ffff881fef26b1f0
>>> <4>[ 2698.881311] RDX: 0000000000000000 RSI: ffff881fef26afd0 RDI: ffff882033ef7c28
>>> <4>[ 2698.889314] RBP: ffff882033ef7b48 R08: 0000000000000000 R09: 0000000000000000
>>> <4>[ 2698.897319] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880f9880cd00
>>> <4>[ 2698.905322] R13: 0000000000000006 R14: 0000000000000004 R15: ffff882033ef7c28
>>> <4>[ 2698.913327] FS:  0000000000000000(0000) GS:ffff88103fa80000(0000) knlGS:0000000000000000
>>> <4>[ 2698.922420] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> <4>[ 2698.928869] CR2: 00000000000003c0 CR3: 0000000001e0b000 CR4: 00000000000406e0
>>> <4>[ 2698.936871] Stack:
>>> <4>[ 2698.939153]  ffff882033ef7b78 ffff881fef26afd0 ffff8810355cbc00 0000000000000006
>>> <4>[ 2698.947512]  0000000000000004 0000000000000006 ffff882033ef7c88 ffffffffa01970dd
>>> <4>[ 2698.955867]  0000000000000000 ffff8810355cbe78 0000000000000000 0000000000000000
>>> <4>[ 2698.964222] Call Trace:
>>> <4>[ 2698.966982] handle_stripe (drivers/md/raid5.c:4635) raid456
>>> <4>[ 2698.974318] ? default_wake_function (kernel/sched/core.c:3376)
>>> <4>[ 2698.981350] ? autoremove_wake_function (kernel/sched/wait.c:295)
>>> <4>[ 2698.988665] ? __wake_up_common (kernel/sched/wait.c:73)
>>> <4>[ 2698.995214] handle_active_stripes.isra.49 (drivers/md/raid5.c:5776) raid456
>>> <4>[ 2699.004020] raid5d (drivers/md/raid5.c:5889) raid456
>>> <4>[ 2699.010571] ? _raw_spin_lock_irqsave
>>> (./arch/x86/include/asm/paravirt.h:696 ./arch/x86/include/asm/qspinlock.h:28
>>> include/asm-generic/qspinlock.h:102 include/linux/spinlock.h:155
>>> include/linux/spinlock_api_smp.h:121 kernel/locking/spinlock.c:159)
>>> <4>[ 2699.017711] md_thread (drivers/md/md.c:7099)
>>> <4>[ 2699.023592] ? add_wait_queue (kernel/sched/wait.c:292)
>>> <4>[ 2699.029952] ? md_rdev_init (drivers/md/md.c:7083)
>>> <4>[ 2699.036305] kthread (kernel/kthread.c:209)
>>> <4>[ 2699.041783] ? flush_kthread_worker (kernel/kthread.c:178)
>>> <4>[ 2699.048719] ret_from_fork (arch/x86/entry/entry_64.S:469)
>>> <4>[ 2699.054779] ? flush_kthread_worker (kernel/kthread.c:178)
>>> <4>[ 2699.061713] Code: 04 24 48 85 c0 49 89 07 0f 84 a3 00 00 00 49 8b 44
>>> 24 08 49 c7 04 24 00 00 00 00 41 c7 44 24 28 00 00 00 00 48 8b 80 98 00 00
>>> 00 <4c> 8b a8 c0 03 00 00 66 66 66 66 90 4c 89 e7 e8 f4 09 20 e1 4d
>>> All code
>>> ========
>>>    0: 04 24                   add    $0x24,%al
>>>    2: 48 85 c0                test   %rax,%rax
>>>    5: 49 89 07                mov    %rax,(%r15)
>>>    8: 0f 84 a3 00 00 00       je     0xb1
>>>    e: 49 8b 44 24 08          mov    0x8(%r12),%rax
>>>   13: 49 c7 04 24 00 00 00    movq   $0x0,(%r12)
>>>   1a: 00
>>>   1b: 41 c7 44 24 28 00 00    movl   $0x0,0x28(%r12)
>>>   22: 00 00
>>>   24: 48 8b 80 98 00 00 00    mov    0x98(%rax),%rax
>>>   2b:*        4c 8b a8 c0 03 00 00    mov    0x3c0(%rax),%r13         <-- trapping instruction
>>>   32: 66 66 66 66 90          data32 data32 data32 xchg %ax,%ax
>>>   37: 4c 89 e7                mov    %r12,%rdi
>>>   3a: e8 f4 09 20 e1          callq  0xffffffffe1200a33
>>>   3f: 4d                      rex.WRB
>>>
>>> Code starting with the faulting instruction
>>> ===========================================
>>>    0: 4c 8b a8 c0 03 00 00    mov    0x3c0(%rax),%r13
>>>    7: 66 66 66 66 90          data32 data32 data32 xchg %ax,%ax
>>>    c: 4c 89 e7                mov    %r12,%rdi
>>>    f: e8 f4 09 20 e1          callq  0xffffffffe1200a08
>>>   14: 4d                      rex.WRB
>>>
>>>
>>> --
>>> Konstantin
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Konstantin
