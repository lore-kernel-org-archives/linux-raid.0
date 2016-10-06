From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: Prefetch in /lib/raid6/avx2.c
Date: Thu, 6 Oct 2016 07:27:03 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1739B85E450@EXCHANGE.collogia.de>
References: <CAFx4rwS5-TCWKxRYpXHeRsfTiJ=mTV0gxoL-yUuqoEbpXst08A@mail.gmail.com>,<20161005231710.GB2804@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="----=_NextPartTM-000-ecec331d-07cb-4ef0-be0c-f3af7f58a0b1"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161005231710.GB2804@kernel.org>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Doug Dumitru <doug@easyco.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, "gayatri.kammela@intel.com" <gayatri.kammela@intel.com>, "ravi.v.shankar@intel.com" <ravi.v.shankar@intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "yuanhan.liu@intel.com" <yuanhan.liu@intel.com>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-ecec331d-07cb-4ef0-be0c-f3af7f58a0b1
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: linux-raid-owner@vger.kernel.org [linux-raid-owner@vger.kernel.org]&=
quot; im Auftrag von &quot;Shaohua Li [shli@kernel.org]=0A=
> Gesendet: Donnerstag, 6. Oktober 2016 01:17=0A=
> An: Doug Dumitru=0A=
> Cc: linux-raid; gayatri.kammela@intel.com; ravi.v.shankar@intel.com; hpa@=
zytor.com; yu-cheng.yu@intel.com; yuanhan.liu@intel.com=0A=
> Betreff: Re: Prefetch in /lib/raid6/avx2.c=0A=
> =0A=
> On Sun, Oct 02, 2016 at 03:40:09PM -0700, Doug Dumitru wrote:=0A=
> > I have been doing some high bandwidth testing of raid-6, and the=0A=
> > pretetch in raid6_avx24_gen_syndrome appears to be less than optimal.=
=0A=
> >=0A=
> > This is my patch (against 4.4.0-38 [Ubuntu 16.04LTS)=0A=
> >=0A=
> > --- cut here ---=0A=
> > --- lib/raid6/avx2.c0   2016-10-01 21:42:25.280347868 -0700=0A=
> > +++ lib/raid6/avx2.c    2016-10-02 15:35:48.168480760 -0700=0A=
> > @@ -189,10 +189,8 @@=0A=
> >=0A=
> >                 for (z =3D z0; z >=3D 0; z--) {=0A=
> >=0A=
> > -                       asm volatile("prefetchnta %0" : : "m" (dptr[z][=
d]));=0A=
> > -                       asm volatile("prefetchnta %0" : : "m" (dptr[z][=
d+32]));=0A=
> > -                       asm volatile("prefetchnta %0" : : "m" (dptr[z][=
d+64]));=0A=
> > -                       asm volatile("prefetchnta %0" : : "m" (dptr[z][=
d+96]));=0A=
> > +                       asm volatile("prefetchnta %0" : : "m" (dptr[z][=
d+128]));=0A=
> > +                       asm volatile("prefetchnta %0" : : "m" (dptr[z][=
d+192]));=0A=
=0A=
From the first look that looks strange. =0A=
=0A=
1) It will add 2 prefetches for the last blocks beyond the data. Feels like=
 bad coding.=0A=
2) The prefetch for the next block is already in the next loop (d+128)=0A=
=0A=
Maybe the prefetcher takes longer than expected. And thus the next loop=0A=
will benefit from the "relocated" hint.=0A=
=0A=
> >=0A=
> >                         asm volatile("vpcmpgtb %ymm4,%ymm1,%ymm5");=0A=
> >                         asm volatile("vpcmpgtb %ymm6,%ymm1,%ymm7");=0A=
> > --- cut here ---=0A=
> >=0A=
> > In perf, the cpu cycles goes from 5.3% to 3.0% for=0A=
> > raid6_avx24_gen_syndrome in my test and throughput increases from=0A=
> > about 8.2GB/sec to almost 10GB/sec.  It is a very "synthetic" test,=0A=
> > but the avx2 code does seem to be a factor.=0A=
> >=0A=
> > I suspect other SSE and AVX "unroll variants" have similar issues, but=
=0A=
> > I have not tested those.=0A=
> >=0A=
> > My test system is an E5-1650 v3 (single socket) with DDR4.  This might=
=0A=
> > help dual sockets even more.=0A=
> =0A=
> CC some intel folks to see if they have ideas=0A=
> --=0A=
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in=
=0A=
> the body of a message to majordomo@vger.kernel.org=0A=
> More majordomo info at  http://vger.kernel.org/majordomo-info.html=0A=
------=_NextPartTM-000-ecec331d-07cb-4ef0-be0c-f3af7f58a0b1
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-ecec331d-07cb-4ef0-be0c-f3af7f58a0b1--
