From: Neil Brown <neilb@suse.de>
Subject: Re: Deadlock in md barrier code? / RAID1 / LVM CoW snapshot + ext3
 / Debian 5.0 - lenny 2.6.26 kernel
Date: Mon, 22 Nov 2010 10:05:09 +1100
Message-ID: <20101122100509.76592b59@notabene.brown>
References: <4C938103.1010304@seoss.co.uk>
	<20100918085925.5fee83ee@notabene>
	<4C97BD21.1040405@seoss.co.uk>
	<4C991D61.1040400@seoss.co.uk>
	<20100922083039.283ccdfd@notabene>
	<4CBC9774.6020500@seoss.co.uk>
	<20101019171650.20c83e7e@notabene>
	<4CBDC641.9090009@seoss.co.uk>
	<4CBDC756.7010606@seoss.co.uk>
	<4CBDF190.2000007@seoss.co.uk>
	<4CBF5267.7080304@seoss.co.uk>
	<20101021100429.4879a001@notabene>
	<4CE56AA9.2010905@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CE56AA9.2010905@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 18 Nov 2010 18:04:25 +0000
Tim Small <tim@seoss.co.uk> wrote:

> On 10/21/10 00:04, Neil Brown wrote:
> >
> > Maybe you could add a could of global atomic variables, one for reads and one
> > for writes.
> > Then on each call to generic_make_request in:
> >   flush_pending_writes, make_request, raid1d
> > increment one or the other depending on whether it is a read or a write.
> > Then in raid1_end_read_request and raid1_end_write_request decrement them
> > appropriately.
> >   
> 
> 
> Ended up with runs like this:
> 
> [  464.244109] 0 Obtaining resync_lock and disabling interrupts for
> allow_barrier
> [  464.244109] conf nr_pending is 5
> [  464.244109] 0 Released resync_lock and enabling interrupts for
> allow_barrier
> [  464.244109] 2216: Post wait until no IO waiting - barrier: 0, pend:
> 5, wait: 0, queued: 0
> [  464.244113] 2216: Pre wait pending to complete - barrier: 1, pend: 5,
> wait: 0, queued: 0
> [  464.244116] In raid1_unplug debug read count: 5 write count: 0
> conf->nr_queued: 0
> [  464.244469] 5113 Obtaining resync_lock and disabling interrupts for
> wait_barrier
> [  464.244469] In raid1_unplug debug read count: 5 write count: 0
> conf->nr_queued: 0
> [  464.244469] 5127 Obtaining resync_lock and disabling interrupts for
> allow_barrier
> [  464.244469] conf nr_pending is 4
> [  464.244469] 5127 Released resync_lock and enabling interrupts for
> allow_barrier
> [  464.244469] 5127 Obtaining resync_lock and disabling interrupts for
> allow_barrier
> [  464.246176] In raid1_unplug debug read count: 4 write count: 0
> conf->nr_queued: 0
> [  464.244469] conf nr_pending is 3
> [  464.244469] 5127 Released resync_lock and enabling interrupts for
> allow_barrier
> [  464.244469] 5127 Obtaining resync_lock and disabling interrupts for
> allow_barrier
> [  464.244469] conf nr_pending is 2
> [  464.244469] 5127 Released resync_lock and enabling interrupts for
> allow_barrier
> [  464.246176] In raid1_unplug debug read count: 2 write count: 0
> conf->nr_queued: 0
> [  464.244469] 5127 Obtaining resync_lock and disabling interrupts for
> allow_barrier
> [  464.244469] conf nr_pending is 1
> [  464.244469] 5127 Released resync_lock and enabling interrupts for
> allow_barrier
> [  464.246176] In raid1_unplug debug read count: 1 write count: 0
> conf->nr_queued: 0
> [  464.244469] 5127 Obtaining resync_lock and disabling interrupts for
> allow_barrier
> [  464.244469] conf nr_pending is 0
> [  464.244469] 5127 Released resync_lock and enabling interrupts for
> allow_barrier
> [  464.244469] In raid1_unplug debug read count: 0 write count: 0
> conf->nr_queued: 0
> [  464.246176] 2216: Post wait pending to complete - barrier: 1, pend:
> 0, wait: 1, queued: 0
> [  464.246176] In raid1_unplug debug read count: 0 write count: 0
> conf->nr_queued: 0
> [  464.246176] 2216: Pre wait until no IO waiting - barrier: 1, pend: 0,
> wait: 1, queued: 0
> [  464.246176] In raid1_unplug debug read count: 0 write count: 0
> conf->nr_queued: 0
> [  464.246176] 5118 Obtaining resync_lock and disabling interrupts for
> wait_barrier
> [  464.246176] In raid1_unplug debug read count: 0 write count: 0
> conf->nr_queued: 0
> [  464.246633] In raid1_unplug debug read count: 0 write count: 0
> conf->nr_queued: 1
> [  464.244469] In raid1_unplug debug read count: 0 write count: 0
> conf->nr_queued: 0
> [  464.246176] In raid1_unplug debug read count: 0 write count: 0
> conf->nr_queued: 0
> [  464.246990] 5118 Released resync_lock and enabling interrupts for
> wait_barrier
> [  464.244469] 5113 Released resync_lock and enabling interrupts for
> wait_barrier
> [  464.246990] 5118 Obtaining resync_lock and disabling interrupts for
> wait_barrier
> [  464.246990] 5118 Released resync_lock and enabling interrupts for
> wait_barrier
> [  464.246990] 5118 Obtaining resync_lock and disabling interrupts for
> wait_barrier
> [  464.246990] 5118 Released resync_lock and enabling interrupts for
> wait_barrier
> [  464.244469] In raid1_unplug debug read count: 3 write count: 0
> conf->nr_queued: 0
> [  464.246990] 5118 Obtaining resync_lock and disabling interrupts for
> wait_barrier
> [  464.246990] 5118 Released resync_lock and enabling interrupts for
> wait_barrier
> [  464.246990] 5118 Obtaining resync_lock and disabling interrupts for
> wait_barrier
> [  464.246990] 5118 Released resync_lock and enabling interrupts for
> wait_barrier
> [  464.246176] 2216: Post wait until no IO waiting - barrier: 0, pend:
> 6, wait: 0, queued: 0
> [  464.246176] 2216: Pre wait pending to complete - barrier: 1, pend: 6,
> wait: 0, queued: 0
> [  464.246176] In raid1_unplug debug read count: 5 write count: 0
> conf->nr_queued: 0
> [  464.246990] 5118 Obtaining resync_lock and disabling interrupts for
> wait_barrier
> [  464.246990] In raid1_unplug debug read count: 6 write count: 0
> conf->nr_queued: 0
> [  464.247091] 0 Obtaining resync_lock and disabling interrupts for
> allow_barrier
> [  464.247091] conf nr_pending is 5
> [  464.247091] 0 Released resync_lock and enabling interrupts for
> allow_barrier
> [  464.247091] In raid1_unplug debug read count: 5 write count: 0
> conf->nr_queued: 0
> [  464.244469] 5113 Obtaining resync_lock and disabling interrupts for
> wait_barrier
> [  464.246176] In raid1_unplug debug read count: 5 write count: 0
> conf->nr_queued: 0
> [  464.244469] In raid1_unplug debug read count: 5 write count: 0
> conf->nr_queued: 0
> [  464.328828] 3639 Obtaining resync_lock and disabling interrupts for
> wait_barrier
> [  464.328834] In raid1_unplug debug read count: 5 write count: 0
> conf->nr_queued: 0
> [  466.065137] 2479 Obtaining resync_lock and disabling interrupts for
> wait_barrier
> [  466.065137] In raid1_unplug debug read count: 5 write count: 0
> conf->nr_queued: 0
> [  467.051970] 2478 Obtaining resync_lock and disabling interrupts for
> wait_barrier
> [  467.051975] In raid1_unplug debug read count: 5 write count: 0
> conf->nr_queued: 0
> [  471.293667] In raid1_unplug debug read count: 5 write count: 0
> conf->nr_queued: 0
> [  471.525081] 220 Obtaining resync_lock and disabling interrupts for
> wait_barrier
> [  471.525081] In raid1_unplug debug read count: 5 write count: 0
> conf->nr_queued: 0
> [  505.308962] 2216 WARNING, schedule_timeout timed out for raise_barrier
> [  505.308076] 5118 WARNING, schedule_timeout timed out for wait_barrier
> 
> 
> ... so does that mean that there are are read requests going awol in the
> block layer?
> 
> If so, then the circumstantial evidence from when the lockups occur make
> it look to me like this is probably an OpenVZ bug, but I'll try and do
> some more digging tomorrow...
> 
> Does that make sense?

Yes.  Superficially, it appears that there are still 5 outstanding read
requests that are not being completed.   I cannot guess how OpenVZ would
cause that, but I don't really know much about OpenVZ.

NeilBrown

