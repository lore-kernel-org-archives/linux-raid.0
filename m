From: Phil Turmel <philip@turmel.org>
Subject: Re: Storage device enumeration script
Date: Wed, 25 May 2011 23:21:52 -0400
Message-ID: <4DDDC750.6040600@turmel.org>
References: <4DDDC301.7090608@turmel.org> <BANLkTiky1L9fisPnxMKsceG19LbhxcF0ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTiky1L9fisPnxMKsceG19LbhxcF0ag@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

On 05/25/2011 11:10 PM, Mathias Bur=C3=A9n wrote:
> On 26 May 2011 04:03, Phil Turmel <philip@turmel.org> wrote:
>> Hi All,
>>
>> Last November, I shared a shell script that helped me keep track of =
the specific hot-swap drives I had in the various slots of my servers. =
 Although encouraged by Roman and John, I declined to make a project ou=
t of it.
>>
>> I've since kicked it around some more, and thought a bit about suppo=
rting more than just the SCSI subsystem.  The latest and greatest is st=
ill built around some standard executables:  blkid, lspci, lsusb, sginf=
o, and smartctl.  The original was similar to "lsscsi", but with contro=
ller details and device serial numbers.
>>
>> New features:
>>        Supports non-SCSI storage devices
>>        Describes layered block devices
>>                MD raid
>>                LVM
>>                generic device mapper
>>                loop (partial)
>>        Shows UUIDs
>>        Shows mountpoints
>>        Avoids repeating subtrees when enumerating raid devices
>>
>> I struggled with the last item, until I gave up on bash.  I needed t=
o pass data to subroutines by reference, and bash is sorely lacking in =
that area.  The new script is in python.  I'm releasing this one under =
the GPL version 2.
>>
>> Please give it a whirl.
>>
>> Phil
>>
>=20
> Awesome, however:
>=20
> $ ./lsdrv.py
>   File "./lsdrv.py", line 301
>     print "%s  =E2=94=94=E2=94=80Volume Group %s (%s) %s free {%s}" %=
 (indent,
> vg.name, ','.join([dev.name for dev in vg.PVs]), vg.free, vg.uuid)
>                                                       ^
> SyntaxError: invalid syntax
>=20
> Maybe it's a copy-paste thing from my mail that does it. Could you pu=
t
> it somewhere, like a pastebin?

Yeah, should have thought of that first.

http://www.turmel.org/other/lsdrv

HTH,

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
