From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: *terrible* direct-write performance with raid5
Date: Tue, 22 Feb 2005 23:27:43 +0100
Message-ID: <v7ose2-sh4.ln1@news.it.uc3m.es>
References: <421B6E5D.6030004@tls.msk.ru> <u7gse2-sul.ln1@news.it.uc3m.es> <421BA784.8040909@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> Peter T. Breuer wrote:
> > Michael Tokarev <mjt@tls.msk.ru> wrote:
> > 
> >>When debugging some other problem, I noticied that
> >>direct-io (O_DIRECT) write speed on a software raid5
> > 
> > And normal write speed (over 10 times the size of ram)?
> 
> There's no such term as "normal write speed" in this context
> in my dictionary, because there are just too many factors
> influencing the speed of non-direct I/O operations (I/O

Well I said to use over 10 times the size of ram, so we get a good
picture of an average sort of situation.

> scheduler aka elevator is the main factor I guess).  More,

I would only want to see the influence of the VMS.

> when going over the buffer cache, "cache trashing" is plays

I doubt that it influences anything here. But it can be tested.

> More to the point seems to be the same direct-io but in
> larger chunks - eg 1Mb or more instead of 8Kb buffer.  And

D_IO is done in blocks and MAYBE multiples of blocks.  You should
really perform all tests at single block sizes first to get a good
picture, or check the kernel code to see if splitting occurs.  I don't
know if it does.

> this indeed makes alot of difference, the numbers looks

It seemss irrelevant to the immediate problem, which is to explain the
discrepancy in your observed figures, not to find some situation in
which you get figures without the discrepancy!

> > And ext2? You will be enormously hampered by using a journalling file
> > system, especially with journal on the same system as the one you are
> > testing! At least put the journal elsewhere - and preferably leave it
> > off.
> 
> This whole issue has exactly nothing to do with journal.

Then you can leave it off :(.

> > I'm afraid there are too many influences to say much from it overall.
> > The "legitimate" (i.e.  controlled) experiment there is between sdX and
> > md (over sdx), with o_direct both times.  For reference I personally
> > would like to see the speed withut o_direct on those two.  And the
> > size/ram of the transfer - you want to run over ten times size of ram
> > when you run without o_direct.
> 
> I/O speed without O_DIRECT is very close to 44 Mb/sec for sdX (it's the
> spid of the drives it seems), and md performs at about 80 Mb/sec.  That

For large transfers? I don't see how MD can be faster than the raw
drive on write! I would suspect that the transfer was not large enough
to measure well.

> numbers are very close to the case with O_DIRECT and large block size
> (eg 1Mb).
> 
> There's much more to the block size really.  I just used 8Kb block because

You should really use 4KB to get a good picture of the problem.

> > Then I would like to see a similar comparison made over hdX instead of
> > sdX.
> 
> Sorry no IDE drives here, and i don't see the point in trying them anyway.

So that we can locate whether the problem is in the md driver or in the
sd driver. (i.e. "see the point" :-).


> > You can forget the fs-based tests for the moment, in other words. You
> > already have plenty there to explain in the sdX/md comparison. And to
> > explain it I would like to see sdX replaced with hdX.
> > 
> > A time-wise graph of the instantaneous speed to disk would probably
> > also be instructive, but I guess you can't get that!
> > 
> > I would guess that you are seeing the results of one read and write to
> > two disks happening in sequence and not happening with any great
> > urgency.  Are the writes sent to each of the mirror targets from raid
> 
> Hmm point.
> 
> > without going through VMS too?  I'd suspect that - surely the requests
> > are just queued as normal by raid5 via the block device system. I don't
> > think the o_direct taint persists on the requests - surely it only
> > exists on the file/inode used for access.
> 
> Well, O_DIRECT performs very-very similar to O_SYNC here (both cases --
> with and without a filesystem involved) in terms of speed.

I don't see the relevance of the remark ...?  O_SYNC is not as sync as
O_DIRECT and in particular does not bypass the VMS.  If you were to do
an O_SYNC write in 8KB lumps it would be very like a O_DIRECT write in
8KB lumps, however. O_SYNC requires FS implementation as far as I
recall, but I may be wrong.

A considerable difference between the two would likely be visible if you
used much larger blocksize or wrote with two processes at once.

> I don't care much now whenever it relly performs direct I/O (from
> userspace buffer directly to controller), esp. since it can't work
> exactly this way with raid5 implemented in software (checksums must
> be written too).

Well, it does work rather in that direction.  Each userspace write gives
rise imediately to one read and two writes (or more?) aimed at the disk
controller.  My point was that those further requests probably pass
through VMS, rather than being sent directly to the controller without
passing thhrough VMS.  In particular, the read may come from VMS buffers
filled through previous readahead rather than directly from the disk.
And also the writes may not go to the controller immediately, but
instead go to VMS and then hang around until the kernel decides to tell
the controller that it has requests waiting that it needs to attend to.

I suggested that the raid5 driver may not be taking pains to inform
the mirror targets that they have work waiting NOW after sending off the
mirror requests.  As far as I recall it just does a make_request()
(unchecked!).  If it were making efforts to honour O_DIRECT it might
want to schedule itself out after the make_request, thus giving the
kernel a chance to run the controllers request function and handle the
requests it has just submitted.  Or it might want to signal disk_tq (or
whatever handles the request function sweep nowadays). There are
probably little thigs it can set on the buffers it makes to cause them
to age fast too.

As it is, things might be a little stalemated at that point - not that I
know for sure, but I can imagine that it might be so.  There's an
opportunity for a lack of pressure to meet another lack of urgency, and
for the two to try and wait each other out ...


> I just don't want to see unnecessary cache trashing

I doubt the cache has much to do with it.  But what happens when you
vary the cpu cache size?  Does the relative difference become more or
less?  DO you have any direct evidence for cache effects?

> and do want to know about I/O errors immediately.
> 
> > Suppose the mirrored requests are NOT done directly - then I guess we
> > are seeing an interaction with the VMS, where priority inversion causes
> > the high-priority requests to the md device to wait on the fulfilment of
> > low priority requests to the sdX devices below them.  The sdX devices
> > requests may not ever get treated until the buffers in question age
> > sufficiently, or until the kernel finds time for them. When is that?
> > Well, the kernel won't let your process run .. hmm. I'd suspect the
> > raid code should be deliberately signalling the kernel to run the
> > request_fn of the mirror devices more often.
> 
> I guess if that's the case, buffer size should not make much difference.

If D_IO requests are not split into 4KB units in the kernel, then any
delay mechanism that is per-request will likely grow relatively less the
larger (and fewer) the requests are.  So I don't see a rationale for
that statement.

> >>Comments anyone? ;)
> > 
> > Random guesses above. Purely without data, of course.
> 
> Heh.  Thanks anyway ;)

No problemo.

Peter

