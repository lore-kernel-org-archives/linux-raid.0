From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: support for external persistent cache
Date: Wed, 19 Jan 2011 01:17:31 -0200
Message-ID: <AANLkTim3BJVbHdtByAni2ObUf0Qjece9jkd1_MSkT56P@mail.gmail.com>
References: <4D365551.7090207@gmail.com>
	<AANLkTimTnaHEA0+==hs7Ew0Zzvdr1EOtxEqH=EfgdN-7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimTnaHEA0+==hs7Ew0Zzvdr1EOtxEqH=EfgdN-7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Cory Coager <ccoager@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

reading again... should you use a good ups system with information
about % of batery, like a notebook?
read/write cache can be change with async or sync options on filesystem=
 mount
batery support is done with ups system
maybe with some time of use (10 years) the baterry of you ramdisk
should be replaced, will you replace it? is easier replace a ups
batery or a ramdisk specific batery?
check at internet about 12vdc atx power supply, and use a charger and
a car batery to supply power to your computer, it's a very nice
solution =3D)


2011/1/19 Roberto Spadim <roberto@spadim.com.br>:
> i think that is a fileystem cache
> not a md raid cache
> i'm right?
>
> 2011/1/19 Cory Coager <ccoager@gmail.com>:
>> I was wondering if it would be possible to add support for specifyin=
g a
>> device to use for read/write persistent cache. =A0The reason why I'm=
 asking is
>> because I see physical ram disks with battery backups available rece=
ntly.
>> =A0These ram disks are relatively cheap and could add great performa=
nce for
>> write through without the fear of data loss.
>>
>> Any interest in adding support for this?
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
