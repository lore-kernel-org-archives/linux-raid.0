From: Marc MERLIN <marc@merlins.org>
Subject: Re: Raid check didn't fix Current_Pending_Sector, but badblocks -nsv
 did
Date: Mon, 6 Jun 2016 21:51:22 -0700
Message-ID: <20160607045122.GL12382@merlins.org>
References: <20160606174113.GI12382@merlins.org>
 <5755CA9F.6090807@prgmr.com>
 <20160606224401.GA6672@merlins.org>
 <57561B38.1070402@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57561B38.1070402@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Sarah Newman <srn@prgmr.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jun 06, 2016 at 08:54:16PM -0400, Phil Turmel wrote:
> Repair doesn't even read the parity (and Q syndrome) blocks if it
> doesn't need them.  It unconditionally recomputes and writes parity (and
> Q) blocks.
 
I see. So if it happens to rewrite a parity block that was unreadable
but that it didn't have to read, I won't even know it was unreadable to
start with (but only one change out of n of that happening in raid5)

> Both processes will compute and rewrite a block that reports a read error.
> > https://www.thomas-krenn.com/en/wiki/Mdadm_checkarray#Check_vs._Repair
> > 
> > Or are you saying that check after getting a read error from one drive,
> > would not rewrite the bad block on that drive? I thought it did...
> 
> They both do.

Thanks for confirming.

> Both processes only apply to the actual data area of each member device,
> which is usually substantially less than the whole disk.  Both processes
> will read or write (or both) every data area sector.
 
Mmmh, so it keeps track of how much of my block device is used by
filesystem blocks and skips the rest? I didn't know that.

> Sectors that haven't ever been deliberately written and aren't read by
> normal mdadm processes are often the first to pop up in disk
> self-diagnostics.  If you look at the sector offsets in the SMART data,
> I bet you find they're all outside the area mdadm is using.

Got it.

> > Whereas badblocks forced an unconditional rewrite of all blocks, and forced
> > the drive to re-allocate those "weak" blocks, even though it was able to
> > read them.
> 
> Probably not.  It got 'em because it wasn't limited to the data area.

Right, I understand now, good to know.
So I'll use badblocks next time I have this issue.

Thanks for clearing this up for me.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
