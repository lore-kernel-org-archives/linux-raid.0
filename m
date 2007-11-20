From: Bernd Schubert <bs@q-leap.de>
Subject: Re: BUG: soft lockup detected on CPU#1! (was Re: raid6 resync blocks the entire system)
Date: Tue, 20 Nov 2007 19:32:24 +0100
Message-ID: <200711201932.25258.bs@q-leap.de>
References: <fhq60j$an9$1@ger.gmane.org> <200711201633.39142.bs@q-leap.de> <Pine.LNX.4.64.0711201125440.23485@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711201125440.23485@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@mcmaster.ca>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday 20 November 2007 18:16:43 Mark Hahn wrote:
> >> yes, but what about memory?  I speculate that this is an Intel-based
> >> system that is relatively memory-starved.
> >
> > Yes, its an intel system, since still has problems to deliver AMD
> > quadcores. Anyway, I don't believe the systems memory bandwidth is only
> > 6 x 280 MB/s = 1680 MB/s (280 MB/s is the maximum I measured per scsi
> > channel). Actually, the measured bandwith of this system is 4 GB/s.
>
> 4 GB/s is terrible, especially for 8 cores, but perhaps you know this.

Yes, but these are lustre storage nodes and the bottleneck is I/O and not 
memory. We get 420 MB/s writes and 900 MB/s reads per OSS (one storage node). 
For that we need between 3 and 4 CPUs, the lustre threads can take the other 
ones. We also only have problems on raid-resync, during normal I/O operation 
the system is perfectly responsive.

>
> > With 2.6.23 and enabled debugging we now nicely get softlockups.
> >
> > [  187.913000] Call Trace:
> > [  187.917128]  [<ffffffff8020d3c1>] show_trace+0x41/0x70
> > [  187.922401]  [<ffffffff8020d400>] dump_stack+0x10/0x20
> > [  187.927667]  [<ffffffff80269949>] softlockup_tick+0x129/0x180
> > [  187.933529]  [<ffffffff80240c9d>] update_process_times+0x7d/0xa0
> > [  187.939676]  [<ffffffff8021c634>] smp_local_timer_interrupt+0x34/0x60
> > [  187.946275]  [<ffffffff8021c71a>] smp_apic_timer_interrupt+0x4a/0x70
> > [  187.952731]  [<ffffffff8020c7db>] apic_timer_interrupt+0x6b/0x70
> > [  187.958848]  [<ffffffff881ca5e3>] :raid456:handle_stripe+0xe23/0xf50
>
> so handle_stripe is taking too long; is this not consistent with the memory
> theory?

Here an argument against memory theory. Per hardware raid we have 3 partitions 
to introduce some kind of 'manual' cpu-threading. Usually the md-driver 
detects it is doing raid over the same partitions and I guess in order to 
prevent disk thrashing it delays the re-sync of the other two md-devices. The 
resync is then limited due to CPU to about 80MB/s (the md process takes 100% 
cpu-time of one single cpu).
Since we simply do not do any disk thrashing at 80MB/s, I simply disabled this 
detection code and also limited the maximum sync-speed to 40MB/s. Now there 
are *three* resyncs running, each with 40MB/s, so altogether 120 MB/s. At 
this speed the system *sometimes* reacts slow, but at least I can login and 
also still can do something on the system. 
I think you will agree more memory bandwidth is used for 3x40MB/s than for 
1x80MB/s resync.

My personal (wild) guess for this problem is, that there is somewhere a global 
lock, preventing all other CPUs to do something. At 100%s (at 80 MB/s) 
there's probably not left any time frame to wake up the other CPUs or its 
sufficiently small to only allow high priority kernel threads to do 
something.
When I limit the sync to 40MB/s each resync-CPU has to wait sufficiently long 
to allow the other CPUs to wake up.


Cheers,
Bernd




-- 
Bernd Schubert
Q-Leap Networks GmbH
