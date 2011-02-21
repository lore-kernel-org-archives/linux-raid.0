From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 19:52:46 -0300
Message-ID: <AANLkTincnob7V3ockg2nqO_ddeZ9UXdigoX5ZwVxocqH@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<4D5245DF.4020401@hardwarefreak.com>
	<iiu4rc$9ju$1@dough.gmane.org>
	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
	<iiud2r$qci$1@dough.gmane.org>
	<4D62ACFE.4020401@cfl.rr.com>
	<AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>
	<AANLkTimxTBTGupRk_1nSajjoWBstHdzVVpF4kEN3Y6XU@mail.gmail.com>
	<AANLkTikR+bKrGUCxnsnNz0vJVGOWoPiP0b618sZNBdqU@mail.gmail.com>
	<AANLkTik+xMXqA1+bM=AAhsqtCha-rDcVNr3Qkd-AmbNY@mail.gmail.com>
	<4D62CF5F.6080007@cfl.rr.com>
	<AANLkTimCU_g6hL5TX4-w6TPeFo7Wn0D+=t7iAqJ3MWcS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimCU_g6hL5TX4-w6TPeFo7Wn0D+=t7iAqJ3MWcS@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i don=B4t think so, since it=B4s ATA command, any ATA compatible can us=
e
it, it could be used for HD with badblocks and dynamic reallocation
without problems, the harddisk don=B4t need a dedicated space for
badblock. for md software we must know if devices support or not TRIM.

the next question, md is ATA compatible? no!?, it=B4s a linux device,
not a ATA device. what commands linux devices allow? could md allow
TRIM?

2011/2/21 Mathias Bur=E9n <mathias.buren@gmail.com>:
> On 21 February 2011 20:47, Phillip Susi <psusi@cfl.rr.com> wrote:
>> On 2/21/2011 2:39 PM, Roberto Spadim wrote:
>>> sorry, but i sent email without a information:
>>> TRIM is a 'ATA Specification' command
>>>
>>> http://en.wikipedia.org/wiki/TRIM_command
>>>
>>> any disk with ATA command could suport TRIM, hard disk or ssd or
>>> anyother type of phisical allocation
>>
>> Sure, but hard disks have no reason to, which is why they don't and
>> won't support it.
>>
>
> My point exactly.
>
> // M
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
