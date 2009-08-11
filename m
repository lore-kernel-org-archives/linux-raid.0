From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH] md: avoid use of broken kzalloc mempool
Date: Tue, 11 Aug 2009 15:03:32 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0908111500260.9568@cobra.newdream.net>
References: <1249332888-13440-1-git-send-email-sage@newdream.net>
 <8604b01355a1ff1ec6397d223c28b1d5.squirrel@neil.brown.name>
 <20090811145258.6cd823d6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755499AbZHKWDd@vger.kernel.org>
In-Reply-To: <20090811145258.6cd823d6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

On Tue, 11 Aug 2009, Andrew Morton wrote:

> On Tue, 4 Aug 2009 08:03:52 +1000 (EST)
> "NeilBrown" <neilb@suse.de> wrote:
> 
> > On Tue, August 4, 2009 6:54 am, Sage Weil wrote:
> > > The kzalloc mempool does not re-zero items that have been used and then
> > > returned to the pool.  Manually zero the allocated multipath_bh instead.
> > >
> > > CC: linux-raid@vger.kernel.org
> > > CC: Neil Brown <neilb@suse.de>
> > > CC: <stable@kernel.org>
> 
> Sage, why did you cc stable@kernel.org?  The patch fixes some bug? 
> What is it?  Why is the fix sufficiently important to warrant
> backporting?

I thought it fixed a bug in multipath (though as Neil points out it turns 
out that code wasn't relying on the structure being zeroed, so there's no 
need to backport).  It would have been pretty rare, only affecting 
multipath after low-memory conditions.  I'm not sure what the criteria are 
for stable, so I thought I'd be on the safe side.

sage


> > Acked-by: NeilBrown <neilb@suse.de>
> > 
> 
> Thanks, I'll merge it once the above is understood.
> 
> > 
> > In fact, you don't even need the memset.  After allocation
> > no assumptions are made about the content of the structure.
> > Every field is immediately initialised except retry_list, which
> > is never accessed until after the object is placed on a list.h list.
> > 
> > So this code never needed kzalloc_pool.
> 
> Well, that's a bit of a functional change so let us (ie: you ;)) do
> that separately?
> 
> 
