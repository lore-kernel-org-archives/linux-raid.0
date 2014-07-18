From: Samuli Suominen <ssuominen@gentoo.org>
Subject: [REGRESSION] mdadm git fails to compile with "make mdassemble" after
 0c21b485e4beb7bcfe631412a231f7c1ea1067bc
Date: Fri, 18 Jul 2014 17:09:33 +0300
Message-ID: <53C92A9D.3070009@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

The broken commit is,
http://git.neil.brown.name/?p=3Dmdadm.git;a=3Dcommit;h=3D0c21b485e4beb7=
bcfe631412a231f7c1ea1067bc

$ make mdassemble
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"
-DVERSION=3D\"3.3.1-14-g13ffbe8\" -DVERS_DATE=3D"\"17th July 2014\""
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\" -Wall -Werror -Wstrict-prototypes
-Wextra -Wno-unused-parameter -ggdb -DSendmail=3D\""/usr/sbin/sendmail
-t"\" -DCONFFILE=3D\"/etc/mdadm.conf\"
-DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=3D\"/run/mdadm\"
-DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/mdadm\"
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"
-DVERSION=3D\"3.3.1-14-g13ffbe8\" -DVERS_DATE=3D"\"17th July 2014\""
-DUSE_PTHREADS -DMDASSEMBLE -o mdassemble mdassemble.c Assemble.c
Manage.c config.c policy.c dlink.c util.c maps.c lib.c xmalloc.c
super0.c super1.c super-ddf.c super-intel.c sha1.c crc32.c sg_io.c
mdstat.c platform-intel.c probe_roms.c sysfs.c super-mbr.c super-gpt.c
pwgr.c
super-intel.c:10611:24: error: =91validate_container_imsm=92 undeclared=
 here
(not in a function)
=2Evalidate_container =3D validate_container_imsm,
^
Makefile:209: recipe for target 'mdassemble' failed
make: *** [mdassemble] Error 1

- Samuli
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
