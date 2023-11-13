Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 407E4C4167D
	for <linux-raid@archiver.kernel.org>; Mon, 13 Nov 2023 08:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjKMIHK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Nov 2023 03:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjKMIHI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Nov 2023 03:07:08 -0500
X-Greylist: delayed 26018 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 13 Nov 2023 00:07:04 PST
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B1310F4
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 00:07:04 -0800 (PST)
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4STMTf2XyVz9R4g
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 19:07:02 +1100 (AEDT)
Received: from [192.168.2.7] (unknown [101.115.9.238])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4STMTf1yKTz9R2M
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 19:07:02 +1100 (AEDT)
Message-ID: <182d07c8-a76e-430d-90e8-6df8c1f1c54d@eyal.emu.id.au>
Date:   Mon, 13 Nov 2023 19:06:53 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: extremely slow writes to array [now not degraded]
To:     linux-raid@vger.kernel.org
References: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au>
 <e25d99ef-89e2-4cba-92ae-4bbe1506a1e4@eyal.emu.id.au>
 <CAAMCDedC-Rgrd_7R8kpzA5CV1nA_mZaibUL7wGVGJS3tVbyK=w@mail.gmail.com>
 <1d0fb40a-1908-4b5e-9856-a5b79eafdc9c@eyal.emu.id.au>
 <ZVHIPNwC2RKTVmok@vault.lan>
Content-Language: en-US
From:   eyal@eyal.emu.id.au
In-Reply-To: <ZVHIPNwC2RKTVmok@vault.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks Johannes,

On 13/11/2023 17.54, Johannes Truschnigg wrote:
> You will need to generate some kind of call stack/graph info to start making
> sense of the mess your running kernel gets itself into in the scenario you
> described.
> 
> I imagine that looking at `perf` (`perf top` in particular; it should suffice
> to paste a few instances of its topmost lines when the involved kernel threads
> are spinning) would yield some useful data to kick off a potentially
> productive debate about what could actually be going on.
> 
> On Fedora, I think `sudo dnf install perf` should set up everything you need
> to get you going; then, look at `sudo perf top -F 999` for a while, and let
> the list know what you see. (You can use your terminal emulator's flow control
> features, available via Ctrl+S to enable and Ctrl+Q to disable, to "freeze"
> the output to make it easier to copy it into a clipboard buffer.)


top shows
     PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
   42858 root      20   0       0      0      0 R 100.0   0.0   4:18.20 kworker/u16:3+flush-9:127

Here are two snapshots of
	sudo perf top -F 999 - p42858

=======================
Samples: 99K of event 'cycles:P', 999 Hz, Event count (approx.): 69262030071 lost: 0/0 drop: 0/0
Overhead  Shared O  Symbol
   34.31%  [kernel]  [k] ext4_mb_scan_aligned
   11.82%  [kernel]  [k] mb_find_order_for_block
    7.31%  [kernel]  [k] ext4_mb_good_group
    5.88%  [kernel]  [k] ext4_mb_load_buddy_gfp
    5.41%  [kernel]  [k] ext4_mb_regular_allocator
    4.84%  [kernel]  [k] xas_descend
    4.69%  [kernel]  [k] filemap_get_entry
    3.65%  [kernel]  [k] ext4_mb_unload_buddy
    3.32%  [kernel]  [k] xas_load
    2.95%  [kernel]  [k] mb_find_extent
    2.63%  [kernel]  [k] ext4_get_group_info
    1.77%  [kernel]  [k] _raw_spin_trylock
    1.66%  [kernel]  [k] __filemap_get_folio
    1.63%  [kernel]  [k] _raw_read_unlock
    1.59%  [kernel]  [k] _raw_read_lock
    1.13%  [kernel]  [k] __rcu_read_unlock
    1.06%  [kernel]  [k] __rcu_read_lock
    1.04%  [kernel]  [k] ext4_mb_find_good_group_avg_frag_lists
    0.76%  [kernel]  [k] xas_start
    0.68%  [kernel]  [k] pagecache_get_page
    0.47%  [kernel]  [k] _raw_spin_unlock
    0.47%  [kernel]  [k] folio_mark_accessed
    0.34%  [kernel]  [k] folio_test_hugetlb
    0.30%  [kernel]  [k] mb_find_buddy
    0.13%  [kernel]  [k] __cond_resched
    0.02%  [kernel]  [k] native_write_msr
    0.02%  [kernel]  [k] find_get_stripe
    0.01%  [kernel]  [k] native_irq_return_iret
    0.01%  [kernel]  [k] timekeeping_advance
    0.01%  [kernel]  [k] _raw_spin_lock
    0.01%  [kernel]  [k] native_read_msr
    0.01%  [kernel]  [k] update_process_times
    0.01%  [kernel]  [k] __update_load_avg_cfs_rq
    0.01%  [kernel]  [k] native_apic_msr_eoi_write
    0.01%  [kernel]  [k] hrtimer_interrupt
    0.01%  [kernel]  [k] _find_next_and_bit
    0.00%  [kernel]  [k] ext4_ext_correct_indexes
    0.00%  [kernel]  [k] scheduler_tick
    0.00%  [kernel]  [k] _raw_spin_lock_irq
    0.00%  [kernel]  [k] lapic_next_deadline
    0.00%  [kernel]  [k] ext4_es_lookup_extent
    0.00%  [kernel]  [k] mpage_process_page_bufs
    0.00%  [kernel]  [k] raid5_compute_blocknr
