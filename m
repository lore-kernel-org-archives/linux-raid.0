From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Docs and operation of RAID10, size limitations on 0.90
Date: Wed, 30 Jul 2008 20:29:07 +0200
Message-ID: <20080730182907.GB10710@rap.rap.dk>
References: <20080728143553.GE30681@nexus.edgeofthenet.org> <4890943E.5060608@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4890943E.5060608@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Richard Michael <rmichael-raid@edgeofthenet.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 30, 2008 at 12:18:06PM -0400, Bill Davidsen wrote:
> Richard Michael wrote:
> >Hello list,
> >
> >I'm building a new system with 8 disks, in two RAID5 arrays of 4 disks
> >each, and a RAID1 array across them.  (Then LVM2 on top of the RAID1
> >array.)
> >
> >I approached it this way for two reasons:
> >
> >1/ It feels "cleanest"; in the sense that it's not a special case, it's
> >just RAID1 with two devices, which happen to be RAID5.

To me it seems muddy. Just having one big raid5 or raid10 would be cleaner and
give better performance.

> >2/ I have a particular usage in mind: I need to be able to split the
> >mirror and remove half; return it later and resync.  Therefore, I want
> >to know which disks comprise which halves.


I am not sure what you mean with this. You want to remove half of the
disks? I think you can do that with raid10, you just remove every other
disk. I have not tried that out, however. You could try it out before
actually emplouing it.

> >However, I'm rethinking toward RAID10.  However, I can't find much
> >documentation about layout, etc.  I believe this was recently discussed
> >on the list.

There is documentation on http://linux-raid.osdl.org/
and on http://std.dkuug.dk/keld/stripemirror.html (for raid10,f2), and 
on http://en.wikipedia.org/wiki/Non-standard_RAID_levels


Best regards
keld
