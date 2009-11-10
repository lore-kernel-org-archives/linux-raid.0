From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 15:11:30 -0500
Message-ID: <yq11vk6nnrh.fsf@sermon.lab.mkp.net>
References: <4AF7066C.1040507@tmr.com>
	<70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	<f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	<70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	<f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	<yq1ljienxql.fsf@sermon.lab.mkp.net>
	<f3177b9e0911100922u435993behd0889ae284cf0ec4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f3177b9e0911100922u435993behd0889ae284cf0ec4@mail.gmail.com>
	(Chris Worley's message of "Tue, 10 Nov 2009 10:22:13 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Majed B." <majedb@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Chris" == Chris Worley <worleys@gmail.com> writes:

Chris> I'm not talking about memory-based or -looking devices.  A block
Chris> device is all you need, and you don't have to re-write file
Chris> systems to put one atop a block device.

And a SATA/SCSI-fronted flash disk isn't a block device how?

Do you have any compelling evidence as to why using a protocol like SCSI
is bad?  A SCSI command is typically 16 bytes.  A typical HBA IOCB
slightly bigger but includes the inevitable scatterlist.  We're talking
a pretty dense format for expressing an I/O operation here.

You seem to be arguing that letting a device speak "block" instead of
SCSI would make things faster.  I'm not convinced.  Also, SCSI gives us
a nice way to track outstanding I/Os via command queueing plus much
more.  All in a open, non-vendor-specific format requiring no custom
drivers.  Unlike, say, the SSS board you mentioned elsewhere in this
thread.

On top of that Linux is used all over the place in deployments that have
throughput and IOPS figures above and beyond the numbers you quote here.
Despite "legacy" controllers being in the mix.


Chris> Those using legacy controller technology can overcome the issue
Chris> by using multiple devices.  We've been talking single device
Chris> performance. I can get 6GB/s using 8 SSS drives.

And adding another flash-backed SAS board isn't giving you exactly the
same benefit?


Chris> And I do appreciate all your work.  I fear, in this case, discard
Chris> will be optimized for the slower technology... we won't be
Chris> getting all that's available from it.

Discard isn't "optimized" for anything.  It's a command.  Filesystem
issues it, it gets sent to the storage device (DSM/TRIM, WRITE SAME, or
UNMAP depending on target type).


Chris> CPU's have much more performance for handling the management
Chris> needed by NAND, and there are so many cores these days going
Chris> unused.

You seem to think that the limiting factor in SSD design is the speed of
the ASIC and not the speed of the actual flash chips behind it.


Chris> SSD's do win the "compatibility" argument.  It's too bad we
Chris> didn't invent thumb drives that were floppy compatible ;)

There are many good reasons for that.  drivers/block/floppy.c contains a
several of them.  Keep a bag of expletives handy.


>> Because initial TRIM performance was absolutely appalling

Chris> Only on SSD's behind legacy controllers.  It worked great as-is
Chris> with SSS.

Please elaborate.

-- 
Martin K. Petersen	Oracle Linux Engineering
