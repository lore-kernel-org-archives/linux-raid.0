From: Neil Brown <neilb@suse.de>
Subject: Re: How to initialize "composite" RAID
Date: Sat, 11 Sep 2010 09:07:09 +1000
Message-ID: <20100911090709.580f3539@notabene>
References: <AANLkTim9TnyTGMWnRr65SrmJDrLN=Maua_QnVLLDerwS@mail.gmail.com>
	<20100910222814.CB50615242D@gemini.denx.de>
	<20100911083748.14843721@notabene>
	<AANLkTi=kKKYWY9rLG57i-kqV02Lnf2QPhe5cqaBKEVyW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=kKKYWY9rLG57i-kqV02Lnf2QPhe5cqaBKEVyW@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hartman <mike@hartmanipulation.com>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 10 Sep 2010 18:45:54 -0400
Mike Hartman <mike@hartmanipulation.com> wrote:

> On Fri, Sep 10, 2010 at 6:37 PM, Neil Brown <neilb@suse.de> wrote:
> > On Sat, 11 Sep 2010 00:28:14 +0200
> > Wolfgang Denk <wd@denx.de> wrote:
> >
> >> Dear Mike Hartman,
> >>
> >> In message <AANLkTim9TnyTGMWnRr65SrmJDrLN=Maua_QnVLLDerwS@mail.gmail.com> you wrote:
> >> > This is unrelated to my other RAID thread, but I discovered this issue
> >> > when I was forced to hard restart due to the other one.
> >> >
> >> > My main raid (md0) is a RAID 5 composite that looks like this:
> >> >
> >> > - partition on hard drive A (1.5TB)
> >> > - partition on hard drive B (1.5TB)
> >> > - partition on hard drive C (1.5TB)
> >> > - partition on RAID 1 (md1) (1.5TB)
> >>
> >> I guess this is a typo and you mean RAID 0 ?
> >>
> >> > md1 is a RAID 0 used to combine two 750GB drives I already had so that
> >>
> >> ...as used here?
> >>
> >> > Detecting md0. Can't start md0 because it's missing a component (md1)
> >> > and thus wouldn't be in a clean state.
> >> > Detecting md1. md1 started.
> >> > Then I use mdadm to stop md0 and restart it (mdadm --assemble md0),
> >> > which works fine at that point because md1 is up.
> >>
> >> Did you try changing your configurations uch that md0 is the RAID 0
> >> and md1 is the RAID 5 array?
> >>
> >
> > Or just swap the order of the two lines in /etc/mdadm.conf.
> >
> > NeilBrown
> >
> 
> I thought about trying that, but I was under the impression that the
> autodetect process didn't refer to that file at all. I take it I was
> mistaken? If so that sounds like the simplest fix.

Depends what you mean by the "auto detect" process.

If you are referring to in-kernel auto-detect triggered by the 0xFD partition
type, then just don't use that.  You cannot control the order in which arrays
are assembled.  You could swap the name md1 and md0 (Which isn't too hard
using --assemble --update=super-minor) but it probably wouldn't make any
change to behaviour.

Get disable in-kernel autodetect and let mdadm assemble the arrays for you.
It has a much better chance of getting it right.

NeilBrown
