From: Jon Lewis <jlewis@lewis.org>
Subject: RE: raid5 won't resync
Date: Tue, 31 Aug 2004 17:27:14 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408311714440.1949@web1.mmaero.com>
References: <200408312040.i7VKeG311366@watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408312040.i7VKeG311366@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org, aaron@america.com
List-Id: linux-raid.ids

On Tue, 31 Aug 2004, Guy wrote:

> I think what you did should work, but...
> I have had similar problems.
> Try again, but this time don't include any spare disks, or any other disks.
> Only include the disks you know have the data.
> Or, just list the disks on the command line.

# mdadm --assemble /dev/md2 /dev/sdc1 /dev/sdm1 /dev/sdf1 /dev/sde1
/dev/sdd1 /dev/sdg1 /dev/sdk1 /dev/sdj1 /dev/sdi1
mdadm: /dev/md2 assembled from 4 drives and 1 spare - not enough to start
the array.

I've left sdl1 and sdn1 out of the above as they're the failed drive and
the partially rebuilt spare.

I see a pattern that could explain why mdadm thinks there are only 4
drives.  From mdadm -E on each drive:

sdc1:    Update Time : Tue Aug 31 03:47:27 2004
sdd1:    Update Time : Tue Aug 31 03:47:27 2004
sde1:    Update Time : Tue Aug 31 03:47:27 2004
sdf1:    Update Time : Tue Aug 31 03:47:27 2004
sdg1:    Update Time : Mon Aug 30 22:42:36 2004
sdi1:    Update Time : Mon Aug 30 22:42:36 2004
sdj1:    Update Time : Mon Aug 30 22:42:36 2004
sdk1:    Update Time : Mon Aug 30 22:42:36 2004
sdl1:    Update Time : Tue Jul 13 02:08:37 2004
sdm1:    Update Time : Mon Aug 30 22:42:36 2004
sdn1:    Update Time : Mon Aug 30 22:42:36 2004

Is mdadm --assemble seeing that 4 drives have a more recent Update Time
than the rest and ignoring the rest?

----------------------------------------------------------------------
 Jon Lewis                   |  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
