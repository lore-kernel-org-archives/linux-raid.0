From: Martin Ritchie <ritchiem@mac.com>
Subject: Newbie questions: Max Active disks, RAID migration, Compiling mdadm 2.3
Date: Sun, 5 Feb 2006 00:47:04 +0000
Message-ID: <10AE6EFE-5542-4B43-8E19-87A66C4FFE6D@mac.com>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=WINDOWS-1252;
	delsp=yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry if these are total newbie questions.

Why can't I have more than 4 active drives in my md RAID?

Why can't I easily migrate a RAID 0 to RAID 5. As I see it RAID 0 is =20
just RAID 5 with a failed parity check drive?

Perhaps this is a limitation of the old v1.11 that FC4 updates to.

I tried to compile 2.3 but I get this error:

$make
gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=3D\"/etc/mdadm.conf\" =
-=20
ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"   -c -o super0.o super0.c
In file included from super0.c:31:
/usr/include/asm/byteorder.h:6:2: error: #warning using private =20
kernel header; include <endian.h> instead!
make: *** [super0.o] Error 1

I'm not too familiar with compiling this sort of thing. (I usually =20
live further away from the hardware and endian issues). I'm guessing =20
there is some sort of option i have to specify to say that this =20
should use the private kernel headers. Including endian.h instead =20
didn't help:

$make
gcc -Wall -Werror -Wstrict-prototypes -DCONFFILE=3D\"/etc/mdadm.conf\" =
-=20
ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"   -c -o super0.o super0.c
cc1: warnings being treated as errors
super0.c: In function =91add_internal_bitmap0=92:
super0.c:737: warning: implicit declaration of function =91__cpu_to_le3=
2=92
super0.c:742: warning: implicit declaration of function =91__cpu_to_le6=
4=92
make: *** [super0.o] Error 1

Oh just because I know it is going to be an issue I'm building on a =20
Athlon 64... my first 64bit linux box so I'm sure there are going to =20
be gotchas that I've not thought about.

Is there somewhere I over looked for finding this information.

TIA
--=20
Martin

"What we do in life, echoes in Eternity."
-Maximus Decimus Meridius



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
