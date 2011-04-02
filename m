From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Raid 5 Array
Date: Sat, 2 Apr 2011 19:04:31 -0300
Message-ID: <AANLkTikJtFb0JtS1-Je9NFXn-CRc4pi7pmYFNV7v2SEg@mail.gmail.com>
References: <BANLkTim8620MUckc+EVCWo9FCTs=65_p8Q@mail.gmail.com>
	<4D977279.30107@gmail.com>
	<BANLkTimJfUhvkpkkAH=NLJOvLL-Jotrwqg@mail.gmail.com>
	<4D97828C.8050806@gmail.com>
	<6158157523854459259@unknownmsgid>
	<20110403040113.472838d4@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110403040113.472838d4@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Simon Mcnair <simonmcnair@gmail.com>, Marcus <nexuslite@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

why use raid 5,6? raid1 isn=B4t more secure?

2011/4/2 Roman Mamedov <rm@romanrm.ru>:
> On Sat, 2 Apr 2011 22:45:58 +0100
> Simon Mcnair <simonmcnair@gmail.com> wrote:
>
>> One last thing.... I've never heard of anyone using a raid 05. Why
>> wouldn't you use a RAID50 ? =A0Please can you dish the dirt on what
>> benefit there is ? (I would have thought a raid50 would have been
>> better with no disadvantages ?). I thought that raid10 & 50 were the
>> main ones in use in 'the industry'.
>
> RAID5/6 with some RAID0 (or JBOD) members is what you use when you wa=
nt to
> include differently-sized devices into the array:
> http://louwrentius.com/blog/2008/08/building-a-raid-6-array-of-mixed-=
drives/
> --
> With respect,
> Roman
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
