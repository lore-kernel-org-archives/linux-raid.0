From: Willy Tarreau <w@1wt.eu>
Subject: Re: RFI for 2.6.25.5 : Re: Regression- XFS won't mount on partitioned md array
Date: Sat, 24 May 2008 15:52:58 +0200
Message-ID: <20080524135258.GF6749@1wt.eu>
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net> <482F67D9.70400@sandeen.net> <482FBD4C.20608@sandeen.net> <482FED60.7060405@dgreaves.com> <4838192F.3050004@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755978AbYEXN75@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4838192F.3050004@dgreaves.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Greg KH <greg@kroah.com>, Eric Sandeen <sandeen@sandeen.net>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, LinuxRaid <linux-raid@vger.kernel.org>, stable@kernel.org
List-Id: linux-raid.ids

Hi David,

On Sat, May 24, 2008 at 02:33:35PM +0100, David Greaves wrote:
> Hi Greg
> Perusing:
>   http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git
> doesn't show the patch referenced below as in the queue for 2.6.25.5

First, please avoid top-posting.

> David Greaves wrote:
> > Eric Sandeen wrote:
> >> Eric Sandeen wrote:
> >>> Eric Sandeen wrote:
> >>>
> >>>> I'll see if I have a little time today to track down the problem.
> >>> Does this patch fix it for you?  Does for me though I can't yet explain
> >>> why ;)
> >>>
> >>> http://www.linux.sgi.com/archives/xfs/2008-05/msg00190.html
> >>>
> >>> -Eric
> > Yes, this fixes it for me - thanks :)
> > 
> >> So what's happening is that xfs is trying to read a page-sized IO from
> >> the last sector of the log... which goes off the end of the device.
> >> This looks like another regression introduced by
> >> a9759f2de38a3443d5107bddde03b4f3f550060e, but fixed by Christoph's patch
> >> in the URL above, which should be headed towards -stable.
> > Damn, I guess I misread my bisect readings when things crashed then.
> > Still, I said 'around' :)
> > 
> >> (aside: it seems that this breaks any external log setup where the log
> >> consists of the entire device... but I'd have expected the xfsqa suite
> >> to catch this...?)
> >>
> >> The patch avoids the problem by looking for some extra locking but it
> >> seems to me that the root cause is that the buffer being read at this
> >> point doesn't have it's b_offset, the offset in it's page, set.  Might
> >> be another little buglet but harmless it seems.

It would have helped to CC stable (fixed) and to give the mainline commit
ID since the stable branch only holds already merged patches. Greg, the
commit is 6ab455ee...

Willy
