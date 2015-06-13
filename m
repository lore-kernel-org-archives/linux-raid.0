From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: doubts about sdd raid1 and cfs
Date: Sat, 13 Jun 2015 17:33:52 -0300
Message-ID: <CAH3kUhG3sErB6TWnafoBHMcjmExwPnBNFfCuomrZbi6uo1W9Bg@mail.gmail.com>
References: <CAH3kUhFLHdJ6T_RHaL2AyFHuH3Ta90DLhj8TKM5jZ_31mY2OCw@mail.gmail.com>
	<alpine.DEB.2.02.1506132211560.9487@uplift.swm.pp.se>
	<CAH3kUhGHPD5PhBcMzjH1iQBJgviuUa76KtAp-UVSqhwFnBpY1g@mail.gmail.com>
	<alpine.DEB.2.02.1506132223340.9487@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1506132223340.9487@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

nice :)
about the space, that was my next doubt ehhe thanks ! leave 40gb to
ssd "bad blocks"

about the writemostly, any comment?

2015-06-13 17:32 GMT-03:00 Mikael Abrahamsson <swmike@swm.pp.se>:
> On Sat, 13 Jun 2015, Roberto Spadim wrote:
>
>> hum, but what about the 850 version instead of 840?
>
>
> SSDs have been around for more than 5 years (intel released the X25-M=
 in
> 2008 according to wikipedia), TRIM has been around for 4-5 years.
>
> I have seen so many problems related to TRIM, that I will not use it =
unless
> it comes default on from a manufacturer that has tested the entire ch=
ain,
> including hardware and software (my Apple laptop for instance).
>
> We have seen TRIM not being NCQ enabled and stalling performance when=
 doing
> TRIM, we have seen firmware bugs that cause drives to lose data when =
doing
> TRIM, we have seen Linux kernel bugs that also caused loss of data.
>
> First of all, ask yourself why you want TRIM, understand how it works=
 and if
> you will benefit, do your research properly, and then enable it.
>
> Personally, I overprovision my SSDs instead:
>
> http://www.samsung.com/global/business/semiconductor/minisite/SSD/glo=
bal/html/whitepaper/whitepaper05.html
> https://en.wikipedia.org/wiki/Write_amplification#Over-provisioning
> http://www.seagate.com/gb/en/tech-insights/ssd-over-provisioning-bene=
fits-master-ti/
> http://www.edn.com/design/systems-design/4404566/Understanding-SSD-ov=
er-provisioning
> http://www.kingston.com/en/ssd/overprovisioning
>
> So I basically leave space on the drive that I don't use. In your cas=
e I
> would only partition 200GB (or even less) of that 240GB drive, and I =
would
> run it without TRIM.
>
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se



--=20
Roberto Spadim
SPAEmpresarial - Software ERP
Eng. Automa=C3=A7=C3=A3o e Controle
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
