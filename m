From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Bug report: mdadm -E oddity
Date: Fri, 20 May 2005 21:15:33 +0200
Message-ID: <ljp1m2-mvd.ln1@news.it.uc3m.es>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com> <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com> <17029.12773.197506.463977@cse.unsw.edu.au> <1116077316.13780.52.camel@compaq-rhel4.xsintricity.com> <17037.35615.456231.737766@cse.unsw.edu.au> <1116592212.23785.75.camel@compaq-rhel4.xsintricity.com> <428E0A92.3060108@steeleye.com>  <kki1m2-r1n.ln1@news.it.uc3m.es> <1116614445.23785.127.camel@compaq-rhel4.xsintricity.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford <dledford@redhat.com> wrote:
> > Surely the raid won't have acked the write, so the journal won't
> > consider the write done and will replay it next chance it gets. Mind
> > you ... owwww! If we restart the array AGAIN without D3, and the
> > journal is now replayed(to redo the write), then since we have already
> > written D1, the parity in P is all wrong relative to it, and hence we
> > will have virtual data in D3 which is all wrong, and hence when we come
> > to write the parity info P we will get it wrong. No? (I haven't done
> > the calculation and so there might be some idempotency here that the
> > casual reasoning above fails to take account of).

> No.  There's no need to do any parity calculations if you are writing
> both D1 and P (because you have D1 and D2 as the write itself, and

OK - you're right as far as this goes.  P is the old difference between
D1 and D2.  When you write anew you want P as the new difference between
D1 and D2.

However, sometimes one calculates the new P by calculating the parity
difference between (cached) old and new data, and updating P with that
info. I don't know when or if the linux raid5 algorithm does that.

> therefore you are getting P from them, not from off of disk, so a full
> stripe write should generate the right data *always*).

> If you are attempting to do a partial stripe write, and let's say you
> are writing D2 in this case (true whenever the element you are trying to
> write is the missing element), then you can read all available elements,
> D1 and P, generate D2, xor D2 out of P, xor in new D2 into P, write P.
> But, really, that's a lot of wasted time.

Depends on relative latencies. If you have the data cached in memory
it's not so silly.  And I believe/guess some of your suggested op
sequence  above is not needed, in the sense that it can be done in
fewer ops.

> Your better off to just read
> all available D? elements, ignore the existing parity, and generate a
> new parity off of the all the existing D elements and the missing D
> element that you have a write for and write that out to the P element.

> Where you start to get into trouble is only with a partial stripe write
> that doesn't write D2.  Then you have to read D1, read P, xor D1 out of
> P, xor new D1 into P, write both.  Only in this case is a replay
> problematic, and that's because you need the new D1 and new P writes to
> be atomic. 

I.e. do both of D1 and P, or neither. But we are discussing precisely
the case when the crash happened after writing D1 but not having
written P (with D2 not present).  I suppose we could also have thought
about P having been updated, but not D1 (it's a race).


> If you replay with both of those complete, then you end up
> with pristine data.  If you replay with only D1 complete, then you end
> up xor'ing the same bit of data in and out of the P block, leaving it
> unchanged and corrupting D2. 

Hmm. I thought you had discussed it above already, and concluded that we
rewrite P (correctly) from the new D1 and D2.

> If you replay with only P complete then
> you get the same thing since the net result is P xor D xor D' xor D xor
> D' = P.

Well, cross me with a salamander, but I thought that was what I was
discussing - I am all confuscicated...

> As far as I know, to solve this issue you have to do a minimal
> journal in the raid device itself.

You are aiming for atomicity? Then, yes, you need the journalling
trick.

> For example, some raid controllers
> reserve a 200MB region at the beginning of each disk for this sort of
> thing.  When in degraded mode, full stripe writes can be sent straight
> through since they will always generate new, correct parity.  Any

OK.

> partial stripe writes that rewrite the missing data block are safe since
> they can be regenerated from a combination of A) the data to be written
> and B) the data blocks that aren't touched without relying on the parity
> block and an xor calculation.  Partial stripe writes that actually
> require the parity generation sequence to work, aka those that don't
> write to the missing element and therefore the missing data *must* be
> preserved, can basically be buffered just like a journal itself does by
> doing something like writing the new data into a ring buffer of writes,
> waiting for completion, then starting the final writes, then when those
> are done, revoking the ones in the buffer.  If you crash during this

I understood journalling to be a generic technique, insensitive to
fs structure. In that case, I don't see why you need discuss the
mechanism.

> time, then you replay those writes (prior to going read/write) from the
> ring buffer, which gives you the updated data on disk.  If the journal
> then replays the writes as well, you don't care because your parity will
> be preserved.
>  
> > On the other hand, if the journal itself is what we are talking about,
> > being located on the raid device, all bets are off (I've said that
> > before, and remain to be convinced that it is not so, but it may be so
> > - I simply see a danger that I have not been made to feel good about ..). 

> Given this specific scenario, it *could* corrupt your journal, but only
> in the case were you have some complete and some incomplete journal
> transactions in the same stripe.  But, then again, the journal is a ring
> buffer, and you have the option of telling (at least ext3) how big your
> stripe size is so that the file system layout can be optimized to that,
> so it could just as easily be solved by making the ext3 journal write in
> stripe sized chunks whenever possible (for all I know, it already does,
> I haven't checked).  Or you could do what I mentioned above.

I think you are saying that setting stripe size and fs block size to 4K
always does the trick.

> All of this sounds pretty heavy, with double copying of writes in two
> places, but it's what you have to do when in degraded mode.  In normal
> mode, you just let the journal do its job and never buffer anything
> because the write replays will always be correct.

Peter

