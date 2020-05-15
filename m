From: "Andrey Jr. Melnikov" <temnota.am@gmail.com>
Subject: Re: raid6check extremely slow ?
Date: Fri, 15 May 2020 13:34:38 +0300
Message-ID: <sq72pg-98v.ln1@banana.localnet>
References: <20200510120725.20947240E1A@gemini.denx.de> <2cf55e5f-bdfb-9fef-6255-151e049ac0a1@cloud.ionos.com> <20200511064022.591C5240E1A@gemini.denx.de> <f003a8c7-e96d-ddc3-6d1d-42a13b70e0b6@cloud.ionos.com> <20200511161415.GA8049@lazy.lzy> <23d84744-9e3c-adc1-3af1-6498b9bcf750@cloud.ionos.com> <20200512160712.GB7261@lazy.lzy> <20200513060753.81496240E1A@gemini.denx.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wolfgang Denk <wd@denx.de> wrote:
> Dear Piergiorgio,

> In message <20200512160712.GB7261@lazy.lzy> you wrote:
> >
> > > BTW, seems there are build problems for raid6check ...
> ...
> > I cannot see this problem.
> > I could compile without issue.
> > Maybe some library is missing somewhere,
> > but I'm not sure where.

> ...
> gcc -O2  -o raid6check raid6check.o restripe.o sysfs.o maps.o lib.o xmalloc.o dlink.o
> /usr/bin/ld: sysfs.o: in function `sysfsline':
> sysfs.c:(.text+0x2707): undefined reference to `parse_uuid'
> /usr/bin/ld: sysfs.c:(.text+0x271a): undefined reference to `uuid_zero'
> /usr/bin/ld: sysfs.c:(.text+0x2721): undefined reference to `uuid_zero'

raid6check miss util.o object. Add it to CHECK_OBJS
