From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Fri, 21 Jan 2011 18:04:22 -0200
Message-ID: <AANLkTikHek0S3GPAcHU0kKV=B+bRJWRyXWZMUQqjag2j@mail.gmail.com>
References: <20110118210112.D13A236C@gemini.denx.de>
	<4D361F26.3060507@stud.tu-ilmenau.de>
	<20110119192104.1FA92D30267@gemini.denx.de>
	<AANLkTimY8XWxnx1MZWXp2undt9J35U8vCyuCHaSF2KkJ@mail.gmail.com>
	<4D37677D.9010108@stud.tu-ilmenau.de>
	<AANLkTi=igTEuP4+NT+RFgc=k03z_qjhSWZKp_jcH1OdR@mail.gmail.com>
	<AANLkTiki_FfRrLtL3dMsrDLXeT8jNO0ndnTNpXk1OXMW@mail.gmail.com>
	<20110121193457.C7719D30268@gemini.denx.de>
	<AANLkTikFbeE=q9i2Bq7FL7+o4u2Qq4vVSnfYbwBorFOV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikFbeE=q9i2Bq7FL7+o4u2Qq4vVSnfYbwBorFOV@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: stefan.huebner@stud.tu-ilmenau.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thanks, i never used a PPC440SPe, i will buy one for hobby =3D)

2011/1/21 Roberto Spadim <roberto@spadim.com.br>:
> =3D) i know
> but, every body tell software is slower, the solution - use hardware
> ok
> there=B4s no opensource firmware for raid hardware
>
> i preffer a good software/hardware solution, linux raid is a good
> software solution for me =3D)
> but, why not try a opensource project? hehe
> what we could do.... a virtual machine :P with only raid and nfs, or
> make a dedicated cpu for raid (cpu affinity) and a portion of memory
> only for raid cache (today i think raid software don=B4t have cache, =
it
> shoudn=B4t, cache is done by linux at filesystem level, i=B4m right?)
>
>
> 2011/1/21 Wolfgang Denk <wd@denx.de>:
>> Dear Roberto,
>>
>> In message <AANLkTiki_FfRrLtL3dMsrDLXeT8jNO0ndnTNpXk1OXMW@mail.gmail=
=2Ecom> you wrote:
>>> a good idea....
>>> why not start a opensource raid controller?
>>> what we need? a cpu, memory, power supply with battery or capacitor=
,
>>> sas/sata (disk interfaces), pci-express or another (computer
>>> interface)
>>> it don=B4t need a operational system, since it will only run one pr=
ogram
>>> with some threads (ok a small operational system to implement threa=
ds
>>> easly)
>>>
>>> we could use arm, fpga, intel core2duo, atlhon, xeon, or another sy=
stem...
>>
>> You could evenuse a processor dedicated for such a job, like a
>> PPC440SPe or PPC460SX or similar, which provide hardware-offload
>> capabilities for the RAID calculations. =A0These are even supported =
by
>> drivers in mainline Linux.
>>
>> But again, thee would not helpo to maximize IOPS - goal for
>> optimization has always been maximum sequential troughput only
>> (and yes, I know exactly what I'm talking about; guess where the
>> aforementioned drivers are coming from).
>>
>> Best regards,
>>
>> Wolfgang Denk
>>
>> --
>> DENX Software Engineering GmbH, =A0 =A0 MD: Wolfgang Denk & Detlev Z=
undel
>> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, German=
y
>> Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.d=
e
>> I don't see any direct evidence ... =A0but, then, my crystal ball is=
 in
>> dire need of an ectoplasmic upgrade. :-) =A0 =A0 =A0 =A0 =A0 =A0 =A0=
-- Howard Smith
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
