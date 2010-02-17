From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: RAID partition starting sector (... 63?)
Date: Wed, 17 Feb 2010 13:13:42 -0500
Message-ID: <87f94c371002171013x53acb705kf0d4f194e211fb27@mail.gmail.com>
References: <73e903671002170713g397742b8l109773b4c20825ce@mail.gmail.com>
	 <yq1bpfnga3l.fsf@sermon.lab.mkp.net>
	 <87r5ojon3j.fsf@frosties.localdomain>
	 <yq17hqbg78q.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq17hqbg78q.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Feb 17, 2010 at 11:24 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Goswin" =3D=3D Goswin von Brederlow <goswin-v-b@web.de> writes:
>
> Goswin> Newer windows starts the first partition at 1M, which gives g=
ood
> Goswin> alignment in nearly every situation.
>
> Correction: Windows aligns the first partition at 1MB + whatever
> alignment is reported by the storage device.
>
> Recent fdisk and parted to do the same.
>
> --
> Martin K. Petersen =A0 =A0 =A0Oracle Linux Engineering

Martin,

I assume this is through the relatively new /sysfs interface.  Is
mdraid now advertising its preferred stripe alignments through /sysfs?

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
