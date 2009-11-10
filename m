From: Chris Worley <worleys@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 13:45:52 -0700
Message-ID: <f3177b9e0911101245o66702d06ja9bbe520f010553e@mail.gmail.com>
References: <4AF7066C.1040507@tmr.com>
	 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	 <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	 <yq1ljienxql.fsf@sermon.lab.mkp.net>
	 <f3177b9e0911100922u435993behd0889ae284cf0ec4@mail.gmail.com>
	 <yq11vk6nnrh.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq11vk6nnrh.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Majed B." <majedb@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 10, 2009 at 1:11 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Chris" =3D=3D Chris Worley <worleys@gmail.com> writes:
>
> Chris> I'm not talking about memory-based or -looking devices. =A0A b=
lock
> Chris> device is all you need, and you don't have to re-write file
> Chris> systems to put one atop a block device.
>
> And a SATA/SCSI-fronted flash disk isn't a block device how?

It's not any different.  The previous statement that I was responding
to (you snipped out) had imlied that the fs code had to be re-written
for non-SCSI devices.  I was just assuring that was not necessary.
>
> Do you have any compelling evidence as to why using a protocol like S=
CSI
> is bad? =A0A SCSI command is typically 16 bytes. =A0A typical HBA IOC=
B
> slightly bigger but includes the inevitable scatterlist. =A0We're tal=
king
> a pretty dense format for expressing an I/O operation here.

I'm not saying the SCSI protocol is bad, I'm saying the SAS/SATA/SCSI
controllers, that have been optimized for years for rotating media,
don't have the compute power to handle the sort of performance
attainable with SSS.

>
> You seem to be arguing that letting a device speak "block" instead of
> SCSI would make things faster. =A0I'm not convinced.

That's not what I'm saying; the protocol is not the culprit, the
controller is.  But, once you get rid of the controller, and just
speak block device, another level of overhead had been removed.

>=A0Also, SCSI gives us
> a nice way to track outstanding I/Os via command queueing plus much
> more. =A0All in a open, non-vendor-specific format requiring no custo=
m
> drivers. =A0Unlike, say, the SSS board you mentioned elsewhere in thi=
s
> thread.

At least one of the boards I mentioned I know has command queuing w/o
being a SCSI device.

>
> On top of that Linux is used all over the place in deployments that h=
ave
> throughput and IOPS figures above and beyond the numbers you quote he=
re.

I was only quoting single drive specs.  You only scale to really big
numbers if you start with really fast individual components.  I'm sure
you could quote TB/s using rotating media, but you have a lot more
expensive pieces needed to get there.

> Despite "legacy" controllers being in the mix.
>
>
> Chris> Those using legacy controller technology can overcome the issu=
e
> Chris> by using multiple devices. =A0We've been talking single device
> Chris> performance. I can get 6GB/s using 8 SSS drives.
>
> And adding another flash-backed SAS board isn't giving you exactly th=
e
> same benefit?

Again, scalability is achieved more readily and with less complexity
using faster components.
>
>
> Chris> And I do appreciate all your work. =A0I fear, in this case, di=
scard
> Chris> will be optimized for the slower technology... we won't be
> Chris> getting all that's available from it.
>
> Discard isn't "optimized" for anything. =A0It's a command. =A0Filesys=
tem
> issues it, it gets sent to the storage device (DSM/TRIM, WRITE SAME, =
or
> UNMAP depending on target type).

Unless you try to coalesce it for a later time, which is what I hear
is being done to compensate for slow controllers.
>
>
> Chris> CPU's have much more performance for handling the management
> Chris> needed by NAND, and there are so many cores these days going
> Chris> unused.
>
> You seem to think that the limiting factor in SSD design is the speed=
 of
> the ASIC and not the speed of the actual flash chips behind it.

True.  They limit the NAND performance based on the lack of
performance of their ASIC and the controller.  That doesn't mean you
can't get a lot better performance out of NAND, it just means they
limited themselves to be compatible, and the kernel will implement a
strategy that will optimize for the poor design.

>
>
> Chris> SSD's do win the "compatibility" argument. =A0It's too bad we
> Chris> didn't invent thumb drives that were floppy compatible ;)
>
> There are many good reasons for that. =A0drivers/block/floppy.c conta=
ins a
> several of them. =A0Keep a bag of expletives handy.

So you _are_ glad that compatibility was not followed in the move to
USB thumb drives, but you also believe the best way to do SSS was
behind compatible legacy SAS/SATA devices optimized for old rotating
media?
>
>
>>> Because initial TRIM performance was absolutely appalling
>
> Chris> Only on SSD's behind legacy controllers. =A0It worked great as=
-is
> Chris> with SSS.
>
> Please elaborate.

I had no performance issues testing w/ the original discard
implementation using SSS.

I'd run IOZone and fill the drive (as I recall ~200GB) w/ files and
benchmark, which, at the end, IOZone would delete all the files
created (in the hundreds), and the delete/discard process was no more
time consuming than just the delete process (for everything on the
drive).  This was w/ the original 2.6.27 and 2.6.28 ext4 "discard"
implementations.

Chris
>
> --
> Martin K. Petersen =A0 =A0 =A0Oracle Linux Engineering
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
