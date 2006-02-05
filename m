From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Newbie questions: Max Active disks, RAID migration, Compiling
 mdadm 2.3
Date: Sat, 04 Feb 2006 18:13:02 -0800
Message-ID: <43E55F2E.1060102@h3c.com>
References: <10AE6EFE-5542-4B43-8E19-87A66C4FFE6D@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <10AE6EFE-5542-4B43-8E19-87A66C4FFE6D@mac.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Ritchie <ritchiem@mac.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


If you remove the '-Werror' it'll compile and work, but you still can't
convert a raid 0 to a raid 5. You're raid level understanding is off as
well, raid 5 is a parity block rotating around all drives, you were
thinking of raid 4 which has a single parity disk. Migrating raid 0 to
raid 4 (and vice versa) should be possible technically, but I don't
think it's implemented anywhere

You should be able to have more than 4 active drives though. I am at
this moment building an array with 6 components, I'm running a few with
more than that, and these are by no means the largest arrays that peopl=
e
are running - just examples of it working.

-Mike

Martin Ritchie wrote:
> Sorry if these are total newbie questions.
>=20
> Why can't I have more than 4 active drives in my md RAID?
>=20
> Why can't I easily migrate a RAID 0 to RAID 5. As I see it RAID 0 is=20
> just RAID 5 with a failed parity check drive?
>=20
> Perhaps this is a limitation of the old v1.11 that FC4 updates to.
>=20
> I tried to compile 2.3 but I get this error:
>=20
> $make
> gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=3D\"/etc/mdadm.conf\=
" -
> ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"   -c -o super0.o super0=
=2Ec
> In file included from super0.c:31:
> /usr/include/asm/byteorder.h:6:2: error: #warning using private  kern=
el
> header; include <endian.h> instead!
> make: *** [super0.o] Error 1
>=20
> I'm not too familiar with compiling this sort of thing. (I usually  l=
ive
> further away from the hardware and endian issues). I'm guessing  ther=
e
> is some sort of option i have to specify to say that this  should use
> the private kernel headers. Including endian.h instead  didn't help:
>=20
> $make
> gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=3D\"/etc/mdadm.conf\=
" -
> ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"   -c -o super0.o super0=
=2Ec
> cc1: warnings being treated as errors
> super0.c: In function =91add_internal_bitmap0=92:
> super0.c:737: warning: implicit declaration of function =91__cpu_to_l=
e32=92
> super0.c:742: warning: implicit declaration of function =91__cpu_to_l=
e64=92
> make: *** [super0.o] Error 1
>=20
> Oh just because I know it is going to be an issue I'm building on a=20
> Athlon 64... my first 64bit linux box so I'm sure there are going to =
 be
> gotchas that I've not thought about.
>=20
> Is there somewhere I over looked for finding this information.
>=20
> TIA

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
