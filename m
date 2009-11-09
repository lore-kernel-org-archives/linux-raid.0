From: "Majed B." <majedb@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Mon, 9 Nov 2009 19:42:18 +0300
Message-ID: <70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
References: <4AF7066C.1040507@tmr.com> <70ed7c3e0911081713m7184356buadd6b102fe4755e8@mail.gmail.com>
	<f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Well, SATA uses SCSI emulation so I guess that's no problem, right?

On Mon, Nov 9, 2009 at 7:37 PM, Chris Worley <worleys@gmail.com> wrote:
> On Sun, Nov 8, 2009 at 6:13 PM, Majed B. <majedb@gmail.com> wrote:
>> The firmware which introduced the TRIM command was deemed buggy and
>> has been pulled out.
>>
>> Are there any filesystems that are TRIM-aware?
>
> Ext4 (at that level in the kernel, it's referred to as "discard", it'=
s
> not TRIM until it's issued as a SCSI command).
>
> Chris
>>
>> On Sun, Nov 8, 2009 at 8:57 PM, Bill Davidsen <davidsen@tmr.com> wro=
te:
>>> For those of us playing with use of SSD for journals on ext[34], th=
is does
>>> have implications for RAID performance.
>>>
>>> http://hardware.slashdot.org/story/09/10/27/1427209/Intel-Updates-S=
SDs-Supports-TRIM-Faster-Writes
>>>
>>> --
>>> Bill Davidsen <davidsen@tmr.com>
>>> =C2=A0Unintended results are the well-earned reward for incompetenc=
e.
>>>
>>>
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
>> =C2=A0 =C2=A0 =C2=A0 Majed B.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
