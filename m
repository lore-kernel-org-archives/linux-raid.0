From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 17:21:31 +0100
Message-ID: <bdsqa2-55l.ln1@news.it.uc3m.es>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <200501041424.19802.maarten@ultratux.net> <eekqa2-4m2.ln1@news.it.uc3m.es> <200501041631.16339.maarten@ultratux.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maarten <maarten@ultratux.net> wrote:
> I'll not even go into gambling, which is immensely popular.  I'm sure there 
> are even mathematicians who gamble.  How do you figure that ?? 

I know plenty who do.  They win.  A friend of mine made his living at
the institute of advanced studies at princeton for two years after his
grant ran out by winning at blackjack in casinos all over the states.
(never play him at poker!  I used to lose all my matchsticks ..)

> > If they say it is 20 years and not 10 years, well I believe that too,
> > but they must be keeping the monkeys out of the room.
> 
> Nope, not 10 years, not 20 years, not even 40 years.  See this Seagate sheet 
> below where they go on record with a whopping 1200.000 hours MTBF.  That 
> translates to 137 years.

I believe that too.  They REALLY have kept the monkeys well away.
They're only a factor of ten out from what I think it is, so I certainly
believe them.  And they probably discarded the ones that failed burn-in
too.

> Now can you please state here and now that you 
> actually believe that figure ?

Of course. Why wouldn't I? They are stating something like 1% lossage
per year under perfect ideal conditions, no dust, no power spikes, no
a/c overloads, etc. I'd easily belueve that.

> Cause it would show that you have indeed 
> fully and utterly lost touch with reality.  No sane human being would take 
> seagate for their word seen as we all experience many many more drive 
> failures within the first 10 years,

Of course we do. Why wouldn't we? That doesn't make their figures
wrong!

> let alone 20, to even remotely support 
> that outrageous MTBF claim.

The number looks believable to me. Do they reboot every day? I doubt
it. It's not outrageous. Just optimistic for real-world conditions.
(And yes, I have ten year old disks, or getting on for it, and they
still work).

> All this goes to show -again- that you can easily make statistics which do not 

No, it means that statistics say what they say, and I understand them
fine, thanks.

> resemble anything remotely possible in real life.  Seagate determines MTBF by 
> setting up 1.200.000 disks, running them for one hour, applying some magic 
> extrapolation wizardry which should (but clearly doesn't) properly account 
> for aging, and hey presto, we've designed a drive with a statistical average 
> life expectancy of 137 years.  Hurray.  

That's a fine technique. It's perfectly OK. I suppose they did state
the standard deviation of their estimator?

> Any reasonable person will ignore that MTBF as gibberish,

No they wouldn't - it looks a perfectly reasonable figure to me, just
impossibly optimisitic for the real world, which contains dust, water
vapour, mains spikes, reboots every day, static electrickery, and a
whole load of other gubbins that doesn't figure in their tests at all.

> and many people 
> would probably even state as much as that NONE of those drives will still 
> work after 137 years. (too bad there's no-one to collect the prize money)

They wouldn't expect them to. If the mtbf is 137 years, then of a batch
of 1000, approx 0.6 and a bit PERCENT would die per year.  Now you get
to multiply.  99.3^n % is ...  well, anyway, it isn't linear, but they
would all be expected to die out by 137y.  Anyone got some logarithms?

> So, the trick seagate does is akin to your trick of defining t as small as you 

Nonsense. Please stop this bizarre crackpottism of yours. I don't have
any numrical disabilities, and if you do, that's your problem, and it
should give yu a guide where you need to work to improve.

> Nope.  I want you to provide a formula which shows how likely a failure is.  

That's your business. 

But it doesn't seem likely that you'll manage it.

> It is entirely my prerogative to test that formula with media with a massive 
> failure rate.  I want to build a raid-1 array out of 40 pieces of 5.25" 
> 25-year old floppy drives, and who's stopping me.  
> What is my expected failure rate ?

Oh, about 20 times the failure rate with one floppy.  If the mtbf for
one floppy is x (so the probabilty of failure is p = 1/x per unit time),
then the raid will fail after two floppies die, which is expected to be
at APPROX 1/(40p) + 1/(39p) = x(1/40 + 1/39) or approximately x/20
units of time from now (I shoould really tell you the expected time to
the second event in a poisson distro, but you can do that for me ..., I
simply point you to the crude calculation above as being roughly good
enough).

It will last one twentieth as long as a single floppy (thanks to the
redundancy).


> > Rest of crank math removed. One can't reason with people who simply
> > don't have the wherewithal to recognise that the problem is inside
> > them.
> 
> This sentence could theoretically equally well apply to you, couldn't it ?

!!

Peter

