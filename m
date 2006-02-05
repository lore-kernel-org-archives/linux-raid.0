From: Neil Brown <neilb@suse.de>
Subject: How do I find endian-conversion function on Redhar/Fedora
Date: Mon, 6 Feb 2006 09:12:46 +1100
Message-ID: <17382.30814.778053.416244@cse.unsw.edu.au>
References: <10AE6EFE-5542-4B43-8E19-87A66C4FFE6D@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Martin Ritchie on Sunday February 5
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 5, ritchiem@mac.com wrote:
>=20
> I tried to compile 2.3 but I get this error:
>=20
> $make
> gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=3D\"/etc/mdadm.conf\=
" -=20
> ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"   -c -o super0.o super0=
=2Ec
> In file included from super0.c:31:
> /usr/include/asm/byteorder.h:6:2: error: #warning using private =20
> kernel header; include <endian.h> instead!
> make: *** [super0.o] Error 1
=2E.
=2E.. including endian.h instead of byteorder.h ...
>=20
> $make
> gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=3D\"/etc/mdadm.conf\=
" -=20
> ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"   -c -o super0.o super0=
=2Ec
> cc1: warnings being treated as errors
> super0.c: In function =91add_internal_bitmap0=92:
> super0.c:737: warning: implicit declaration of function =91__cpu_to_l=
e32=92
> super0.c:742: warning: implicit declaration of function =91__cpu_to_l=
e64=92
> make: *** [super0.o] Error 1

This is starting to really annoy me, and probably bother other people
to.

mdadm needs functions to convert 16, 32, and 64 bit values between
host-endian and little-endian.  The standard 'C' library doesn't seem
to provide any.
The linux-kernel headers provide __cpu_to_leXX and __leXX_to_cpu, so I
use them.  But Redhat/Fedora seem to take this as an affront to the
rightness of things and complain, saying I should use "endian.h".=20
However on SuSE and Debian, 'endian.h' doesn't contain any function to
manipulate byte order.

So my plea for help:  Could someone with a Redhat installation please
see if there is any way to get functions that convert between little
endian and host endian, or if there is some name I can #define to
disable the 'private kernel header' warning..

Thanks.

NeilBrown

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
