From: Phil Turmel <philip@turmel.org>
Subject: Re: recovering RAID5 from multiple disk failures
Date: Fri, 01 Feb 2013 08:21:55 -0500
Message-ID: <510BC173.7070002@turmel.org>
References: <kegcd6$6dl$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <kegcd6$6dl$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Ritzert <ksciplot@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Michael,

On 02/01/2013 07:28 AM, Michael Ritzert wrote:
> Hi all,
> 
> this looks bad:
> I have a RAID5 that showed a disk error. The disk failed badly with read
> errors. Apparantly, these happen to be at locations important to the file
> system, as the RAID read speed was some kb/s with permanent timeouts
> reading from the disk.
> So I removed the disk from the RAID, to be able to take a backup. The
> backup ran well for one directory, and then completely stopped. It turned
> out another disk also suddenly showed read errors.
> 
> So the situation is: I have a four-disk RAID5 with two active disks, and
> two that dropped out at different times.

Please show the errors from dmesg.

And show "smartctl -x" for the drives that failed.

> I made 1:1 copies of all 4 disks with ddrescue, and the error report shows
> that the errorneous regions do not overlap. So I hope there is a chance to
> recover the data.

Very good.

> But for the filesystem mount, there were only read accesses to the array
> after the first disk dropped out. So my strategy would be to convince md
> to accept all disks as uptodate and treat the read errors on two disks,
> and the differing filesystem metadata as RAID errors that can hopefully
> be corrected.
> 
> The mdadm report for one of the disks looks like this:
> /dev/sdb3:
>           Magic : a92b4efc
>         Version : 0.90.00
>            UUID : f5ad617a:14ccd4b1:3d7a38e4:71465fe8
>   Creation Time : Fri Nov 26 19:58:40 2010
>      Raid Level : raid5
>   Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
>      Array Size : 5855836800 (5584.56 GiB 5996.38 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 0
> 
>     Update Time : Fri Jan  4 16:33:36 2013
>           State : clean
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 74966e68 - correct
>          Events : 237
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>       Number   Major   Minor   RaidDevice State
> this     3       8       51        3      active sync
> 
>    0     0       0        0        0      removed
>    1     1       8       19        1      active sync   /dev/sdb3
>    2     2       0        0        2      faulty removed
>    3     3       8       51        3      active sync

Also show "mdadm -E" for all of the member devices.  This data is an
absolute *must* before any major surgery on an array.

> My first attempt would be to try
> mdadm --create --metadata=0.9 --chunk=64 --assume-clean, etc.
> 
> Is there a chance for this to succeed? Or do you have better suggestions?

"--create" is a *terrible* first step.  "mdadm --assemble --force" is
the right tool for this job.

> If all recovery that involves assembling the array fails: Is is possible
> to manually assemble the data?
> I'm thinking in the direction of: take the first 64k from disk1, then 64k
> from disk2, etc.? This would probably take years to complete, but the data
> is of really big importance to me (which is why I put it on a RAID in the
> first place...).

Your scenario sounds like the common timeout mismatch catastrophe, which
is why I asked for "smartctl -x".  If that is the case, MD won't be able
to do the reconstructions that it should when encounting read errors.

Also, you have a poor understanding of MD's use--it is *not* a backup
alternative.  It is a tool for maximizing *uptime*.  It will keep you
running through the normal random failures that complex
electro-mechanical systems experience.

MD won't save your data from accidental deletion or other operator
error.  It won't save your data from a lightning strike.  It won't save
your data from a home or office fire.  You still need to make backups.

Phil
