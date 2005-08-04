From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 000 of 7] Introduction
Date: Wed, 3 Aug 2005 22:45:32 -0700
Message-ID: <20050803224532.73df5fb2.akpm@osdl.org>
References: <20050802193525.12307.patches@notabene>
	<20050803221045.14fd1125.akpm@osdl.org>
	<17137.43363.852096.540453@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17137.43363.852096.540453@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
>
> On Wednesday August 3, akpm@osdl.org wrote:
> > NeilBrown <neilb@cse.unsw.edu.au> wrote:
> > >
> > > 
> > > Following are 7 patches for md in 2.6.13-rc4
> > > They are all fairly well tested, with the possible exception of '4' -
> > > I haven't actually tried throwing BIO_RW_BARRIER requests are any md
> > > devices.  However the code is very straight forward.
> > > 
> > > I'm happy (even keen) for these to go into 2.6.13.
> > > If it's getting a bit late, then 2 is probably the most important.
> > > The others we can probably live without.
> > > 
> > 
> > hm, OK.  Merging 1) and 2) seems sane.  I must say that I worry about 4)
> > and would prefer to defer things if poss.
> 
> Fair enough.  4 can wait until 2.6.14 (only a couple of months away,
> right :-)

Thereabouts..

> > 
> > If there are others there which you really would prefer to see in 2.6.13
> > then please let me know.
> > 
> 
> 5, 6, and 7 I would really prefer to be in 2.6.13.

OK.

> The intent-bitmap stuff is broken (in small but potentially
> significant ways) without them, and they are complete no-ops if
> bitmaps aren't enabled:
>   5 only touches bitmap.c
>   6 removes the setting for R1BIO_Degraded which is not used and
>      slightly re-arranges an 'if' statement.  All other changes are 
>      complete no-ops if bitmaps aren't enabled.
>   7: if bitmaps aren't enabled, all this does is call "wait_event"
>      exactly the same way as will very possibly be called a few lines
>      later when md_update_sb is called.
> 
> So I'm convinced (and hopefully convincing) that they don't have any
> significant effect if bitmaps aren't enabled, and fix genuine problems
> with bitmaps, and so are appropriate for 2.6.13...

We'll see ;)
