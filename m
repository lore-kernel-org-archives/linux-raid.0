From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md 000 of 7] Introduction
Date: Thu, 4 Aug 2005 15:36:35 +1000
Message-ID: <17137.43363.852096.540453@cse.unsw.edu.au>
References: <20050802193525.12307.patches@notabene>
	<20050803221045.14fd1125.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Wednesday August 3
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 3, akpm@osdl.org wrote:
> NeilBrown <neilb@cse.unsw.edu.au> wrote:
> >
> > 
> > Following are 7 patches for md in 2.6.13-rc4
> > They are all fairly well tested, with the possible exception of '4' -
> > I haven't actually tried throwing BIO_RW_BARRIER requests are any md
> > devices.  However the code is very straight forward.
> > 
> > I'm happy (even keen) for these to go into 2.6.13.
> > If it's getting a bit late, then 2 is probably the most important.
> > The others we can probably live without.
> > 
> 
> hm, OK.  Merging 1) and 2) seems sane.  I must say that I worry about 4)
> and would prefer to defer things if poss.

Fair enough.  4 can wait until 2.6.14 (only a couple of months away,
right :-)

> 
> If there are others there which you really would prefer to see in 2.6.13
> then please let me know.
> 

5, 6, and 7 I would really prefer to be in 2.6.13.

The intent-bitmap stuff is broken (in small but potentially
significant ways) without them, and they are complete no-ops if
bitmaps aren't enabled:
  5 only touches bitmap.c
  6 removes the setting for R1BIO_Degraded which is not used and
     slightly re-arranges an 'if' statement.  All other changes are 
     complete no-ops if bitmaps aren't enabled.
  7: if bitmaps aren't enabled, all this does is call "wait_event"
     exactly the same way as will very possibly be called a few lines
     later when md_update_sb is called.

So I'm convinced (and hopefully convincing) that they don't have any
significant effect if bitmaps aren't enabled, and fix genuine problems
with bitmaps, and so are appropriate for 2.6.13...

Thanks,
NeilBrown

  

> 
> > 
> > 
> >  [PATCH md 001 of 7] Remove a stray debugging printk.
> >  [PATCH md 002 of 7] Make 'md' and alias for 'md-mod'
> >  [PATCH md 003 of 7] Fix minor error in raid10 read-balancing calculation.
> >  [PATCH md 004 of 7] Fail IO requests to md that require a barrier.
> >  [PATCH md 005 of 7] Always honour md bitmap being read from disk
> >  [PATCH md 006 of 7] Yet another attempt to get bitmap-based resync to do the right thing in all cases...
> >  [PATCH md 007 of 7] Make sure md bitmap updates are flushed when array is stopped.
