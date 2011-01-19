From: Marc MERLIN <marc@merlins.org>
Subject: Re: How to force rewrite of a smart detected bad block with raid5: checkarray?
Date: Wed, 19 Jan 2011 12:57:39 -0800
Message-ID: <20110119205739.GI7117@merlins.org>
References: <4D372F1C.7080703@clear.net.nz> <20110119184914.GA27358@merlins.org> <20110120070133.47eccd10@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110120070133.47eccd10@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Richard Scobie <r.scobie@clear.net.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jan 20, 2011 at 07:01:33AM +1100, NeilBrown wrote:
> > > The kernel source, Documentation/md.txt.
> > 
> > Ah, yes of course. Didn't think about looking there, thanks.
> 
> "man md" is also an appropriate place to look.

Ah yes. Thanks for that too.

> > Mmmh, so I was curious as to how repair, when reading all the blocks of a
> > stripe with no read errors, and finding a parity mismatch, would know which
> > block was corrupted and needs to be rewritten.
> 
> It doesn't repair the data - that would be impossible.  It repairs the

that's what I thought.

> redundancy information which is all that raid really knows about.
> i.e. if it finds an inconsistency it re-writes the parity block.

Right, so it has only chance out of n to fix the right drive. Better than
nothing though.

> It isn't often useful.  But if you parity blocks are wrong somehow, then it
> can be useful.  It will not recover data that you have already lost, but it
> could make it less likely to lose more data.
 
Fair enough.

> md currently treats RAID6 just the same way as RAID5 - parity is re-written.
> It is possible that more could be done, but it isn't completely clear that it
> should - and it certainly isn't high on my priority list.

Understood.

So, I went back and read man md, and md.txt in the kernel Documentation
tree, but I could not find documentation on this:
  echo 3907029168 > sync_min                                                                                                
  echo 3907029170 > sync_max 

and as per my other post, it didn't work for me on 2.6.36
(echo: write error: Invalid argument)

Any suggestions?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems & security ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
