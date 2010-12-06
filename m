From: =?ISO-8859-1?Q?Stefan_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: turn off auto assembly
Date: Mon, 06 Dec 2010 22:52:56 +0100
Message-ID: <4CFD5B38.2090801@stud.tu-ilmenau.de>
References: <4CF7F369.4090303@stud.tu-ilmenau.de>	<slrnifg359.9qh.Mario.Holbe@darkside.dyn.samba-tng.org> <20101203123009.0aa23102@notabene.brown>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101203123009.0aa23102@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for all the hints.

There were no udev-rules on the computers, so I fixed the problem using
Neil's hints: 'echo "AUTO -all" >> /etc/mdadm.conf'.

Cheers,
Stefan

P.S.: as the "auto assemble everything with 0xfd partition type" may
become destructive at times (I have to deal a lot with damaged arrays),
I'd suggest not to make it the default setting.  But the other side is:
most people who set up a RAID would want to have it this way, so I gues=
s
it's my duty to make sure no autoassembly on my technicians' computers
happens, unless I tell mdadm to do so...

P.P.S.: The behaviour might very well have come with the update to
mdadm-3.1.4, which may well have come nearly in parallel with me
updating the kernels... (as Gentoo stable jumped from 3.0 to 3.1.4 in
late October, at the beginning of November I updated the kernels...)

Am 03.12.2010 02:30, schrieb Neil Brown:
> On Thu, 2 Dec 2010 22:16:25 +0100 Mario 'BitKoenig' Holbe
> <Mario.Holbe@TU-Ilmenau.DE> wrote:
>
>> Stefan /*St0fF*/ H=FCbner <stefan.huebner@stud.tu-ilmenau.de> wrote:
>>> Now I have the effect that upon plugging in drives that formerly we=
re
>>> part of an array, the md_mod modules gets loaded and tries to
>>> auto-assemble arrays.  This disturbs the diagnosis.
>>> I've tried raid=3Dnoautodetect as kernel commandline, and I grepped=
 the
>>> source for the MODULE_PARM_DESC macro, which yielded no (useful) re=
sult.
>>>  This "automagic" behaviour happens since 2.6.36.
>> Are you sure this autodetection is triggered by the module?
>> And are you sure this behaviour is bound to this specific kernel
>> version?
>>
>> In-Kernel auto-assembly is usually not active when md is compiled as
>> module. Probably in your case this is some udev-triggered assembly?
> s/usually not/never/
>
> With a sufficiently recent mdadm, you can put
>    AUTO -all
>
> in mdadm.conf to disable auto-assembly.
>
> Alternately, find the udev rule (/lib/udev/rules.d/64-md-something) a=
nd=20
> comment out the bit where it runs "mdadm -I" or "mdadm --incremental"=
=2E
>
> NeilBrown
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
