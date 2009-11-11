From: Chris Worley <worleys@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Wed, 11 Nov 2009 11:17:43 -0700
Message-ID: <f3177b9e0911111017w32a8022ao15c1d1f7c666a2b1@mail.gmail.com>
References: <4AF7066C.1040507@tmr.com>
	 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	 <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	 <yq1ljienxql.fsf@sermon.lab.mkp.net>
	 <f3177b9e0911100922u435993behd0889ae284cf0ec4@mail.gmail.com>
	 <yq11vk6nnrh.fsf@sermon.lab.mkp.net>
	 <f3177b9e0911101245o66702d06ja9bbe520f010553e@mail.gmail.com>
	 <yq1skcmm2jj.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1skcmm2jj.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 10, 2009 at 3:35 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Chris" =3D=3D Chris Worley <worleys@gmail.com> writes:
>
> Chris> I'm not saying the SCSI protocol is bad, I'm saying the
> Chris> SAS/SATA/SCSI controllers, that have been optimized for years =
for
> Chris> rotating media, don't have the compute power to handle the sor=
t
> Chris> of performance attainable with SSS.
>
> And I'm saying that at least in the SCSI case that's untrue. =A0SAS a=
nd FC
> controllers are optimized for lots and lots of I/O because their main
> application is driving large storage arrays which have performance
> comparable to the solid state devices you mention.

We're going to have to agree to disagree on this.  My feeling is, you
haven't tried the next generation in I/O performance, only the slow
SSD's currently available, and don't (yet) see the potential for
getting rid of all the hardware layers that evolved around rotating
media.  And when you talk of FC... there's more performance
inhibition.  Slow hardware like 10G Ethernet and FC8 can't keep up
with the performance required for fast SSS I/O.  A single QDR IB port
is a good start, with 3GB/s per port (measured using SRP to export the
drives).  How many FC8 or 10G over iSCSI ports would it take to get
one QDR IB ports performance(?)... then start thinking 2x, 4x, 8x, ...
and the complexity of the old hardware becomes daunting when trying to
scale.   Again, to scale easily and with less complexity: you need
your fundamental components to be fast.  SSD's, FC, 10G are last
generation hardware and way too slow.

You can use a 90's vintage distributed supercomputer with 100's of
processors to run tasks that one CPU can do as fast or faster today...
but many would agree that the new CPU is probably an easier choice.

And again, I'm not attacking the SCSI protocol, just the controller
performance; but getting rid of unnecessary OS software layers (i.e.
when you can directly use a block device), also provides more
performance.  When you've got <50usecs latency storage, every CPU
cycle counts.

<snip>
>
> Chris> I'd run IOZone and fill the drive (as I recall ~200GB) w/ file=
s
> Chris> and benchmark, which, at the end, IOZone would delete all the
> Chris> files created (in the hundreds), and the delete/discard proces=
s
> Chris> was no more time consuming than just the delete process (for
> Chris> everything on the drive). =A0This was w/ the original 2.6.27 a=
nd
> Chris> 2.6.28 ext4 "discard" implementations.
>
> And which device was this? =A0How did it implement discard?

This was a non-GPL driver (as is the management layer for all SSD's),
so I doubt you're interested.

The methodology used was that laid out by David Wodhouse in:

http://lwn.net/Articles/293658/

Basically: 1) register for the discard, 2) decode the write BIO's that
indicate "discard", 3) send completion when done.

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
