From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 16:06:29 +0100
Message-ID: <lortg2-9th.ln1@news.it.uc3m.es>
References: <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <d1f8fr$k8f$1@sea.gmane.org> <e1nrg2-os1.ln1@news.it.uc3m.es> <d1fd9v$7h6$1@sea.gmane.org> <dsftg2-8cr.ln1@news.it.uc3m.es> <20050319125821.GO18819@marowsky-bree.de> <hvltg2-ss8.ln1@news.it.uc3m.es> <20050319140754.GP18819@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree <lmb@suse.de> wrote:
> On 2005-03-19T14:27:45, "Peter T. Breuer" <ptb@lab.it.uc3m.es> wrote:
> 
> > > Which one of the datasets you choose you could either arbitate via some
> > > automatic mechanisms (drbd-0.8 has a couple) or let a human decide.
> > But how on earth can you get into this situation? It still is not clear
> > to me, and it seems to me that there is a horrible flaw in the managing
> > algorithm for the failover if it can happen, and one should fix it.
> 
> You mean, like an admin screwup which should never happen? ;-)

The admin would have had to do it deliberately, while preventing the
normal failover from occurring. Mind you, I agree that he CAN do it,
and thus has quite a high Murphy-mediated liklihood of doing it. But an
admin can do anything, so "shrug" .. he jumped in, let him climb out.

> Remember what RAID is about: About errors which _should not_ occur (if
> the world was perfect and software and hardware never failed); but which
> with a given probability they _do_ occur anyway, because the real world
> doesn't always do the right thing.

The software here is managing hardware failures by imposing a strict
procedure!  Are you suggesting that it be also prepared to fix its own
procedural failures?  Why not simply "fix the software"?

Yes, being prepared to act in a robust and sensible fashion under
unexpected circumstances is always good, but I simply cannot countenance
failover software that is designed to SAVE one from disaster also being
envisaged as possibly failing in a way that obtains the situation that
it is explicitly intended to avoid - namely causing writes to two disks
at the same time.

> It's futile to argue about that it should never occur; morale arguments
> don't change reality. 

It does NOT occur within the design, and the design is there precisely
to avoid it.  Once it has occured, the failover design really has failed
:(.

OK, it's an interesting situation, and we would like to get out of it
neatly if it's practible, but I don't see much sense worrying about it
- it's like worrying about giving away too many fouls on half-way, when
you are 10-0 down and they're still scoring. The problem is NOT this
situation, but how you managed to get into it.

> Split-brain is a well studied subject, and while many prevention
> strategies exist, errors occur even in these algorithms;

Show me how :-(.  The algorithm is perfectly simple: block, flush one,
stop one, start one, unblock.

That was under admin control. If you failover via death, it's even
simpler: one dies, start another.

Then you get the problems on resync, but I'll happily give the "simple"
recipe for that too!



> and there's
> always a trade-off:

Yes.

> For some scenarios, they might choose a very low
> probability of split-brain occuring in exchange for a higher guarantee
> that service will 'always' be provided. It all depends on the kind of
> data and service, the requirements and the cost associated with it.

Well, that I agree with. And I am in favour of catering for the dumb
admin. But if he wants to write both sides, I don't see why we should
stop him :).


> > > The default with drbd-0.7 is that they will detect this situation has
> > > occured and refuse to start replication unless the admin intervenes and
> > > decides which side wins.
> > Hmm. I don't believe it can detect it reliably. It is always possible
> > for both sides to have written different data in the ame places, etc.
> 
> drbd can detect this reliably by its generation counters;

It doesn't matter what words are used - it can't. If you split the two
systems and carry on writing to both, then both "generation counters"
will increment in the same way, but you don't have to write the same
data to both!

> the one
> element which matters here is the one which tracks if the device has
> been promoted to primary while being disconnected.

If both systems get "promoted to primary", they both get the same
count.

> (Each side keeps its own generation counters and it's own bitmap &
> journal, and during regular operation, they are all sync'ed. So they can
> be used to figure out what diverged 'easily' enough.)

They can't (not in all circumstances - that's just logical).

> If you don't believe something, why don't you go read up ;-)

Because I am a theorist, so I don't need to read up.  It would only
either confuse me with irrelevant detail or annoy me for being wrong :).
I can tell what can and cannot happen without having to experience it -
that's the whole point of theory :-(. (well, you did ask).



> This also is a reasonably well studied subject; there's bits in "Fault
> Tolerance in Distributed Systems" by Jalote, and Philipp Reisner also
> has a paper on it online; I think parts of it are also covered by his
> thesis.

Quite probably, but all the writings in the world can't change the
semantics of the universe :(.  Two systems disconnected from each other
cannot reliably be told apart without consulting a third "observer" who
has been experiencing their actions throughout.  You'd have to have them
logging to a third node to figure out which is "right" (and which is
"left" :-).

Peter

