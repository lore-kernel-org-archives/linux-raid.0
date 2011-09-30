From: William Thompson <wt@electro-mechanical.com>
Subject: Re: RAID1 question
Date: Fri, 30 Sep 2011 10:14:54 -0400
Message-ID: <20110930141454.GF19871@electro-mechanical.com>
References: <20110929183457.GA19871@electro-mechanical.com>
 <20110929192611.GA23316@cthulhu.home.robinhill.me.uk>
 <20110929193705.GE19871@electro-mechanical.com>
 <20110929202505.GB23316@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110929202505.GB23316@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 29, 2011 at 09:25:05PM +0100, Robin Hill wrote:
> On Thu Sep 29, 2011 at 03:37:05PM -0400, William Thompson wrote:
> 
> > On Thu, Sep 29, 2011 at 08:26:11PM +0100, Robin Hill wrote:
> > > You don't need to recreate the raid at all, just reassemble it. You may
> > > want to update the homehost though, otherwise it will (IIRC) auto
> > > assemble to md_126 (or so) instead of md0.
> > 
> > The reason I asked this was because a mirrored pair that I currently have is
> > 0.90 version and I was going to use 1.0
> > 
> You _should_ be able to do a --create --assume-clean there, without
> losing the data, but I'd go with a backup, --create, and restore jsut to
> be safe.

Agreed, however, in this case, I was going for a new raid with new data and
the disks would already be in sync.

> > > ability to check the array for mismatches though, and the recovery
> > > process would bring everything into sync whenever it's run anyway. More
> > 
> > I've rarely done this.  On large disks, this takes may hours to perform.
> > 
> It can, but it also ensures the disks are readable. If you don't run
> regular checks, in a recovery situation you may hit a bad block on a
> supposedly good disk and have a heap more trouble to deal with.

Understood.

> > > of a question would be why not do the initial recovery? It doesn't delay
> > > access to the array, and at least the I/O load is happening at a
> > > controlled point (rather than at recovery time, when you have no
> > 
> > I guess the only reason I can come up with would be to avoid extra head
> > seeks.  Well, that and the time it takes.
> > 
> > During the initial sync, if a write happens to an area that has been synced,
> > does it go to all drives?  What about a write to an area that as not been
> > synced yet?
> > 
> If the area has already been synced then writes will definitely go to
> all members. I'm pretty sure this also happens in areas which haven't
> been synced as well, but I'm not 100% on that.

Ok, thanks.
