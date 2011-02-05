From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: compile (newbie)
Date: Sat, 5 Feb 2011 12:50:15 -0200
Message-ID: <AANLkTiki4NV34SsLtdhM6p8-E5Q1WqoDEdp3yjy2ACR6@mail.gmail.com>
References: <AANLkTinHswHzC5cE5cH3YtS1XMcL2FRY-Jt_Nvvq04wd@mail.gmail.com>
	<20110205170226.675850ae@notabene.brown>
	<AANLkTim-SKjqAMff0wiB+34AnLhLthH09SAeef5cP3B2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim-SKjqAMff0wiB+34AnLhLthH09SAeef5cP3B2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

what diference between raid1.ko, and raid1.o ?
sorry i'm new to kernel modules

2011/2/5 Roberto Spadim <roberto@spadim.com.br>:
> nice thanks neil
>
> 2011/2/5 NeilBrown <neilb@suse.de>:
>> On Sat, 5 Feb 2011 02:12:37 -0200 Roberto Spadim <roberto@spadim.com=
=2Ebr>
>> wrote:
>>
>>> hi, how could i compile raid1.c?
>>>
>>> i have kernel headers, kernel source, kernel binary
>>> all my md (raid1,raid5,raid0,all md options on make menuconfig) are=
 modules
>>>
>>> could i just goto md directory and
>>> gcc raid1.c
>>> ?
>>>
>>
>> =A0From the top level in the kernel tree run
>>
>> =A0make drivers/md/raid1.o
>>
>> =A0or
>> =A0make drivers/md/raid1.ko
>>
>> =A0to get a kernel module that you can load (if you are running a co=
mpatible
>> =A0kernel).
>>
>> NeilBrown
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
