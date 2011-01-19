From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: support for external persistent cache
Date: Wed, 19 Jan 2011 15:22:31 -0200
Message-ID: <AANLkTinyjqL0_hao+BxLc2Xxah2izt8bVYBkPVnkcG7d@mail.gmail.com>
References: <AANLkTimTnaHEA0+==hs7Ew0Zzvdr1EOtxEqH=EfgdN-7@mail.gmail.com>
	<AANLkTim3BJVbHdtByAni2ObUf0Qjece9jkd1_MSkT56P@mail.gmail.com>
	<4D365BE2.9020300@gmail.com>
	<AANLkTi=5rNxQtNsixdSYZE_XBtQR+q=WpwA_BNXp5vpr@mail.gmail.com>
	<20110119155211.GA31671@erebus.underworld.local>
	<AANLkTimP0eTReK+UH4mm67tUckV+Q=DxNXgUgvqB=4zi@mail.gmail.com>
	<20110119162941.GA32537@erebus.underworld.local>
	<AANLkTikZmu3uNjv_PehWOx6JWcTP60nVVLR_UeS_0wJi@mail.gmail.com>
	<AANLkTikCUkESU8zNLRgmDpz_wdKfDFC3YTG0R4O+5eVi@mail.gmail.com>
	<AANLkTinhFAiYYV=cm7UuYHeOsDLwSP_yVsbMPTCwcNee@mail.gmail.com>
	<20110119171922.GA1130@erebus.underworld.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119171922.GA1130@erebus.underworld.local>
Sender: linux-raid-owner@vger.kernel.org
To: Cory Coager <ccoager@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i=B4m not a good person to implement raid at kernel level, maybe at fus=
e level

neil have more time in this forum than me
neilb@suse.de

i=B4m new here =3D) hihi

i will make a new post this is very big...


2011/1/19 Cory Coager <ccoager@gmail.com>:
> On Wed, Jan 19, 2011 at 03:04:09PM -0200, Roberto Spadim wrote:
>> check:
>> Key Specifications
>>
>> =A0 =A0 * 500GB, 320GB and 250GB hard drive capacity options =A0 (ha=
rd disk
>> like, maybe 100mb/s with 7200rpm =A0 - it?s you hd disk (/dev/sda in=
 my
>> example) )
>> =A0 =A0 * 7200-RPM spindle speed
>> =A0 =A0 * 4GB SLC NAND solid state memory =A0 (SSD like, maybe 300mb=
/s =A0 -
>> it?s you ssd cache disk (/dev/sdb in my example) )
>> =A0 =A0 * 32MB of drive-level cache =A0(is it ddr3? ddr3 is 10000mb/=
s, maybe
>> less, sata is 3gb/s =A0 =A0- it?s the linux/computer ram memory)
>> =A0 =A0 * SATA 3Gb/s with Native Command Queuing (3000mb/s)
>>
>> what this disk do?
>>
>> operational system write to (hd) and read from (hd)
>>
>> hd:
>> write/read in memory
>> if not in memory, read from ssd
>> if not in ssd, read from hd
>>
>> write can be async
>> when loser energy, save memory to ssd, 32mb is fast to write, with
>> 300mb/s ssd speed you can use a super capacitor and have 1 second of
>> life...
>> after write to ssd, write to hd
>
> Sounds about right. =A0Can we make it happen?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
