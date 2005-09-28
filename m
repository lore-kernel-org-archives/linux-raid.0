From: Jeff Hanson <jhanson@sgi.com>
Subject: Re: still compile error
Date: Wed, 28 Sep 2005 14:02:12 -0400
Message-ID: <pan.2005.09.28.18.02.10.304558@sgi.com>
References: <43395DCB.9010500@naa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 27 Sep 2005 16:57:15 +0200, Norman Schmidt wrote:

> Unfortunately, Neils last answer didn=B4t answer my compile error.
>=20
> I just tried mdadm-1.9.0, it compiles well under a standard SuSE 9.3 =
distro.
>=20
> But mdadm-2.0 and mdadm-2.1 do not with the following error:
>=20
> gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=3D\"/etc/mdadm.conf\=
"=20
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"   -c -o bitmap.o bitma=
p.c
> bitmap.c: In function `bitmap_fd_read':
> bitmap.c:130: warning: int format, different type arg (arg 3)
> make: *** [bitmap.o] Error 1
>=20

What platform (i386, x86_64, ...).  On my i386 SuSE Linux 9.3 system
it compiles just fine with gcc-3.3.5-5.

Is the system updated from YOU?
--=20
-----------------------------------------------------------------------
Jeff Hanson - jhanson@sgi.com - Field Technical Analyst

You can choose a ready guide in some celestial voice.=20
If you choose not to decide, you still have made a choice.=20
You can choose from phantom fears and kindness that can kill;=20
I will choose a path that's clear=20
I will choose freewill. - Lee/Lifeson/Peart


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