=======================

Samples: 342K of event 'cycles:P', 999 Hz, Event count (approx.): 68792587269 lost: 0/0 drop: 0/0
Overhead  Shared O  Symbol
   34.01%  [kernel]  [k] ext4_mb_scan_aligned
   11.91%  [kernel]  [k] mb_find_order_for_block
    6.56%  [kernel]  [k] ext4_mb_good_group
    6.19%  [kernel]  [k] ext4_mb_load_buddy_gfp
    5.30%  [kernel]  [k] ext4_mb_regular_allocator
    4.80%  [kernel]  [k] xas_descend
    4.77%  [kernel]  [k] filemap_get_entry
    3.72%  [kernel]  [k] ext4_mb_unload_buddy
    3.38%  [kernel]  [k] xas_load
    2.96%  [kernel]  [k] mb_find_extent
    2.71%  [kernel]  [k] ext4_get_group_info
    1.77%  [kernel]  [k] _raw_spin_trylock
    1.76%  [kernel]  [k] _raw_read_unlock
    1.71%  [kernel]  [k] __filemap_get_folio
    1.56%  [kernel]  [k] _raw_read_lock
    1.19%  [kernel]  [k] __rcu_read_unlock
    1.18%  [kernel]  [k] ext4_mb_find_good_group_avg_frag_lists
    1.04%  [kernel]  [k] __rcu_read_lock
    0.80%  [kernel]  [k] xas_start
    0.65%  [kernel]  [k] pagecache_get_page
    0.56%  [kernel]  [k] folio_mark_accessed
    0.48%  [kernel]  [k] _raw_spin_unlock
    0.34%  [kernel]  [k] mb_find_buddy
    0.30%  [kernel]  [k] folio_test_hugetlb
    0.18%  [kernel]  [k] __cond_resched
    0.02%  [kernel]  [k] perf_adjust_freq_unthr_context
    0.01%  [kernel]  [k] trigger_load_balance
    0.01%  [kernel]  [k] _raw_spin_lock
    0.01%  [kernel]  [k] timekeeping_advance
    0.01%  [kernel]  [k] update_fast_timekeeper
    0.01%  [kernel]  [k] account_system_index_time
    0.01%  [kernel]  [k] __accumulate_pelt_segments
    0.01%  [kernel]  [k] __hrtimer_next_event_base
    0.01%  [kernel]  [k] update_irq_load_avg
    0.01%  [kernel]  [k] errseq_check
    0.00%  [kernel]  [k] cpuacct_account_field
    0.00%  [kernel]  [k] __queue_work
    0.00%  [kernel]  [k] native_read_msr
    0.00%  [kernel]  [k] __run_timers
    0.00%  [kernel]  [k] find_get_stripe
    0.00%  [kernel]  [k] native_irq_return_iret
    0.00%  [kernel]  [k] hrtimer_active
    0.00%  [kernel]  [k] native_apic_msr_eoi_write
    0.00%  [kernel]  [k] xas_find_marked
    0.00%  [kernel]  [k] hrtimer_interrupt
    0.00%  [kernel]  [k] _raw_spin_lock_irqsave
    0.00%  [kernel]  [k] timekeeping_update
    0.00%  [kernel]  [k] irqtime_account_irq
    0.00%  [kernel]  [k] scheduler_tick
    0.00%  [kernel]  [k] pvclock_gtod_notify
    0.00%  [kernel]  [k] tick_sched_do_timer
    0.00%  [kernel]  [k] task_tick_fair
    0.00%  [kernel]  [k] native_write_msr
    0.00%  [kernel]  [k] __sysvec_apic_timer_interrupt
    0.00%  [kernel]  [k] update_sd_lb_stats.constprop.0
    0.00%  [kernel]  [k] asm_sysvec_apic_timer_interrupt
    0.00%  [kernel]  [k] update_curr
    0.00%  [kernel]  [k] _raw_spin_unlock_irqrestore
    0.00%  [kernel]  [k] ktime_get
    0.00%  [kernel]  [k] wq_worker_tick
    0.00%  [kernel]  [k] __radix_tree_lookup
    0.00%  [kernel]  [k] arch_scale_freq_tick
    0.00%  [kernel]  [k] native_sched_clock
    0.00%  [kernel]  [k] __update_load_avg_cfs_rq
    0.00%  [kernel]  [k] kthread_data
    0.00%  [kernel]  [k] raid5_get_active_stripe
    0.00%  [kernel]  [k] ext4_mb_new_blocks
    0.00%  [kernel]  [k] calc_global_load_tick
    0.00%  [kernel]  [k] irq_work_run_list
    0.00%  [kernel]  [k] _raw_spin_lock_irq
    0.00%  [kernel]  [k] lapic_next_deadline
    0.00%  [kernel]  [k] error_entry
    0.00%  [kernel]  [k] kmem_cache_alloc
    0.00%  [kernel]  [k] filemap_get_folios_tag
    0.00%  [kernel]  [k] intel_pmu_disable_all
    0.00%  [kernel]  [k] crypto_shash_update
    0.00%  [kernel]  [k] ext4_mb_use_preallocated.constprop.0
    0.00%  [kernel]  [k] raid5_compute_sector
    0.00%  [kernel]  [k] ext4_sb_block_valid
    0.00%  [kernel]  [k] read_tsc
    0.00%  [kernel]  [k] ext4_bio_write_folio
    0.00%  [kernel]  [k] ext4_fill_raw_inode
    0.00%  [kernel]  [k] crc32c_pcl_intel_update
    0.00%  [kernel]  [k] memset_orig
    0.00%  [kernel]  [k] start_this_handle
    0.00%  [kernel]  [k] update_load_avg
    0.00%  [kernel]  [k] bio_add_page
