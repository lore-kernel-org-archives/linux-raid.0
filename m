From: John Lange <john.lange@bighostbox.com>
Subject: RE: Please review: Slackware RAID How-To
Date: Thu, 20 May 2004 02:58:56 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1085039936.10231.74.camel@localhost>
References: <200405200502.i4K52rB18138@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200405200502.i4K52rB18138@www.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hey Guy. Thanks very much for your research.

Since we couldn't seem to come up with a definitive answer I decided to
resort to some tests. I have a little RAID 5 array comprised of 3 8G
SCSI disks in a old Dell PowerEdge (same box mentioned in the How-To).

Just for reference here is it's raidtab:

raiddev /dev/md0
raid-level      5
nr-raid-disks   3
nr-spare-disks  0
chunk-size      32
persistent-superblock 1
parity-algorithm        left-symmetric
device          /dev/sdb1
raid-disk       0
device          /dev/sdc1
raid-disk       1
device          /dev/sdd1
raid-disk       2

I used mke2fs to format the drive in 3 different ways with variable
stride settings then ran bonnie++ on it.

The settings were:

stride=64
stride=4
stride=512

The first two are based on the different formulas we discussed. I tried
512 just because I thought I'd do something a bit crazy to see if it
made any difference.

The results in bonnie++ were almost statistically identical in every
case. The only difference in performance was a 20% drop in random seeks
when stride=512 but the rest of the performance indicators were almost
identical. I repeated the test to make sure it wasn't a blip.

So the bottom line is; for me, neither chunk-size OR stride makes any
difference to performance.

John Lange

On Thu, 2004-05-20 at 00:02, Guy wrote:
> More info!
> 
> I found this comment in another group.  It would indicate "stripe size"
> should be used.  But it should not make a difference.
> 
> Guy
> 
> =======================================================================
> The stride option places the inode and block bitmaps so that successive
> block groups' bitmaps are on a different RAID stripes.  I suppose this
> might improve disk I/O performance, as the bitmaps are the most heavily 
> used blocks on the disk.  However, the cache should prevent most of the
> I/O in the first place...
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of John Lange
> Sent: Wednesday, May 19, 2004 11:34 PM
> To: office@ninti.com.au
> Cc: LinuxRaid
> Subject: RE: Please review: Slackware RAID How-To
> 
> No, stride is not needed for RAID 1 as stride is about striping and RAID
> 1 does not do striping, it does mirroring.
> 
> According to man raidtab, chunk-size "Sets the stripe size to size
> kilobytes.". So unless I'm completely off my rocker, chunk-size is also
> not needed for RAID 1 as it also only applies to striping.
> 
> Thanks for pointing that out. I have removed it from my HowTo.
> 
> I believe this error is also in the Software RAID HowTo which is where I
> copied my examples from.
> 
> Regards,

