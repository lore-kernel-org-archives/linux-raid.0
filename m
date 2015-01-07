From: Matt Callaghan <matt_callaghan@sympatico.ca>
Subject: Unable to make mdadm from git (fatal error: ansidecl.h)
Date: Wed, 7 Jan 2015 09:41:16 -0500
Message-ID: <BLU436-SMTP110D88E7A927B5BBD9760981460@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

As per http://www.spinics.net/lists/raid/msg39353.html, I also am 
running into a recreation of RAID6 problem where the devices had 
differing offsets due to addition to an array over time (growth) in 
between mdadm upgrades... it seems I need a version of mdadm that 
supports creating an array with varying data offsets per device.

As per suggested by you:

  git clone git://neil.brown.name/mdadm -b data_offset
  cd mdadm
  make

But it failed:
{{{
In file included from super0.c:27:0:
sha1.h:29:22: fatal error: ansidecl.h: No such file or directory
compilation terminated.
}}}

full output:
{{{
fermulator@fermmy-server:/usr/local/src/mdadm/mdadm_git/mdadm$ make
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
mdadm.o mdadm.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
config.o config.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
policy.o policy.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
mdstat.o mdstat.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
ReadMe.o ReadMe.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
util.o util.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
maps.o maps.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
lib.o lib.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
Manage.o Manage.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
Assemble.o Assemble.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
Build.o Build.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
Create.o Create.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
Detail.o Detail.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
Examine.o Examine.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
Grow.o Grow.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
Monitor.o Monitor.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
dlink.o dlink.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
Kill.o Kill.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
Query.o Query.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
Incremental.o Incremental.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
mdopen.o mdopen.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter 
-ggdb -DSendmail=\""/usr/sbin/sendmail -t"\" 
-DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" 
-DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" 
-DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DUSE_PTHREADS   -c -o 
super0.o super0.c
In file included from super0.c:27:0:
sha1.h:29:22: fatal error: ansidecl.h: No such file or directory
compilation terminated.
}}}

Anything I need to do different? or is that git branch unstable atm?
