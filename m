From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 11:36:02 -0500
Message-ID: <yq1ljienxql.fsf@sermon.lab.mkp.net>
References: <4AF7066C.1040507@tmr.com>
	<70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	<f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	<70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	<f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	(Chris Worley's message of "Mon, 9 Nov 2009 09:59:38 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: "Majed B." <majedb@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Chris" == Chris Worley <worleys@gmail.com> writes:

Chris> The only problem is SSD's put Solid State Storage (SSS) behind
Chris> SATA/SAS controllers... while compatible w/ old disk technology,
Chris> it severely limits performance (i.e. none of these SSD drives do
Chris> even 300MB/s... while SSS drives do 800MB/s).

You are arguing that the SATA/SCSI protocols are inhibiting factors on
the grounds that PCIe solid state devices are faster.

Performance inside a flash device is gated by the number of channels you
run in parallel.  There is not much point in increasing the number of
channels if your physical interconnect (3Gbps SATA, say) can't handle
the traffic.  Hence the drive towards 6Gbps interconnects and beyond for
both SATA and SAS.

Also, not all SSS boards present a memory-style device to the host.
Several shipping SSS boards use a regular SAS HBA backed by multiple
SATA/SAS targets which again comprise of multiple flash channels.  And
the performance of these devices is absolutely on par with the
memory-based devices.  Without requiring proprietary drivers, and
without reinventing filesystems and I/O stack.

We have been pushing tens of gigabytes per second through the storage
stack for years when connected to arrays which - given their large
non-volatile caches - are virtually indistinguishable from SSDs.  We're
constantly tweaking and tuning.  Jens has done a lot of work to bring
down command latency, I have worked on storage topology which allows us
to uniquely identify the characteristics of the physical storage device
so we can issue I/O in an optimal fashion.

Note that I don't think that memory-based SSS devices are without merit.
But it's baloney to claim that a storage-flavored interface inherently
means bad performance.


Chris> So it looks like "design by committee" Linux is well behind
Chris> Windows 7, while Linux contemplates slowing new technology down
Chris> to optimize for ill-designed SSD's.

We're not slowing anything, nor are we optimizing for ill-designed SSDs.

Because initial TRIM performance was absolutely appalling there was a
lot of discussion about the merits of doing weekly scrubs instead of
issuing TRIM on the fly.  However, Windows 7 shipped issuing TRIM in
realtime which means that all the early SSDs with lame duck DSM
performance are headed straight for the garbage bin.

Futhermore, unlike Windows 7 we can't pretend everything is desktop
class ATA.  We've spent a lot of time making sure that our block layer
discard support works equally well for both ATA DSM (TRIM) as well as
SCSI WRITE SAME and UNMAP used by high-end arrays.  All three commands
have been moving targets and none of them are technically set in stone
in their respective standards bodies yet.

So I think it would be a stretch to claim that TRIM is well tested and
stable in the industry.  intel just pulled their latest X25-M firmware
because of problems with Windows 7...

-- 
Martin K. Petersen	Oracle Linux Engineering
