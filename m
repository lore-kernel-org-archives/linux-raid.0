From: maarten <maarten@ultratux.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 21:55:34 +0100
Message-ID: <200501042155.34455.maarten@ultratux.net>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <200501041631.16339.maarten@ultratux.net> <bdsqa2-55l.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bdsqa2-55l.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 04 January 2005 17:21, Peter T. Breuer wrote:
> Maarten <maarten@ultratux.net> wrote:


> > Nope, not 10 years, not 20 years, not even 40 years.  See this Seagate
> > sheet below where they go on record with a whopping 1200.000 hours MTBF. 
> > That translates to 137 years.
>
> I believe that too.  They REALLY have kept the monkeys well away.
> They're only a factor of ten out from what I think it is, so I certainly
> believe them.  And they probably discarded the ones that failed burn-in
> too.
>
> > Now can you please state here and now that you
> > actually believe that figure ?
>
> Of course. Why wouldn't I? They are stating something like 1% lossage
> per year under perfect ideal conditions, no dust, no power spikes, no
> a/c overloads, etc. I'd easily belueve that.

No spindle will take 137 years of abuse at the incredibly high speed of 10000 
rpm and not show enough wear so that the heads will either collide with the 
platters or read on adjacent tracks.  Any mechanic can tell you this.
I don't care what kind of special diamond bearings you use, it's just not 
feasible.  We could even start a debate of how much decay we would see in the 
silicon junctions in the chips, but that is not useful nor on-topic.  Let's 
just say that the transistor barely exists 50 years and it is utter nonsense 
to try to say anything meaningful about what 137 years will do to 
semiconductors and their molecular structures over that vast a timespan.  
Remember, it was not too long ago they said CDs were indestructible (by time 
elapsed, not by force, obviously). And look what they say now. 

I don't see where you come up with 1% per year.  Remember that MTBF means MEAN 
time between failures, so for every single drive that dies in year one, one 
other drive has to double its life expectancy to twice 137, which is 274 
years.  If your reasoning is correct with one drive dying per year, the 
remaining bunch after 50 years will have to survive another 250(!) years, on 
average.  ...But wait, you're still not convinced, eh ?

Also, I'm not used to big data centers buying disks by the container, but from 
what I've heard no-one can actually say that they lose as little as 1 drive a 
year for any hundred drives bought. Those figures are (much) higher.
You yourself said in a previous post you expected 10% per year, and that is 
WAY off the 1% mark you now state 'believeable'.  How come ?

> > Cause it would show that you have indeed
> > fully and utterly lost touch with reality.  No sane human being would
> > take seagate for their word seen as we all experience many many more
> > drive failures within the first 10 years,
>
> Of course we do. Why wouldn't we? That doesn't make their figures
> wrong!

Yes it does. By _definition_ even. It clearly shows that one cannot account 
for tens, nay hundreds, of years wear and tear by just taking a very small 
sample of drives and having them tested for a very small amount of time.

Look, _everybody_ knows this.  No serious admin will not change their drives 
after five years as a rule, or 10 years at the most. And that is not simply 
due to Moore's law.  The failure rate just gets too high, and economics 
dictate that they must be decommissioned.  After "only" 10 years...!

> > let alone 20, to even remotely support
> > that outrageous MTBF claim.
>
> The number looks believable to me. Do they reboot every day? I doubt

Of course they don't.  They never reboot. MTBF is not measured in adverse 
conditions.  Even so, neither do disks in a data centre...

> it. It's not outrageous. Just optimistic for real-world conditions.
> (And yes, I have ten year old disks, or getting on for it, and they
> still work).

Some of em do, yes. Not all of them. 
(to be fair, the MTBF in those days was much lower than now (purportedly)).

> > All this goes to show -again- that you can easily make statistics which
> > do not
>
> No, it means that statistics say what they say, and I understand them
> fine, thanks.

Uh-huh.  So explain to me why drive manufacturers do not give a 10 year 
warrantee. I say because they know full well that they would go bankrupt if 
they did since not 8% but rather 50% or more would return in that time.

> > resemble anything remotely possible in real life.  Seagate determines
> > MTBF by setting up 1.200.000 disks, running them for one hour, applying
> > some magic extrapolation wizardry which should (but clearly doesn't)
> > properly account for aging, and hey presto, we've designed a drive with a
> > statistical average life expectancy of 137 years.  Hurray.
>
> That's a fine technique. It's perfectly OK. I suppose they did state
> the standard deviation of their estimator?

Call them and find out; you're the math whiz. 
And I'll say it again: if some statistical technique yields wildly different 
results than the observable, verifiable real world does, then there is 
something wrong with said technique, not with the real world.
The real world is our frame of reference, not some dreamed-up math model which 
attempts to describe the world. And if they do collide, a math theory gets 
thrown out, not the real world observations instead...! 


> > Any reasonable person will ignore that MTBF as gibberish,
>
> No they wouldn't - it looks a perfectly reasonable figure to me, just
> impossibly optimisitic for the real world, which contains dust, water
> vapour, mains spikes, reboots every day, static electrickery, and a
> whole load of other gubbins that doesn't figure in their tests at all.

Test labs have dust, water vapours and mains spikes too, albeit as little as 
possible. They're testing on earth, not on some utopian other parallel world.  
Good colo's do a good job to eliminate most adverse effects.  In any case, 
dust is not a great danger to disks (but it is to fans), heat is. Especially 
quick heat buildup, hence powercycles are amongst the worst.  Drives don't 
really like the expansion of materials that occurs when temperatures rise, 
nor the extra friction that a higher temperature entails. 

> > and many people
> > would probably even state as much as that NONE of those drives will still
> > work after 137 years. (too bad there's no-one to collect the prize money)
>
> They wouldn't expect them to. If the mtbf is 137 years, then of a batch
> of 1000, approx 0.6 and a bit PERCENT would die per year.  Now you get
> to multiply.  99.3^n % is ...  well, anyway, it isn't linear, but they
> would all be expected to die out by 137y.  Anyone got some logarithms?

Look up what the word "mean" from mtbf means, and recompute.

Maarten

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

