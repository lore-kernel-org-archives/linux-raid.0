From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: experience with Adaptec 1430SA
Date: Mon, 24 Jan 2011 19:45:13 +0000
Message-ID: <AANLkTi=n6QBQhpmUGxZSQYTWvEsxFUXgF0oykM-iQSid@mail.gmail.com>
References: <4D39E466.60803@cdf.toronto.edu>
	<4D3A0C11.6040106@hardwarefreak.com>
	<4D3DCE7D.8050702@cdf.toronto.edu>
	<AANLkTikzpyHj8j3LTckMgRdBRfi1GYuHJ+Sm6rPA1bRL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikzpyHj8j3LTckMgRdBRfi1GYuHJ+Sm6rPA1bRL@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Iordan Iordanov <iordan@cdf.toronto.edu>, Stan Hoeppner <stan@hardwarefreak.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 24 January 2011 19:17, Roberto Spadim <roberto@spadim.com.br> wrote:
> hi guys, can anyone help me with a question
> what=C2=B4s better (more confiable) SSD SATA2 or SAS harddisk? for se=
rvers...
>
> 2011/1/24 Iordan Iordanov <iordan@cdf.toronto.edu>:
>> Hi Stan,
>>
>> Thanks for pointing out the Rosewill card, I think we'll go for that=
 one
>> instead. Does anybody have something negative to say about this? We =
will be
>> using it with kernel 2.6.26. I'm looking mostly for:
>>
>> 1) Data corruption horror stories.
>> 2) Performance limitation nightmare scenarios.
>>
>> Thanks!
>> Iordan
>>
>> On 01/21/11 17:43, Stan Hoeppner wrote:
>>>
>>> Iordan Iordanov put forth on 1/21/2011 1:54 PM:
>>>>
>>>> Hi Guys,
>>>>
>>>> Has any of you used an Adaptec 1430SA, Marvell 88SX7042 based adap=
ter?
>>>>
>>>> Here is an example link to it:
>>>>
>>>> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816103105&=
cm_re=3DAdaptec_1430SA-_-16-103-105-_-Product
>>>>
>>>>
>>>> What about any other Marvell 88SX7042 based adapter for that matte=
r?
>>>
>>> Save yourself $40 and get this PCIe x4 Rosewill card built with the=
 same
>>> Marvell
>>> 88SX7042:
>>>
>>> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816132018
>>>
>>> It even gives you the choice between 2 internal and 2 external port=
s, or 4
>>> internal ports. =C2=A0Eat your heart out Adaptec. :)
>>>
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


=46or what usage? I'd say, for best reliability, get enterprise class S=
SD SLC.

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
