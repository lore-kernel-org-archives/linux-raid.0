From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid5 won't resync
Date: Tue, 31 Aug 2004 18:37:18 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408312237.i7VMbN311819@watkins-home.com>
References: <Pine.LNX.4.58.0408311714440.1949@web1.mmaero.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0408311714440.1949@web1.mmaero.com>
To: 'Jon Lewis' <jlewis@lewis.org>
Cc: linux-raid@vger.kernel.org, aaron@america.com
List-Id: linux-raid.ids

You have 2 failed drives?
RAID5 only supports 1 failed drive.

Have you tested the drives to determine if they are good?
Example:
dd if=/dev/sdf of=/dev/null bs=64k

If you can find enough good drives, use the force option on assemble.
But don't include any disks that don't have 100% of the data.
A spare that did a partial re-build is not good to use at this point.

So, if your array had 10 disks, you need to find 9 of them that are still
working.

Guy

-----Original Message-----
From: Jon Lewis [mailto:jlewis@lewis.org] 
Sent: Tuesday, August 31, 2004 5:27 PM
To: Guy
Cc: linux-raid@vger.kernel.org; aaron@america.com
Subject: RE: raid5 won't resync

On Tue, 31 Aug 2004, Guy wrote:

> I think what you did should work, but...
> I have had similar problems.
> Try again, but this time don't include any spare disks, or any other
disks.
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

