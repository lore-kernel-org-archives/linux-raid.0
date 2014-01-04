From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Why 4k native drives haven't arrived
Date: Sat, 04 Jan 2014 12:40:00 -0600
Message-ID: <52C85580.2080303@hardwarefreak.com>
References: <52C61807.6050906@hardwarefreak.com> <yq1d2k8zsie.fsf@sermon.lab.mkp.net>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1d2k8zsie.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/3/2014 3:04 PM, Martin K. Petersen wrote:
>>>>>> "Stan" == Stan Hoeppner <stan@hardwarefreak.com> writes:
> 
> Stan,
> 
> Stan> Advanced Format 512e drives, drives with 4K native sectors but
> Stan> 512B sectors presented to the host, 
> 
> Ignoring ECC, legacy/native drives have a 1:1 mapping between logical
> and physical block sizes (512/520/528 bytes).
> 
> 512e drives have a 512-byte logical block size. That's what the host
> operating system uses for addressing purposes when filling out the
> command to the disk. Internally, they use 4096-byte physical blocks on
> media.
> 
> Drives with 4096-byte logical *and* physical blocks are slowly becoming
> available. These drives are referred to as 4Kn (4K native) drives. So be
> careful about using the term "native" when referring to the physical
> sector size.

My exact statement above leaves no doubt.  But your point is duly noted,
and I'll make sure I use "logical" and "physical" in the future.

> Linux supports drives with logical block sizes up to the system page
> size. This means we support 4Kn drives and have for over a decade. DASD
> on the mainframe is 4Kn, for instance. And there are a bunch of SAN
> devices and SSDs out there that also report themselves as 4Kn. So
> devices absolutely exist and are available.
> 
> 4Kn harddrives are harder to come by, however. SAS/FC drives are
> available formatted as 4Kn when you order them. Some 512n drives can be
> reformatted. But you won't find 4Kn formatted drives in retail.
> 
> 4Kn SATA works fine in Linux as well but has failed to get any
> traction. Mainly because there is no win for the user. Just lots of
> pain.

I agree for the most part, and I was a vocal critic of the whole 4K push
when it started, and especially of 512e.  But as the throughput of
drives increases, 4K host transfers with 4Kn drives will pay some
performance dividends, though obviously nothing dramatic.  So it's not
completely bleak.

> Stan> The physical sector size presented to the host is irrelevant to
> Stan> the drive manufacturers, given the singular goal above.  Switching
> Stan> to a native 4K sector does not benefit the manufacturers.  At the
> Stan> current time it actually will cause them tremendous problems.
> 
> The drive vendors pushed 4Kn for years and years. The problem was that
> to the host there is no benefit whatsoever. Just lots of pain throughout
> the entire I/O stack (BIOS, OS, HBA ROMs, RAID controller firmware). And
> no win. None.
> 
> So the drive vendors begrudgingly did 512e as a transitional thing. But
> they would like nothing more than killing off read-modify-write handling
> in their firmware/ASICs.

I'm sure they would but is this a high priority?  RMW handling was a
small price to pay for the increased platter density they were after.
And now that most modern OS partitioning tools align to 1MB this isn't a
performance issue for the user.  Does the RMW code occupy a huge amount
of the firmware space on the drive, or continual sink of engineering
dollars with each new drive model?

I'm of the impression than 512e is done, is taking no additional money
out of the drive vendors' pockets, yet increasing net dollars due to
larger drive capacities, and fewer platters needed on some smaller
drives.  This is why I said there is little motivation on the part of
the drive vendors to continue pushing 4Kn drives.

Whether 512B or 4KB it's obviously preferable to everyone to have the
logical and physical block sizes match--vendors, OS kernel programmers,
users.

> We are sticking with 512-byte logical/physical blocks for server
> workloads for several reasons. First of all it's important to have
> predictable performance. The read-modify-write cycles for misaligned
> writes on 512e drives can severely impact performance.
>
> The second reason is data integrity preservation. None of the consumer
> 512e drives feature protection against sibling block corruption during
> read-modify-write. The nasty thing here is that a partial block write
> can end up garbling logical blocks within the 4KB physical sector that
> were not part of the failed I/O request. This is an absolute no-go from
> a data integrity perspective.
>
> Therefore server drives have two options: Native (512n up to a certain
> capacity point, 4Kn for larger drives), or 512e with flash, supercaps or
> other tech that'll allow the drive to complete a partial block write
> during power failure. Both are out there.

Note that I've presented counterpoints here simply for technical
discussion.  I'm no fan of 512e, never have been, never will be, have
never used a 512e drive, and never will, not if I can void it.  I'm
still a 512n kinda guy.

> Stan> Thus native 4K drives will not be on the open market until the
> Stan> manufacturers are comfortable that most legacy machines have been
> Stan> retired, eliminating the possibility of the scenario above.
> 
> Actually, >2TB USB drives typically expose 4Kn to the host. For that
> reason there are already problems with XP and big drives.

http://support.microsoft.com/kb/2510009

Windows 7 doesn't support 4Kn drives either.  Up to now I thought it was
limited to XP.  Since these two versions of Windows make up ~80% of the
installed MS Windows base, putting 4Kn USB drives on the market *is*
suicide.

> PS. See also: https://oss.oracle.com/~mkp/docs/linux-advanced-storage.pdf

Interesting read.  Are the suggested IDENTIFY DEVICE responses simply a
reprint of the ATA/SCSI standards, or are these return values Linux
specific, as the paper seems to suggest?  I assume they're standard, as
the vendors would most likely code for Windows if it required different
values.

-- 
Stan

