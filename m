From: David Wahler <dwahler@gmail.com>
Subject: Re: BUG?: RAID6 reshape hung in reshape_request
Date: Mon, 27 Apr 2015 12:20:50 -0500
Message-ID: <CAGivzjF-5VWBzE0M9FB9BGpYeed=0rxNvKPzkZJdVbUAwbqyJA@mail.gmail.com>
References: <CAGivzjGyifS3r0rypqM7n2P-fcA7NvPjJWa6kV_wfGx2biDrDg@mail.gmail.com>
 <20150427112056.7195d226@notabene.brown> <CAGivzjE4zVGpoUdGpgKR_e+EaiBE60R3Ta=o9mW+VFqO8McrrQ@mail.gmail.com>
 <CAGivzjHvk8pSUyWOMzNioNtgpQ7gRoL=hkTX0=m7Mi8KzgRWAg@mail.gmail.com> <20150427165926.6128d59b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150427165926.6128d59b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 27, 2015 at 1:59 AM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 26 Apr 2015 20:56:58 -0500 David Wahler <dwahler@gmail.com> wrote:
>
>> [oops, forgot to cc the list]
>>
>> On Sun, Apr 26, 2015 at 8:20 PM, NeilBrown <neilb@suse.de> wrote:
>> > Anyway:
>> >
>> >   Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.
>> >
>> > that is the only thing that looks at all interesting.  Particularly the last
>> > 3 words.
>> > What does
>> >    mdadm --examine-badblocks /dev/sd[cde]1
>> > show?
>>
>> root@ceres:~# mdadm --examine-badblocks /dev/sd[cde]1
>> Bad-blocks on /dev/sdc1:
>>           3699640928 for 32 sectors
>> Bad-blocks on /dev/sdd1:
>>           3699640928 for 32 sectors
>> Bad-blocks on /dev/sde1:
>>           3699640928 for 32 sectors
>>
>> Hmm, that seems kind of odd to me. For what it's worth, all four
>> drives passed a SMART self-test, and "dd > /dev/null" completed
>> without errors on all of them. I just read about the "badblocks" tool
>> and I'm running it now.
>
> The array is reshaping a RAID6 from 4->5 devices, so that is 2 data disks to
> 3 data disks.
>
> Reshape pos'n : 5548735488 (5291.69 GiB 5681.91 GB)
>
> so it is about 5.3TB through the array, so it has read about 2.6TB from the
> devices and written about 1.7TB to the devices.
>
> 3699640928 sectors is about 1.8TB.  That seems a little too close to be a co-incidence.
>
> Maybe when reshape write to somewhere that is a bad-block, it gets confused.
>
> On the other hand, when it copies from the 1.8TB address to the 1.2TB address
> it should have record that it was bad-blocks that were being copied.  It
> doesn't seem like it did.
>
> I'll have to look at the code and try to figure out what is happening.
>
> I don't think there is anything useful you can do in the mean time...
>
> NeilBrown
>

Thanks, I appreciate you taking the time to look at this.

GDB tells me that the address where the reshape is getting stuck
corresponds to drivers/md/raid5.c:4933. I also noticed that there's a
kernel thread "md127_raid6" occupying 100% of a CPU core. Here's a
representative stack for that thread (with line numbers added by me):

[<ffffffffa06aeb20>] raid_run_ops+0xbe0/0x1170 [raid456]
arch/x86/include/asm/bitops.h:311
[<ffffffffa06ab277>] ops_run_io+0x27/0x970 [raid456] drivers/md/raid5.c:742
[<ffffffffa06a9940>] ops_complete_reconstruct+0x0/0x1c0 [raid456]
drivers/md/raid5.c:1433
[<ffffffffa06b2a00>] handle_stripe+0xbd0/0x2650 [raid456]
drivers/md/raid5.c:4099
[<ffffffff810a3162>] pick_next_task_fair+0x652/0x850 kernel/sched/fair.c:5047
[<ffffffffa06b463d>] handle_active_stripes.isra.41+0x1bd/0x4b0
[raid456] drivers/md/raid5.c:5248
[<ffffffff810115eb>] __switch_to+0x14b/0x5d0 arch/x86/include/asm/paravirt.h:276
[<ffffffffa06b4d7c>] raid5d+0x44c/0x5b0 [raid456] drivers/md/raid5.c:5340
[<ffffffffa0760c56>] md_thread+0x126/0x130 [md_mod]
[<ffffffff810a86f0>] autoremove_wake_function+0x0/0x30
[<ffffffffa0760b30>] md_thread+0x0/0x130 [md_mod]
[<ffffffff81089403>] kthread+0xd3/0xf0
[<ffffffff81089330>] kthread+0x0/0xf0
[<ffffffff81560598>] ret_from_fork+0x58/0x90
[<ffffffff81089330>] kthread+0x0/0xf0
[<ffffffffffffffff>] 0xffffffffffffffff

