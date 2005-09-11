From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Accelerating Linux software raid
Date: Mon, 12 Sep 2005 09:14:45 +1000
Message-ID: <17188.47717.37227.50988@cse.unsw.edu.au>
References: <e9c3a7c2050906112410dc1d16@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday September 6
Sender: linux-raid-owner@vger.kernel.org
To: dan.j.williams@gmail.com
Cc: linux-raid@vger.kernel.org, dave.jiang@gmail.com
List-Id: linux-raid.ids

On Tuesday September 6, dan.j.williams@gmail.com wrote:
> Hello,
> 
> I am writing to the list to gauge interest for a modification of the
> md driver that allows it to take advantage of raid acceleration
> hardware.  I/O processors like the Intel IOP333
> (http://www.intel.com/design/iio/docs/iop333.htm) contain an xor
> engine for raid5 and raid6 calculations, but currently the md driver
> does not fully utilize these resources.
> 
> Dave Jiang wrote a driver that re-routed calls to xor_block() to use
> the hardware xor engine.  However, from my understating, he found that
> performance did not improve, due to the fact that md deals in
> PAGE_SIZE (4K) blocks.  At 4K the overhead of setting up the engine
> destroys any performance advantage over a software xor.  The goal of
> the modification would be to enable md to understand the capacity of
> the platform's xor resources and allow it to issue optimal block
> sizes.
> 
> The first question is whether a solution along these lines would be
> valued by the community?  The effort is non-trivial.

If the effort is non-trivial, then I suggest you only do it if it has
really value to *you*.
If it does, community involvement is more likely to provide value *to*
you (such as guidance, bug-fixes, long-term maintenance) than to get
value *from* you, though hopefully it would be a win-win situation.

I'm not surprised that simply replacing xor_block with calls into the
hardware engine didn't help much.  xor_block is currently called under
a spinlock, so the main processor will probably be completely idle
while the AA is doing the XOR calculation, so there isn't much room
for improvement.

If I were to try to implement this, here is how I would do it:

1/ get the xor calc out from under the spinlock.  This will require a
  fairly deep understanding of the handle_stripe() function.
  The 'stripe_head' works somewhat like a state machine.
  handle_stripe assesses the current state and advances it one step.

  Currently if it determines that it is time to write some data, it
  will
   - copy data out of file-system buffers into it's own cache
   - perform the xor calculations in the cache, locking all
      blocks the then become dirty.
   - schedule a write on all those locked blocks.
  The stripe won't be ready to be handled again until all the writes
  complete.

  This should be changed so that we don't copy+xor, but instead just
  lock the blocks and flag them as needing xor.  Then after
  sh->lock is dropped you will send the copy+xor request to the AA, or
  do it in-line.  Once the copy+xor is completed, the stripe
  needs to get flagged for handling again.
  Stripe handle will then need to notice that parity has been 
   calculated, so writing can commence.

2/ Then I would try to find the best internal API to provide for the 
   AA (Application Accelerator for those who haven't read the spec
   yet).
   My guess is that it should work much like the crypto API.  I'm not 
   up-to-date with that so I don't know if the async-crypto-API is
   complete and merged yet  (async-crypto-API is for sending data
   to separate processors for crypto manipulation and being alerted 
   asynchronously when they complete).  If it is, definitely look into
   using that.  If it isn't, certainly look into it and maybe even
   help it's development to make sure it can handle multiple-input xor
   operations. 


Step 1 is probably quite useful anyway and is unlikely to slow current
performance - just re-arrange it.  Once that is done, plugging in
async xor should be fairly easy whether you use crypto-api or not.

I don't think it is practical to use larger block sizes for the xor
operations, and I doubt it is needed.  The DMA engine in the AA has a
very nice chaining arrangement where new operations can be added to the
end of the chain at any time, and I doubt the effort of loading a new
chain descriptor would be a substantial fraction of the time it takes
to xor a 4k block.  As long as you keep everything async (i.e. keep
the main processor busy while the copy+xor is happening) you should
notice some speed-up ... or at least a drop is cpu activity.

One last note:  if you do decide to give '1/' a try, remember to keep
patches small and well defined.  handle_stripe currently does xor
in four places: two in compute_parity (one prior to write, one for
resync) and two in compute_block (one for degraded read, one for
recovery). 
Don't try to change these all at once.  One, or at most two, at a time
makes the patches much easier to review.

Good luck,
NeilBrown
