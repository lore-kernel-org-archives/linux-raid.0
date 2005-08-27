From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: number of global spares?
Date: Sat, 27 Aug 2005 15:28:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0508271518520.24427-100000@coffee.psychology.mcmaster.ca>
References: <1125122532.1055.35.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1125122532.1055.35.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > > Please be sure to use a fixed-pitch font when viewing the tables found
> > > below.  BTW, if people weren't so terrified of HTML, I could just make a
> > > nice HTML table for easy reading without silly font requirements...
> > 
> > it's not a matter of terror - many people still prefer ascii email.
> > (naturally, we also use fixed-pitch fonts for this.)
> 
> Er, IMO it makes *ix folk look like hide bound traditionalists, which is
> unfortunate, because *ix is a more capable vehicle for OS evolution.
> HTML clearly has a great deal more expressive power - why fight it?

people have different value functions - I don't find the expressiveness
of html to be worthwhile enough, for instance.  language has, after all,
proven itself pretty well over the millenia.

> So I hear.  Right now, we have one global spare per shelf, but the
> vendor is advising we decrease the number of global spares.

find out what your controller can do.  if it can actually use a spare
that it's not connected to (doubtful), then you could certainly get 
away with a single hot-spare.  you should also look up the MTBF specs 
of the disks, or make a guess (are they in a well-cooled environment?)
about how often you expect failures.  it may be that having a single
cold spare in a cabinet is good enough.  after all, when a disk goes,
you'll be in degraded mode for at least as long as it takes to rebuild
the raid, plus any latency for making the spare available...

can you go *past* 9+1?  if you're already assuming read-mostly,
or else slow writes (partial stripe RMW cycles), then going 
to a pair of 22+1+spare sounds perfectly plausible to me.
yes, it's not typically done, but not for inherent reasons...

