From: Norman Schmidt <schmidt@naa.net>
Subject: still compile error
Date: Tue, 27 Sep 2005 16:57:15 +0200
Message-ID: <43395DCB.9010500@naa.net>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Unfortunately, Neils last answer didn=C2=B4t answer my compile error.

I just tried mdadm-1.9.0, it compiles well under a standard SuSE 9.3 di=
stro.

But mdadm-2.0 and mdadm-2.1 do not with the following error:

gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=3D\"/etc/mdadm.conf\"=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"   -c -o bitmap.o bitmap.=
c
bitmap.c: In function `bitmap_fd_read':
bitmap.c:130: warning: int format, different type arg (arg 3)
make: *** [bitmap.o] Error 1

Help would be appreciated.

Thanks, Norman.
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
