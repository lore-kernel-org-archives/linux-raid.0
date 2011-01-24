From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: experience with Adaptec 1430SA
Date: Mon, 24 Jan 2011 18:19:25 -0200
Message-ID: <AANLkTinc=ijmJoxu=7xNZZGvuDQtStDA=GZWDYyR=cH4@mail.gmail.com>
References: <4D39E466.60803@cdf.toronto.edu>
	<4D3A0C11.6040106@hardwarefreak.com>
	<4D3DCE7D.8050702@cdf.toronto.edu>
	<AANLkTikzpyHj8j3LTckMgRdBRfi1GYuHJ+Sm6rPA1bRL@mail.gmail.com>
	<AANLkTi=n6QBQhpmUGxZSQYTWvEsxFUXgF0oykM-iQSid@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=n6QBQhpmUGxZSQYTWvEsxFUXgF0oykM-iQSid@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: Iordan Iordanov <iordan@cdf.toronto.edu>, Stan Hoeppner <stan@hardwarefreak.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

today i=B4m using sas 3gb/s 2x 146gb 10000rpm 2,5" hardware raid1
i want to change to ssd
what the best? i=B4m using a old sas interface (3gb/s)
maybe a sata2 3gb/s 2x ocz vertex2 120gb raid1 software(linux) could wo=
rk?

2011/1/24 Mathias Bur=E9n <mathias.buren@gmail.com>:
> On 24 January 2011 19:17, Roberto Spadim <roberto@spadim.com.br> wrot=
e:
>> hi guys, can anyone help me with a question
>> what=B4s better (more confiable) SSD SATA2 or SAS harddisk? for serv=
ers...
>>
>> 2011/1/24 Iordan Iordanov <iordan@cdf.toronto.edu>:
>>> Hi Stan,
>>>
>>> Thanks for pointing out the Rosewill card, I think we'll go for tha=
t one
>>> instead. Does anybody have something negative to say about this? We=
 will be
>>> using it with kernel 2.6.26. I'm looking mostly for:
>>>
>>> 1) Data corruption horror stories.
>>> 2) Performance limitation nightmare scenarios.
>>>
>>> Thanks!
>>> Iordan
>>>
>>> On 01/21/11 17:43, Stan Hoeppner wrote:
>>>>
>>>> Iordan Iordanov put forth on 1/21/2011 1:54 PM:
>>>>>
>>>>> Hi Guys,
>>>>>
>>>>> Has any of you used an Adaptec 1430SA, Marvell 88SX7042 based ada=
pter?
>>>>>
>>>>> Here is an example link to it:
>>>>>
>>>>> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816103105=
&cm_re=3DAdaptec_1430SA-_-16-103-105-_-Product
>>>>>
>>>>>
>>>>> What about any other Marvell 88SX7042 based adapter for that matt=
er?
>>>>
>>>> Save yourself $40 and get this PCIe x4 Rosewill card built with th=
e same
>>>> Marvell
>>>> 88SX7042:
>>>>
>>>> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816132018
>>>>
>>>> It even gives you the choice between 2 internal and 2 external por=
ts, or 4
>>>> internal ports. =A0Eat your heart out Adaptec. :)
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>>
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
> For what usage? I'd say, for best reliability, get enterprise class S=
SD SLC.
>
> // Mathias
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
