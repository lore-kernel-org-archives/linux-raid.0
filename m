From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 22:38:06 +0100
Message-ID: <uuera2-bi5.ln1@news.it.uc3m.es>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <200501041631.16339.maarten@ultratux.net> <bdsqa2-55l.ln1@news.it.uc3m.es> <200501042155.34455.maarten@ultratux.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten <maarten@ultratux.net> wrote:
> I don't see where you come up with 1% per year.

Because that is 1/137 approx (hey, is that planks constant or
something...)

> Remember that MTBF means MEAN 
> time between failures,

I.e. it's the inverse of the probability of failure per unit time, in a
Poisson distribution.  A Poisson distribution only has one parameter
and that's it! The standard deviation is that too. No, I don't recall
the third moment offhand.

> so for every single drive that dies in year one, one 
> other drive has to double its life expectancy to twice 137, which is 274 

Complete nonsense. Please go back to remedial statistics.

> years.  If your reasoning is correct with one drive dying per year, the 

Who said that? I said the probability of failure is 1% per year. Not
one drive per year! If you have a hundred drives, you expect about one
death in the first year.

> remaining bunch after 50 years will have to survive another 250(!) years, on 
> average.  ...But wait, you're still not convinced, eh ?

Complete and utter disgraceful nonsense! Did you even get as far as the
11-year old standard in your math?

> Also, I'm not used to big data centers buying disks by the container, but from 
> what I've heard no-one can actually say that they lose as little as 1 drive a 
> year for any hundred drives bought. Those figures are (much) higher.

Of course not - I would say 10% myself. A few years ago it was 20%, but
I believe that recently the figure may have fallen as low as 5%. That's
perfectly consistent with their spec.

> You yourself said in a previous post you expected 10% per year, and that is 
> WAY off the 1% mark you now state 'believeable'.  How come ?

Because it is NOT "way off the 1% mark". It is close to it! Especially
when you bear in mind that real disks are exposed to a much more
stressful environment than the manufacturers testing labs.  Heck, we
can't even get FANs that last longer than 3 to 6 months in the
atmosphere here (dry, thin, dusty, heat reaching 46C in summer, dropping
below zero in wnter).

Is the problem simply "numbers" with you?

> > Of course we do. Why wouldn't we? That doesn't make their figures
> > wrong!
> 
> Yes it does. By _definition_ even.


No it doesn't.


> It clearly shows that one cannot account 
> for tens, nay hundreds, of years wear and tear by just taking a very small 
> sample of drives and having them tested for a very small amount of time.

Nor does anyone suggest that one should!  Where do you get this from?
Of course their figures don't reflect your environment, or mine.  If you
want to duplicte their figures, you have to duplicate their environment!
Ask them how, if you're interested.

> Look, _everybody_ knows this.  No serious admin will not change their drives 
> after five years as a rule,

Well, three years is when we change, but that's because everything is
changed every three years, since it depreciates to zero in that time,
im accounting terms. But I have ten year old disks working fine (says
he, wincing at the seagate fireballs and barracudas screaming ..).

> or 10 years at the most. And that is not simply 
> due to Moore's law.  The failure rate just gets too high, and economics 
> dictate that they must be decommissioned.  After "only" 10 years...!

Of course! So? I really don't see why you think that is anything to do
with the mtbf, whhich is only the single parameter telling you what the
scale of the poisson distribution for moment-to-moment failure is!

I really don't get why you don't get this!

Don't you know what the words mean?

Then it's no wonder that whatever you say around the area makes very
little sense, and why you have the feeling that THEY are saying
nonsense, rather than that you are UNDERSTANDING nonsense, which is the
case!

Please go and learn some stats!

> > No, it means that statistics say what they say, and I understand them
> > fine, thanks.
> 
> Uh-huh.  So explain to me why drive manufacturers do not give a 10 year 
> warrantee.

Because if they did they would have to replace 100% of their disks. If
there is a 10y mtbf in the real world (as I estimate), then very few of
them would make it to ten years.


> I say because they know full well that they would go bankrupt if 
> they did since not 8% but rather 50% or more would return in that time.

No, the mtbf in our conditions is somewhere like 10y. That means that
almost none would make it to ten years. 10% would die each year. 90%
would remain. After 5 years 59% would remain. After 10 years 35% would
remain.

> > That's a fine technique. It's perfectly OK. I suppose they did state
> > the standard deviation of their estimator?
> 
> Call them and find out; you're the math whiz. 

It doesn't matter. It's good enough as a guide.

> And I'll say it again: if some statistical technique yields wildly different 
> results than the observable, verifiable real world does, then there is 

But it doesn't! 

> something wrong with said technique, not with the real world.

They are not trying to estimate the mtbf in YOUR world, but in THEIRS.
Those are different. If you want to emulate them, so be it! I don't.

> The real world is our frame of reference, not some dreamed-up math model which 

There is nothing wrong with their model. It doesn't reflect your world.

> attempts to describe the world. And if they do collide, a math theory gets 
> thrown out, not the real world observations instead...! 

You are horribly confused!  Please do not try and tell real
statisticians that YOU do not understand the model, and that therefore
THEY should change them.  You can simply understand them. They only are
applying accelerating techniques. They take 1000 disks and run them for
a year - if 10 die, then they know the mtbf is about 100y. That does
not mean that disks will last a 100y! It means that 10 in every
thousand will die within one year.

That seems to be your major confusion.

And that's only for starters. They then have to figure out how the mtbf
changes with time! But really, you don't care about that, since it's
only the mtbf during the first five years that you care about, as you
said.

So what are you on about?


> > They wouldn't expect them to. If the mtbf is 137 years, then of a batch
> > of 1000, approx 0.6 and a bit PERCENT would die per year.  Now you get
> > to multiply.  99.3^n % is ...  well, anyway, it isn't linear, but they
> > would all be expected to die out by 137y.  Anyone got some logarithms?
> 
> Look up what the word "mean" from mtbf means, and recompute.

I know what it means - you don't.  It is the inverse of the probability
of failure in any moment of time. A strange way of stating that
parameter, but then I guess it's just that people are more used to
seeing it expresed in ohms than mho.

Peter

