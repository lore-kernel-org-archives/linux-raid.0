From: <pg_mh@mh.to.sabi.co.UK>
Subject: Re: How do I tell which disk failed?
Date: Tue, 8 Jan 2013 21:24:14 +0000
Message-ID: <20716.36478.963423.179073@tree.ty.sabi.co.uk>
References: <1357610701.16366.13.camel@corn.betterworld.us>
	<alpine.DEB.2.00.1301081054520.26235@uplift.swm.pp.se>
	<1357665605.16366.161.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
From: pg@lxra2.for.sabi.co.uk (Peter Grandi)
In-Reply-To: <1357665605.16366.161.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>>> Personalities : [raid1]
>>> md0 : active raid1 sda1[0] sdc2[2] sdb2[1]
>>>      96256 blocks [3/3] [UUU]
>>>
>>> md1 : active raid1 sda3[0] sdc4[2] sdb4[1]
>>>      730523648 blocks [3/3] [UUU]
>>>      [>....................]  resync =  0.4% (3382400/730523648) finish=14164.9min speed=855K/sec

>>> I see my array is reconstructing, but I can't tell which
>>> disk failed. [ ... ] The system is currently sluggish and
>>> the load is 13 [ ... ]

If your kernel is one that puts IO wait in the load average
that's expected if there is heavy IO load that makes resync
slow.

>> A more recent check show speed continuing to rise; [ ... ]

Perhaps because the 'fsck' ended, as the speed issue is likely
to have been been a long 'fsck', consequent to an abrupt
shutdown:

>>  [ ... ] The resulting shutdown (which was a manual power
>> off) leaves the arrays and their components in a funky state.
>> When the system comes back, it fixes things up. [ ... ]

Plus the poor alignment of the 'sda' partitions cutting write
rates very significantly. Your 'sd[bc]' disks instead are GPT
partitioned and that is by default 1MiB aligned, but you
probably used some very old tool and 'sd[bc]4' are 1KiB aligned:

  $ factor 6835938
  6835938: 2 3 17 29 2311

Someone else has pointed out the large difference in partition
sizes among 'sda' vs. 'sd[bc]'; while that does not cause speed
issue, the RAID set will just reduce to the multiple of the
smallest size. Indeed it is reported as 730m blocks, which is
the equivalent of  1461047490s reported by 'fdisk' for 'sda3'.

Probably you should have a 2-disk RAID1 of 'sd[bc]' alone.

>> Even if this did happen, in RAID 1 wouldn't some of the
>> componnents (partitions in my case) be deemed good and others
>> bad, with the latter resynced to match the former?  And if
>> that is happening, why can't I tell which partition(s) are
>> master (considered good) and which are not

Because you haven't read some relevant documentation...

>> (being overwritten with contents of the master)?

Two ways, for example:

  * The "event counts" reported by will be different (higher
    event count means more recent).

  * 'iostat' will tell you which drives are being read and which
    written.

> I checked the logs and didn't see anything about a drive
> failing, though there were some smartd reports of changes in
> drive parameters like temperature.

The kernel logs always tell if a resync is triggered by a
failure, but note that a resync happens on a failure when a
spare is added to the RAID set to replace the failed drive, or
when the drives are out of sync because of an abrupt shutdown,
which seems to be your case.

Anyhow the ways to look at the health of the disk suggested by
others are somewhat misleading. The first thing is to have a
mental model of possible disk failure modes... Anyhow, the most
relevant data are in 'smartctl -A' the number of reallocated
sectors (too many indicates a failing disk) and the SMART
selftest and error logs, to check the frequency of issues.
