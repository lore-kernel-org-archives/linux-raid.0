From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Hard drive Reliability?
Date: Thu, 20 May 2004 00:39:46 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0405200018170.15906-100000@coffee.psychology.mcmaster.ca>
References: <1084996693.4021.8.camel@ws101.darkcore.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1084996693.4021.8.camel@ws101.darkcore.net>
To: John Lange <john.lange@bighostbox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> all come to the conclusion that Hard Drives are far less reliable than
> they used to be.

margins are stretched, for sure.  I don't believe this is the main
cause of people's frustration with disk failures, but instead the 
fact that drives are treated with less care.  nowadays, those annoying
randoms at the corner computer store keep a pile of disks under 
the counter, with nothing but an anti-static bag to protect them.
think nothing of clanking them together to shuffle the deck looking
for the 80G one you're asking for.  and how did those disks arrive?
some low-margin shipping service, packed 40 per box, from a fourth-line
reseller that specializes in shifting objects at high speed.

the fact is that disks are dirt cheap now, so whining about their 
robustness is kind of silly.  if you don't like trusting a single 
disk, use raid: that's what it's for.  yes, it's less of a clean
solution on small machines, but there is *no* reliability problem
on servers, since raid5 is fast and cheap and you get to choose
your comfort level of bomb-proof-ness.

> Case in point, I have a 120G Maxtor drive in a server that began to fail
> less than 8 months into service. Major headache.

there is no conspiracy: all the top-tier vendors have roughly the same 
quality (and product lines, and prices, etc.)

> fail so often this saves loads of headaches. After a their system has
> died and they 'lost everything' people are more than willing to pay the
> extra $150 for redundancy.

it's curious to reflect on the social aspects of the PC revolution.
people just plain like the idea of having their stuff stored on a box
that sits within reach.  the fact that this is becoming cheaper and 
cheaper doesn't mean that it's the right solution, always, all ways.
diskless PCs make HUGE amounts of sense; I suppose we can blame MSFT
somewhat for fighting that.

> I know drive manufactures were sued recently in a class action for
> shipping drives which they knew were going to fail prematurely but that
> was a few years back.

that is a somewhat deceptive way to put it.  IBM honestly produced 
a product that they thought was good.  in fact, it was the darling
of the geek industry, until people realized that there were some odd
issues having to do with abrupt power-offs (do we even have the story
straight yet?).  IBM is, like any other large organization, crippled
by its legal types, and can't just forthrightly say "we screwed up 
and didn't test this odd usage pattern properly".

as products mature, they tend to become more complex, and entertain 
new failure modes.  can you reach under the hood and tweak the carb
on your car?  similarly, features like auto-defect-sparing and 
write-behind caches that flush on power-loss are tricky, and produce
non-intuitive failure modes.  can they be tested better, sure.  is there
any going back?  no.

> So what are other peoples feelings about drive reliability and are some
> brands better than others?

maxtor/seagate/hgst/wd are safe bets.  go for 3yr warranties.  
use some form of raid and/or backup and/or replication.

> Does anyone know of any web sites with statistics or test data?

storagereview.com tries, but its hard to collect serious data from
random, noncompliant populations.  in particular, squeaky wheels lead
to drastic biases.


