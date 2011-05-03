From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: Mirrored volume peformance questions
Date: Tue, 3 May 2011 23:34:30 +0200
Message-ID: <20110503213430.GC24265@www2.open-std.org>
References: <96B30EF4F3E17749BCFF7F1816090EDA02DCE41A87@EX-SEA31-B.ant.amazon.com> <BANLkTikcVPQwFEancNbOkKvdHTwdHDb=XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTikcVPQwFEancNbOkKvdHTwdHDb=XA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: "Morad, Steve" <morad@amazon.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 03, 2011 at 04:52:07PM -0300, Roberto Spadim wrote:
> 2011/5/3 Morad, Steve <morad@amazon.com>:
> > I have a few questions about volume mirroring performance implications.
> >
> 
> > 2. Similarly, would a RAID10 configuration give me the same (or better) read behavior across these same disks, while providing twice the storage capacity of the above configuration?

RAID10 and RAID1 gives the same storage capacity with the same disks.

Linux MD RAID10 is actually just another way of doing raid1-like
layouts.


> in md world
> raid1+ raid0 != raid10
> 
> raid10 can use layouts
> raid1 can?t
> 
> raid10 have diferent read_balance algorithms than raid1
> raid10 with far layout is better optimized for sequencial read (it?s
> like raid0 stripe)
> raid10 with near/offset layoute are better optimized for multthread

Hmm, raid10 near, offset and far are about the same for multithread,
according to several benchmarks. Actually the far layout has significant
better random read performance than the near layout in some thests,
about 25 % better speed, and about 100 % bettter speed than raid1.

best regards
keld
