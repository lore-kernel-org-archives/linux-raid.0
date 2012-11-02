From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Compilation error on today's git
Date: Fri, 2 Nov 2012 18:19:08 +0000
Message-ID: <CADNH=7G46syc+HBQmEXgHJtzy61tXu0-3GmZNuhsis9YHZ7JjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Output:

gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\"
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o
managemon.o managemon.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\"
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS
-Wl,-O1,--sort-common,--as-needed,-z,relro -o mdadm mdadm.o config.o
policy.o mdstat.o  ReadMe.o util.o maps.o lib.o Manage.o Assemble.o
Build.o Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o
Query.o Incremental.o mdopen.o super0.o super1.o super-ddf.o
super-intel.o bitmap.o super-mbr.o super-gpt.o restripe.o sysfs.o
sha1.o mapfile.o crc32.o sg_io.o msg.o xmalloc.o platform-intel.o
probe_roms.o
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\"
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS
-Wl,-O1,--sort-common,--as-needed,-z,relro -pthread -Wl,-z,now -o
mdmon mdmon.o monitor.o managemon.o util.o maps.o mdstat.o sysfs.o
config.o policy.o lib.o Kill.o sg_io.o dlink.o ReadMe.o super0.o
super1.o super-intel.o super-mbr.o super-gpt.o super-ddf.o sha1.o
crc32.o msg.o bitmap.o xmalloc.o platform-intel.o probe_roms.o
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\"
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\"
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS
-Wl,-O1,--sort-common,--as-needed,-z,relro -Wall -Werror
-Wstrict-prototypes -Wextra -Wno-unused-parameter -ggdb
-DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\"
-DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\"
-DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\"
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS
-DMDASSEMBLE -DMDASSEMBLE_AUTO -o mdassemble mdassemble.c Assemble.c
Manage.c config.c policy.c dlink.c util.c maps.c lib.c xmalloc.c
super0.c super1.c super-ddf.c super-intel.c sha1.c crc32.c sg_io.c
mdstat.c platform-intel.c probe_roms.c sysfs.c super-mbr.c super-gpt.c
mdopen.c  pwgr.c
/tmp/ccLhf8CR.o: In function `Assemble':
/home/x/aur/mdadm-git/src/mdadm-build/Assemble.c:1242: undefined
reference to `map_lock'
/home/x/aur/mdadm-git/src/mdadm-build/Assemble.c:1244: undefined
reference to `map_by_uuid'
/home/x/aur/mdadm-git/src/mdadm-build/Assemble.c:1657: undefined
reference to `map_unlock'
/tmp/ccCwcXCE.o: In function `update_super1':
/home/x/aur/mdadm-git/src/mdadm-build/super1.c:950: undefined
reference to `bitmap_sectors'
collect2: error: ld returned 1 exit status
make: *** [mdassemble] Error 1

Mathias
