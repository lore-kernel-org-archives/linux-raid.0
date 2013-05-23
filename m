From: keld@keldix.com
Subject: Re: "Missing" RAID devices
Date: Thu, 23 May 2013 10:30:32 +0200
Message-ID: <20130523083032.GA2579@www5.open-std.org>
References: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com> <519B9351.4050708@turmel.org> <CAGPLN=uiUD3wnwt6DfELaLh+yqxkbrA=KetPiQHZrqq4FrS=HA@mail.gmail.com> <519C0B13.3040906@turmel.org> <519D4A15.7020107@hardwarefreak.com> <519D541B.1090508@turmel.org> <519DB04B.5030505@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <519DB04B.5030505@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Phil Turmel <philip@turmel.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, May 23, 2013 at 12:59:39AM -0500, Stan Hoeppner wrote:
> On 5/22/2013 6:26 PM, Phil Turmel wrote:
> > On 05/22/2013 06:43 PM, Stan Hoeppner wrote:
> >> Sorry for the dup Phil, hit the wrong reply button.
> > 
> > No worries.
> > 
> >> On 5/21/2013 7:02 PM, Phil Turmel wrote:
> >> ...
> >>> ...First is /dev/md1, a small (~500m) n-way
> >>> ...as /boot.  The other, /dev/md2, uses
> >>> ...raid10,far3 or raid6.
> >>>
> >>> I put LVM on top of /dev/md2, with LVs for swap, ... /tmp
> >>
> >> Swap and tmp atop an LV atop RAID6?  The former will always RMW on page
> >> writes, the latter quite often will cause RMW.  As you stated your
> >> performance requirements are modest.  However, for the archives, putting
> >> swap on a parity array, let alone a double parity array, is not good
> >> practice.
> > 
> > Ah, good point.  Hasn't hurt me yet, but it would if I pushed anything
> > hard.  I'll have to revise my baseline to always have a small raid10,f3
> > to go with the raid6.
> 
> Yeah, the kicker here is that swap on a parity array seems to work fine,
> right up until the moment it doesn't.  And that's when the kernel goes
> into heavy swapping due to any number of causes.  When that happens,
> you're heavily into RMW, disk heads are bang'n, latency goes through the
> roof.  If any programs are trying to access files on the parity array,
> say a mildly busy IMAP, FTP, etc, server, everything grinds to a halt.
> 
> With your particular setup, instead you might use n additional
> partitions, one each across the physical disks that comprise your n-way
> RAID1.  You would configure the partition type of each as (82) Linux
> swap, and add them all to fstab with equal priority.  The kernel will
> interleave the 4KB swap page writes evenly across all of these
> partitions, yielding swap performance similar to an n-way RAID0 stripe.
> 
> The downside to this setup is the kernel probably crashes if you lose
> one of these disks and thus the swap partition on it.  So you could
> simply make another md/RAID1 of these n partitions if n is an odd number
> of spindles.  Or n/2 RAID1 arrays if n is even.  Then put one swap
> partition on each RAID1 device and do swap interleaving across the RAID1
> pairs as described above in the non RAID case.
> 
> The reason for this last configuration is simple-- more swap throughput
> for the same number of physical writes.  With a 4 drive RAID1 and a
> single swap partition atop, each 4KB page write to swap generates a 4KB
> write to each of the 4 disks, 16KB total.  If you create two RAID1s and
> put a swap partition on each and interleave them, each 4KB page write to
> swap generates only two 4KB writes, 8KB total.  Here for each 16KB
> written you're moving two pages to swap instead of one.  Thus your swap
> bandwidth is doubled.  But you still have redundancy and crash avoidance
> if one disk fails.  You may be tempted to use md/RAID10 of some layout
> to optimize for writes, but you'd gain nothing, and you'd lose some
> performance due to overhead.  The partitions you'll be using in this
> case are so small that they easily fit in a single physical disk track,
> thus no head movement is required to seek between sectors, only rotation
> of the platter.
> 
> Another advantage to this hybrid approach is less disk space consumed.
> If you need 8GB of swap, a 4-way RAID1 swap partition requires 32GB of
> disk space, 8GB per disk.  With the n/2 RAID1 approach and 4 disks it
> requires half that, 16GB.  With the no redundancy interleaved approach
> it requires 1/4th, only 2GB per disk, 8GB total.  With today's
> mechanical disk capacities this isn't a concern.  But if using SSDs it
> can be.
> 
> > Meanwhile, I'm applying some of the general ideas I've seen from you:
> > I've acquired a pair of Crucial M4 SSDs for my new home media server to
> > keep small files and databases away from the bulk storage.  Not in
> > service yet, but I'm very pleased so far.
> 
> If the two are competing for seeks thus slowing everything down, moving
> the random access stuff to SSD should help.
> 
> > I'm pretty sure the new kit is way overkill for a media server... :-)
> 
> Not so many years ago folks would have said the same about 4TB mech
> drives. ;)

I think a raid10,far3 is a good choice for swap, then you will enjoy
RAID0-like reading speed. and good write speed (compared to raid6),
and a chance of live surviving if just one drive keeps functioning.

best regards
keld
