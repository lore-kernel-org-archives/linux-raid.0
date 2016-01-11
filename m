From: NeilBrown <nfbrown@novell.com>
Subject: Re: Create Lock to Eliminate RMW in RAID/456 when writing perfect stripes
Date: Mon, 11 Jan 2016 18:44:23 +1100
Message-ID: <87wprg8srs.fsf@notabene.neil.brown.name>
References: <CAFx4rwR1gtLZUF6MUx71QTvw3hT5GKhsEMU2xcBpAz5wZWBUCw@mail.gmail.com> <87h9j7yn5x.fsf@notabene.neil.brown.name> <CAFx4rwQDX-Eu+b1Jv_OToUduwM_prRy_2YWp2=ptnS3UCv1c1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwQDX-Eu+b1Jv_OToUduwM_prRy_2YWp2=ptnS3UCv1c1Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Dec 31 2015, Doug Dumitru wrote:

> A new lock for RAID-4/5/6 to minimize read/modify/write operations.
>
> The Problem:  The background thread for raid can wake up
> asynchronously and will sometimes wake up and start processing a write
> before the writing thread has finished updating the stripe cache
> blocks.  If the calling thread write was a long write (longer than
> chunk size), then the background thread will configure a raid write
> operation that is sub-optimal resulting in extra IO operations, slower
> performance, and higher wear on Flash storage.
>
> The Easy Fix:  When the calling thread has a long write, it "locks"
> the stripe number with a semaphore.  When the background thread wakes
> up and starts working on a stripe, it locks the same lock, and then
> immediately releases it.  This way the background thread will wait for
> the write to fully populate the stripe caches before it start to build
> a write request.

The code does something a lot like this already.
When the filesystem starts a write, it calls "blk_start_plug()"
When it finishes it calls "blk_finish_plug()".

md/raid5 detects this plugging and when it gets a bio and attaches it to
a "stripe_head", the stripe_head is queued on a delayed-list which is
not processed until the blk_finish_plug() is called.

So we should already not start processing a request until we have the
whole request.  But this sometimes doesn't work.  Understanding why it
doesn't work and what actually happens would be an important first step
to fixing the problem.

The plugging doesn't guarantee that a request will be delayed - doing
that can too easily lead to deadlocks.  Rather it just discourages early
processing.  If a memory shortage appears and RAID5 could free up some
memory by processing a request earlier, it is better to do that than to
wait indefinitely and possibly deadlock.
It is possible that this safety-valve code is triggering too early in
some cases.

>
> The Really High Performance Fix:  If the application is well enough
> behaved to write complete, perfect stripes contained in a single BIO
> request, then the whole stripe cache logic can be bypassed.  This lets
> you submit the member disk IO operations directly from the calling
> thread.  I have this running in a patch in the field and it works
> well, but the use case is very limited and something probably breaks
> with more "normal" IO patterns.  I have hit 11GB/sec with RAID-5 and
> 8GB/sec with RAID-6 this way with 24 SSDs.

It would certainly be interesting to find a general solution which
allowed full stripes to be submitted without a context switch.  It
should be possible.  There is already code which avoids copying from the
filesystem buffer into the stripe cache.  Detecting complete stripes and
submitting them immediately should be possible.  Combining several
stripe_heads into a whole stripe should be possible in many cases using
the new stripe-batching.


>
> Tweak-ability:  All of these changes can be exposed in /sys to allow
> sysadmins to tune their system possibly enabling or disabling
> features.  Most useful for early code that might have broken use
> cases.  Then again, too many knobs sometimes just increases confusion.
>
> Asking for Feedback:  I am happy to write "all of the above" and
> submit it and work with the group to get it tested etc.  If this
> interests you, please comment on how far you think I should go.  Also,
> if there are any notes on "submission style", how and where to post
> patches, which kernel version to patch/develop against, documentation
> style, sign-off requirements, etc. please point me at them.
>

Patches should be sent to linux-raid@vger.kernel.org
Documentation/SubmittingPatches should describe all the required style.

I think a really important first step is to make sure you understand how
the current code is supposed to work, and why it fails sometimes.  The
above short notes should get you started in following what should
happens.

I really don't think locks as you describe them would be part of a
solution.  Flag bits in the stripe_heads, different queues of
stripe_heads and different queuing disciplines might be.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWk11XAAoJEDnsnt1WYoG5AkQP+gKDxXfP2NavN4/6LmWMxeq2
QW4CWvkn7w40Weo6jFiwhuQfcLv2L43ODUBaz5vqcxOQeuUjzNdymPc2QUrXhJAI
0RWr2UAT/dXOBavmHwz/BQFdlFdY9KoWBniPSiNH0hhbRRyZ2RiyIGSTJpygHxr2
RTjAqoy8IBBDmRjnB2jh8mRLnL+KAfdA/2BNSVeKT/SfaMoWAPNEvACW5uOWY3FJ
z5LzaCXL83BUH69GZP/ap/lUo+XTH3KM4CZ+u2Dl99ZR5GZzfomKgDHEuFo6KD9u
74+J2TA90KAjt8DP4kgA8RMSZI6t4gHCL5IcMRJRnNIy6pnHtYm1jHPDzovqYlVR
ANDFa7mXyYYgF9K9Rwb+YJEabyHDY04uy/Ks76HzLXZ6A4OUGyS43gqepRro+4Gu
0ev/fjqnGA8IFmgRJdK8oS2WyUhqW/JjcN6Vpw4XeVqp+qkZVnHO35GEM7no86t+
12mkRtppGeSNpPNQeHsBX+OXMAOHMuX9vJfgoCnHjZjHVF+g/mjdXLyVtwm/9BFx
MxVEtS9Z/5IfRbhauHIsMxbBWCr17y6Zzg1yzYZZ96g6gUw4Se0Rswqgt5473YtP
dGYKU9aa0NVqepjYQWbs6aqvvvhveZIYQxYjITDqY15psLtVkOYqm/551BW9oJFQ
Kl2crgGWYqdtgj1TggmB
=g0Mx
-----END PGP SIGNATURE-----
--=-=-=--
