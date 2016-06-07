From: Marc MERLIN <marc@merlins.org>
Subject: Re: Raid check didn't fix Current_Pending_Sector, but badblocks -nsv
 did
Date: Tue, 7 Jun 2016 07:04:56 -0700
Message-ID: <20160607140456.GM12382@merlins.org>
References: <20160607135731.GA12550@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160607135731.GA12550@metamorpher.de>
 <5756C67A.2040109@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Sarah Newman <srn@prgmr.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 07, 2016 at 09:04:58AM -0400, Phil Turmel wrote:
> No, it doesn't keep track of anything the filesystem does.  Look at the
> mdadm -E report for one of you member devices -- it shows the location
> of the superblock, the start location and size of the data area, and
> possibly information about the optional bitmap or bad block table.
> Areas outside the data area are not touched by check or repair scrubs.
 
Ok, that makes more sense. In my case, the md array is the entire drive,
minus partition and boot sector header, which is why I expected scanning
that would be good enough.
But as been pointed out already, it's very possible that the bad
sectors happened either on the parity drive that didn't get scanned, or
the unused space before the md array data actually starts on the drive.

> Or just ignore them.  You aren't using them, so they can't hurt you.
> However, do look at the sector numbers in the SMART reports to make sure
> they aren't in the data area.  (If you aren't using the whole disk for

The smart scan log for that drive didn't seem to show where said bad
sectores were (smartctl -a, log at the end). Either way, now they've
been remapped, so it's fine.

On Tue, Jun 07, 2016 at 03:57:31PM +0200, Andreas Klauer wrote:
> On Mon, Jun 06, 2016 at 10:41:13AM -0700, Marc MERLIN wrote:
> > Howdy, I have a raid 5 where one drive reported this:
> > 197 Current_Pending_Sector  0x0032   200   199   000    Old_age   Always -       29
> 
> RAID survival depends on healthy drives. This one does not look healthy. 
> If the data on your RAID is important, I'd replace this drive. Getting 
> this count back down to zero doesn't make it any more trustworthy.

Yeah, I hear what you're saying here. I usually do this actually. If
this drive grows another single bad sector, I will do this, but at this
time the hassle fo replacing the drive is not worth it yet.
The array is also used to hold offsite backups of backups of personal
data (not work stuff)

Thanks for the replies.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
