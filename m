From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: md extension to support booting from raid whole disks.
Date: Sat, 09 May 2009 09:20:30 +0200
Message-ID: <4A052EBE.5010605@rabbit.us>
References: <49F68CE0.2010906@zytor.com> <1240963225.18303.858.camel@ezra>	<49F7997C.2070808@zytor.com> <1240964410.18303.895.camel@ezra>	<49F79F26.9060309@zytor.com> <1240965831.18303.944.camel@ezra>	<20090429064333.GB9372@boogie.lpds.sztaki.hu>	<87hc04leau.fsf@frosties.localdomain>	<1241217394.4418.4.camel@poledra.romunt.nl>	<1241226246.4862.24.camel@ezra>	<6c4602af0905021002i6fb0e667mdde8fb589f34ead6@mail.gmail.com> <87ab5n45dc.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ab5n45dc.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Micha Przyuski <mikylie@gmail.com>, Daniel Reurich <daniel@centurion.net.nz>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> Micha=C2=B3 Przy=C2=B3uski <mikylie@gmail.com> writes:
>=20
>=20
> The point was not to add redundancy but to remove complexity.
>=20
> Just look at what you need to do for the next generation of disks
> (>2TB):
>=20
> - Create a MS Dos partition table with a fake /boot partition in the
>   first 2TB.
> - Create a GPT table with a matching /boot partition and the rest
> - Create a raid1 for /boot
> - Create a raidX for the rest
>=20
> Now you have to watch 2 raids and add/remove partitions from 2 raids,
> You also need to copy the bootloader to every new disk you add.
>=20
> The idea is to bring this down to:
>=20
> - Create raidX over all disks
>=20
>> it a hidden raid1 over first few sectors is just creating an
>> automation that gains nothing and makes things unnecessarily
>> complicated inside.
>=20
> If the hidden raid1 is just reserved space that is considered part of
> the raid metadata then this moves completly into mdadm userspace. The
> extra complexity comes down to "read reserved space from old disk,
> write reserved space to new disk". In the most basic form that is 3
> lines of code (declare buffer, read, write).
>=20

This is the best description of the problem/benefit so far. Also when
deciding on the size of the reserved space, factor in possible
bitmap size explosion when moving from say a 4x300G raid6 to a 4x2T rai=
d6.

+1 on this feature request

Cheers
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
