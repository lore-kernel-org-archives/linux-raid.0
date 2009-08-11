From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] md: avoid use of broken kzalloc mempool
Date: Tue, 11 Aug 2009 14:52:58 -0700
Message-ID: <20090811145258.6cd823d6.akpm@linux-foundation.org>
References: <1249332888-13440-1-git-send-email-sage@newdream.net>
	<8604b01355a1ff1ec6397d223c28b1d5.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8604b01355a1ff1ec6397d223c28b1d5.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: sage@newdream.net, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

On Tue, 4 Aug 2009 08:03:52 +1000 (EST)
"NeilBrown" <neilb@suse.de> wrote:

> On Tue, August 4, 2009 6:54 am, Sage Weil wrote:
> > The kzalloc mempool does not re-zero items that have been used and then
> > returned to the pool.  Manually zero the allocated multipath_bh instead.
> >
> > CC: linux-raid@vger.kernel.org
> > CC: Neil Brown <neilb@suse.de>
> > CC: <stable@kernel.org>

Sage, why did you cc stable@kernel.org?  The patch fixes some bug? 
What is it?  Why is the fix sufficiently important to warrant
backporting?

> Acked-by: NeilBrown <neilb@suse.de>
> 

Thanks, I'll merge it once the above is understood.

> 
> In fact, you don't even need the memset.  After allocation
> no assumptions are made about the content of the structure.
> Every field is immediately initialised except retry_list, which
> is never accessed until after the object is placed on a list.h list.
> 
> So this code never needed kzalloc_pool.

Well, that's a bit of a functional change so let us (ie: you ;)) do
that separately?

