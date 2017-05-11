From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Building mdadm in parallel fails
Date: Thu, 11 May 2017 11:05:05 +0200
Message-ID: <b9ef7f70-a7c6-b170-4a23-e33074893951@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear mdadm folks,


I hope this list is the correct forum to report this issue to.

Building the utility mdadm 4.0 with in parallel with 62 cores, gives the 
error below. Building with `-j1` works.

```
$ make -j62 PREFIX=/usr EPREFIX=/usr BINDIR=/usr/bin SBINDIR=/usr/sbin 
LIBEXECDIR=/usr/libexec SYSCONFDIR=/etc SHAREDSTATEDIR=/var 
LOCALSTATEDIR=/var LIBDIR=/usr/lib INCLUDEDIR=/usr/include 
DATAROOTDIR=/usr/share DATADIR=/usr/share INFODIR=/usr/share/info 
LOCALEDIR=/usr/share/locale MANDIR=/usr/share/man 
DOCDIR=/usr/share/doc/mdadm V=1 everything[…]
cc -o mdadm.Os -Wall -Werror -Wstrict-prototypes -Wextra 
-Wno-unused-parameter -ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM 
-DUSE_PTHREADS -DBINDIR=\"/usr/bin\"  -DHAVE_STDINT_H -Os mdadm.c 
config.c policy.c mdstat.c ReadMe.c util.c maps.c lib.c Manage.c 
Assemble.c Build.c Create.c Detail.c Examine.c Grow.c Monitor.c dlink.c 
Kill.c Query.c Incremental.c Dump.c mdopen.c super0.c super1.c 
super-ddf.c super-intel.c bitmap.c super-mbr.c super-gpt.c restripe.c 
sysfs.c sha1.c mapfile.c crc32.c sg_io.c msg.c xmalloc.c 
platform-intel.c probe_roms.c crc32c.c -ldl
> cc -o mdmon.O2 -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" -DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM   -DUSE_PTHREADS -DBINDIR=\"/usr/bin\"  -pthread -DHAVE_STDINT_H -O2 -D_FORTIFY_SOURCE=2 mdmon.c monitor.c managemon.c util.c maps.c mdstat.c sysfs.c policy.c lib.c Kill.c sg_io.c dlink.c ReadMe.c super-intel.c super-mbr.c super-gpt.c super-ddf.c sha1.c crc32.c msg.c bitmap.c xmalloc.c platform-intel.c probe_roms.c -ldl
sed -e 's/{DEFAULT_METADATA}/1.2/g' \
-e 's,{MAP_PATH},/run/mdadm/map,g'  mdadm.8.in > mdadm.8
man -l md.4 > md.man
man -l mdadm.conf.5 > mdadm.conf.man
man -l mdmon.8 > mdmon.man
man -l raid6check.8 > raid6check.man
man -l mdadm.8 > mdadm.man
rm -f mdadm.o config.o policy.o mdstat.o  ReadMe.o util.o maps.o lib.o 
Manage.o Assemble.o Build.o Create.o Detail.o Examine.o Grow.o Monitor.o 
dlink.o Kill.o Query.o Incremental.o Dump.o mdopen.o super0.o super1.o 
super-ddf.o super-intel.o bitmap.o super-mbr.o super-gpt.o restripe.o 
sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o xmalloc.o 
platform-intel.o probe_roms.o crc32c.o
> cc  -DBINDIR=\"/usr/bin\" -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" -DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM   -DUSE_PTHREADS -DMDASSEMBLE -DMDASSEMBLE_AUTO -static -DHAVE_STDINT_H -o mdassemble.static mdassemble.c Assemble.c Manage.c config.c policy.c dlink.c util.c maps.c lib.c xmalloc.c super0.c super1.c super-ddf.c super-intel.c sha1.c crc32.c sg_io.c mdstat.c platform-intel.c probe_roms.c sysfs.c super-mbr.c super-gpt.c mapfile.c mdopen.c pwgr.c
cc -ggdb  -o raid6check raid6check.o restripe.o sysfs.o maps.o lib.o 
xmalloc.o dlink.o
cc: error: restripe.o: No such file or directory
cc: error: sysfs.o: No such file or directory
cc: error: maps.o: No such file or directory
cc: error: lib.o: No such file or directory
cc: error: xmalloc.o: No such file or directory
cc: error: dlink.o: No such file or directory
Makefile:217: recipe for target 'raid6check' failed
make: *** [raid6check] Error 1
make: *** Waiting for unfinished jobs....
/usr/bin/ld: cannot find xmalloc.o: No such file or directory
collect2: error: ld returned 1 exit status
Makefile:214: recipe for target 'test_stripe' failed
make: *** [test_stripe] Error 1
make[1]: Leaving directory '/dev/shm/bee-joey/mdadm/mdadm-4.0-0/source'
mv mdassemble.static mdassemble.auto
```

Kind regards,

Paul
