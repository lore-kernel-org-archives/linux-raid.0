From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: avoid use of broken kzalloc mempool
Date: Thu, 13 Aug 2009 09:17:47 +1000
Message-ID: <19075.19867.522323.983427@notabene.brown>
References: <1249332888-13440-1-git-send-email-sage@newdream.net>
	<8604b01355a1ff1ec6397d223c28b1d5.squirrel@neil.brown.name>
	<20090811145258.6cd823d6.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Tuesday August 11
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sage@newdream.net, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 11, akpm@linux-foundation.org wrote:
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
> 
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

Yes, I'll keep an eye out for your change to be merged, then I'll
apply mine.

NeilBrown
