From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Sat, 07 Jan 2012 10:25:53 -0600
Message-ID: <4F087211.5020000@hardwarefreak.com>
References: <20111212115459.GC20730@fi.muni.cz> <4EE61EAE.20101@anonymous.org.uk> <20120106150823.GX25976@fi.muni.cz> <20231.9177.523012.471046@tree.ty.sabi.co.UK> <20120106201150.GB13358@fi.muni.cz> <4F077BE1.4050408@hardwarefreak.com> <20232.21966.952905.343604@tree.ty.sabi.co.UK>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20232.21966.952905.343604@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/7/2012 8:25 AM, Peter Grandi wrote:

I wrote:
>>> And I suspect that XFS swidth/sunit settings will still work
>>> with RAID-10 parameters even over plain LVM logical volume on
>>> top of that RAID 10, while the settings would be more tricky
>>> when used with interleaved LVM logical volume on top of
>>> several RAID-1 pairs (LVM interleaving uses LE/PE-sized
>>> stripes, IIRC).


> Stripe alignment is only relevant for parity RAID types, as it
> is meant to minimize read-modify-write. 

The benefits aren't limited to parity arrays.  Tuning the stripe
parameters yields benefits on RAID0/10 arrays as well, mainly by packing
a full stripe of data when possible, avoiding many partial stripe width
writes in the non aligned case.  Granted the gains are workload
dependent, but overall you get a bump from aligned writes.

> There is no RMW problem
> with RAID0, RAID1 or combinations. 

Which is one of the reasons the linear concat over RAID1 pairs works
very well for some workloads.

> But there is a case for
> 'sunit'/'swidth' with single flash based SSDs as they do have a
> RMW-like issue with erase blocks. In other cases whether they
> are of benefit is rather questionable.

I'd love to see some documentation supporting this sunit/swidth with a
single SSD device theory.

I wrote:
>> One would use a linear concatenation and drive parallelism
>> with XFS allocation groups, i.e. for a 24 drive chassis you'd
>> setup an mdraid or lvm linear array of 12 RAID1 pairs and
>> format with something like: $ mkfs.xfs -d agcount=24 [device]
>> As long as one's workload writes files relatively evenly
>> across 24 or more directories, one receives fantastic
>> concurrency/parallelism, in this case 24 concurrent
>> transactions, 2 to each mirror pair.


> That to me sounds a bit too fragile ; RAID0 is almost always
> preferable to "concat", even with AG multiplication, and I would
> be avoiding LVM more than avoiding MD.

This wholly depends on the workload.  For something like maildir RAID0
would give you no benefit as the mail files are going to be smaller than
a sane MDRAID chunk size for such an array, so you get no striping
performance benefit.

And RAID0 is far more fragile here than a concat.  If you lose both
drives in a mirror pair, say to controller, backplane, cable, etc
failure, you've lost your entire array, and your XFS filesystem.  With a
cocncat you can lose a mirror pair, run an xfs_repair and very likely
end up with a functioning filesystem, sans the directories and files
that resided on that pair.  With RAID0 you're totally hosed.  With a
concat you're probably mostly still in business.

-- 
Stan
