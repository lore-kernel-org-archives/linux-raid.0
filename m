From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard
Date: Thu, 30 Dec 2004 22:39:42 +0100
Message-ID: <u59ea2-4qr.ln1@news.it.uc3m.es>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es> <41D45C1F.5030307@tls.msk.ru>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dm-crypt@saout.de
List-Id: linux-raid.ids

In gmane.linux.raid Michael Tokarev <mjt@tls.msk.ru> wrote:
> Peter T. Breuer wrote:
> > In gmane.linux.raid Georg C. F. Greve <greve@fsfeurope.org> wrote:
> > 
> > Yes, well, don't put the journal on the raid partition. Put it
> > elsewhere (anyway, journalling and raid do not mix, as write ordering
> > is not - deliberately - preserved in raid, as far as I can tell).
> 
> This is a sort of a nonsense, really.  Both claims, it seems.

It's perfectly correct, as far as I know!

> I can't say for sure whenever write ordering is preserved by
> raid --

There is nothing that attempts expliciitly to maintain the ordering in
RAID (talking about mirroring here).  Mirror requests are submitted
_asynchronously_ to the block subsystem for each device in the mirror,
for each incoming request.  The kernel doesn't even have any way of
tracking in what order requests are emitted (it would need a counter
field in each request and there is not one), let alone in what order
they are emitted per device, under the device it is aiming at.

And then of course there is no way at all of telling the underlying
devices in what order to treat the requests either - and what about
request aggregation? Requests are normally aggregated by the kernel
before being sent to devices - ok, I think I recall that RAID turns
that off on itself by using its own make_request function, but it
doesn't control request aggregation in the sub-devices.

And I don't know what happens if you throw the extra resync thread into
the mix, but there certainly IS a RAID kernel thread that does nothing
else than retry failed requests (and do resyncs?) - which of course will
be out of order if ever they are successfully completed by the thread.

If we move on to RAID5, then the situation is simply even more
complicated because we no longer have to think about when solid,
physical, mirrored data is written, but when "virtual" redundant data is
written (and read).

I'm not even sure what in the kernel in general can possibly guarantee
that the sequence write-read-read-write-read can remain ordered that way
when an unplug event interrupts the sequence.

> it should, and if it isn't, it's a bug and should be
> fixed.  Nothing else is wrong with placing journal into raid

It's been that way forever.

> (the same as the filesystem in question). 

What's wrong is that the journal will be mirrored (if it's a mirror).
That means that (1) its data will be written twice, which is a big deal
since ALL the i/o goes through the journal first, and (2) the journal
is likely to be inconsistent (since it is so active) if you get one of
those creeping invisible RAID corruptions that can crop up inevitably
in RAID normal use.

> Suggesting to remove
> journal just isn't fair: the journal is here for a reason.

Well, I'd remove it: presumably his aim is to reduce fsck times after a
crash.  But consider - if he has had a crash, it is likely that his data is
corrupted, so he WANTS to check. 

All that a journal does is guarantee consistency of a FS, not
correctness.  Personally, I prefer to see the incorrectness.  If you
don't want to check the filesystem you can always just choose to not run
fsck!

And in this case the journal is a significant extra risk factor,
because it is ON the falied medium, and on the part that is most
active, moreover!

All you have to do to make things safer is take the journal OFF the
raid array. You immediately remove the potential for corruption IN the
journal (I believe that's what he has seen anyway - damage to the disk
under the journal), which is where we have deduced by the above argument
that the major source of likely corruptions must lie.

There's also no good sense in data-journalling, but I don't think
reiserfs does that anyway (it didn't use to, I know - ext3 was the
first to do data journalling, although even that's a misnomer, since
you try writing a 4GB file as an atomic operation ...).

Journals do no magic. You have to consider if they introduce more
benefits than dangers.

> And, finally, the kernel should not crash.

Well, I'm afraid that like everyone else it is dependent on hardware
and authors, both of which are fallible!

> If something like
> this is unsupported, it should refuse to do so, instead of
> crashing randomly.

???

Morality is so comforting :-).

Peter

