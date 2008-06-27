From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 recovery dramas.
Date: Sat, 28 Jun 2008 06:44:19 +1000
Message-ID: <18533.20771.286899.160882@notabene.brown>
References: <48608E9B.6080904@curly.ii.net>
	<18532.49368.984453.933541@notabene.brown>
	<4864CBAB.90201@curly.ii.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mark Davies on Friday June 27
Sender: linux-raid-owner@vger.kernel.org
To: Mark Davies <mark@curly.ii.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 27, mark@curly.ii.net wrote:
> > I'm at a bit of a loss as to what to suggest.  The data is mostly
> > there, but getting it back is tricky.
> > 
> > What you need to do is 
> >    choose one of sdd and sde which you think is device  '3'
> >      (sdc is 0, sdb is 1, sda is 2).
> >    rewrite the metadata to assert this fact
> >    assemble the array read-only with sd[abc] and the one you choose
> >    read the data to make sure it is all where
> >    switch to read-write so the reshape competes, leaving you with
> >     a degraded array
> >    add the other drive and let it recover.
> > 
> > The early steps in particular are not easy.
> 
> Since there's only two options, what's to stop me taking a backup of the 
> metadata, and then rewriting the metadata on one drive, mounting it, 
> seeing if it makes sense.  If it does, great.  If it doesn't, then 
> restore the metadata and repeat the process on the other drive.
> 
> Or am I missing an important step?

Yes, you could do that.
But re-writing the metadata is non-trivial, and I'm not confident
about how to start the array read-only.
  echo 1 > /sys/module/md-mod/parameters/start_ro
might do it, bit I would want to test with some scratch data first.

I would create some loop back devices over files and try to make a
similar situation and assemble the array and assure my self that
reshape doesn't start automatically (it shouldn't while the array is
readonly) before actually doing anything to the real devices.

NeilBrown
