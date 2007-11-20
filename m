From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: BUG: soft lockup detected on CPU#1! (was Re: raid6 resync blocks
 the entire system)
Date: Tue, 20 Nov 2007 12:16:43 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711201125440.23485@coffee.psychology.mcmaster.ca>
References: <fhq60j$an9$1@ger.gmane.org> <20071118221819.GA26053@lanczos.q-leap.de>
 <Pine.LNX.4.64.0711200045130.4836@coffee.psychology.mcmaster.ca>
 <200711201633.39142.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200711201633.39142.bs@q-leap.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> yes, but what about memory?  I speculate that this is an Intel-based
>> system that is relatively memory-starved.
>
> Yes, its an intel system, since still has problems to deliver AMD quadcores.
> Anyway, I don't believe the systems memory bandwidth is only
> 6 x 280 MB/s = 1680 MB/s (280 MB/s is the maximum I measured per scsi
> channel). Actually, the measured bandwith of this system is 4 GB/s.

4 GB/s is terrible, especially for 8 cores, but perhaps you know this.

> With 2.6.23 and enabled debugging we now nicely get softlockups.
>
> [  187.913000] Call Trace:
> [  187.917128]  [<ffffffff8020d3c1>] show_trace+0x41/0x70
> [  187.922401]  [<ffffffff8020d400>] dump_stack+0x10/0x20
> [  187.927667]  [<ffffffff80269949>] softlockup_tick+0x129/0x180
> [  187.933529]  [<ffffffff80240c9d>] update_process_times+0x7d/0xa0
> [  187.939676]  [<ffffffff8021c634>] smp_local_timer_interrupt+0x34/0x60
> [  187.946275]  [<ffffffff8021c71a>] smp_apic_timer_interrupt+0x4a/0x70
> [  187.952731]  [<ffffffff8020c7db>] apic_timer_interrupt+0x6b/0x70
> [  187.958848]  [<ffffffff881ca5e3>] :raid456:handle_stripe+0xe23/0xf50

so handle_stripe is taking too long; is this not consistent with the memory theory?

> (gdb) l *(handle_stripe+0xe23)
> 0x5613 is in handle_stripe (drivers/md/raid5.c:1853).
> 1848
> 1849    static void end_reshape(raid5_conf_t *conf);
> 1850
> 1851    static int page_is_zero(struct page *p)
> 1852    {
> 1853            char *a = page_address(p);
> 1854            return ((*(u32*)a) == 0 &&
> 1855                    memcmp(a, a+4, STRIPE_SIZE-4)==0);
> 1856    }

that's a weird piece of code.
