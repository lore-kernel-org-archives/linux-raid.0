From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: compile (newbie)
Date: Sat, 5 Feb 2011 15:40:37 +0000
Message-ID: <AANLkTikCx4-rEte1ohQp7D7b-dmWFhX2XVm1f-66fg_+@mail.gmail.com>
References: <AANLkTinHswHzC5cE5cH3YtS1XMcL2FRY-Jt_Nvvq04wd@mail.gmail.com>
	<20110205170226.675850ae@notabene.brown>
	<AANLkTim-SKjqAMff0wiB+34AnLhLthH09SAeef5cP3B2@mail.gmail.com>
	<AANLkTiki4NV34SsLtdhM6p8-E5Q1WqoDEdp3yjy2ACR6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTiki4NV34SsLtdhM6p8-E5Q1WqoDEdp3yjy2ACR6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: NeilBrown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 5 February 2011 14:50, Roberto Spadim <roberto@spadim.com.br> wrote:
> what diference between raid1.ko, and raid1.o ?
> sorry i'm new to kernel modules
>
> 2011/2/5 Roberto Spadim <roberto@spadim.com.br>:
>> nice thanks neil
>>
>> 2011/2/5 NeilBrown <neilb@suse.de>:
>>> On Sat, 5 Feb 2011 02:12:37 -0200 Roberto Spadim <roberto@spadim.co=
m.br>
>>> wrote:
>>>
>>>> hi, how could i compile raid1.c?
>>>>
>>>> i have kernel headers, kernel source, kernel binary
>>>> all my md (raid1,raid5,raid0,all md options on make menuconfig) ar=
e modules
>>>>
>>>> could i just goto md directory and
>>>> gcc raid1.c
>>>> ?
>>>>
>>>
>>> =C2=A0From the top level in the kernel tree run
>>>
>>> =C2=A0make drivers/md/raid1.o
>>>
>>> =C2=A0or
>>> =C2=A0make drivers/md/raid1.ko
>>>
>>> =C2=A0to get a kernel module that you can load (if you are running =
a compatible
>>> =C2=A0kernel).
>>>
>>> NeilBrown
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

http://tinyurl.com/5tyg7b3 .

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
