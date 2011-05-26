From: CoolCold <coolthecold@gmail.com>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 12:11:53 +0400
Message-ID: <BANLkTi=XSiGzXyFb6rK9Uo0JMj9iV6JM_A@mail.gmail.com>
References: <4DDDC301.7090608@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDDC301.7090608@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

May be setup some github repo for this?

On Thu, May 26, 2011 at 7:03 AM, Phil Turmel <philip@turmel.org> wrote:
> Hi All,
>
> Last November, I shared a shell script that helped me keep track of t=
he specific hot-swap drives I had in the various slots of my servers. =A0=
Although encouraged by Roman and John, I declined to make a project out=
 of it.
>
> I've since kicked it around some more, and thought a bit about suppor=
ting more than just the SCSI subsystem. =A0The latest and greatest is s=
till built around some standard executables: =A0blkid, lspci, lsusb, sg=
info, and smartctl. =A0The original was similar to "lsscsi", but with c=
ontroller details and device serial numbers.
>
> New features:
> =A0 =A0 =A0 =A0Supports non-SCSI storage devices
> =A0 =A0 =A0 =A0Describes layered block devices
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0MD raid
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0LVM
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0generic device mapper
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0loop (partial)
> =A0 =A0 =A0 =A0Shows UUIDs
> =A0 =A0 =A0 =A0Shows mountpoints
> =A0 =A0 =A0 =A0Avoids repeating subtrees when enumerating raid device=
s
>
> I struggled with the last item, until I gave up on bash. =A0I needed =
to pass data to subroutines by reference, and bash is sorely lacking in=
 that area. =A0The new script is in python. =A0I'm releasing this one u=
nder the GPL version 2.
>
> Please give it a whirl.
>
> Phil
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
