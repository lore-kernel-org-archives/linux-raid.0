From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: raid10 resync hangs in 4.2.6, 4.3
Date: Mon, 23 Nov 2015 10:20:35 +0100
Message-ID: <5652DA63.9080309@intel.com>
References: <564F6304.3040502@tomt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <564F6304.3040502@tomt.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Tomt <andre@tomt.net>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/20/2015 07:14 PM, Andre Tomt wrote:
> [resend with compressed attachments, first may have gotten eaten by a grue]
> 
> Hi
> 
> I'm seeing hangs with RAID10 resyncs on my system. RAID5/6 recovery on the same drive set works without any problems. BTRFS RAID6 is problem free on a different set of (very busy) drives on the same controllers as well.
> 
> It happens shortly after array creation, from seconds to a couple minutes in.
> 
> wchan for md0_resync kernel thread shows it sitting in raise_barrier() forever, while md0_raid10 keeps a CPU core 100% busy (but shows no wchan), and no resyncing or I/O to the array is getting done anymore.
> 
> After a short while kernel starts spitting out rcu_sched self-detected stall on CPU warnings, and other rcu use starts getting iffy (I think).
> 
> I/O directly to the RAID member disk (below md layer, eg /dev/sdX directly) continues to work after the hang, and there are no I/O errors in the kernel log.
> 
> The array is a 8 drive array spread over 3 HBAs, created with:
> mdadm --create /dev/md0 --level=10 --chunk=128 --bitmap=none --raid-devices=8 /dev/sda1 /dev/sdg1 /dev/sdl1 /dev/sdm1 /dev/sdi1 /dev/sdj1 /dev/sdp1 /dev/sds1
> 
> The HBAs are LSI SAS2008 in IT mode (mpt2sas driver), oldish 2TB SATA drives. Dual socket Xeon E5 v3 system with both sockets populated.
> 
> This happens on at least 4.2.6 and 4.3
> I'm going to test some earlier kernels.
> 
> attached some more info.
> 
> md0_resync stack:
>> root@mental:~# cat /proc/1663/stack
>> [<ffffffffc042dd02>] raise_barrier+0x11b/0x14d [raid10]
>> [<ffffffffc0432830>] sync_request+0x193/0x14fc [raid10]
>> [<ffffffffc0559ac6>] md_do_sync+0x7d2/0xd78 [md_mod]
>> [<ffffffffc0556df9>] md_thread+0x12f/0x145 [md_mod]
>> [<ffffffff9d061db2>] kthread+0xcd/0xd5
>> [<ffffffff9d3b7a8f>] ret_from_fork+0x3f/0x70
>> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> md0_raid10 stack:
>> root@mental:~# cat /proc/1662/stack
>> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> cat stack trying to read /dev/md0 after hang:
>> root@mental:~# cat /proc/1737/stack
>> [<ffffffffc042de2b>] wait_barrier+0xd8/0x118 [raid10]
>> [<ffffffffc042f83c>] __make_request+0x3e/0xb17 [raid10]
>> [<ffffffffc0430399>] make_request+0x84/0xdc [raid10]
>> [<ffffffffc0557aab>] md_make_request+0xf6/0x1cc [md_mod]
>> [<ffffffff9d1a369a>] generic_make_request+0x97/0xd6
>> [<ffffffff9d1a37d1>] submit_bio+0xf8/0x140
>> [<ffffffff9d140e71>] mpage_bio_submit+0x25/0x2c
>> [<ffffffff9d141499>] mpage_readpages+0x10e/0x11f
>> [<ffffffff9d13c76c>] blkdev_readpages+0x18/0x1a
>> [<ffffffff9d0d09e4>] __do_page_cache_readahead+0x13c/0x1e0
>> [<ffffffff9d0d0c67>] ondemand_readahead+0x1df/0x1f2
>> [<ffffffff9d0d0da0>] page_cache_sync_readahead+0x38/0x3a
>> [<ffffffff9d0c70b3>] generic_file_read_iter+0x184/0x50b
>> [<ffffffff9d13c8f7>] blkdev_read_iter+0x33/0x38
>> [<ffffffff9d1132fd>] __vfs_read+0x8d/0xb1
>> [<ffffffff9d113820>] vfs_read+0x95/0x120
>> [<ffffffff9d11402d>] SyS_read+0x49/0x84
>> [<ffffffff9d3b772e>] entry_SYSCALL_64_fastpath+0x12/0x71
>> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> 
> First OOPS (more in dmesg.txt)
>> [  150.183473] md0: detected capacity change from 0 to 8001054310400
>> [  150.183647] md: resync of RAID array md0
>> [  150.183652] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> [  150.183654] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
>> [  150.183678] md: using 128k window, over a total of 7813529600k.
>> [  233.068271] INFO: rcu_sched self-detected stall on CPU
>> [  233.068308]     5: (17999 ticks this GP) idle=695/140000000000001/0 softirq=1235/1235 fqs=8999
>> [  233.068335]      (t=18000 jiffies g=935 c=934 q=37)
>> [  233.068354] Task dump for CPU 5:
>> [  233.068356] md0_raid10      R  running task        0  1662      2 0x00000008
>> [  233.068358]  0000000000000000 ffff88103fca3de0 ffffffff9d069f07 0000000000000005
>> [  233.068360]  ffffffff9d63d0c0 ffff88103fca3df8 ffffffff9d06beb9 ffffffff9d63d0c0
>> [  233.068361]  ffff88103fca3e28 ffffffff9d08c836 ffffffff9d63d0c0 ffff88103fcb4e80
>> [  233.068363] Call Trace:
>> [  233.068364]  <IRQ>  [<ffffffff9d069f07>] sched_show_task+0xb9/0xbe
>> [  233.068372]  [<ffffffff9d06beb9>] dump_cpu_task+0x32/0x35
>> [  233.068375]  [<ffffffff9d08c836>] rcu_dump_cpu_stacks+0x71/0x8c
>> [  233.068378]  [<ffffffff9d08f32c>] rcu_check_callbacks+0x20f/0x5a3
>> [  233.068382]  [<ffffffff9d0b72da>] ? acct_account_cputime+0x17/0x19
>> [  233.068384]  [<ffffffff9d0911a2>] update_process_times+0x2a/0x4f
>> [  233.068387]  [<ffffffff9d09cd55>] tick_sched_handle.isra.5+0x31/0x33
>> [  233.068388]  [<ffffffff9d09cd8f>] tick_sched_timer+0x38/0x60
>> [  233.068390]  [<ffffffff9d0917e1>] __hrtimer_run_queues+0xa1/0x10c
>> [  233.068392]  [<ffffffff9d091c52>] hrtimer_interrupt+0xa0/0x172
>> [  233.068395]  [<ffffffff9d0367a4>] smp_trace_apic_timer_interrupt+0x76/0x88
>> [  233.068397]  [<ffffffff9d0367bf>] smp_apic_timer_interrupt+0x9/0xb
>> [  233.068400]  [<ffffffff9d3b8402>] apic_timer_interrupt+0x82/0x90
>> [  233.068401]  <EOI>  [<ffffffff9d19e9aa>] ? bio_copy_data+0xce/0x2af
>> [  233.068410]  [<ffffffffc04320e5>] raid10d+0x974/0xf2c [raid10]
>> [  233.068417]  [<ffffffffc0556df9>] md_thread+0x12f/0x145 [md_mod]
>> [  233.068421]  [<ffffffffc0556df9>] ? md_thread+0x12f/0x145 [md_mod]
>> [  233.068424]  [<ffffffff9d07ad2e>] ? wait_woken+0x6d/0x6d
>> [  233.068428]  [<ffffffffc0556cca>] ? md_wait_for_blocked_rdev+0x102/0x102 [md_mod]
>> [  233.068431]  [<ffffffff9d061db2>] kthread+0xcd/0xd5
>> [  233.068434]  [<ffffffff9d061ce5>] ? kthread_worker_fn+0x13f/0x13f
>> [  233.068436]  [<ffffffff9d3b7a8f>] ret_from_fork+0x3f/0x70
>> [  233.068438]  [<ffffffff9d061ce5>] ? kthread_worker_fn+0x13f/0x13f
> 

Hi Andre,

I've recently sent a patch for a similar problem, I suspect the root
cause is the same here. Please check out this patch:

http://marc.info/?l=linux-raid&m=144665464232126&w=2

Artur
