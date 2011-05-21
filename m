From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm git, -Werror=unused-but-set-variable
Date: Sat, 21 May 2011 22:27:18 +1000
Message-ID: <20110521222718.55ac4bae@notabene.brown>
References: <BANLkTinf5OaDXN5KMrdP5ZOCADS=zXRwnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinf5OaDXN5KMrdP5ZOCADS=zXRwnQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?ISO-8859-1?B?QnVy6W4=?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 21 May 2011 11:20:01 +0100 Mathias Bur=C3=A9n <mathias.buren@gm=
ail.com>
wrote:

> The git as of today "fails" to compile on my Archlinux system:
>=20
> =3D=3D> Starting build()...
> =3D=3D> Fetching sources...
> Cloning into ./mdadm...
> remote: Counting objects: 9107, done.
> remote: Compressing objects: 100% (6096/6096), done.
> remote: Total 9107 (delta 6874), reused 3903 (delta 3004)
> Receiving objects: 100% (9107/9107), 2.46 MiB | 12 KiB/s, done.
> Resolving deltas: 100% (6874/6874), done.
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> mdadm.o mdadm.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> config.o config.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> policy.o policy.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> mdstat.o mdstat.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> ReadMe.o ReadMe.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> util.o util.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> maps.o maps.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> lib.o lib.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> Manage.o Manage.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> Assemble.o Assemble.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> Build.o Build.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> Create.o Create.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> Detail.o Detail.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> Examine.o Examine.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> Grow.o Grow.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> Monitor.o Monitor.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> dlink.o dlink.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> Kill.o Kill.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> Query.o Query.c
> gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
> -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
> -DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.con=
f\"
> -DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
> -DMDMON_DIR=3D\"/dev/.mdadm\"
> -DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c=
 -o
> Incremental.o Incremental.c
> Query.c: In function =E2=80=98Query=E2=80=99:
> Query.c:38:16: error: variable =E2=80=98superrno=E2=80=99 set but not=
 used
> [-Werror=3Dunused-but-set-variable]
> cc1: all warnings being treated as errors
>=20
> make: *** [Query.o] Error 1
> make: *** Waiting for unfinished jobs....
> =3D=3D> ERROR: A failure occurred in build().
>     Aborting...
>=20
> This with gcc 4.6.0.
>=20
> Regards,
> /M

Thanks for the report.
This patch will go in in the near future.
(The variable has been unused since 2005 !!!)

Thanks,
NeilBrown

diff --git a/Query.c b/Query.c
index f9857d6..0b15e28 100644
--- a/Query.c
+++ b/Query.c
@@ -35,7 +35,7 @@ int Query(char *dev)
 	int fd =3D open(dev, O_RDONLY);
 	int vers;
 	int ioctlerr;
-	int superror, superrno;
+	int superror;
 	struct mdinfo info;
 	mdu_array_info_t array;
 	struct supertype *st =3D NULL;
@@ -82,10 +82,9 @@ int Query(char *dev)
 		       array.spare_disks, array.spare_disks=3D=3D1?"":"s");
 	}
 	st =3D guess_super(fd);
-	if (st) {
+	if (st)
 		superror =3D st->ss->load_super(st, fd, dev);
-		superrno =3D errno;
-	} else
+	else
 		superror =3D -1;
 	close(fd);
 	if (superror =3D=3D 0) {
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
