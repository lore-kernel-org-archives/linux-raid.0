From: Bernd Schubert <bs@q-leap.de>
Subject: Re: BUG: soft lockup detected on CPU#1! (was Re: raid6 resync blocks the entire system)
Date: Tue, 20 Nov 2007 16:33:38 +0100
Message-ID: <200711201633.39142.bs@q-leap.de>
References: <fhq60j$an9$1@ger.gmane.org> <20071118221819.GA26053@lanczos.q-leap.de> <Pine.LNX.4.64.0711200045130.4836@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711200045130.4836@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@mcmaster.ca>, Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday 20 November 2007 06:55:52 Mark Hahn wrote:
> > I know this is a high end configuration, but no latency critical
> > component is at any limit, 4 CPUs are idling, PCI-X busses are
> > far away from being saturated.
>
> yes, but what about memory?  I speculate that this is an Intel-based
> system that is relatively memory-starved.

Yes, its an intel system, since still has problems to deliver AMD quadcores. 
Anyway, I don't believe the systems memory bandwidth is only 
6 x 280 MB/s = 1680 MB/s (280 MB/s is the maximum I measured per scsi 
channel). Actually, the measured bandwith of this system is 4 GB/s.

With 2.6.23 and enabled debugging we now nicely get softlockups.


[  187.913000] Call Trace:
[  187.917128]  [<ffffffff8020d3c1>] show_trace+0x41/0x70
[  187.922401]  [<ffffffff8020d400>] dump_stack+0x10/0x20
[  187.927667]  [<ffffffff80269949>] softlockup_tick+0x129/0x180
[  187.933529]  [<ffffffff80240c9d>] update_process_times+0x7d/0xa0
[  187.939676]  [<ffffffff8021c634>] smp_local_timer_interrupt+0x34/0x60
[  187.946275]  [<ffffffff8021c71a>] smp_apic_timer_interrupt+0x4a/0x70
[  187.952731]  [<ffffffff8020c7db>] apic_timer_interrupt+0x6b/0x70
[  187.958848]  [<ffffffff881ca5e3>] :raid456:handle_stripe+0xe23/0xf50
[  187.965360]  [<ffffffff881cb365>] :raid456:raid5d+0x2d5/0x3e0
[  187.971267]  [<ffffffff881a0ff9>] :md_mod:md_thread+0x39/0x130
[  187.977246]  [<ffffffff8024c73c>] kthread+0x6c/0xa0
[  187.982225]  [<ffffffff8020c9b8>] child_rip+0xa/0x12
[  187.988910]
[  207.232587] BUG: soft lockup detected on CPU#1!
[  207.237405]
[  207.237405] Call Trace:
[  207.241672]  [<ffffffff8020d3c1>] show_trace+0x41/0x70
[  207.247049]  [<ffffffff8020d400>] dump_stack+0x10/0x20
[  207.252470]  [<ffffffff80269949>] softlockup_tick+0x129/0x180
[  207.258513]  [<ffffffff80240c9d>] update_process_times+0x7d/0xa0
[  207.264651]  [<ffffffff8021c634>] smp_local_timer_interrupt+0x34/0x60
[  207.271222]  [<ffffffff8021c71a>] smp_apic_timer_interrupt+0x4a/0x70
[  207.277698]  [<ffffffff8020c7db>] apic_timer_interrupt+0x6b/0x70
[  207.283819]  [<ffffffff8023c6c9>] __do_softirq+0x59/0x100
[  207.289332]  [<ffffffff8020cd2c>] call_softirq+0x1c/0x30
[  207.294743]  [<ffffffff8020f165>] do_softirq+0x75/0xe0
[  207.299998]  [<ffffffff8020ee72>] do_IRQ+0xc2/0x1b0
[  207.305010]  [<ffffffff8020c076>] ret_from_intr+0x0/0xf
[  207.310346]  [<ffffffff80515606>] _spin_unlock_irq+0x26/0x30
[  207.316111]  [<ffff8101234d97a8>]
[  207.319509] DWARF2 unwinder stuck at 0xffff8101234d97a8
[  207.324905] Leftover inexact backtrace:
[  207.328843]  [<ffffffff80515565>] _spin_unlock_irqrestore+0x55/0x70
[  207.335236]  [<ffffffff8025517d>] trace_hardirqs_on+0xbd/0x160
[  207.341184]  [<ffffffff881a0ff9>] :md_mod:md_thread+0x39/0x130
[  207.347123]  [<ffffffff8024cdf0>] autoremove_wake_function+0x0/0x30
[  207.353504]  [<ffffffff8024cdf0>] autoremove_wake_function+0x0/0x30
[  207.359898]  [<ffffffff881a0fc0>] :md_mod:md_thread+0x0/0x130
[  207.365761]  [<ffffffff8024c73c>] kthread+0x6c/0xa0
[  207.370765]  [<ffffffff8020c9b8>] child_rip+0xa/0x12
[  207.375855]  [<ffffffff8020c0cc>] restore_args+0x0/0x30
[  207.381172]  [<ffffffff8024c6d0>] kthread+0x0/0xa0
[  207.386089]  [<ffffffff8020c9ae>] child_rip+0x0/0x12
[  207.391169]
[  219.044383] BUG: soft lockup detected on CPU#1!

(gdb) l *(handle_stripe+0xe23)
0x5613 is in handle_stripe (drivers/md/raid5.c:1853).
1848
1849    static void end_reshape(raid5_conf_t *conf);
1850
1851    static int page_is_zero(struct page *p)
1852    {
1853            char *a = page_address(p);
1854            return ((*(u32*)a) == 0 &&
1855                    memcmp(a, a+4, STRIPE_SIZE-4)==0);
1856    }
1857


Any ideas how to debug this?


Thanks,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
