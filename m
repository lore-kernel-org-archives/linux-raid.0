From: NeilBrown <neilb@suse.de>
Subject: Re: PATCH: RAID10-layout-descriptions
Date: Mon, 16 Jun 2014 06:43:17 +1000
Message-ID: <20140616064317.22366dea@notabene.brown>
References: <1402852943.4708.8.camel@heisenberg.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1402852943.4708.8.camel@heisenberg.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 15 Jun 2014 19:22:23 +0200 Christoph Anton Mitterer
<calestyo@scientia.net> wrote:

> Hi Neil.
> 
> As mentioned on GitHub before I'm trying to clean up some old patches or
> get them merged.
> 
> 
> I lost a bit track on what we've discussed about them before,...
> 
> One thing I remember is that you didn't like unicode and tbl(1) being
> used.

tbl I can live with.  Unicode I cannot.
In some contexts Unicode may be ok (non-English words) but not for
line-drawing characters and not for special punctuation.  troff should be
able to create those characters itself and you should tell it what you want.

> 
> Well of course we can talk about that again,... but I think this is
> 2014, so literally everyone has unicode and I think the explanations
> benefit from it (actually I see more and more manpages using unicode).

It's not true that "literally everyone" has enough water to drink.
Suggesting they have Unicode is ridiculous.

> 
> With respect to tbl(1) and the box drawings... I think you were
> complaining that this doesn't work with groff when rendering e.g. to
> PDF.... well I guess you're right, but the question is probably: is
> anyone in the world doing this?

Google  for "manpages pdf"

There are certainly web sites that display man pages in HTML, so that is a
minimum requirement.
The correct approach is not "do what I think is cool" but "do the same sort
of think that all other man pages do to maximize interoperability".


> I mean for manpages it seems to work quite well and IMHO improves
> readability and understandability of the explanations quite a lot... and
> we can't just cover any side way on how the nroff files might be used,
> and for which rendering doesn't work.

The idea of following standards is that if everyone does, then you *do* cover
all conforming uses of the code.

Some of that "standard" is in "man 7 man-pages".  Some of it is simply
defacto.

( of 18508 man pages on my laptop, 333 contain Unicode.
 Some is in peoples names. Some are in month names for non-western
 calendar.
 There are occasional "copyright" characters which should be \*(co.

 mmcli.8  uses some unicode quotes, which is wrong.  I'm sure there are 
           troff special directives for that
 screen.1 does too
 systemd.time.7 and timedatectl  use an arrow instead of \[->]
 and several use accented characters and non-latin characters which is
 probably OK.
)
> 
> 
> After all,... I think the patches below contain lots of valuable
> information which is currently missing in the manpages... so having that
> information merged somehow is surely better than not.
> Actually the same is IMHO fully missing for the different RAID 5/6
> layouts.

Yes, the patches contain valuable improvements.  Unfortunately some are
blended with regressions which make them hard to use.
Others just fix problems which were introduced earlier in the series, which
is poor form.

When sending patches by email it is greatly preferred to send one patch per
email.  This makes it a lot easier to apply (using "git am"), and a lot
easier to reply to.

I may try to pick the usable bits out of the patches later in the month as I
do like some of the improvements.  But I'd rather not have to :-)

Thanks,
NeilBrown


> 
> I'd be happy if someone could look into spelling issues and that like.
> 
> Cheers,
> Chris.

