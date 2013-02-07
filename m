From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: RAID performance
Date: Thu, 7 Feb 2013 04:07:03 -0500
Message-ID: <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com>
References: <51134E43.7090508@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51134E43.7090508@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 7, 2013 at 1:48 AM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
> Hi all,
>
> I'm trying to resolve a significant performance issue (not arbitrary dd
> tests, etc but real users complaining, real workload performance).
>
> I'm currently using 5 x 480GB SSD's in a RAID5 as follows:
> md1 : active raid5 sdf1[0] sdc1[4] sdb1[5] sdd1[3] sde1[1]
>       1863535104 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5]
> [UUUUU]
>       bitmap: 4/4 pages [16KB], 65536KB chunk
>
> Each drive only has a single partition, and is partitioned a little
> smaller than the drive (supposedly this should improve performance).
> Each drive is set to the deadline scheduler.
>
> Drives are:
> Intel 520s MLC 480G SATA3
> Supposedly Read 550M/Write 520M
>
> I think the workload being generated is simply too much for the
> underlying drives. I've been collecting the information from
> /sys/block/<drive>/stat every 10 seconds for each drive. What makes me
> think the drives are overworked is that the backlog value gets very high
> at the same time the users complain about performance.
>
> The load is a bunch of windows VM's, which were working fine until
> recently when I migrated the main fileserver/domain controller on
> (previously it was a single SCSI Ultra320 disk on a standalone machine).
> Hence, this also seems to indicate a lack of performance.
>
> Currently the SSD's are connected to the onboard SATA ports (only SATA II):
> 00:1f.2 SATA controller: Intel Corporation Cougar Point 6 port SATA AHCI
> Controller (rev 05)

Why would you plug thousands of dollars of SSD into an onboard
controller? It's probably running off a 1x PCIE shared with every
other onboard device. An LSI 8x 8 port HBA will run you a few
hundred(less than 1 SSD) and let you melt your northbridge. At least
on my Supermicro X8DTL boards I had to add active cooling to it or it
would overheat and crash at sustained IO. I can hit 2 - 2.5GB a second
doing large sequential IO with Samsung 840 Pros on a RAID10.

>
> There is one additional SSD which is just the OS drive also connected,
> but it is mostly idle (all it does is log the stats/etc).
>
> Assuming the issue is underlying hardware, then I'm thinking to do the
> following:
> 1) Get a battery backed RAID controller card (which should improve
> latency because the OS can pretend it is written while the card deals
> with writing it to disk).

As another person mentioned hardware raid is terrible for SSD. SSDs
are optimized to use the large RAM cache they have onboard. Most
hardware RAID controllers will disable it.

> 2) Move from a 5 disk RAID5 to a 8 disk RAID10, giving better data
> protection (can lose up to four drives) and hopefully better performance
> (main concern right now), and same capacity as current.

I've had strange issues with anything other than RAID1 or 10 with SSD.
Even with the high IO and IOP rates of SSDs the parity calcs and extra
writes still seem to penalize you greatly.

Also if your kernel does not have md TRIM support you risk taking a
SEVERE performance hit on writes. Once you complete a full write pass
on your NAND the SSD controller will require extra time to complete a
write. if your IO is mostly small and random this can cause your NAND
to become fragmented. If the fragmentation becomes bad enough you'll
be lucky to get 1 spinning disk worth of write IO out of all 5
combined.

-- 
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
