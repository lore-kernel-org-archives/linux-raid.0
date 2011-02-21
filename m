From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 23:42:20 +0000
Message-ID: <AANLkTim8fxO3M+jEqgBHvQaxgm+MyaVz670au2wG4MkO@mail.gmail.com>
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
	<AANLkTincnob7V3ockg2nqO_ddeZ9UXdigoX5ZwVxocqH@mail.gmail.com>
	<AANLkTimrc0Sn8Mn9AM01rjgT1=4DsU6QLQoS3FA7Kn=8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimrc0Sn8Mn9AM01rjgT1=4DsU6QLQoS3FA7Kn=8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Phillip Susi <psusi@cfl.rr.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21 February 2011 23:41, Mathias Bur=C3=A9n <mathias.buren@gmail.com>=
 wrote:
> On 21 February 2011 22:52, Roberto Spadim <roberto@spadim.com.br> wro=
te:
>> i don=C2=B4t think so, since it=C2=B4s ATA command, any ATA compatib=
le can use
>> it, it could be used for HD with badblocks and dynamic reallocation
>> without problems, the harddisk don=C2=B4t need a dedicated space for
>> badblock. for md software we must know if devices support or not TRI=
M.
>>
>> the next question, md is ATA compatible? no!?, it=C2=B4s a linux dev=
ice,
>> not a ATA device. what commands linux devices allow? could md allow
>> TRIM?
>>
>> 2011/2/21 Mathias Bur=C3=A9n <mathias.buren@gmail.com>:
>>> On 21 February 2011 20:47, Phillip Susi <psusi@cfl.rr.com> wrote:
>>>> On 2/21/2011 2:39 PM, Roberto Spadim wrote:
>>>>> sorry, but i sent email without a information:
>>>>> TRIM is a 'ATA Specification' command
>>>>>
>>>>> http://en.wikipedia.org/wiki/TRIM_command
>>>>>
>>>>> any disk with ATA command could suport TRIM, hard disk or ssd or
>>>>> anyother type of phisical allocation
>>>>
>>>> Sure, but hard disks have no reason to, which is why they don't an=
d
>>>> won't support it.
>>>>
>>>
>>> My point exactly.
>>>
>>> // M
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>>
>>
>>
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>>
>
> Please don't top post.
> http://www.splitbrain.org/blog/2011-02/15-top_posting_like_dont_i_why
>
> Harddrives already have an allocated area with spare sectors, which
> they use whenever they need to. You can find out how many sectors hav=
e
> been reallocated by the HDD by looking at the SMART data, like so:
>
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FLAG =C2=A0 =C2=A0=
 VALUE WORST THRESH TYPE
> UPDATED =C2=A0WHEN_FAILED RAW_VALUE
> [...]
> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 200 =C2=A0 200 =C2=
=A0 140 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
>
> // M
>

I forgot to write that the trim command has nothing to do with bad
blocks or sectors, it's just a way of "resetting" blocks so that can
be written to without having to erase them first. (IIRC)

There is no such issue with HDDs, therefore have no benefit at all
using the trim command with them.

// M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
