From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance
Date: Thu, 07 Feb 2013 02:11:31 -0600
Message-ID: <511361B3.8060204@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51134E43.7090508@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/7/2013 12:48 AM, Adam Goryachev wrote:

> I'm trying to resolve a significant performance issue (not arbitrary dd
> tests, etc but real users complaining, real workload performance).

It's difficult to analyze your situation without even a basic
description of the workload(s).  What is the file access pattern?  What
types of files?

> I'm currently using 5 x 480GB SSD's in a RAID5 as follows:
> md1 : active raid5 sdf1[0] sdc1[4] sdb1[5] sdd1[3] sde1[1]
>       1863535104 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5]
...
> Each drive is set to the deadline scheduler.

Switching to noop may help a little, as may disablig NCQ, i.e. putting
the driver in native IDE mode, or setting queue depth to 1.

> Drives are:
> Intel 520s MLC 480G SATA3
> Supposedly Read 550M/Write 520M

> I think the workload being generated is simply too much for the
> underlying drives. 

Not possible.  With an effective spindle width of 4, these SSDs can do
~80K random read/write IOPS sustained.  To put that into perspective,
you would need a ~$150,000 high end FC SAN array controller with 270 15K
SAS drives in RAID0 to get the same IOPS.

The problem is not the SSDs.  Probably not the controller either.

> I've been collecting the information from
> /sys/block/<drive>/stat every 10 seconds for each drive. What makes me
> think the drives are overworked is that the backlog value gets very high
> at the same time the users complain about performance.

What is "very high"?  Since you mention "backlog" I'll assume you're
referring to field #11.  If so, note that on my idle server (field #9 is
0), it is currently showing 434045280 for field #11.  That's apparently
a weighted value of milliseconds.  And apparently it's not reliable as a
diagnostic value.

What you should be looking at is field #9, which simply tells you how
may IOs are in progress.  But even if this number is high, which it can
be be very high with SSDs, it doesn't inform you if the drive is
performing properly or not.  What you should be using is ioptop or
something similar.  But this still isn't going to be all that informative.

> The load is a bunch of windows VM's, which were working fine until
> recently when I migrated the main fileserver/domain controller on
> (previously it was a single SCSI Ultra320 disk on a standalone machine).
> Hence, this also seems to indicate a lack of performance.

You just typed 4 lines and told us nothing of how this relates to the
problem you wish us to help you solve.  Please be detailed.

> Currently the SSD's are connected to the onboard SATA ports (only SATA II):
> 00:1f.2 SATA controller: Intel Corporation Cougar Point 6 port SATA AHCI
> Controller (rev 05)

Unless this Southbridge has a bug (I don't have time to research it),
then this isn't the problem.

> There is one additional SSD which is just the OS drive also connected,
> but it is mostly idle (all it does is log the stats/etc).

Irrelevant.

> Assuming the issue is underlying hardware

It's not.

> 1) Get a battery backed RAID controller card (which should improve
> latency because the OS can pretend it is written while the card deals
> with writing it to disk).

[BB/FB]WC is basically useless with SSDs.  LSI has the best boards, and
the "FastPath" option for SSDs basically disables the onboard cache to
get it out of the way.  Enterprise SSDs have extra capacitance allowing
for cache flushing on power loss so battery/flash protection on the RAID
card isn't necessary.  The write cache on the SSDs themselves is faster
in aggregate than the RAID card's ASIC and cache RAM interface, thus
having BBWC on the card enabled with SSDs actually slows you down.

So, in short, this isn't the answer to your problem, either.

> 2) Move from a 5 disk RAID5 to a 8 disk RAID10, giving better data
> protection (can lose up to four drives) and hopefully better performance
> (main concern right now), and same capacity as current.

You've got plenty of hardware performance.  Moving to RAID10 will simply
cost more money with no performance gain.  Here's why:

md/RAIAD5 and md/RAID10 both rely on a single write thread.  If you've
been paying attention on this list you know that patches are in the
works to fix this but are not, AFAIK, in mainline yet, and a long way
from being in distro kernels.  So, you've got maximum possible read
performance now, but your *write performance is limited to a single CPU
core* with both of these RAID drives.  If your problem is write
performance, your only solution at this time with md is to use a layered
RAID, such as RAID0 over RAID1 pairs, or linear over RAID1 pairs.  This
puts all of your cores in play for writes.

The reason this is an issue is that even a small number of SSDs can
overwhelm a single md thread, which is limited to one core of
throughput.  This has also been discussed thoroughly here recently.

> The real questions are:
> 1) Is this data enough to say that the performance issue is due to
> underlying hardware as opposed to a mis-configuration?

No, it's not.  We really need to have more specific workload data.

> 2) If so, any suggestions on specific hardware which would help?

It's not a hardware problem.  Given that it's a VM consolidation host,
I'd guess it's a hypervisor configuration problem.

> 3) Would removing the bitmap make an improvement to the performance?

I can't say this any more emphatically.  You have 5 of Intel's best
consumer SSDs and an Intel mainboard.  The problem is not your hardware.

> Motherboard is Intel S1200BTLR Serverboard - 6xSATAII / Raid 0,1,10,5
> 
> It is possibly to wipe the array and re-create that would help.......

Unless you're write IOPS starved due to md/RAID5 as I described above,
blowing away the array and creating a new one isn't going to help.  You
simply need to investigate further.

And if you would like continued assistance, you'd need to provide much
greater detail of the hardware and workload.  You didn't mention your
CPU(s) model/freq.  This matters greatly with RAID5 and SSD.  Nor RAM
type/capacity, network topology, nor number of users and what
applications they're running when they report the performance problem.
Nor did you mention which hypervisor kernel/distro you're using, how
many Windows VMs you're running, and the primary workload of each, etc,
etc, etc.

> Any comments, suggestions, advice greatly received.

More information, please.

-- 
Stan

