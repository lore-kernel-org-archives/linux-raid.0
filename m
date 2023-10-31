Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF9CC4167B
	for <linux-raid@archiver.kernel.org>; Tue, 31 Oct 2023 02:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjJaCo3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 Oct 2023 22:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjJaCo2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 Oct 2023 22:44:28 -0400
X-Greylist: delayed 497 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Oct 2023 19:44:24 PDT
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0B6A6
        for <linux-raid@vger.kernel.org>; Mon, 30 Oct 2023 19:44:24 -0700 (PDT)
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SKDll4y07z9RMF
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 13:36:03 +1100 (AEDT)
Received: from [IPV6:2405:6e00:494:92f5:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:494:92f5:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SKDll0vN7z9Q1B
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 13:36:02 +1100 (AEDT)
Message-ID: <ae1e840e-4b7c-4f3b-958d-902de1db514a@eyal.emu.id.au>
Date:   Tue, 31 Oct 2023 13:35:51 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From:   eyal@eyal.emu.id.au
Subject: Re: problem with recovered array
To:     linux-raid@vger.kernel.org
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks Roger,

On 31/10/2023 03.14, Roger Heflin wrote:
> look at  SAR -d output for all the disks in the raid6.   It may be a
> disk issue (though I suspect not given the 100% cpu show in raid).

It seems that sar is installed but not active here. Latest data is from 2017...

> Clearly something very expensive/deadlockish is happening because of
> the raid having to rebuild the data from the missing disk, not sure
> what could be wrong with it.
> 
> If you are on a kernel that has a newer version upgrading and
> rebooting may change something  If it is one close to the newest
> kernel version going back a minor version (if 6.5 go back to the last
> 6.4 kernel).

I am running the latest available kernel
	6.5.8-200.fc38.x86_64 #1 SMP PREEMPT_DYNAMIC Fri Oct 20 15:53:48 UTC 2023 x86_64 GNU/Linux

> You might also install the perf package and run "perf top" and see
> what sorts of calls the kernel is spending all of its time in.

I now installed perf. Below is a grab from the console. Should I use different options?

Does anyone understand it?

BTW, I now ran rsync into the array and it barely moved. In 2 hours it copied about 5GB.
iostat shows about 5KB/s (kilobytes!) all that time.


TIA

top shows
     PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
1385760 root      20   0       0      0      0 R  99.7   0.0 161:32.64 kworker/u16:4+flush-9:127

$ sudo perf top --pid 1385760 -g
+  100.00%     0.49%  [kernel]  [k] ext4_mb_regular_allocator
+   99.96%     0.00%  [kernel]  [k] ext4_do_writepages
+   99.10%     0.00%  [kernel]  [k] ext4_ext_map_blocks
+   89.39%     7.85%  [kernel]  [k] ext4_mb_find_good_group_avg_frag_lists
+   81.78%    55.43%  [kernel]  [k] ext4_mb_good_group
+   28.74%    14.63%  [kernel]  [k] ext4_get_group_info
+   12.40%     0.00%  [kernel]  [k] ret_from_fork_asm
+   12.40%     0.00%  [kernel]  [k] ret_from_fork
+   12.40%     0.00%  [kernel]  [k] kthread
+   12.40%     0.00%  [kernel]  [k] worker_thread
+   12.40%     0.00%  [kernel]  [k] process_one_work
+   12.40%     0.00%  [kernel]  [k] wb_workfn
+   12.40%     0.00%  [kernel]  [k] wb_writeback
+   12.40%     0.00%  [kernel]  [k] __writeback_inodes_wb
+   12.40%     0.00%  [kernel]  [k] writeback_sb_inodes
+   12.40%     0.00%  [kernel]  [k] __writeback_single_inode
+   12.40%     0.00%  [kernel]  [k] do_writepages
+   12.40%     0.00%  [kernel]  [k] ext4_writepages
+   12.40%     0.00%  [kernel]  [k] ext4_map_blocks
+   12.40%     0.00%  [kernel]  [k] ext4_mb_new_blocks
+    7.21%     7.12%  [kernel]  [k] __rcu_read_unlock
+    6.21%     3.23%  [kernel]  [k] ext4_mb_scan_aligned
+    4.77%     4.67%  [kernel]  [k] __rcu_read_lock
+    2.96%     0.56%  [kernel]  [k] mb_find_extent
+    2.63%     0.55%  [kernel]  [k] ext4_mb_load_buddy_gfp
+    2.32%     2.29%  [kernel]  [k] mb_find_order_for_block
+    2.00%     0.08%  [kernel]  [k] pagecache_get_page
+    1.88%     0.14%  [kernel]  [k] __filemap_get_folio
+    1.71%     0.51%  [kernel]  [k] filemap_get_entry
+    1.12%     0.43%  [kernel]  [k] xas_load
+    0.68%     0.63%  [kernel]  [k] xas_descend
      0.34%     0.34%  [kernel]  [k] ext4_mb_unload_buddy
      0.29%     0.22%  [kernel]  [k] _raw_read_unlock
      0.25%     0.25%  [kernel]  [k] _raw_spin_trylock
      0.17%     0.17%  [kernel]  [k] _raw_read_lock
      0.11%     0.10%  [kernel]  [k] mb_find_buddy
      0.11%     0.00%  [kernel]  [k] asm_sysvec_apic_timer_interrupt
      0.10%     0.00%  [kernel]  [k] sysvec_apic_timer_interrupt
      0.09%     0.00%  [kernel]  [k] __sysvec_apic_timer_interrupt
      0.08%     0.00%  [kernel]  [k] hrtimer_interrupt
      0.08%     0.07%  [kernel]  [k] xas_start
      0.07%     0.00%  [kernel]  [k] __hrtimer_run_queues
      0.06%     0.00%  [kernel]  [k] tick_sched_timer
      0.05%     0.04%  [kernel]  [k] folio_mark_accessed
      0.04%     0.04%  [kernel]  [k] _raw_spin_unlock
      0.04%     0.00%  [kernel]  [k] update_process_times
      0.04%     0.02%  [kernel]  [k] __cond_resched
      0.04%     0.04%  [kernel]  [k] folio_test_hugetlb
      0.04%     0.00%  [kernel]  [k] tick_sched_handle
      0.03%     0.00%  [kernel]  [k] scheduler_tick
      0.02%     0.00%  [kernel]  [k] tick_sched_do_timer
      0.02%     0.00%  [kernel]  [k] timekeeping_advance
      0.01%     0.00%  [kernel]  [k] task_tick_fair
      0.01%     0.00%  [kernel]  [k] perf_adjust_freq_unthr_context
      0.01%     0.00%  [kernel]  [k] clockevents_program_event
      0.01%     0.01%  [kernel]  [k] _raw_spin_lock_irqsave
      0.01%     0.00%  [kernel]  [k] timekeeping_update
      0.01%     0.00%  [kernel]  [k] arch_scale_freq_tick
      0.01%     0.01%  [kernel]  [k] native_irq_return_iret
      0.01%     0.01%  [kernel]  [k] native_write_msr
      0.01%     0.00%  [kernel]  [k] update_load_avg
      0.01%     0.00%  [kernel]  [k] lapic_next_deadline
      0.01%     0.00%  [kernel]  [k] sched_clock_cpu
      0.01%     0.00%  [kernel]  [k] irqtime_account_irq
      0.00%     0.00%  [kernel]  [k] sched_clock
      0.00%     0.00%  [kernel]  [k] __irq_exit_rcu
      0.00%     0.00%  [kernel]  [k] native_read_msr
      0.00%     0.00%  [kernel]  [k] native_apic_msr_eoi_write
      0.00%     0.00%  [kernel]  [k] update_rq_clock
      0.00%     0.00%  [kernel]  [k] smp_call_function_single_async
      0.00%     0.00%  [kernel]  [k] native_sched_clock
      0.00%     0.00%  [kernel]  [k] update_vsyscall
      0.00%     0.00%  [kernel]  [k] _raw_spin_lock
      0.00%     0.00%  [kernel]  [k] generic_exec_single
      0.00%     0.00%  [kernel]  [k] notifier_call_chain
      0.00%     0.00%  [kernel]  [k] __update_load_avg_cfs_rq
      0.00%     0.00%  [kernel]  [k] tick_do_update_jiffies64
      0.00%     0.00%  [kernel]  [k] update_irq_load_avg
      0.00%     0.00%  [kernel]  [k] tick_program_event
      0.00%     0.00%  [kernel]  [k] trigger_load_balance
      0.00%     0.00%  [kernel]  [k] rb_erase
      0.00%     0.00%  [kernel]  [k] update_wall_time
      0.00%     0.00%  [kernel]  [k] ktime_get
      0.00%     0.00%  [kernel]  [k] llist_add_batch
      0.00%     0.00%  [kernel]  [k] hrtimer_active
      0.00%     0.00%  [kernel]  [k] wq_worker_tick
      0.00%     0.00%  [kernel]  [k] timerqueue_add
      0.00%     0.00%  [kernel]  [k] irqentry_enter
      0.00%     0.00%  [kernel]  [k] psi_account_irqtime
      0.00%     0.00%  [kernel]  [k] run_posix_cpu_timers
      0.00%     0.00%  [kernel]  [k] ktime_get_update_offsets_now
      0.00%     0.00%  [kernel]  [k] rcu_sched_clock_irq
      0.00%     0.00%  [kernel]  [k] read_tsc
      0.00%     0.00%  [kernel]  [k] x86_pmu_disable
      0.00%     0.00%  [kernel]  [k] update_curr
      0.00%     0.00%  [kernel]  [k] _raw_spin_lock_irq
      0.00%     0.00%  [kernel]  [k] account_system_index_time
      0.00%     0.00%  [kernel]  [k] __update_load_avg_se
      0.00%     0.00%  [kernel]  [k] error_entry
      0.00%     0.00%  [kernel]  [k] update_fast_timekeeper
      0.00%     0.00%  [kernel]  [k] _raw_spin_unlock_irqrestore
      0.00%     0.00%  [kernel]  [k] hrtimer_run_queues
      0.00%     0.00%  [kernel]  [k] pvclock_gtod_notify
      0.00%     0.00%  [kernel]  [k] call_function_single_prep_ipi
      0.00%     0.00%  [kernel]  [k] crypto_shash_update
      0.00%     0.00%  [kernel]  [k] cpuacct_charge
      0.00%     0.00%  [kernel]  [k] perf_pmu_nop_void
      0.00%     0.00%  [kernel]  [k] kthread_data
      0.00%     0.00%  [kernel]  [k] hrtimer_update_next_event
      0.00%     0.00%  [kernel]  [k] hrtimer_forward
      0.00%     0.00%  [kernel]  [k] __hrtimer_next_event_base
      0.00%     0.00%  [kernel]  [k] __do_softirq
      0.00%     0.00%  [kernel]  [k] __schedule
      0.00%     0.00%  [kernel]  [k] __run_timers
      0.00%     0.00%  [kernel]  [k] rcu_note_context_switch
      0.00%     0.00%  [kernel]  [k] _find_next_and_bit
      0.00%     0.00%  [kernel]  [k] tcp_orphan_count_sum
      0.00%     0.00%  [kernel]  [k] cpuacct_account_field
      0.00%     0.00%  [kernel]  [k] pick_next_task_fair
      0.00%     0.00%  [kernel]  [k] irqtime_account_process_tick
      0.00%     0.00%  [kernel]  [k] md_handle_request
      0.00%     0.00%  [kernel]  [k] kmem_cache_alloc
      0.00%     0.00%  [kernel]  [k] calc_global_load_tick
      0.00%     0.00%  [kernel]  [k] irq_exit_rcu
      0.00%     0.00%  [kernel]  [k] blake2s_compress_ssse3
      0.00%     0.00%  [kernel]  [k] find_get_stripe
      0.00%     0.00%  [kernel]  [k] rb_next
      0.00%     0.00%  [kernel]  [k] error_return
      0.00%     0.00%  [kernel]  [k] update_min_vruntime
      0.00%     0.00%  [kernel]  [k] netlink_broadcast
      0.00%     0.00%  [kernel]  [k] prb_retire_rx_blk_timer_expired
      0.00%     0.00%  [kernel]  [k] __accumulate_pelt_segments
      0.00%     0.00%  [kernel]  [k] kernfs_notify
      0.00%     0.00%  [kernel]  [k] ntp_get_next_leap
      0.00%     0.00%  [kernel]  [k] ext4_mb_prefetch
      0.00%     0.00%  [kernel]  [k] __radix_tree_lookup
      0.00%     0.00%  [kernel]  [k] irqentry_exit
      0.00%     0.00%  [kernel]  [k] asm_sysvec_reschedule_ipi
      0.00%     0.00%  [kernel]  [k] ext4_ext_insert_extent
      0.00%     0.00%  [kernel]  [k] fast_mix
      0.00%     0.00%  [kernel]  [k] record_times
      0.00%     0.00%  [kernel]  [k] irq_enter_rcu
      0.00%     0.00%  [kernel]  [k] early_xen_iret_patch
      0.00%     0.00%  [kernel]  [k] __orc_find
      0.00%     0.00%  [kernel]  [k] irq_work_tick
      0.00%     0.00%  [kernel]  [k] kmem_cache_free

> On Mon, Oct 30, 2023 at 8:44 AM <eyal@eyal.emu.id.au> wrote:
>>
>> F38
>>
>> I know this is a bit long but I wanted to provide as much detail as I thought needed.
>>
>> I have a 7-member raid6. The other day I needed to send a disk for replacement.
>> I have done this before and all looked well. The array is now degraded until I get the new disk.
>>
>> At one point my system got into trouble and I am not sure why, but it started to have
>> very slow response to open/close files, or even keystrokes. At the end I decided to reboot.
>> It refused to complete the shutdown and after a while I used the sysrq feature for this.
>>
>> On the restart it dropped into emergency shell, the array had all members listed as spares.
>> I tried to '--run' the array but mdadm refused 'cannot start dirty degraded array'
>> though the array was now listed in mdstat and looked as expected.
>>
>> Since mdadm suggested I use --force', I did so
>>          mdadm --assemble --force /dev/md127 /dev/sd{b,c,d,e,f,g}1
>>
>> Q0) was I correct to use this command?
>>
>> 2023-10-30T01:08:25+1100 kernel: md/raid:md127: raid level 6 active with 6 out of 7 devices, algorithm 2
>> 2023-10-30T01:08:25+1100 kernel: md127: detected capacity change from 0 to 117187522560
>> 2023-10-30T01:08:25+1100 kernel: md: requested-resync of RAID array md127
>>
>> Q1) What does this last line mean?
>>
>> Now that the array came up I still could not mount the fs (still in emergency shell).
>> I rebooted and all came up, the array was there and the fs was mounted and so far
>> I did not notice any issues with the fs.
>>
>> However, it is not perfect. I tried to copy some data from an external (USB) disk to the array
>> and it went very slowly (as in 10KB/s, the USB could do 120MB/s). The copy (rsync) was running
>> at 100% CPU which is unexpected. I then stopped it. As a test, I rsync'ed the USB disk to another
>> SATA disk on the server and it went fast, so the USB disk is OK.
>>
>> I then noticed (in 'top') that there is a kworker running at 100% CPU:
>>
>>       PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
>>    944760 root      20   0       0      0      0 R 100.0   0.0 164:00.85 kworker/u16:3+flush-9:127
>>
>> It did it for many hours and I do not know what it is doing.
>>
>> Q2) what does this worker do?
>>
>> I also noticed that mdstat shows a high bitmap usage:
>>
>> Personalities : [raid6] [raid5] [raid4]
>> md127 : active raid6 sde1[4] sdg1[6] sdf1[5] sdd1[7] sdb1[8] sdc1[9]
>>         58593761280 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/6] [_UUUUUU]
>>         bitmap: 87/88 pages [348KB], 65536KB chunk
>>
>> Q3) Is this OK? Should the usage go down? It does not change at all.
>>
>> While looking at everything, I started iostat on md127 and I see that there is a constant
>> trickle of writes, about 5KB/s. There is no activity on this fs.
>> Also, I see similar activity on all the members, at the same rate, so md127 does not show
>> 6 times the members activity. I guess this is just how md works?
>>
>> Q4) What is this write activity? Is it related to the abovementioned 'requested-resync'?
>>          If this is a background thing, how can I monitor it?
>>
>> Q5) Finally, will the array come up (degraded) if I reboot or will I need to coerse it to start?
>>          What is the correct way to bring up a degraded array? What about the 'dirty' part?
>> 'mdadm -D /dev/md127' mention'sync':
>>       Number   Major   Minor   RaidDevice State
>>          -       0        0        0      removed
>>          8       8       17        1      active sync   /dev/sdb1
>>          9       8       33        2      active sync   /dev/sdc1
>>          7       8       49        3      active sync   /dev/sdd1
>>          4       8       65        4      active sync   /dev/sde1
>>          5       8       81        5      active sync   /dev/sdf1
>>          6       8       97        6      active sync   /dev/sdg1
>> Is this related?
>>
>> BTW I plan to run a 'check' at some point.
>>
>> TIA
>>
>> --
>> Eyal at Home (eyal@eyal.emu.id.au)

-- 
Eyal at Home (eyal@eyal.emu.id.au)

