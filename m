From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Sat, 7 Jan 2012 14:25:18 +0000
Message-ID: <20232.21966.952905.343604@tree.ty.sabi.co.UK>
References: <20111212115459.GC20730@fi.muni.cz>
	<4EE61EAE.20101@anonymous.org.uk>
	<20120106150823.GX25976@fi.muni.cz>
	<20231.9177.523012.471046@tree.ty.sabi.co.UK>
	<20120106201150.GB13358@fi.muni.cz>
	<4F077BE1.4050408@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F077BE1.4050408@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


>> And I suspect that XFS swidth/sunit settings will still work
>> with RAID-10 parameters even over plain LVM logical volume on
>> top of that RAID 10, while the settings would be more tricky
>> when used with interleaved LVM logical volume on top of
>> several RAID-1 pairs (LVM interleaving uses LE/PE-sized
>> stripes, IIRC).

Stripe alignment is only relevant for parity RAID types, as it
is meant to minimize read-modify-write. There is no RMW problem
with RAID0, RAID1 or combinations. But there is a case for
'sunit'/'swidth' with single flash based SSDs as they do have a
RMW-like issue with erase blocks. In other cases whether they
are of benefit is rather questionable.

> One would use a linear concatenation and drive parallelism
> with XFS allocation groups, i.e. for a 24 drive chassis you'd
> setup an mdraid or lvm linear array of 12 RAID1 pairs and
> format with something like: $ mkfs.xfs -d agcount=24 [device]
> As long as one's workload writes files relatively evenly
> across 24 or more directories, one receives fantastic
> concurrency/parallelism, in this case 24 concurrent
> transactions, 2 to each mirror pair.

That to me sounds a bit too fragile ; RAID0 is almost always
preferable to "concat", even with AG multiplication, and I would
be avoiding LVM more than avoiding MD.
