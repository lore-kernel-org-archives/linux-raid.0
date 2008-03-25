From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: component growing in raid5
Date: Tue, 25 Mar 2008 14:38:47 +0100 (MET)
Message-ID: <Pine.GSO.4.64.0803251412000.15900@montezuma.acc.umu.se>
References: <47E5FFB8.5030903@bteam.hu> <47E753C4.7030903@rabbit.us>
 <47E7C609.9000501@bteam.hu> <18408.63715.481333.26215@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18408.63715.481333.26215@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 25 Mar 2008, Peter Grandi wrote:

>  * Single volume filesystems larger than 1-2TB require something
>    like JFS or XFS (or Reiser4 or 'ext4' for the brave). Larger
>    than 5-10TB is not entirely feasible with any filesystem
>    currently known (just think 'fsck' times) even if the ZFS
>    people glibly say otherwise (no 'fsck' ever!).

The ZFS people provide an fsck, it's called "resilver", which checks 
parity and checksums and update accordingly.

>  * Single RAID volumes up to say 10-20TB are currently feasible,
>    say as 24x(1+1)x1TB (for example with Thumpers). Beyond that
>    I would not even try, and even that is a bit crazy. I don't
>    think that one should put more than 10-15 drives at most in
>    a single RAID volume, even a RAID10 ones.

I'd agree, a 12-14 disk raid6 is as high that I'd like to go. This is 
mostly limited by rebuild-times though, you'd preferably stay within a day 
or two of single-parity "risk".

>  * Large storage pools can only be reasonably built by using
>    multiple volumes across networks and on top of those some
>    network/cluster file system, and it matters a bit whether
>    single filesystem image is essential or not.

Or for that matter an application that can handle multiple storage pools, 
many of the software that needs really large-scale storage can itself 
split data store between multiple locations. That way you can have 
resonably small filesystems and stay sane.

>  * RAID5 (but not RAID6 or other mad arrangements) may be used if
>    almost all accesses are reads, the data carries end-to-end
>    checksums, and there are backups-of-record for restoring the
>    data quickly, and then each array is not larger than say 4+1.
>    In other words if RAID5 is used as a mostly RO frontend, for
>    example to a large slow tape archive (thanks to R. Petkus for
>    persuading me that there is this exception).

Funny, my suggestion would definately be raid6 for anything except 
database(-like) load, that is anything that doesn't ends up as lots of 
small updates. My normal usecase is to store large files and having 60% 
more disks really costs alot in both purchase and power for the same 
usable space.

Of course, we'd be more likely to go for a good hardware raid6 controller 
that utilises the extra parity to make a good guess on what data is wrong 
in the case of silent data corruption on a single disk (unlike Linux 
software raid). Unless, of course, you can run ZFS which has proper 
checksumming so you can know which (if any) data is still good.

> A couple of relevant papers for inspiration on best practices by
> those that have to deal with this stuff:
>
>  https://indico.desy.de/contributionDisplay.py?contribId=26&sessionId=40&confId=257
>  http://indico.fnal.gov/contributionDisplay.py?contribId=43&amp;sessionId=30&amp;confId=805

And this is my usecase. It might be quite different from, say, database 
storage or home directories.

/Mattias Wadenstein
