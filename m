From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: SSD - TRIM command
Date: Mon, 21 Feb 2011 18:51:50 +0000
Message-ID: <AANLkTimxTBTGupRk_1nSajjoWBstHdzVVpF4kEN3Y6XU@mail.gmail.com>
References: <AANLkTikfeH_n04iJ=5e=_G4a_GrxiWyZNJ1oCYyiBhNO@mail.gmail.com>
	<4D517F4F.4060003@gmail.com>
	<4D5245DF.4020401@hardwarefreak.com>
	<iiu4rc$9ju$1@dough.gmane.org>
	<AANLkTi=WNk3=3Jwm-YJeujcrdh-OQ4W4mJrq+YJ5Xv4k@mail.gmail.com>
	<iiud2r$qci$1@dough.gmane.org>
	<4D62ACFE.4020401@cfl.rr.com>
	<AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim6qJRZABYj4y_1sL6xq7y_w-STbaC4MK3U05ug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Phillip Susi <psusi@cfl.rr.com>, David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(please don't top post)

On 21 February 2011 18:25, Roberto Spadim <roberto@spadim.com.br> wrote=
:
> TRIM is a new feature for many hard disk/ssd
> it=C2=B4s more to get a bigger life o disk, allow a dynamic badblock
> reallocation (filesystem must tell where is empty)
>
>
> 2011/2/21 Phillip Susi <psusi@cfl.rr.com>:
>> On 2/9/2011 10:49 AM, David Brown wrote:
>>> I've been reading a little more about this. =C2=A0It seems that the=
 days of
>>> TRIM may well be numbered - the latest generation of high-end SSDs =
have
>>> more powerful garbage collection algorithms, together with more spa=
re
>>> blocks, making TRIM pretty much redundant. =C2=A0This is, of course=
, the most
>>> convenient solution for everyone (as long as it doesn't cost too mu=
ch!).
>>>
>>> The point of the TRIM command is to tell the SSD that a particular =
block
>>> is no longer being used, so that the SSD can erase it in the backgr=
ound
>>> - that way when you want to write more data, there are more free bl=
ocks
>>> ready and waiting. =C2=A0But if you've got plenty of spare blocks, =
it's easy
>>> to have them erased in advance and you don't need TRIM.
>>
>> It is not just about having free blocks ready and waiting. =C2=A0Whe=
n doing
>> wear leveling, you might find an erase block that has not been writt=
en
>> to in a long time, so you want to move that data to a more worn bloc=
k,
>> and use the less worn block for more frequently written to sectors. =
=C2=A0If
>> you know that sectors are unused because they have been TRIMed, then=
 you
>> don't have to waste time and wear copying the junk there to the new
>> flash block.
>>
>> TRIM is also quite useful for thin provisioned storage, which seems =
to
>> be getting popular.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

TRIM is not a new feature for HDDs as they don't have the problem that
SSDs have. Where did you hear this?

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
