From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: mdadm -git compile error
Date: Fri, 1 Jul 2011 09:26:39 +0100
Message-ID: <BANLkTinTyMeTHha89E9pSWjoB5FVPo9Q3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Morning,

Using the git of today I see this:

 $ make
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
Assemble.o Assemble.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
Build.o Build.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
Create.o Create.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
Detail.o Detail.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
Examine.o Examine.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
Grow.o Grow.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
Monitor.o Monitor.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
dlink.o dlink.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
Kill.o Kill.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
Query.o Query.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
Incremental.o Incremental.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
mdopen.o mdopen.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
super0.o super0.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
super1.o super1.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
super-ddf.o super-ddf.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
super-intel.o super-intel.c
super-intel.c: In function =E2=80=98validate_geometry_imsm=E2=80=99:
super-intel.c:5208:8: error: passing argument 6 of
=E2=80=98validate_geometry_imsm_container=E2=80=99 makes pointer from i=
nteger without
a cast [-Werror]
super-intel.c:4715:12: note: expected =E2=80=98char *=E2=80=99 but argu=
ment is of type
=E2=80=98long long unsigned int=E2=80=99
super-intel.c:5208:8: error: passing argument 7 of
=E2=80=98validate_geometry_imsm_container=E2=80=99 from incompatible po=
inter type
[-Werror]
super-intel.c:4715:12: note: expected =E2=80=98long long unsigned int *=
=E2=80=99 but
argument is of type =E2=80=98char *=E2=80=99
super-intel.c:5208:8: error: passing argument 8 of
=E2=80=98validate_geometry_imsm_container=E2=80=99 makes integer from p=
ointer without
a cast [-Werror]
super-intel.c:4715:12: note: expected =E2=80=98int=E2=80=99 but argumen=
t is of type
=E2=80=98long long unsigned int *=E2=80=99
super-intel.c:5208:8: error: too many arguments to function
=E2=80=98validate_geometry_imsm_container=E2=80=99
super-intel.c:4715:12: note: declared here
cc1: all warnings being treated as errors

make: *** [super-intel.o] Error 1

Regards,
/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
