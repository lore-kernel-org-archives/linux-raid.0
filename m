From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid check didn't fix Current_Pending_Sector, but badblocks -nsv
 did
Date: Tue, 7 Jun 2016 09:04:58 -0400
Message-ID: <5756C67A.2040109@turmel.org>
References: <20160606174113.GI12382@merlins.org> <5755CA9F.6090807@prgmr.com>
 <20160606224401.GA6672@merlins.org> <57561B38.1070402@turmel.org>
 <20160607045122.GL12382@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160607045122.GL12382@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Sarah Newman <srn@prgmr.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/07/2016 12:51 AM, Marc MERLIN wrote:
> On Mon, Jun 06, 2016 at 08:54:16PM -0400, Phil Turmel wrote:

>> Both processes only apply to the actual data area of each member device,
>> which is usually substantially less than the whole disk.  Both processes
>> will read or write (or both) every data area sector.
>  
> Mmmh, so it keeps track of how much of my block device is used by
> filesystem blocks and skips the rest? I didn't know that.

No, it doesn't keep track of anything the filesystem does.  Look at the
mdadm -E report for one of you member devices -- it shows the location
of the superblock, the start location and size of the data area, and
possibly information about the optional bitmap or bad block table.
Areas outside the data area are not touched by check or repair scrubs.

> Right, I understand now, good to know.
> So I'll use badblocks next time I have this issue.

Or just ignore them.  You aren't using them, so they can't hurt you.
However, do look at the sector numbers in the SMART reports to make sure
they aren't in the data area.  (If you aren't using the whole disk for
mdadm, be sure to adjust for the partition start sector.)  If they *are*
in the data area, watch dmesg while scrubbing to see what's really
happening.

Phil