=======================

$ sudo sysctl -a|grep -i dirty
vm.dirty_background_bytes = 0
vm.dirty_background_ratio = 10
vm.dirty_bytes = 0
vm.dirty_expire_centisecs = 3000
vm.dirty_ratio = 20
vm.dirty_writeback_centisecs = 500
vm.dirtytime_expire_seconds = 43200
=======================

$ cat /proc/meminfo
MemTotal:       32704840 kB
MemFree:          539904 kB
MemAvailable:   28070392 kB
Buffers:          280668 kB
Cached:         27201712 kB
SwapCached:           32 kB
Active:          4388732 kB
Inactive:       25812468 kB
Active(anon):    3118472 kB
Inactive(anon):    16500 kB
Active(file):    1270260 kB
Inactive(file): 25795968 kB
Unevictable:      174936 kB
Mlocked:               0 kB
SwapTotal:      16777212 kB
SwapFree:       16776956 kB
Zswap:                 0 kB
Zswapped:              0 kB
Dirty:            169872 kB
Writeback:             0 kB
AnonPages:       2893880 kB
Mapped:           958348 kB
Shmem:            416040 kB
KReclaimable:     803204 kB
Slab:            1052924 kB
SReclaimable:     803204 kB
SUnreclaim:       249720 kB
KernelStack:       23616 kB
PageTables:        43176 kB
SecPageTables:         0 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    33129632 kB
Committed_AS:   11705468 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       69000 kB
VmallocChunk:          0 kB
Percpu:             6272 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
FileHugePages:         0 kB
FilePmdMapped:         0 kB
CmaTotal:              0 kB
CmaFree:               0 kB
Unaccepted:            0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:               0 kB
DirectMap4k:      268428 kB
DirectMap2M:     7972864 kB
DirectMap1G:    25165824 kB

HTH

-- 
Eyal at Home (eyal@eyal.emu.id.au)