And the output of running "perf record" for a few seconds followed by
"perf report":

# ========
# captured on: Mon Apr 27 12:07:01 2015
# hostname : ceres
# os release : 4.0.0
# perf version : 4.0.g39a880
# arch : x86_64
# nrcpus online : 4
# nrcpus avail : 4
# cpudesc : Intel(R) Core(TM) i3-4160 CPU @ 3.60GHz
# cpuid : GenuineIntel,6,60,3
# total memory : 16112348 kB
# cmdline : /home/david/software/linux/tools/perf/perf record -p 508
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0,
config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0, excl_guest
= 1, precise_ip = 0, attr_mmap2 = 1, attr_mmap  = 1, attr_mmap_data =
0
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# pmu mappings: cpu = 4, software = 1, power = 6, uncore_imc = 7,
tracepoint = 2, breakpoint = 5
# ========
#
# Samples: 84K of event 'cycles'
# Event count (approx.): 76131836770
#
# Overhead  Command      Shared Object      Symbol
# ........  ...........  .................
...........................................
#
    41.90%  md127_raid6  [raid6_pq]         [k] raid6_avx24_gen_syndrome
    19.31%  md127_raid6  [raid456]          [k] analyse_stripe
     8.48%  md127_raid6  [raid456]          [k] ops_run_i
     4.05%  md127_raid6  [raid456]          [k] handle_stripe
     3.72%  md127_raid6  [raid456]          [k] ops_complete_reconstruct
     3.30%  md127_raid6  [kernel.kallsyms]  [k] __kernel_fpu_end
     3.07%  md127_raid6  [raid456]          [k] schedule_reconstruction
     3.01%  md127_raid6  [raid456]          [k] raid5_compute_sector
     1.42%  md127_raid6  [raid456]          [k] handle_active_stripes.isra.41
     1.33%  md127_raid6  [kernel.kallsyms]  [k] __kernel_fpu_begin
     1.33%  md127_raid6  [raid456]          [k] do_release_stripe
     1.16%  md127_raid6  [raid456]          [k] raid_run_ops
     1.14%  md127_raid6  [md_mod]           [k] md_is_badblock
     1.12%  md127_raid6  [raid456]          [k] set_syndrome_sources
     1.07%  md127_raid6  [kernel.kallsyms]  [k] _raw_spin_lock_irqsave
     0.93%  md127_raid6  [async_pq]         [k] async_gen_syndrome
     0.69%  md127_raid6  [raid456]          [k] release_stripe
     0.64%  md127_raid6  [md_mod]           [k] md_wakeup_thread
     0.54%  md127_raid6  [raid456]          [k] __release_stripe
     0.40%  md127_raid6  [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
     0.22%  md127_raid6  [raid456]          [k] release_stripe_list
     0.20%  md127_raid6  [kernel.kallsyms]  [k] __wake_up_common
     0.17%  md127_raid6  [raid456]          [k] release_inactive_stripe_list
     0.16%  md127_raid6  [kernel.kallsyms]  [k] __wake_up
     0.13%  md127_raid6  [raid456]          [k] raid5d
     0.11%  md127_raid6  [kernel.kallsyms]  [k] _raw_spin_lock_irq
     0.10%  md127_raid6  [raid456]          [k] return_io
[...etc...]

I don't urgently need this array up and running, so I'm happy to leave
it in its current state for the next few days in case there's anything
else I can do to help track this down.

-- David
