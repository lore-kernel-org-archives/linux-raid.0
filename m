From: Neil Brown <neilb@suse.de>
Subject: Re: experiences with raid5: stripe_queue patches
Date: Tue, 16 Oct 2007 12:01:37 +1000
Message-ID: <18196.7041.136050.242139@notabene.brown>
References: <200710151703.10404.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bernd Schubert on Monday October 15
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 15, bs@q-leap.de wrote:
> Hi,
> 
> in order to tune raid performance I did some benchmarks with and without the 
> stripe queue patches. 2.6.22 is only for comparison to rule out other 
> effects, e.g. the new scheduler, etc.

Thanks!

> It seems there is a regression with these patch regarding the re-write 
> performance, as you can see its almost 50% of what it should be.
> 
> write      re-write   read       re-read
> 480844.26  448723.48  707927.55  706075.02 (2.6.22 w/o SQ patches)
> 487069.47  232574.30  709038.28  707595.09 (2.6.23 with SQ patches)
> 469865.75  438649.88  711211.92  703229.00 (2.6.23 without SQ patches)

I wonder if it is a fairness issue.  One concern I have about that new
code it that it seems to allow full stripes to bypass incomplete
stripes in the queue indefinitely.  So an incomplete stripe might be
delayed a very long time. 

I've had a bit of time to think about these patches and experiment a
bit.
I think we should think about the stripe queue in four parts;
  A/  those that have scheduled some write requests
  B/  those that have scheduled some pre-read requests
  C/  those that can start writing without any preread
  D/  those that need some preread before we write.

Original code  lets C flow directly to A, and D move into B in
bursts.  i.e. once B becomes empty, all of D moves to B.

The new code further restricts D to only move to B when the total size
of A+B is below some limit.

I think that including the size of A is good as it gives stripes on D
more chance to move to C by getting more blocks attached.  However it
is bad because it makes it easier for stripes on C to over take
stripes on D.

I made a tiny change to raid5_activate_delayed so that the while loop
aborts if "atomic_read(&conf->active_stripes) < 32"
This (in a very coarse way) limits D moving to B when A+B is more than
a certain size, and it had a similar effect to the SQ patches on a
simple sequential write test.  But it still allowed some pre-read
requests (that shouldn't be needed) to slip through.

I think we should:
  Keep a precise count of the size of A
  Only allow the D->B transition when A < one-full-stripe
  Limit the extent to which C can leap frog D.
    I'm not sure how best to do this yet.  Something simple but fair
    is needed.


> 
> An interesting effect to notice: Without these patches the pdflush daemons 
> will take a lot of CPU time, with these patches, pdflush almost doesn't 
> appear in the 'top' list.

Maybe the patches move processing time from make_request into raid5d,
thus moving it from pdflush to raid5d.  Does raid5d appear higher in
the list....

> 
> Actually we would prefer one single raid5 array, but then one single raid5 
> thread will run with 100% CPU time leaving 7 CPUs idle state, the status of 
> the hardware raid says its utilization is only at about 50% and we only see 
> writes at about 200 MB/s.
> On the contrary, with 3 different software raid5 sets the i/o to the harware 
> raid systems is the bottleneck.
> 
> Is there any chance to parallize the raid5 code? I think almost everything is 
> done in raid5.c make_request(), but the main loop there is spin_locked by 
> prepare_to_wait(). Would it be possible not to lock this entire loop?

I think you want multiple raid5d threads - that is where most of the
work is done.  That is just a case of creating them and keeping track
of them so they can be destroyed when appropriate, and - possibly the
trickiest bit - waking them up at the right time, so they share the
load without wasteful wakeups.

NeilBrown
