From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid check didn't fix Current_Pending_Sector, but badblocks -nsv
 did
Date: Mon, 6 Jun 2016 20:54:16 -0400
Message-ID: <57561B38.1070402@turmel.org>
References: <20160606174113.GI12382@merlins.org> <5755CA9F.6090807@prgmr.com>
 <20160606224401.GA6672@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160606224401.GA6672@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, Sarah Newman <srn@prgmr.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/06/2016 06:44 PM, Marc MERLIN wrote:

> From what I understand, the only difference between the 2 is that repair
> does not use the write-intent bitmap, but both will repair an error if
> found.

Repair doesn't even read the parity (and Q syndrome) blocks if it
doesn't need them.  It unconditionally recomputes and writes parity (and
Q) blocks.

Both processes will compute and rewrite a block that reports a read error.

> https://www.thomas-krenn.com/en/wiki/Mdadm_checkarray#Check_vs._Repair
> 
> Or are you saying that check after getting a read error from one drive,
> would not rewrite the bad block on that drive? I thought it did...

They both do.

> Either way, it seems that neither would have worked because while those
> blocks were marked as "need to be reallocated" by the drive, I think the
> kernel was actually able to read them without problem, so the md layer never
> saw anything and therefore never did anything either.

Both processes only apply to the actual data area of each member device,
which is usually substantially less than the whole disk.  Both processes
will read or write (or both) every data area sector.

Sectors that haven't ever been deliberately written and aren't read by
normal mdadm processes are often the first to pop up in disk
self-diagnostics.  If you look at the sector offsets in the SMART data,
I bet you find they're all outside the area mdadm is using.

Magnetism does slowly decay on drive platters, faster in the spots where
manufacturing didn't maintain the intended oxide thickness.  Completely
normal and is the basis for URE specifications.

> Whereas badblocks forced an unconditional rewrite of all blocks, and forced
> the drive to re-allocate those "weak" blocks, even though it was able to
> read them.

Probably not.  It got 'em because it wasn't limited to the data area.

Phil
