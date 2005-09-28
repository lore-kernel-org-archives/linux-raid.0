From: Norman Schmidt <schmidt@naa.net>
Subject: Re: still compile error
Date: Wed, 28 Sep 2005 21:15:56 +0200
Message-ID: <433AEBEC.2000003@naa.net>
References: <43395DCB.9010500@naa.net> <pan.2005.09.28.18.02.10.304558@sgi.com>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <pan.2005.09.28.18.02.10.304558@sgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Hanson schrieb:

>>Unfortunately, Neils last answer didn=B4t answer my compile error.
>>
>>I just tried mdadm-1.9.0, it compiles well under a standard SuSE 9.3 =
distro.
>>
>>But mdadm-2.0 and mdadm-2.1 do not with the following error:
>>
>>gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=3D\"/etc/mdadm.conf\=
"=20
>>-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"   -c -o bitmap.o bitma=
p.c
>>bitmap.c: In function `bitmap_fd_read':
>>bitmap.c:130: warning: int format, different type arg (arg 3)
>>make: *** [bitmap.o] Error 1
>>
>=20
>=20
> What platform (i386, x86_64, ...).  On my i386 SuSE Linux 9.3 system
> it compiles just fine with gcc-3.3.5-5.
>=20
> Is the system updated from YOU?

It is fully updated with manual YOU. The platform is x86_64, processor=20
is one opteron 246 with 2 GB ram.

Norman.

--=20
Norman Schmidt          Institut fuer Physikal. u. Theoret. Chemie
Dipl.-Chem. Univ.       Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg
                         IT-Systembetreuer Physikalische Chemie
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
