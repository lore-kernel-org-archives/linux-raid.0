From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Fwd: "Enhanced" MD code avaible for review]
Date: Wed, 17 Mar 2004 20:01:17 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040317190117.GA23968@lst.de>
References: <405899E8.8070806@pobox.com> <20040317183756.GA23667@lst.de> <2241002704.1079549645@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2241002704.1079549645@aslan.btc.adaptec.com>
To: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 17, 2004 at 11:54:05AM -0700, Justin T. Gibbs wrote:
> > On Wed, Mar 17, 2004 at 01:33:12PM -0500, Jeff Garzik wrote:
> >> A patch to fs/partitions/check.c is also required for this
> >> release to function correctly:
> 
> Hmm.  I don't think Jeff wrote that.

That's why it's doubly-quoted, right?

> >> http://people.freebsd.org/~gibbs/linux/SRC/md_announce_whole_device.diff
> > 
> > Vetoed.  Kernel-level autodetection code is deprecated already, don't
> > even try to add functionality for it.
> 
> So do you speak for the entire community in expressing that auto-detection
> will never make sense in the kernel?  Are you completely unwilling to
> entertain even a minor discussion on the topic for those of us that don't
> understand the concerns the community has in supporting it?

I speak about the concencus the 'community' has reached in the past.
If you invested the tiniest amount of googling you'd have seen messages
from Neil where he sais he'd rather get rid of autodetection ioctls
in favour of mdadm doing the work, and patches extending autodetection
beeing rejected.  Which pretty much fits into the general do it in
userspace if you can rule.

> > As for the actual code please post diffs instead of tarballs.
> 
> If you look at the posted code, you'll see that diffs make little
> sense at this point.  But I will generate diffs in addition
> to the tarball with the next release later this week.

Diffs alwasy make sense if you touch existing code.

