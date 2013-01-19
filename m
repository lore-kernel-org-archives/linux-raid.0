From: Phil Turmel <philip@turmel.org>
Subject: Re: Suboptimal raid6 linear read speed
Date: Sat, 19 Jan 2013 18:53:41 -0500
Message-ID: <50FB3205.7000409@turmel.org>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us> <50F70DB7.6020104@hardwarefreak.com> <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se> <50F90857.3010305@hardwarefreak.com> <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se> <50F9D32F.7090606@hardwarefreak.com> <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se> <50FB22D8.5000803@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50FB22D8.5000803@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/19/2013 05:48 PM, Stan Hoeppner wrote:
> On 1/19/2013 1:43 AM, Mikael Abrahamsson wrote:
> 
>> With a BER of 10^-14 you have a 16% risk of getting URE when reading an
>> entire 2TB drive.
> 
> On 1/19/2013 7:21 AM, Roy Sigurd Karlsbakk wrote:
> 
>> ok, perhaps, maybe, but then it's 17% chance of losing data after a
>> mirror or raid-5 rebuild with 2TB drives...
> 
> 
> Where are you guys coming up with this 16-17% chance of URE on any
> single full read of this 2TB, 10E14 drive?  The URE rate here is 1 bit
> for every 12.5 trillion bytes.  Thus, statistically, one must read this
> drive more than 6 times to encounter a URE.  Given that, how is any
> single full read between the 1st and the 6th going to have a 16-17%
> chance of encountering a URE for that one full read?  That doesn't make
> sense.

2TB/12.5TB == .16 == 16%.

It's not quite right, though.  A more precise prediction is to use the
Poisson distribution[1], as UREs are generally statistically independent
of each other (independent of the time since the previous one).

For 2TB in a 1:10^14 spec'd drive, it works out to ~ 14.8%.

Probability of zero errors in 2TB == P(0, 2TB/12.5TB) == 0.8521.

Note that the probability of reading a 12TB array without error given
1:10^14 spec'd drives is P(0, 12TB/12.5TB) ==> 38.29%, not 4%.  You
can't just scale the error rate by the size of the data to be read.

Similarly, the odds of reading through it twice ==> P(0, 24TB/12.5TB)
==> 14.66%.  It's not linear.

Of course, drives don't have a constant average error rate through their
whole life, but they behave as one through most of it.

HTH,

Phil

[1] http://stattrek.com/probability-distributions/poisson.aspx


