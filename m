From: Marc MERLIN <marc@merlins.org>
Subject: Re: How to force rewrite of a smart detected bad block with raid5: checkarray?
Date: Wed, 19 Jan 2011 10:49:14 -0800
Message-ID: <20110119184914.GA27358@merlins.org>
References: <4D372F1C.7080703@clear.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D372F1C.7080703@clear.net.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <r.scobie@clear.net.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jan 20, 2011 at 07:36:12AM +1300, Richard Scobie wrote:
> Marc Merlin wrote:
> 
> > Also, I didn't find anything about sync_action, check, and repair in
> > the mdadm man page (a pointer to
> > https://raid.wiki.kernel.org/index.php/RAID_Administration
> > would me useful).
> > Actually the above page still says that you can't check just a range
> > of blocks.
> 
> > Is there more up to date documentation that I should be reading
> > somewhere?
> 
> The kernel source, Documentation/md.txt.

Ah, yes of course. Didn't think about looking there, thanks.

Mmmh, so I was curious as to how repair, when reading all the blocks of a
stripe with no read errors, and finding a parity mismatch, would know which
block was corrupted and needs to be rewritten.
Given that I don't see how it can figure that out, I'm not even sure when
repair would be useful for raid5 when there are no underlying media errors
returned (raid6 obviously has redundant info and it's possible there).

Not that I need repair in my case (check indeed does the right thing), I'm
just not sure when repair would be useful.

Anyway, thanks again for the pointer.

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems & security ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
