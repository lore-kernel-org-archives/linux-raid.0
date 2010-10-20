From: Neil Brown <neilb@suse.de>
Subject: Re: Deadlock in md barrier code? / RAID1 / LVM CoW snapshot + ext3
 / Debian 5.0 - lenny 2.6.26 kernel
Date: Thu, 21 Oct 2010 10:04:29 +1100
Message-ID: <20101021100429.4879a001@notabene>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CBF5267.7080304@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@seoss.co.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 20 Oct 2010 21:34:47 +0100
Tim Small <tim@seoss.co.uk> wrote:

> On 19/10/10 20:29, Tim Small wrote:
> > Sprinkled a few more printks....
> >
> > http://buttersideup.com/files/md-raid1-lockup-lvm-snapshot/dmesg-deadlock-instrumented.txt
> >
> 
> It seems that when the system is hung, conf->nr_pending gets stuck with
> a value of 2.  The resync task ends up stuck in the second
> wait_event_lock_irq within raise barrier, and everything else gets stuck
> in the first wait_event_lock_irq when waiting for that to complete..
> 
> So my assumption is that some IOs either get stuck incomplete, or take a
> path through the code such that they complete without calling allow_barrier.
> 
> Does that make any sense?
>

Yes, it is pretty much the same place that my thinking has reached.

I am quite confident that IO requests cannot complete without calling
allow_barrier - if that were possible  I think we would be seeing a lot more
problems, and in any case it is a fairly easy code path to verify by
inspection.

So the mostly likely avenue or exploration is that the IO's get stuck
somewhere.  But where?

They could get stuck in the device queue while the queue is plugged.  But
queues are meant to auto-unplug after 3msec.  And in any case the
raid1_unplug call in wait_event_lock_irq will make sure everything is
unplugged.

If there was an error (which according to the logs there wasn't) the request
could be stuck in the retry queue, but raid1d will take things off that queue
and handle them.  raid1_unplug wakes up raid1d, and the stack traces show
that raid1d is simply waiting to be woken, it isn't blocking on anything.
I guess there could be an attempt to do a barrier write that failed and
needed to be retried.   Maybe you could add a printk if RIBIO_BarrierRetry
ever gets set.  I don't expect it tell us much though.

They could be in pending_bio_list, but that is flushed by raid1d too.


Maybe you could add a could of global atomic variables, one for reads and one
for writes.
Then on each call to generic_make_request in:
  flush_pending_writes, make_request, raid1d
increment one or the other depending on whether it is a read or a write.
Then in raid1_end_read_request and raid1_end_write_request decrement them
appropriately.

Then in raid1_unplug (which is called just before the schedule in the
event_wait code) print out these two numbers.
Possibly also print something when you decrement them if they become zero.

That would tell us if the requests were stuck in the underlying devices, or
if they were stuck in raid1 somewhere.

Maybe you could also check that the retry list and the pending list are empty
and print that status somewhere suitable...

NeilBrown
