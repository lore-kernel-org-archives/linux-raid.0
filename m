From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 15:05:34 +0100
Message-ID: <eekqa2-4m2.ln1@news.it.uc3m.es>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <200501040145.07569.maarten@ultratux.net> <rs6qa2-ekh.ln1@news.it.uc3m.es> <200501041424.19802.maarten@ultratux.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Maarten <maarten@ultratux.net> wrote:
> On Tuesday 04 January 2005 11:14, Peter T. Breuer wrote:
> > maarten <maarten@ultratux.net> wrote:
> > > On Monday 03 January 2005 21:41, Peter T. Breuer wrote:
> > > > maarten <maarten@ultratux.net> wrote:
> 
> > It would make sense to a 16 year old, since that's about where you get
> > to be certified as competent in differential calculus and probability
> > theory, if my memory of my high school math courses is correct.  This is
> > pre-university stuff by a looooooong way.
> 
> Oh wow.  So you deduced I did not study math at university ?

Well, I deduced that you did not get to the level expected of a 16 year
old.

> Well, that IS an eye-opener for me.  I was unaware studying math was a 

One doesn't "study" math, one _does_ math, just as one _does_ walking
down the street, talking, and opening fridge doors. Your competency
at it gets certified in school and uni, that's all.

> requirement to engage in conversation on the linux-raid mailinglist ?

Looks like it, or else one gets bogged down in inane conversations at
about the level of "what is an editor".

Look - a certain level of mathematical competence is required in the
technical world.  You cannot get away without it.  Being able to do math
to the level expected of an ordinary 16 year old is certainly expected
by me in order to be able to talk, walk, and eat pizza with you as an
ordinary human being.  

As to the Poisson distribution, I know it forms part of the university
syllabus even for laboratory techs first degrees, because the head tech
here, who has been doing his degree in tech stuff here while he admins,
used to keep coming and asking me things like "how do I calculate the
expected time between two collisions given that packets are emitted
from both ends according to a Poisson distribution with mean mu".

And that's ordinary 16 year-old math stuff. Stands to reason they would
teach it in a university at a crummy place like this.

> Or is this not the list I think it is ?

It's not the list you think it is, I think.

> > The problem is that I never have a 9-year old child available when I
> > need one ...
> 
> Um, check again... he's sitting right there with you I think.

OK! Now he can explain this man page to me, which they say a 9-year old
child can understand (must be the solaris man page for "passwd" again).

> > Therefore you forget it. All of differential calculus works like that.
> > Forget the square term - it vanishes. All terms of the series beyond
> > the first can be ignored as you go to the limiting situation.
> 
> And that is precisely what false assumption you're making ! We ARE not going 

There is no false assumption. This is "precisely" what you are getting
wrong. I do not want to argue with you, I just want you to GET IT.

> to the limiting situation.

Yes we are.

> We are discussing the probabilities in failures of 
> media.

PER UNIT TIME, for gawd's sake. Choose a small unit. One small enough
to please you. Then make it "vanishingly small", slowly, please. Then
we can all take a rest while you get it.


> You cannot assume we will be talking about harddisks, and neither is 

I don't.

> the failure rate in harddisk anywhere near limit zero.

Eh? It's tiny per tiny unit of time. As you would expect, naively.

> Drive manufacturers 
> might want you to believe that through publishing highly theoretical MTBFs, 

If the MTBF is one year (and we are not discussing failure, but error),
then the probability of a failure PER DAY is 1/365, or about 0.03. That
would make the square of that probability PER DAY about 0.0009, or
negligible in the scale of the linear term. This _is_ mathematics.

And if you want to consider the probability PER HOUR, then the
probability of failure is about 0.0012. Per minute it is about 0.00002.
Per second it is about 0.0000003. The square term is 0.0000000000009,
or completely negligible.

And that is failure, not error.

But we don't care. Just take a time unit that is pleasingly small, and
consider the probability per THAT unit. And please keep the unit to
yourself.

> but that doesn't make it so that any harddrive has a life expectancy of 20+ 
> years, as the daily facts prove all the time.

It does mean it. It means precisely that (given certain experimental
conditions). If you want to calculate the MTBF in a real dusty noisy
environment, I would say it is about ten years. That is, 10% chance of
failure per year.

If they say it is 20 years and not 10 years, well I believe that too,
but they must be keeping the monkeys out of the room.

> You cannot assume p to be vanishingly small.

I don't have to - make it so.  Then yes, I can.

> Maybe p really is the failure 
> rate in 20 year old DAT tapes that were stored at 40 degrees C.  Maybe it is 

You simply are spouting nonsense. Please cease. It is _painful_. Like
hearing somebody trying to sing when they cannot sing, or having to
admire amateur holiday movies. 

P is vanishingly small when you make it so. Do so! It doesn't require
anything but a choice on your part to choose a sufficiently small unit
of time to scale it to.

> the failure rate of wet floppydisks. You cannot make assumptions about p.  

I don't. You on the other hand ...

> The nice thing in math is that you can make great calculations when you 
> assume a variable is limit zero or limit infinite.  The bad thing is, you 

Complete and utter bullshit. You ought to be ashamed.

> cannot assume that things in real life act like predefined math variables.

Rest of crank math removed. One can't reason with people who simply
don't have the wherewithal to recognise that the problem is inside
them.

Peter

