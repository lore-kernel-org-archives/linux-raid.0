From: CoolCold <coolthecold@gmail.com>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 12:24:41 +0400
Message-ID: <BANLkTik-HjxNPGON7ZEwOSKJZOBzeETeAg@mail.gmail.com>
References: <4DDDC301.7090608@turmel.org>
	<BANLkTiky1L9fisPnxMKsceG19LbhxcF0ag@mail.gmail.com>
	<4DDDC750.6040600@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDDC750.6040600@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

On Thu, May 26, 2011 at 7:21 AM, Phil Turmel <philip@turmel.org> wrote:
> On 05/25/2011 11:10 PM, Mathias Bur=C3=A9n wrote:
>> On 26 May 2011 04:03, Phil Turmel <philip@turmel.org> wrote:
>>> Hi All,
>>>
>>> Last November, I shared a shell script that helped me keep track of=
 the specific hot-swap drives I had in the various slots of my servers.=
 =C2=A0Although encouraged by Roman and John, I declined to make a proj=
ect out of it.
>>>
>>> I've since kicked it around some more, and thought a bit about supp=
orting more than just the SCSI subsystem. =C2=A0The latest and greatest=
 is still built around some standard executables: =C2=A0blkid, lspci, l=
susb, sginfo, and smartctl. =C2=A0The original was similar to "lsscsi",=
 but with controller details and device serial numbers.
>>>
>>> New features:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Supports non-SCSI storage devices
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Describes layered block devices
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MD raid
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LVM
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0generic devi=
ce mapper
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0loop (partia=
l)
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Shows UUIDs
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Shows mountpoints
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Avoids repeating subtrees when enumerati=
ng raid devices
>>>
>>> I struggled with the last item, until I gave up on bash. =C2=A0I ne=
eded to pass data to subroutines by reference, and bash is sorely lacki=
ng in that area. =C2=A0The new script is in python. =C2=A0I'm releasing=
 this one under the GPL version 2.
>>>
>>> Please give it a whirl.
>>>
>>> Phil
>>>
>>
>> Awesome, however:
>>
>> $ ./lsdrv.py
>> =C2=A0 File "./lsdrv.py", line 301
>> =C2=A0 =C2=A0 print "%s =C2=A0=E2=94=94=E2=94=80Volume Group %s (%s)=
 %s free {%s}" % (indent,
>> vg.name, ','.join([dev.name for dev in vg.PVs]), vg.free, vg.uuid)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^
>> SyntaxError: invalid syntax
>>
>> Maybe it's a copy-paste thing from my mail that does it. Could you p=
ut
>> it somewhere, like a pastebin?
>
> Yeah, should have thought of that first.
>
> http://www.turmel.org/other/lsdrv
>
> HTH,

Works in Debian Squeeze, but requires packages pciutils and sg3-utils
to be installed.

On Debian Lenny produces error:
root@gamma2:/tmp# python lsdrv
Traceback (most recent call last):
  File "lsdrv", line 17, in <module>
    import os, io, re
ImportError: No module named io


>
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
