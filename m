From: Jeff Hanson <jhanson@sgi.com>
Subject: Re: still compile error
Date: Thu, 29 Sep 2005 09:19:55 -0400
Message-ID: <pan.2005.09.29.13.19.52.927124@sgi.com>
References: <43395DCB.9010500@naa.net> <pan.2005.09.28.18.02.10.304558@sgi.com> <433AEBEC.2000003@naa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 28 Sep 2005 21:15:56 +0200, Norman Schmidt wrote:

> Jeff Hanson schrieb:
>=20
>>>Unfortunately, Neils last answer didn=B4t answer my compile error.
>>>
>>>I just tried mdadm-1.9.0, it compiles well under a standard SuSE 9.3=
 distro.
>>>
>>>But mdadm-2.0 and mdadm-2.1 do not with the following error:
>>>
>>>gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=3D\"/etc/mdadm.conf=
\"=20
>>>-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"   -c -o bitmap.o bitm=
ap.c
>>>bitmap.c: In function `bitmap_fd_read':
>>>bitmap.c:130: warning: int format, different type arg (arg 3)
>>>make: *** [bitmap.o] Error 1
>>>
>>=20
>>=20
>> What platform (i386, x86_64, ...).  On my i386 SuSE Linux 9.3 system
>> it compiles just fine with gcc-3.3.5-5.
>>=20
>> Is the system updated from YOU?
>=20
> It is fully updated with manual YOU. The platform is x86_64, processo=
r=20
> is one opteron 246 with 2 GB ram.

Ah - same problem on ia64 system with SLES9SP2

gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=3D\"/etc/mdadm.conf\" =
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"   -c -o bitmap.o bitmap.=
c
bitmap.c: In function `bitmap_fd_read':
bitmap.c:130: warning: int format, different type arg (arg 3)
bitmap.c:171: warning: long long unsigned int format, __u64 arg (arg 3)
bitmap.c: In function `ExamineBitmap':
bitmap.c:265: warning: long long unsigned int format, __u64 arg (arg 2)
bitmap.c:266: warning: long long unsigned int format, __u64 arg (arg 2)
bitmap.c:276: warning: long long unsigned int format, __u64 arg (arg 2)
make: *** [bitmap.o] Error 1

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
