From: Wolfgang Denk <wd@denx.de>
Subject: Re: raid6check extremely slow ?
Date: Fri, 15 May 2020 13:54:17 +0200
Message-ID: <20200515115417.BD9BA240E1A@gemini.denx.de>
References: <20200510120725.20947240E1A@gemini.denx.de> <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com> <20200511064022.591C5240E1A@gemini.denx.de> <f003a8c7-e96d-ddc3-6d1d-42a13b70e0b6@cloud.ionos.com> <20200511161415.GA8049@lazy.lzy> <23d84744-9e3c-adc1-3af1-6498b9bcf750@cloud.ionos.com> <20200512160712.GB7261@lazy.lzy> <20200513060753.81496240E1A@gemini.denx.de> <sq72pg-98v.ln1@banana.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <sq72pg-98v.ln1@banana.localnet>
Sender: linux-raid-owner@vger.kernel.org
To: "Andrey Jr. Melnikov" <temnota.am@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear "Andrey Jr. Melnikov",

In message <sq72pg-98v.ln1@banana.localnet> you wrote:
>
> > ...
> > gcc -O2  -o raid6check raid6check.o restripe.o sysfs.o maps.o lib.o xmalloc.o dlink.o
> > /usr/bin/ld: sysfs.o: in function `sysfsline':
> > sysfs.c:(.text+0x2707): undefined reference to `parse_uuid'
> > /usr/bin/ld: sysfs.c:(.text+0x271a): undefined reference to `uuid_zero'
> > /usr/bin/ld: sysfs.c:(.text+0x2721): undefined reference to `uuid_zero'
>
> raid6check miss util.o object. Add it to CHECK_OBJS

This makes things just worse.  With this, I get:

...
gcc -Wall -Wstrict-prototypes -Wextra -Wno-unused-parameter -Wimplicit-fallthrough=0 -O2 -DSendmail=\""/usr/sbin/sendmail -t"\" -DCONFFILE=\"/etc/mdadm.conf\" -DCONFFILE2=\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=\"/run/mdadm\" -DMAP_FILE=\"map\" -DMDMON_DIR=\"/run/mdadm\" -DFAILED_SLOTS_DIR=\"/run/mdadm/failed-slots\" -DNO_COROSYNC -DNO_DLM -DVERSION=\"4.1-77-g3b7aae9\" -DVERS_DATE="\"2020-05-14\"" -DUSE_PTHREADS -DBINDIR=\"/sbin\"  -o util.o -c util.c
gcc -O2  -o raid6check raid6check.o restripe.o sysfs.o maps.o lib.o xmalloc.o dlink.o util.o
/usr/bin/ld: util.o: in function `mdadm_version':
util.c:(.text+0x702): undefined reference to `Version'
/usr/bin/ld: util.o: in function `fname_from_uuid':
util.c:(.text+0xdce): undefined reference to `super1'
/usr/bin/ld: util.o: in function `is_subarray_active':
util.c:(.text+0x30b3): undefined reference to `mdstat_read'
/usr/bin/ld: util.c:(.text+0x3122): undefined reference to `free_mdstat'
/usr/bin/ld: util.o: in function `flush_metadata_updates':
util.c:(.text+0x3ad3): undefined reference to `connect_monitor'
/usr/bin/ld: util.c:(.text+0x3af1): undefined reference to `send_message'
/usr/bin/ld: util.c:(.text+0x3afb): undefined reference to `wait_reply'
/usr/bin/ld: util.c:(.text+0x3b1f): undefined reference to `ack'
/usr/bin/ld: util.c:(.text+0x3b29): undefined reference to `wait_reply'
/usr/bin/ld: util.o: in function `container_choose_spares':
util.c:(.text+0x3c84): undefined reference to `devid_policy'
/usr/bin/ld: util.c:(.text+0x3c9b): undefined reference to `pol_domain'
/usr/bin/ld: util.c:(.text+0x3caa): undefined reference to `pol_add'
/usr/bin/ld: util.c:(.text+0x3cbc): undefined reference to `domain_test'
/usr/bin/ld: util.c:(.text+0x3ccb): undefined reference to `dev_policy_free'
/usr/bin/ld: util.c:(.text+0x3d11): undefined reference to `dev_policy_free'
/usr/bin/ld: util.o: in function `set_cmap_hooks':
util.c:(.text+0x3f80): undefined reference to `dlopen'
/usr/bin/ld: util.c:(.text+0x3f9c): undefined reference to `dlsym'
/usr/bin/ld: util.c:(.text+0x3fad): undefined reference to `dlsym'
/usr/bin/ld: util.c:(.text+0x3fbe): undefined reference to `dlsym'
/usr/bin/ld: util.o: in function `set_dlm_hooks':
util.c:(.text+0x4310): undefined reference to `dlopen'
/usr/bin/ld: util.c:(.text+0x4330): undefined reference to `dlsym'
/usr/bin/ld: util.c:(.text+0x4341): undefined reference to `dlsym'
/usr/bin/ld: util.c:(.text+0x4352): undefined reference to `dlsym'
/usr/bin/ld: util.c:(.text+0x4363): undefined reference to `dlsym'
/usr/bin/ld: util.c:(.text+0x4374): undefined reference to `dlsym'
/usr/bin/ld: util.o:util.c:(.text+0x4385): more undefined references to `dlsym' follow
/usr/bin/ld: util.o: in function `set_cmap_hooks':
util.c:(.text+0x3fed): undefined reference to `dlclose'
/usr/bin/ld: util.o: in function `set_dlm_hooks':
util.c:(.text+0x43e5): undefined reference to `dlclose'
/usr/bin/ld: util.o:(.data+0x0): undefined reference to `super0'
/usr/bin/ld: util.o:(.data+0x8): undefined reference to `super1'
/usr/bin/ld: util.o:(.data+0x10): undefined reference to `super_ddf'
/usr/bin/ld: util.o:(.data+0x18): undefined reference to `super_imsm'
/usr/bin/ld: util.o:(.data+0x20): undefined reference to `mbr'
/usr/bin/ld: util.o:(.data+0x28): undefined reference to `gpt'
collect2: error: ld returned 1 exit status
make: *** [Makefile:221: raid6check] Error 1


Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Ninety-Ninety Rule of Project Schedules:
        The first ninety percent of the task takes ninety percent of
the time, and the last ten percent takes the other ninety percent.
