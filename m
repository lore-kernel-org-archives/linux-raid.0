From: David Haring <david.haring@billboard.cz>
Subject: Re: partitions on software-raid
Date: Tue, 16 Dec 2003 22:29:56 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FDF7954.9050805@billboard.cz>
References: <3FDF285D.806@ratnet.stw.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FDF285D.806@ratnet.stw.uni-erlangen.de>
To: schmidt@naa.net
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Norman Schmidt wrote:
> Hi!
>=20
> Since noone has answered my last question yet:
>=20
> Has anyone ever used partitions on a md device? It is possible to mak=
e=20
> them with fdisk, and fdisk shows their names as /dev/md0p1 (eg.). The=
y=20
> are also shown in the partition table. But there are no /dev entries.

I think it is possible, but it is nonstandard feature
(Neil Brown maintains patches for 2.4)

> There are very few google hits, but no successful tries are documente=
d.
>=20
> Is this functionality implemented yet? I do not understand much C, so=
 I=20
> gave up on understanding md.c in the kernel source tree. In the=20
> up-to-date list of major and minor numbers, there are no entries=20
> concerning partitions on md devices.
>=20
> I think Neil Brown stated somewhere on this list that there could be =
up=20
> to 15 partitions for up to 16 md devices, but I don=B4t remember, cou=
ldn=B4t=20
> find it, and I don=B4t know wether he told how to make the devices or=
=20
> mount those partitions.

see Neil's patches at
http://cgi.cse.unsw.edu.au/~neilb/patches/linux-stable/2.4.leading/2003=
-01-06:00/016MdPart
http://cgi.cse.unsw.edu.au/~neilb/patches/linux-stable/2.4.leading/2003=
-01-06:00/017MdpMajor

David Haring


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
