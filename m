From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 00:53:00 +0100
Message-ID: <srmra2-n0n.ln1@news.it.uc3m.es>
References: <2h9ra2-mfj.ln1@news.it.uc3m.es> <200501042138.j04Lcs921349@www.watkins-home.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy <bugzilla@watkins-home.com> wrote:
> A birthday candle lasts about 2 minutes (as a guess).  I think they would
> light 1000 candles at the same time.  Then monitor them until the first one
> fails, say at 2 minutes.  I think the MTBF would then be computed as 2000
> minutes MTBF!

If the distribution is Poisson (i.e. the probabilty of dying per moment
time is constant over time) then that is correct. I don't know offhand
if that is an unbiassed estimator. I would imagine not. It would be
biassed to the short side.

> But we can be sure that by 2.5 minutes, at least 90% of them
> would have failed.

Then you would be sure that the distribution was not Poisson. What is
the problem here, exactly?  Many different distributions can have the
same mean.  For example, this one:

deaths per unit time
|
|   /\
|  /  \
| /    \
|/      \
---------->t

and this one

deaths per unit time
|
|\      /
| \    /
|  \  /
|   \/
---------->t

have the same mean. The same mtbf.

Is this a surprise ? The mean on its own is only one parameter of a
distribution - for a posson distribution, it is the only parameter, but
that is a particular case.  For the normal disribution you require both
the mean and the standard deviation in order to specify the
distribution.  You can get very different normal distributions with the
same mean!

I can't draw a Poisson distribution in ascii, but it has a short sharp
rise to the peak, then a long slow decline to infinity. If you were to
imagine that half the machines had died by the time the mtbf were
reached, you would be very wrong! Many more have died than half. But
that long tail of those very few machines that live a LOT longer than
the mtbf balances it out.

I already did this once for you, but I'll do it again: if the mtbf is
ten years, then 10% die every year.  Or 90% survive every year.  This
means that by the time 10 years have passed only 35% have survived
(90%^10).  So 2/3 of the machines have died by the time the mtbf is
reached!

If you want to know where the peak of the death rate occurs, well, it
looks to me as though it is at the mtbf (but I am calculating mentally,
not on paper, so do your own checks). After that deaths become less
frequent in the population as a whole.

To estimate the mtbf, I would imagine that one averages the proportion
of the population that die per month, for several months. But I guess
serious appicative statisticians have evolved far more sophisticated
and more efficient estimators.

And then there is the problem that the distribution is bipolar, not pure
poisson.  There will be a subpopulation of faulty disks that die off
earlier.  So they need to discount early measurements in favour of the
later ones (bad luck if you get one of the subpopulation of defectives
:) - but that's what their return policy is for).



Peter

