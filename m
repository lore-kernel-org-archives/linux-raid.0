From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Wed, 11 Nov 2009 12:00:15 -0500
Message-ID: <87f94c370911110900h776286d9xba8d7f696dec18c1@mail.gmail.com>
References: <4AF7066C.1040507@tmr.com>
	 <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	 <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	 <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	 <f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	 <yq1ljienxql.fsf@sermon.lab.mkp.net>
	 <f3177b9e0911100922u435993behd0889ae284cf0ec4@mail.gmail.com>
	 <yq11vk6nnrh.fsf@sermon.lab.mkp.net>
	 <87f94c370911101301v4b71ce74hbd4ebd20e7ce2419@mail.gmail.com>
	 <yq1ocnam1k5.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1ocnam1k5.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chris Worley <worleys@gmail.com>, "Majed B." <majedb@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 10, 2009 at 5:56 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Greg" =3D=3D Greg Freemyer <greg.freemyer@gmail.com> writes:
>
> Greg> I'm not sure where it ended up, but the big SSD / discard
> Greg> discussion of a few months ago talked about 3 kinds of solution=
s,
> Greg> and I thought the plan was to support all 3.
>
> We don't design for the past.
>
>
> Greg> 1) optimization 1 - A white-listed instant discard feature. =A0=
In
> Greg> =A0 =A0this methodology, the filesystems would immediately send
> Greg> =A0 =A0discard calls down to the block layer would send them on=
 down
> Greg> =A0 =A0the block stack to the physical devices with very minima=
l
> Greg> =A0 =A0buffering.
>
> There's no whitelist. =A0That's just how it works.
>
> Yes, there were a few crappy devices out there. =A0Windows 7 issuing =
TRIM
> commands in realtime made them instantly obsolete. =A0If future devic=
es
> suck with Windows 7 nobody will buy them.
>
>
> Greg> 2) optimization 2 - The block layer would accept those small
> Greg> =A0 =A0discards, but accumulate them for a short period. =A0(le=
ss than a
> Greg> =A0 =A0second was my impression). =A0Then coalesce them into la=
rger
> Greg> =A0 =A0discards and send them down the block stack and eventual=
ly to
> Greg> =A0 =A0the physical device.
>
> SSDs are special in that they actually track map state on a per-logic=
al
> block basis. =A0Other thinly provisioned devices track space in units
> ranging from 16-32-64KB up to megabytes.
>
> It's up to each block device to track the map space. =A0The way most
> arrays work is that they'll ignore the portions of the request that a=
re
> not aligned to and a multiple of their internal allocation unit.
>
> The same applies to MD. =A0IOW, MD would only unmap the portions of t=
he
> discard request that constitute entire stripes. =A0No keeping state
> required.
>
> Jens just queued my patch which allows block devices to communicate
> their unmap granularity and alignment to the filesystems. =A0This mea=
ns we
> can potentially use this to influence filesystem allocators. =A0For S=
CSI
> arrays these values are queried and passed up the stack. =A0MD can ch=
oose
> to manually set the granularity to its stripe size.
>
>
> Greg> 3) optimization 3 - a background freespace scanner would run fr=
om
> Greg> time to time that scanned a filesystem for free blocks and send=
 a
> Greg> discard / trim command down to the device. =A0This is what Mark=
 Lord
> Greg> was working on. =A0His solution was primarily in user space and=
 was
> Greg> controlled by cron.
>
> I think that's a fine approach for legacy devices. =A0But as I said I
> think Windows 7 will root out all devices with poor TRIM performance
> pretty quickly.
>
> --
> Martin K. Petersen =A0 =A0 =A0Oracle Linux Engineering
>

Martin,

So for a workload mostly composed of small files residing on a MD raid
4/5/6 setup, how is this supposed to work.  (ie. Tiffs, small word
docs, pdfs, individual emails, etc.)

Most of the individual files will be less than one stripe wide, so
when they are deleted I gather the discard range will be less than a
stripe and therefore MD would ignore it in the simplest of
implementations.  ie. Without coalescence at some point, MD will never
forward discards to the hardware.

Thus I would think for that workload, the nightly full freespace scan
and discard would be the best solution.

Thanks
Greg


--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Pap=
er -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html=
>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
