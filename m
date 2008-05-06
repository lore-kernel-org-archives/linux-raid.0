From: Neil Brown <neilb@suse.de>
Subject: Re: [RFC PATCH] md: towards a replacement for the raid5 STRIPE_OP_* flags
Date: Tue, 6 May 2008 14:10:28 +1000
Message-ID: <18463.55860.363396.961894@notabene.brown>
References: <20080505224915.29821.46041.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Monday May 5
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 5, dan.j.williams@intel.com wrote:
> The STRIPE_OP_* flags record the state of stripe operations which are
> performed outside the stripe lock.  Their use in indicating which
> operations need to be run is straightforward; however, interpolating what
> the next state of the stripe should be based on a given combination of
> these flags is not straightforward, and has led to bugs.  An easier to read
> implementation with minimal degrees of freedom is needed.

Thanks a lot for looking at this.

Yes, fewer degrees of freedom does seem like a good direction.

I cannot quite decide if I like what you have done or not.  That fact
that you found a bug speaks highly in favour of the approach you
took.  However it doesn't seem to be removing any flag bits, which
bothers me.  I had hoped that at least one and possibly two of
ops.{pending,ack,complete} could go.

You have made the state-machine aspect of the code more explicit by
introducing labels for the high-level states.
When you have a multi-threads machine as we do, I think it is
sometimes easier to encode just the low-level state of the data (which
is harder to get wrong due to races) and each time make a decision
based on that.

This is what we were previously doing, but it seems to be just a
little to complex.  Maybe that is telling us the for sufficiently
complex machines, focussing on the high-level states is the best way
to solve the complexity... but I'm not 100% convinced yet and am keen
to explore.

One aspect of your states that seems a bit odd is that you have both
"idle" and "done" states.  As states, these seem to me to mean much
the same thing - nothing is happening.  You do some "finish up"
tasking in the "done" state.  Maybe these should be done on the
transition from "run" back to "idle".... but maybe locking
requirements make that awkward...

As I said, I would like to see only one bitfield in place of the
current pending,ack,complete.

The way I imagine this is as follows:
  When the machine enters some state (xxx_run) there are some number
  of tasks that need to be accomplished.
  We set "state = xxx_run" and ops.pending = set.of.bits.

  Then outside the lock we doing:
    if (test_and_clean(bit, &ops.pending))
	atomic_inc(&sh->count);
	start 'bit' operation
  for each bit.
  When the operation completes, sh->count is decremented.

  So when ops.pending is 0, and sh->count is zero, xxx_run must have
  completed.
  Possibly we inc sh->count when we set the bit in pending rather than
  when we clear it.  That makes it universal that if sh->count is 0,
  then it is time to assess the current state and move on.

I remains to be seen if the various states, particularly of parity
check and repair, can be adequately deduced from the general state of
the stripe, or whether we need an explicit state variable like you
introduced.

Would you be interested in trying to remove .ack and .complete as
described above and see where that leave us?


Thanks,
NeilBrown
