From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: support for external persistent cache
Date: Wed, 19 Jan 2011 15:37:59 -0200
Message-ID: <AANLkTimOPNY+0Yq18c1x+ON1YKFgHmep0GHCgAnt9pyb@mail.gmail.com>
References: <AANLkTim3BJVbHdtByAni2ObUf0Qjece9jkd1_MSkT56P@mail.gmail.com>
	<4D365BE2.9020300@gmail.com>
	<AANLkTi=5rNxQtNsixdSYZE_XBtQR+q=WpwA_BNXp5vpr@mail.gmail.com>
	<20110119155211.GA31671@erebus.underworld.local>
	<AANLkTimP0eTReK+UH4mm67tUckV+Q=DxNXgUgvqB=4zi@mail.gmail.com>
	<20110119162941.GA32537@erebus.underworld.local>
	<AANLkTikZmu3uNjv_PehWOx6JWcTP60nVVLR_UeS_0wJi@mail.gmail.com>
	<20110119170252.GA891@erebus.underworld.local>
	<AANLkTinG9LeZOevLM1WRT-H_fgk5wTY8tmGkadrzS0pH@mail.gmail.com>
	<AANLkTimAETFguk3iThXBRt5+Kr-KkyDfBcwOphz4NeOZ@mail.gmail.com>
	<20110119172907.GA1342@erebus.underworld.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119172907.GA1342@erebus.underworld.local>
Sender: linux-raid-owner@vger.kernel.org
To: Cory Coager <ccoager@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

please check my email =3D)
let=B4s end this email?

2011/1/19 Cory Coager <ccoager@gmail.com>:
> On Wed, Jan 19, 2011 at 03:15:40PM -0200, Roberto Spadim wrote:
>> hummm....
>> thinking again.....
>>
>> what?s the today raid1 problem?
>> it?s based on minimal disk size
>> for example...
>> /dev/sda 1gb
>> /dev/sdb 1tb
>> we can have a 1gb raid only
>>
>> what you want is:
>> 1tb raid0
>> with a automatic /dev/sda to /dev/sdb write
>>
>>
>> could we call this raid0-cache?
>> i think we could implement it in raid....
>>
>> check this fuse (filesystem) implementation: http://www.furquim.org/=
chironfs/
>> it?s based on filesystem (ok it?s a raid1, not a cache like, but?s
>> limited to max filesystem size, not the minimal filesystem size... o=
k
>> it?s not secure to use it since small filesystem don?t have all
>> information, but?s nice)
>>
>> anyone want to make raid0-cache implementation?
>
> I have two comments on this.
>
> I don't think the cache device should be the same size as your
> disk storage. =A0It should be a small cache size similar to
> hardware RAID.
>
> Also, we'd need a way to flush the data from the cache device
> on bootup.
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
