From: Maarten <maarten@ultratux.net>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 16:31:16 +0100
Message-ID: <200501041631.16339.maarten@ultratux.net>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <200501041424.19802.maarten@ultratux.net> <eekqa2-4m2.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eekqa2-4m2.ln1@news.it.uc3m.es>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 04 January 2005 15:05, Peter T. Breuer wrote:
> Maarten <maarten@ultratux.net> wrote:
> > On Tuesday 04 January 2005 11:14, Peter T. Breuer wrote:
> > > maarten <maarten@ultratux.net> wrote:
> > > > On Monday 03 January 2005 21:41, Peter T. Breuer wrote:
> > > > > maarten <maarten@ultratux.net> wrote:

> > Well, that IS an eye-opener for me.  I was unaware studying math was a
>
> One doesn't "study" math, one _does_ math, just as one _does_ walking
> down the street, talking, and opening fridge doors. Your competency
> at it gets certified in school and uni, that's all.

I know a whole mass of people who can't calculate what chance the toss of a 
coin has.  Or who don't know how to verify their money change is correct.
So it seems math is not an essential skill, like walking and talking is.
I'll not even go into gambling, which is immensely popular.  I'm sure there 
are even mathematicians who gamble.  How do you figure that ?? 

> > but that doesn't make it so that any harddrive has a life expectancy of
> > 20+ years, as the daily facts prove all the time.
>
> It does mean it. It means precisely that (given certain experimental
> conditions). If you want to calculate the MTBF in a real dusty noisy
> environment, I would say it is about ten years. That is, 10% chance of
> failure per year.
>
> If they say it is 20 years and not 10 years, well I believe that too,
> but they must be keeping the monkeys out of the room.

Nope, not 10 years, not 20 years, not even 40 years.  See this Seagate sheet 
below where they go on record with a whopping 1200.000 hours MTBF.  That 
translates to 137 years.  Now can you please state here and now that you 
actually believe that figure ?  Cause it would show that you have indeed 
fully and utterly lost touch with reality.  No sane human being would take 
seagate for their word seen as we all experience many many more drive 
failures within the first 10 years, let alone 20, to even remotely support 
that outrageous MTBF claim.

All this goes to show -again- that you can easily make statistics which do not 
resemble anything remotely possible in real life.  Seagate determines MTBF by 
setting up 1.200.000 disks, running them for one hour, applying some magic 
extrapolation wizardry which should (but clearly doesn't) properly account 
for aging, and hey presto, we've designed a drive with a statistical average 
life expectancy of 137 years.  Hurray.  

Any reasonable person will ignore that MTBF as gibberish, and many people 
would probably even state as much as that NONE of those drives will still 
work after 137 years. (too bad there's no-one to collect the prize money)

So, the trick seagate does is akin to your trick of defining t as small as you 
like and [then] proving that p goes to zero.  Well newsflash, you can't 
determine anything useful from running 1000 drives for one hour, and probably 
even less from running 3.600.000 drives for one second.  The idea alone is 
preposterous.

http://www.seagate.com/cda/products/discsales/marketing/
detail/0,1081,551,00.html

> > Maybe p really is the failure
> > rate in 20 year old DAT tapes that were stored at 40 degrees C.  Maybe it
> > is
>
> You simply are spouting nonsense. Please cease. It is _painful_. Like
> hearing somebody trying to sing when they cannot sing, or having to
> admire amateur holiday movies.

Nope.  I want you to provide a formula which shows how likely a failure is.  
It is entirely my prerogative to test that formula with media with a massive 
failure rate.  I want to build a raid-1 array out of 40 pieces of 5.25" 
25-year old floppy drives, and who's stopping me.  
What is my expected failure rate ?

> Rest of crank math removed. One can't reason with people who simply
> don't have the wherewithal to recognise that the problem is inside
> them.

This sentence could theoretically equally well apply to you, couldn't it ?

Maarten

