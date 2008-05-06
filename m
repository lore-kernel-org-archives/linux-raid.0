From: Marc MERLIN <marc_news@merlins.org>
Subject: how to recreate a raid5 array with n-1 drives?
Date: Mon, 5 May 2008 22:48:19 -0700
Message-ID: <20080506054819.GA6413@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Howdy,

I had a 5 drive raid5 array that went down due to the a double disk failure.
Both drives aren't dead, but I seem to have picked the wrong drive as the
'good' one.
When I brought the array back up with
mdadm --assemble --run --force /dev/md5 /dev/sd{c,d,f,g}
and then started a rebuild with:
mdadm /dev/md5 -a /dev/sdd1

I'm getting failures when a certain block from sde1 is read.

Before I forget:
There isn't a way to tell the raid subsystem not to kill a degraded array if
it finds a single disk failure (bad block) and not an entire bad drive, is
it?  (if not, I'd love that added to the wishlist if it isn't there yet).

Assuming there isn't, I did start a rebuild on sdd1 (the old drive), which
should have been rewritting the same blocks back onto themselves.

So, I'd like to bring the array back up with sdd1 instead of sde1.
Of course, I can't do that with assemble now that I've done a partial rebuild
on sdd1.

I thought I could recreate a n-1 array like so:
gargamel:~# mdadm --create /dev/md5 --level=5 --chunk=64 --layout=left-symmetric  --raid-devices=5  /dev/sd{c,d,f,g}1
mdadm: You haven't given enough devices (real or missing) to create this array

In the olden days (pre-mdadm), I could bring up the array by giving 5 drives
and marking /dev/sde1 as failed-disk instead of read-disk (or somesuch).

I could not find a way to do this with mdadm in the man page. How do I give
/dev/sde1 on the command line as a failed drive?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems & security ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
