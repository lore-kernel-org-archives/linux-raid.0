From: Phil Turmel <philip@turmel.org>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Fri, 9 Feb 2018 15:13:26 -0500
Message-ID: <1227ce39-31af-22f2-f4fa-de85466f05c7@turmel.org>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org>
 <aedfc1ac-a95f-b20f-2713-87cf412afdf4@uni-konstanz.de>
 <20180209192928.vliiwkv6q76jf6jp@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180209192928.vliiwkv6q76jf6jp@merlins.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, Kay Diederichs <kay.diederichs@uni-konstanz.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Marc,

On 02/09/2018 02:29 PM, Marc MERLIN wrote:

> But, I'm confused by what happened. The md check ran to completion.
> It found things and supposedly fixed them:
> [240351.053406] md/raid:md7: read error corrected (8 sectors at
> 9159374528 on sdf1)

> Strangely, it did nothing with this:
> [287271.959779] sd 4:4:0:0: [sdh] tag#6 Add. Sense: Unrecovered read
> error - auto reallocate failed

> Now, the sync is comnplete, and my bad blocks are still there?
> myth:~# smartctl -A /dev/sdh
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       2
> 
> myth:~# smartctl -A /dev/sdf
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       7
> 

> The pending sectors should have been re-written and become
> Reallocated_Event_Count, no?

Yes, and not necessarily.  Pending sectors can be non-permanent errors
-- the drive firmware will test a pending sector immediately after write
to see if the write is readable.  If not, it will re-allocate while it
still has the write data in its buffers.  Otherwise, it'll clear the
pending sector.

> So, mdadm is happy allegedly, but my drives still have the same bad
> sectors they had (more or less).

If you have bad block lists enabled in your array, MD will *never* try
to fix the underlying sectors.  Please show your mdadm -E reports for
these devices.  If necessary, stop the array and re-assemble with the
options to disable bad block lists.  { How this misfeature got into the
kernel and enabled by default baffles me. }

Also, pending sectors that are in dead zones between metadata and array
data will not be accessed by a check scrub, and will therefore persist.

> Yes, I know I should trash (return) those drives,

Well, non-permanent read errors are not considered warranty failures.
They are in the drive specs.  When pending is zero and actual
re-allocations are climbing (my threshold is double digits), *then* it's
time to replace.

> but I still want to understand why I can't get basic block remapping
> working Any idea what went wrong?

Invalid expectations, perhaps.

Phil

