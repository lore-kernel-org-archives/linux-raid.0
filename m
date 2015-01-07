From: Matt Callaghan <matt_callaghan@sympatico.ca>
Subject: Re: Unable to make mdadm from git (fatal error: ansidecl.h)
Date: Wed, 7 Jan 2015 09:47:50 -0500
Message-ID: <BLU437-SMTP2672B50CE40DDD37D20E2181460@phx.gbl>
References: <BLU436-SMTP110D88E7A927B5BBD9760981460@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP110D88E7A927B5BBD9760981460@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Turns out this functionality is available in latest mdadm 3.3.2 by using 
"--data-offset=varable" and appending the offset to each device like: 
<device_name>:<offset>. It also supports specifying in raw sectors.

-------- Original Message --------
From: Matt Callaghan <matt_callaghan@sympatico.ca>
Sent: Wed 07 Jan 2015 09:41:16 AM EST
To: linux-raid@vger.kernel.org
Cc:
Subject: Unable to make mdadm from git (fatal error: ansidecl.h)


> Hi Neil,

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
-- 
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



