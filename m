From: Wolfgang Denk <wd@denx.de>
Subject: Re: raid6check extremely slow ?
Date: Wed, 13 May 2020 08:07:53 +0200
Message-ID: <20200513060753.81496240E1A@gemini.denx.de>
References: <20200510120725.20947240E1A@gemini.denx.de> <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com> <20200511064022.591C5240E1A@gemini.denx.de> <f003a8c7-e96d-ddc3-6d1d-42a13b70e0b6@cloud.ionos.com> <20200511161415.GA8049@lazy.lzy> <23d84744-9e3c-adc1-3af1-6498b9bcf750@cloud.ionos.com> <20200512160712.GB7261@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20200512160712.GB7261@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Piergiorgio,

In message <20200512160712.GB7261@lazy.lzy> you wrote:
>
> > BTW, seems there are build problems for raid6check ...
...
> I cannot see this problem.
> I could compile without issue.
> Maybe some library is missing somewhere,
> but I'm not sure where.

I see the same problem when trying to build current to of tree
(mdadm-4.1-74-g5cfb79d):

-> make raid6check
...
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -Wimplicit-fallthrough=0 -O2 -DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" -DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM -DVERSION=\"4.1-74-g5cfb79d\" -DVERS_DATE="\"2020-04-27\"" -DUSE_PTHREADS -DBINDIR=\"/sbin\"  -o dlink.o -c dlink.c
In function "dl_strndup",
    inlined from "dl_strdup" at dlink.c:73:12:
dlink.c:66:5: error: "strncpy" output truncated before terminating nul copying as many bytes from a string as its length [-Werror=stringop-truncation]
   66 |     strncpy(n, s, l);
      |     ^~~~~~~~~~~~~~~~
dlink.c: In function "dl_strdup":
dlink.c:73:31: note: length computed here
   73 |     return dl_strndup(s, (int)strlen(s));
      |                               ^~~~~~~~~
cc1: all warnings being treated as errors


removing the "-Werror" from the CWFLAGS setting in the Makefile then
leads to:

...
gcc -O2  -o raid6check raid6check.o restripe.o sysfs.o maps.o lib.o xmalloc.o dlink.o
/usr/bin/ld: sysfs.o: in function `sysfsline':
sysfs.c:(.text+0x2707): undefined reference to `parse_uuid'
/usr/bin/ld: sysfs.c:(.text+0x271a): undefined reference to `uuid_zero'
/usr/bin/ld: sysfs.c:(.text+0x2721): undefined reference to `uuid_zero'

This might come from commit b06815989 "mdadm: load default
sysfs attributes after assemblation"; mdadm-4.1 builds ok.


Build tests were run on Fedora 32.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Calm down, it's *__only* ones and zeroes.
