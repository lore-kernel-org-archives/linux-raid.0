From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/19] Hardware Accelerated MD RAID5: Introduction
Date: Mon, 9 Oct 2006 08:18:33 +1000
Message-ID: <17705.31033.706571.150023@cse.unsw.edu.au>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932186AbWJIAb2@vger.kernel.org>
In-Reply-To: message from Dan Williams on Monday September 11
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com
List-Id: linux-raid.ids



On Monday September 11, dan.j.williams@intel.com wrote:
> Neil,
>=20
> The following patches implement hardware accelerated raid5 for the In=
tel
> Xscale=AE series of I/O Processors.  The MD changes allow stripe
> operations to run outside the spin lock in a work queue.  Hardware
> acceleration is achieved by using a dma-engine-aware work queue routi=
ne
> instead of the default software only routine.

Hi Dan,
 Sorry for the delay in replying.
 I've looked through these patches at last (mostly the raid-specific
 bits) and while there is clearly a lot of good stuff here, it does
 'feel' right - it just seems too complex.

 The particular issues that stand out to me are:
   - 33 new STRIPE_OP_* flags.  I'm sure there doesn't need to be that
      many new flags.
   - the "raid5 dma client" patch moves far too much internal
     knowledge about raid5 into drivers/dma.

 Clearly there are some complex issues being dealt with and some
 complexity is to be expected, but I feel there must be room for some
 serious simplification.

 Let me try to describe how I envisage it might work.

 As you know, the theory-of-operation of handle_stripe is that it
 assesses the state of a stripe deciding what actions to perform and
 then performs them.  Synchronous actions (e.g. current parity calcs)
 are performed 'in-line'.  Async actions (reads, writes) and actions
 that cannot be performed under a spinlock (->b_end_io) are recorded
 as being needed and then are initiated at the end of handle_stripe
 outside of the sh->lock.

 The proposal is to bring the parity and other bulk-memory operations
 out of the spinlock and make them optionally asynchronous.

 The set of tasks that might be needed to be performed on a stripe
 are:
	Clear a target cache block
	pre-xor various cache blocks into a target
	copy data out of bios into cache blocks. (drain)
	post-xor various cache blocks into a target
	copy data into bios out of cache blocks (fill)
	test if a cache block is all zeros
	start a read on a cache block
	start a write on a cache block

 (There is also a memcpy when expanding raid5.  I think I would try to
  simply avoid that copy and move pointers around instead).

 Some of these steps require sequencing. e.g.
   clear, pre-xor, copy, post-xor, write
 for a rwm cycle.
 We could require handle_stripe to be called again for each step.
 i.e. first call just clears the target and flags it as clear.  Next
 call initiates the pre-xor and flags that as done.  Etc.  However I
 think that would make the non-offloaded case too slow, or at least
 too clumsy.

 So instead we set flags to say what needs to be done and have a
 workqueue system that does it.

 (so far this is all quite similar to what you have done.)

 So handle_stripe would set various flag and other things (like
 identify which block was the 'target' block) and run the following
 in a workqueue:

raid5_do_stuff(struct stripe_head *sh)
{
	raid5_cont_t *conf =3D sh->raid_conf;

	if (test_bit(CLEAR_TARGET, &sh->ops.pending)) {
		struct page =3D *p->sh->dev[sh->ops.target].page;
		rv =3D async_memset(p, 0, 0, PAGE_SIZE, ops_done, sh);
		if (rv !=3D BUSY)
			clear_bit(CLEAR_TARGET, &sh->ops.pending);
		if (rv !=3D COMPLETE)
			goto out;
	}

	while (test_bit(PRE_XOR, &sh->ops.pending)) {
		struct page *plist[XOR_MAX];
		int offset[XOR_MAX];
		int pos =3D 0;
		int d;

		for (d =3D sh->ops.nextdev;
		     d < conf->raid_disks && pos < XOR_MAX ;
		     d++) {
			if (sh->ops.nextdev =3D=3D sh->ops.target)
				continue;
			if (!test_bit(R5_WantPreXor, &sh->dev[d].flags))
				continue;
			plist[pos] =3D sh->dev[d].page;
			offset[pos++] =3D 0;
		}
		if (pos) {
			struct page *p =3D sh->dev[sh->ops.target].page;
			rv =3D async_xor(p, 0, plist, offset, pos, PAGE_SIZE,
				       ops_done, sh);
			if (rv !=3D BUSY)
				sh->ops.nextdev =3D d;
			if (rv !=3D COMPLETE)
				goto out;
		} else {
			clear_bit(PRE_XOR, &sh->ops.pending);
			sh->ops.nextdev =3D 0;
		}
	}
	=09
	while (test_bit(COPY_IN, &sh0>ops.pending)) {
		...
	}
	....

	if (test_bit(START_IO, &sh->ops.pending)) {
		int d;
		for (d =3D 0 ; d < conf->raid_disk ; d++) {
			/* all that code from the end of handle_stripe */
		}

	release_stripe(conf, sh);
	return;

 out:
	if (rv =3D=3D BUSY) {
		/* wait on something and try again ???*/
	}
	return;
}

ops_done(struct stripe_head *sh)
{
	queue_work(....whatever..);
}


Things to note:
 - we keep track of where we are up to in sh->ops.
      .pending is flags saying what is left to be done
      .next_dev is the next device to process for operations that
        work on several devices
      .next_bio, .next_iov will be needed for copy operations that
        cross multiple bios and iovecs.

 - Each sh->dev has R5_Want flags reflecting which multi-device
   operations are wanted on each device.

 - async bulk-memory operations take pages, offsets, and lengths,
   and can return COMPLETE (if the operation was performed
   synchronously) IN_PROGRESS (if it has been started, or at least
   queued) or BUSY if it couldn't even be queued.  Exactly what to do
   in that case I'm not sure.  Probably we need a waitqueue to wait
   on.

 - The interface between the client and the ADMA hardware is a
   collection of async_ functions.  async_memcpy, async_xor,
   async_memset etc.

   I gather there needs to be some understanding
   about whether the pages are already appropriately mapped for DMA or
   whether a mapping is needed.  Maybe an extra flag argument should
   be passed.

   I imagine that any piece of ADMA hardware would register with the
   'async_*' subsystem, and a call to async_X would be routed as
   appropriate, or be run in-line.

This approach introduces 8 flags for sh->ops.pending and maybe two or
three new R5_Want* flags.  It also keeps the raid5 knowledge firmly in
the raid5 code base.  So it seems to keep the complexity under control

Would this approach make sense to you?  Is there something really
important I have missed?

(I'll try and be more responsive next time).

Thanks,
NeilBrown
