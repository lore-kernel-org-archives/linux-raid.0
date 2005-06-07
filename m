From: Mike Hardy <mhardy@h3c.com>
Subject: Re: entire array lost when some blocks unreadable?
Date: Tue, 07 Jun 2005 14:21:30 -0700
Message-ID: <42A60FDA.5080402@h3c.com>
References: <42A60A1A.9030302@gmx.ch> <42A60D5F.2060407@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42A60D5F.2060407@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Tom Eicher <tom.eicher@gmx.ch>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Brad Campbell wrote:

> Join the long line next to the club trophy cabinet :)

Its a shame the line is this long - I wish I had the time to implement
the solution myself, but not having that I can't really whine either.
Its still a shame though. Alas.

> Something along those lines.
> Generally if I get an error notification from smartd I pull the drive
> from the array and re-add it. This causes a rewrite of the entire disk
> and everyone is happy. (Unless the drive is dying, in which case the
> rewrite of the entire disk usually finishes it off nicely)

When I get one of those, the first thing I do is verify my backup :-).
The backup is a second array that's on the network, so I typically
remount it read-only at that point.

Then I start drive scans on all drives (primary and backup) to see if
I've got any other blocks that will stop reconstruction. If I find any
other bad blocks on other devices, I immediately remount the primary as
read-only to preserve the data (if its not already gone) on all of the
disks. Note my disks almost never get written to, so this actually does
preserve the old data everywhere in all the cases I care about.

After that, a fail and re-add has done the trick for me in the past, but
once I actually got remapped into a bad block. Very annoying. Since
then, I fail the disk and do multiple badblocks passes on it.

Being able to enable an "aggressively correct" raid mode where any
single-block read error triggered a reconstruct/write/re-read cycle
until either it worked or failed would be nice. Bonus points for extra
md status markers that mdadm could pick up and mail to folks depending
on policy configuration.

-Mike
