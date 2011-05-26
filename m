From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 04:10:51 +0100
Message-ID: <BANLkTiky1L9fisPnxMKsceG19LbhxcF0ag@mail.gmail.com>
References: <4DDDC301.7090608@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDDC301.7090608@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

On 26 May 2011 04:03, Phil Turmel <philip@turmel.org> wrote:
> Hi All,
>
> Last November, I shared a shell script that helped me keep track of t=
he specific hot-swap drives I had in the various slots of my servers. =C2=
=A0Although encouraged by Roman and John, I declined to make a project =
out of it.
>
> I've since kicked it around some more, and thought a bit about suppor=
ting more than just the SCSI subsystem. =C2=A0The latest and greatest i=
s still built around some standard executables: =C2=A0blkid, lspci, lsu=
sb, sginfo, and smartctl. =C2=A0The original was similar to "lsscsi", b=
ut with controller details and device serial numbers.
>
> New features:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Supports non-SCSI storage devices
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Describes layered block devices
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MD raid
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LVM
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0generic device=
 mapper
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0loop (partial)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Shows UUIDs
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Shows mountpoints
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Avoids repeating subtrees when enumerating=
 raid devices
>
> I struggled with the last item, until I gave up on bash. =C2=A0I need=
ed to pass data to subroutines by reference, and bash is sorely lacking=
 in that area. =C2=A0The new script is in python. =C2=A0I'm releasing t=
his one under the GPL version 2.
>
> Please give it a whirl.
>
> Phil
>

Awesome, however:

$ ./lsdrv.py
  File "./lsdrv.py", line 301
    print "%s  =E2=94=94=E2=94=80Volume Group %s (%s) %s free {%s}" % (=
indent,
vg.name, ','.join([dev.name for dev in vg.PVs]), vg.free, vg.uuid)
                                                      ^
SyntaxError: invalid syntax

Maybe it's a copy-paste thing from my mail that does it. Could you put
it somewhere, like a pastebin?

cheers,
/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
