From: Jim Paris <jim@jtan.com>
Subject: Re: Kernel panic, FS corruption  Was: Re: Call for RAID-6 users
Date: Thu, 5 Aug 2004 20:19:09 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040806001909.GA19760@jim.sh>
References: <cds76e$ee7$1@terminus.zytor.com> <200407310228.27969.maarten@ultratux.net> <200408011503.20452.maarten@ultratux.net> <20040801180536.GA3897@jim.sh> <ceuhbm$rgs$1@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ceuhbm$rgs$1@terminus.zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > > I eventually got a kernel panic when copying large amounts of data to a 
> > > [degraded] raid6 array, which this time was the full 600 GB size.
> > > Don't know if it is helpful to anyone but info below:
> > 
> > The panic is from reiserfs, and it's occuring because the FS is
> > getting corrupted due to the raid6 problems.
> 
> It's still very odd to me that so far the only thing that triggers
> this kind of problems is reiserfs.  Either reiserfs just has a really
> odd series of access patterns, or it is relying on behaviour which
> isn't actually guaranteed.  I suspect the former, but it's still odd.

No, I did see the same corruption with XFS; it just took more work
before it would show up (ie. I couldn't get it to show up by simply
copying one huge file; I had to untar a full filesystem onto it).
So I would suspect the odd access patterns.  I could also run a test
with EXT2/3 if you'd like.  I didn't manage to trigger the corruption
directly on the md device, but my access pattern was quite simple in
that case (dd big blocks to different areas).

Are you able to reproduce the problem with the scripts I sent earlier?
If not, I can give you access to a machine that can.

-jim
