From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 11:14:19 +0100
Message-ID: <rs6qa2-ekh.ln1@news.it.uc3m.es>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <200501040145.07569.maarten@ultratux.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten <maarten@ultratux.net> wrote:
> On Monday 03 January 2005 21:41, Peter T. Breuer wrote:
> > maarten <maarten@ultratux.net> wrote:
> > > Just for laughs, I calculated this chance also for a three-way raid-1
> > > setup
> 
> > > Let us (randomly) assume there is a 10% chance of a disk failure.
> >
> > No, call it "p". That is the correct name. And I presume you mean "an
> > error", not "a failure".
> 
> You presume correctly.
> 
> > > We therefore have eight possible scenarios:
> >
> > Oh, puhleeeeze.  Infantile arithmetic instead of elementary probabilistic
> > algebra is not something I wish to suffer through ...
> 
> Maybe not.  Your way of explaining may make sense to a math expert, I tried to 

It would make sense to a 16 year old, since that's about where you get
to be certified as competent in differential calculus and probability
theory, if my memory of my high school math courses is correct.  This is
pre-university stuff by a looooooong way.

The problem is that I never have a 9-year old child available when I
need one ...

> explain it in a form other humans might comprehend, and that was on purpose.

If that's your definition of a human, I'm not sure I want to see them!

> Your way may be correct, or it may not be, I'll leave that up to other people. 

What do you see as incorrect?


> To me, it looks like you complicate it and obfuscate it, like someone can 

No, I simplify and make it clear.

> Now excuse me if my omitting "p" in my calculation made you lose your 
> concentration... or something.  Further comments to be found below.

It does, because what you provide is a sort of line-noise instead of
just "p". 

Not abstracting away from the detail to the information content behind
it is perhaps a useful trait in a sysadmin.


> > There is no need for you to consider these scenarios. The probability
> > is 3p^2, which is tiny. Forget it. (actually 3p^2(1-p), but forget the
> > cube term).
> 
> If you're going to prove something in calculations, you DO NOT 'forget' a tiny 

You forget it because it is tiny.  As tiny as you or I could wish to
make it.  Puhleeze.  This is just Poisson distributions.


> probability.  This is not science, it's math.

Therefore you forget it. All of differential calculus works like that.
Forget the square term - it vanishes. All terms of the series beyond
the first can be ignored as you go to the limiting situation.


> Who is to say p will always be 0.1 ? 

Me.  Or you.  But it will always be far less.  Say in the 1/10^40 range
for a time interval of one second.  You can look up such numbers for
yourself at manufacturers sites - I vaguely recall they appear on their
spec sheets.


> In another scenario in another calculation p might be as high as 0.9 !

This is a probabilty PER UNIT TIME.  Choose the time interval to make it
as small as you like.


> > > Scenarios G and H are special, the chances
> > > of that occurring are calculated seperately.
> >
> > No, they are NOT special. one of them is the chance that everything is
> > OK, which is (1-p)^3, or approx 1-3p (surprise surprise). The other is
> > the completely forgetable probaility p^3 that all three are bad at that
> > spot.
> 
> Again, you cannot go around setting (1-p)^3 to 1-3p.

Of course I can.  I think you must have failed differential calculus!
The derivative of (1-p)^3 near p=0 is -3.  That is to say that the
approximation series for (1-p)^3 is 1 - 3p + o(p).  And by o(p) I mean a
term that when divided by p tends to zero as p tends to 0.

In other words, something that you can forget.


> P is a variable which is 
> not known to you (therefore it is a variable)

It's a value. That I call it "p" does not make it variable.


> thus might as well be 0.9.  Is 

Your logic fails here - it is exactly as small as I wish it to be,
because I get to choose the interval of time (the "scale") involved.


> 0.1^3 the same to you as 1-2.7 ?   Not really huh, is it ?

If your jaw were to drop any lower it would drag on the ground :(.  This
really demonstrates amazing ignorance of very elementary high school
math.

Perhaps you've forgotten it all!  Then how do you move your hand from
point A to point B?  How do you deal with the various moments of inertia
involved, and the feedback control, all under the affluence of incohol
and gravity too?

Maybe it's a Kalman filter.  You try it with the other hand first, and
follow that with the hand you want, compensating for the differences you
see.

> > This is excruciatingly poor baby math!
> 
> Oh, well then my math seems on par with your admin skills... :-p

Peter

