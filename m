From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RAID HDDs spin up sequence
Date: Tue, 1 Feb 2011 13:46:04 -0200
Message-ID: <AANLkTimY3=hDLHvc8LBGAzPEZxy2Mc+xpLLvHjV8knbP@mail.gmail.com>
References: <20110131201823.GA15704@lazy.lzy>
	<AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com>
	<20110131222348.GA15912@lazy.lzy>
	<9EBB77E762A6744BACE68EDD6A4796990129EC0E@MX31A.corp.emc.com>
	<AANLkTimKD79Yq3zp35YsrAmVu7EXLMPQLH9YojuoTXTf@mail.gmail.com>
	<AANLkTi=B+CxNghSFTR-bQddOXPsNCeAJn4iZT7dmsasS@mail.gmail.com>
	<4D482040.1090903@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D482040.1090903@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hum that=B4s right.
maybe a power-up safe eletronic could be implemented
i don=B4t know if implementation is faster out of linux (hardware) or
inside (code)
using code is easy to port it to any hardware
maybe neil have interest in implement it in source code (i don=B4t know
if there=B4s more linux (kernel) developer here in list)

2011/2/1 John Robinson <john.robinson@anonymous.org.uk>:
> On 01/02/2011 14:44, Roberto Spadim wrote:
>>
>> try to put big capacitors and inductors on energy cable... it=B4s a =
good
>> eletric level solution... capacitor and inductors will help the star=
t
>> current/voltage oscilation
>
> No, it isn't; they'd cause excessive power draw on initial power-up.
>
> Cheers,
>
> John.
>
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
