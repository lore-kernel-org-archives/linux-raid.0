From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 18:19:44 +0100
Message-ID: <gi3ug2-oub.ln1@news.it.uc3m.es>
References: <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <d1f8fr$k8f$1@sea.gmane.org> <e1nrg2-os1.ln1@news.it.uc3m.es> <d1fd9v$7h6$1@sea.gmane.org> <dsftg2-8cr.ln1@news.it.uc3m.es> <20050319125821.GO18819@marowsky-bree.de> <hvltg2-ss8.ln1@news.it.uc3m.es> <20050319140754.GP18819@marowsky-bree.de> <lortg2-9th.ln1@news.it.uc3m.es> <20050319162443.GR18819@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree <lmb@suse.de> wrote:
> On 2005-03-19T16:06:29, "Peter T. Breuer" <ptb@lab.it.uc3m.es> wrote:
> 
> I'm cutting out those parts of the discussion which are irrelevant (or
> which I don't consider worth pursuing; maybe you'll find someone else
> to explain with more patience).

Probably :-).

> > It doesn't matter what words are used - it can't. If you split the two
> > systems and carry on writing to both, then both "generation counters"
> > will increment in the same way, but you don't have to write the same
> > data to both!
> 
> That flag gets said (as part of the generation counter tuple) on both
> sides when that happens, and if it is set on both sides, they know
> something went wrong.

Fine, but ...

> And then they can consult their bitmaps to figure out the set of blocks
> which diverge. (Granted, it's a superset, but typically it'll be a much
> smaller set than the entire volume.)

It doesn't matter - Let them both have exactly the same bitmaps, but let
different data have been written to each of them in those marked blocks.
There's no way of telling which is "good" or "bad", then!  It's just a
difference of opinion - the universe bifurcated (it does it all the time
:) and one disk went into one fork and the other disk into the other
fork, and they happily did things for a while, then they got examined
again (the universes joined).

Hey presto!  - two disks with perfectly valid but different histories.

Now let their experiences while apart be the same from the point of view
of the metadata, but different at the data level, and you have two disks
that have no distinguishing characteristics at all that you can see or
measure, but they're different.


> That part is really simple in theory.

Knowing which blocks are/may be different does not help them decide who is
_right_. 

Lars, I am trying to move you "upwards" from the detail of the
algorithms to a level at which you can see that there is no algorithm
that can decide reliably which of two diverged traces is the more
"valid" in some sense.  Whatever your algorithm is, let it decide in a
given case.  Say it says "A" is more valid.  It looks at certain
characteristics of A and B's bitmaps and maybe other "generation" marks
to decide.  Fine.  Now let A have B's present data at the time of
divergence and every time data gets written to A in its diverged univese
let it be written with B's present data.  The bitmap and the marks will
be the same as before!  Now apply your decision algorithm.  It chooses A
again (it has the same data to work on).  Unfortunately, that's choosing
something that looks just like B!  So B was the "more valid"!

> > I can tell what can and cannot happen without having to experience it -
> > that's the whole point of theory :-(. (well, you did ask).
> 
> Your theory is flawed.

:(. Oooh, unfortunately not.


> > Quite probably, but all the writings in the world can't change the
> > semantics of the universe :(.  Two systems disconnected from each other
> > cannot reliably be told apart without consulting a third "observer" who
> > has been experiencing their actions throughout.  You'd have to have them
> > logging to a third node to figure out which is "right" (and which is
> > "left" :-).
> 
> Wrong model. They know that at one point in time they've been in sync,
> and that they have since diverged, and so they can figure out where
> those differences occur.

They can't. That's the point. See above rough hack at a proof. 

Peter

