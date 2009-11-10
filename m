From: Chris Worley <worleys@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 10:22:13 -0700
Message-ID: <f3177b9e0911100922u435993behd0889ae284cf0ec4@mail.gmail.com>
References: <4AF7066C.1040507@tmr.com>
	 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	 <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	 <yq1ljienxql.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1ljienxql.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Majed B." <majedb@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 10, 2009 at 9:36 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Chris" =3D=3D Chris Worley <worleys@gmail.com> writes:
>
> Chris> The only problem is SSD's put Solid State Storage (SSS) behind
> Chris> SATA/SAS controllers... while compatible w/ old disk technolog=
y,
> Chris> it severely limits performance (i.e. none of these SSD drives =
do
> Chris> even 300MB/s... while SSS drives do 800MB/s).
>
> You are arguing that the SATA/SCSI protocols are inhibiting factors o=
n
> the grounds that PCIe solid state devices are faster.
>
> Performance inside a flash device is gated by the number of channels =
you
> run in parallel. =A0There is not much point in increasing the number =
of
> channels if your physical interconnect (3Gbps SATA, say) can't handle
> the traffic. =A0Hence the drive towards 6Gbps interconnects and beyon=
d for
> both SATA and SAS.

Absolutely agreed: the SSD manufacturers will limit their NAND
performance given the performance limitations of the controller
front-end.  Also, given their management layer is an on-board ASIC,
they further limit their performance in this design.

>
> Also, not all SSS boards present a memory-style device to the host.
> Several shipping SSS boards use a regular SAS HBA backed by multiple
> SATA/SAS targets which again comprise of multiple flash channels. =A0=
And
> the performance of these devices is absolutely on par with the
> memory-based devices. =A0Without requiring proprietary drivers, and
> without reinventing filesystems and I/O stack.

I'm not talking about memory-based or -looking devices.  A block
device is all you need, and you don't have to re-write file systems to
put one atop a block device.

Those using legacy controller technology can overcome the issue by
using multiple devices.  We've been talking single device performance.
 I can get 6GB/s using 8 SSS drives.  Scalability is much easier when
you start with really fast individual components.  So, legacy
controllers are still a bad design.

>
> We have been pushing tens of gigabytes per second through the storage
> stack for years when connected to arrays which - given their large
> non-volatile caches - are virtually indistinguishable from SSDs. =A0W=
e're
> constantly tweaking and tuning. =A0Jens has done a lot of work to bri=
ng
> down command latency, I have worked on storage topology which allows =
us
> to uniquely identify the characteristics of the physical storage devi=
ce
> so we can issue I/O in an optimal fashion.

And I do appreciate all your work.  I fear, in this case, discard will
be optimized for the slower technology... we won't be getting all
that's available from it.
>
> Note that I don't think that memory-based SSS devices are without mer=
it.

Let's call it CPU-based.  "Memory-based" sounds like RAM-based
storage... we're not talking about that.

> But it's baloney to claim that a storage-flavored interface inherentl=
y
> means bad performance.

You need an epiphany here.  Between the SAS/SATA controllers and the
on-board drive logic, SSD's are a bad design when it comes to
performance.  They are dwarfed, in performance, by CPU-based
controllers.  CPU's have much more performance for handling the
management needed by NAND, and there are so many cores these days
going unused.

SSD's do win the "compatibility" argument.  It's too bad we didn't
invent thumb drives that were floppy compatible ;)

>
>
> Chris> So it looks like "design by committee" Linux is well behind
> Chris> Windows 7, while Linux contemplates slowing new technology dow=
n
> Chris> to optimize for ill-designed SSD's.
>
> We're not slowing anything, nor are we optimizing for ill-designed SS=
Ds.
>
> Because initial TRIM performance was absolutely appalling

Only on SSD's behind legacy controllers.  It worked great as-is with SS=
S.

> there was a
> lot of discussion about the merits of doing weekly scrubs instead of
> issuing TRIM on the fly. =A0However, Windows 7 shipped issuing TRIM i=
n
> realtime which means that all the early SSDs with lame duck DSM
> performance are headed straight for the garbage bin.

Too bad the legacy design doesn't go with them ;)

Chris
>
> Futhermore, unlike Windows 7 we can't pretend everything is desktop
> class ATA. =A0We've spent a lot of time making sure that our block la=
yer
> discard support works equally well for both ATA DSM (TRIM) as well as
> SCSI WRITE SAME and UNMAP used by high-end arrays. =A0All three comma=
nds
> have been moving targets and none of them are technically set in ston=
e
> in their respective standards bodies yet.
>
> So I think it would be a stretch to claim that TRIM is well tested an=
d
> stable in the industry. =A0intel just pulled their latest X25-M firmw=
are
> because of problems with Windows 7...
>
> --
> Martin K. Petersen =A0 =A0 =A0Oracle Linux Engineering
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
