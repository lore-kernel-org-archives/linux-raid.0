From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: mdadm git build failure in super-intel.c
Date: Sun, 15 Apr 2012 16:49:34 +0100
Message-ID: <CADNH=7ERpaZwop536OFMBmaMJch80+87SgCZZqsa6T26-EoV4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

mdadm from git fails to build as of today:


=3D=3D> Connecting to GIT server....
Cloning into 'mdadm'...
remote: Counting objects: 202, done.
remote: Compressing objects: 100% (194/194), done.
remote: Total 202 (delta 37), reused 84 (delta 7)
Receiving objects: 100% (202/202), 517.30 KiB | 29 KiB/s, done.
Resolving deltas: 100% (37/37), done.
=3D=3D> GIT checkout done or server timeout
=3D=3D> Starting make...
Cloning into '/home/fackamato/aur/mdadm-git/src/mdadm-build'...
done.
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
mdadm.o mdadm.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
config.o config.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
policy.o policy.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
mdstat.o mdstat.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
ReadMe.o ReadMe.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
util.o util.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
maps.o maps.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
lib.o lib.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
Manage.o Manage.c
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
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
bitmap.o bitmap.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
super-mbr.o super-mbr.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
super-gpt.o super-gpt.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
restripe.o restripe.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
sysfs.o sysfs.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS
-DHAVE_STDINT_H -o sha1.o -c sha1.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
mapfile.o mapfile.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
crc32.o crc32.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
sg_io.o sg_io.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
msg.o msg.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
platform-intel.o platform-intel.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
probe_roms.o probe_roms.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
mdmon.o mdmon.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
monitor.o monitor.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS   -c -=
o
managemon.o managemon.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS
-Wl,--hash-style=3Dgnu -Wl,--as-needed -o mdadm mdadm.o config.o
policy.o mdstat.o  ReadMe.o util.o maps.o lib.o Manage.o Assemble.o
Build.o Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o
Query.o Incremental.o mdopen.o super0.o super1.o super-ddf.o
super-intel.o bitmap.o super-mbr.o super-gpt.o restripe.o sysfs.o
sha1.o mapfile.o crc32.o sg_io.o msg.o platform-intel.o probe_roms.o
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS
-Wl,--hash-style=3Dgnu -Wl,--as-needed -pthread -Wl,-z,now -o mdmon
mdmon.o monitor.o managemon.o util.o maps.o mdstat.o sysfs.o config.o
policy.o lib.o Kill.o sg_io.o dlink.o ReadMe.o super0.o super1.o
super-intel.o super-mbr.o super-gpt.o super-ddf.o sha1.o crc32.o msg.o
bitmap.o platform-intel.o probe_roms.o
rm -f mdadm.o config.o policy.o mdstat.o  ReadMe.o util.o maps.o lib.o
Manage.o Assemble.o Build.o Create.o Detail.o Examine.o Grow.o
Monitor.o dlink.o Kill.o Query.o Incremental.o mdopen.o super0.o
super1.o super-ddf.o super-intel.o bitmap.o super-mbr.o super-gpt.o
restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o
platform-intel.o probe_roms.o
gcc -DHAVE_STDINT_H -Wall -Werror -Wstrict-prototypes -Wextra
-Wno-unused-parameter -ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/dev/.mdadm\" -DMAP_FILE=3D\"map\"
-DMDMON_DIR=3D\"/dev/.mdadm\"
-DFAILED_SLOTS_DIR=3D\"/dev/.mdadm/failed-slots\" -DUSE_PTHREADS
-DMDASSEMBLE -DMDASSEMBLE_AUTO -o mdassemble mdassemble.c Assemble.c
Manage.c config.c policy.c dlink.c util.c maps.c lib.c super0.c
super1.c super-ddf.c super-intel.c sha1.c crc32.c sg_io.c mdstat.c
platform-intel.c probe_roms.c sysfs.c super-mbr.c super-gpt.c mdopen.c
 pwgr.c
super-intel.c:913:27: error: =E2=80=98num_data_stripes=E2=80=99 defined=
 but not used
[-Werror=3Dunused-function]
super-intel.c:920:13: error: =E2=80=98set_total_blocks=E2=80=99 defined=
 but not used
[-Werror=3Dunused-function]
cc1: all warnings being treated as errors
make: *** [mdassemble] Error 1
=3D=3D> ERROR: A failure occurred in build().
    Aborting...


Regards,
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
