From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 17:35:12 -0500
Message-ID: <yq1skcmm2jj.fsf@sermon.lab.mkp.net>
References: <4AF7066C.1040507@tmr.com>
	<70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	<f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	<70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	<f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	<yq1ljienxql.fsf@sermon.lab.mkp.net>
	<f3177b9e0911100922u435993behd0889ae284cf0ec4@mail.gmail.com>
	<yq11vk6nnrh.fsf@sermon.lab.mkp.net>
	<f3177b9e0911101245o66702d06ja9bbe520f010553e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f3177b9e0911101245o66702d06ja9bbe520f010553e@mail.gmail.com>
	(Chris Worley's message of "Tue, 10 Nov 2009 13:45:52 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Majed B." <majedb@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Chris" == Chris Worley <worleys@gmail.com> writes:

Chris> I'm not saying the SCSI protocol is bad, I'm saying the
Chris> SAS/SATA/SCSI controllers, that have been optimized for years for
Chris> rotating media, don't have the compute power to handle the sort
Chris> of performance attainable with SSS.

And I'm saying that at least in the SCSI case that's untrue.  SAS and FC
controllers are optimized for lots and lots of I/O because their main
application is driving large storage arrays which have performance
comparable to the solid state devices you mention.

In fact, many deployments use said SCSI controllers to drive RAM-based
solid state storage devices which are faster than the flash-based
devices we're talking about here.


Chris> Unless you try to coalesce it for a later time, which is what I
Chris> hear is being done to compensate for slow controllers.

We don't coalesce.


Chris> True.  They limit the NAND performance based on the lack of
Chris> performance of their ASIC and the controller.  

Interesting theory.

I'm personally of the conviction that cheap SSDs suffer from amazingly
poor FTL design rather than inherent hardware limitations.

That's something intel got right with their drives.  The hardware itself
is pretty unremarkable.


Chris> That doesn't mean you can't get a lot better performance out of
Chris> NAND, it just means they limited themselves to be compatible, and
Chris> the kernel will implement a strategy that will optimize for the
Chris> poor design.

You are confusing limitations in interconnect technology with the
properties of the protocols used.  There is no point in adding channels
behind the ASIC to drive 12 Gbps of I/O if your host interface is 1.5
Gbps SATA.  That has nothing to do with whether ATA and SCSI are
suitable protocols.

I'm arguing that the at least SCSI is a good protocol for sending
commands to a block device.  Nothing prevents your flash-based block
device from presenting a PCIe SCSI interface to the host and then do
something completely different in the back.

There's lots of warts in SCSI.  And I personally think that ATA TRIM was
very poorly defined.  But I don't believe that these protocols are
inherently bad for driving storage.  And I don't believe that coming up
with a custom "block" interface will improve anything in the short term.
Heck, the overhead of speaking SCSI is so low that even the thumb drive
you brought up implements it.  At negligible cost.


Chris> but you also believe the best way to do SSS was behind compatible
Chris> legacy SAS/SATA devices optimized for old rotating media?

You're the one claiming these "legacy" devices are optimized for
rotating media.  I'm claiming there's nothing rotating about either
protocol.

Both express "do something to this range of blocks" in 16 bytes or less
+ a scatterlist describing memory.  That's a pretty efficient interface
in my book.


Chris> I'd run IOZone and fill the drive (as I recall ~200GB) w/ files
Chris> and benchmark, which, at the end, IOZone would delete all the
Chris> files created (in the hundreds), and the delete/discard process
Chris> was no more time consuming than just the delete process (for
Chris> everything on the drive).  This was w/ the original 2.6.27 and
Chris> 2.6.28 ext4 "discard" implementations.

And which device was this?  How did it implement discard?

-- 
Martin K. Petersen	Oracle Linux Engineering
