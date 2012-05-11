From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: [RFC PATCH 0/7] bcache: md conversion
Date: Sat, 12 May 2012 05:52:51 +1000
Message-ID: <CAOzFzEiTMNytGhN51G0AQ9eOspeZ0=TbXsfxStB-THSLa6PF3w@mail.gmail.com>
References: <20120511194327.25770.79292.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120511194327.25770.79292.stgit-p8uTFz9XbKgaePuBGzJMJzMJUdESFZ8XQQ4Iyu8u01E@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On 12 May 2012 05:46, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> The consensus from LSF was that bcache need not invent a new interfac=
e
> when md and dm can both do the job. =A0As mentioned in patch 7 this s=
eries
> aims to be a minimal conversion. =A0Other refactoring items like
> deprecating register_lock for mddev->reconfig_mutex are deferred.
>
> This supports assembly of an already established cache array:
>
> =A0 =A0 =A0 =A0mdadm -A /dev/md/bcache /dev/sd[ab]
>
> ...will create the /dev/md/bcache container and a subarray representi=
ng
> the cache volume. =A0"Flash-only", or backing-device only volumes wer=
e not
> tested. =A0"Create" support and hot-add/hot-remove come later.
>
> Note:
> * When attempting to test with small loopback devices (100MB), assemb=
ly
> =A0soft locks in bcache_journal_read(). =A0That hang went away with l=
arger
> =A0devices, so there seems to be minimum component device size that n=
eeds
> =A0to be considered in the tooling.
>
> ---
>
> Dan Williams (7):
> =A0 =A0 =A0bcache: compile fix
> =A0 =A0 =A0bcache: disable lockdep, enable CONFIG_BCACHE=3Dm
> =A0 =A0 =A0bcache: drop select COMPACTION
> =A0 =A0 =A0bcache: fix symlink removal
> =A0 =A0 =A0bcache: move to drivers/md/
> =A0 =A0 =A0bcache: uplevel allocation of 'cached_dev' and 'cache'
> =A0 =A0 =A0md: add bcache personality
>
>
> =A0drivers/block/Kconfig =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A02
> =A0drivers/block/Makefile =A0 =A0 =A0 =A0 =A0 | =A0 =A01
> =A0drivers/md/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 14 +
> =A0drivers/md/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A01
> =A0drivers/md/bcache/Kconfig =A0 =A0 =A0 =A0| =A0 =A03
> =A0drivers/md/bcache/Makefile =A0 =A0 =A0 | =A0 =A02
> =A0drivers/md/bcache/alloc.c =A0 =A0 =A0 =A0| =A0 =A00
> =A0drivers/md/bcache/bcache.h =A0 =A0 =A0 | =A0 39 ++++
> =A0drivers/md/bcache/bset.c =A0 =A0 =A0 =A0 | =A0 =A00
> =A0drivers/md/bcache/bset.h =A0 =A0 =A0 =A0 | =A0 =A00
> =A0drivers/md/bcache/btree.c =A0 =A0 =A0 =A0| =A0 18 --
> =A0drivers/md/bcache/btree.h =A0 =A0 =A0 =A0| =A0 =A00
> =A0drivers/md/bcache/debug.c =A0 =A0 =A0 =A0| =A0 =A00
> =A0drivers/md/bcache/debug.h =A0 =A0 =A0 =A0| =A0 =A00
> =A0drivers/md/bcache/io.c =A0 =A0 =A0 =A0 =A0 | =A0 =A00
> =A0drivers/md/bcache/journal.c =A0 =A0 =A0| =A0 =A00
> =A0drivers/md/bcache/journal.h =A0 =A0 =A0| =A0 =A00
> =A0drivers/md/bcache/md.c =A0 =A0 =A0 =A0 =A0 | =A0374 ++++++++++++++=
++++++++++++++++++++++
> =A0drivers/md/bcache/request.c =A0 =A0 =A0| =A0 24 +-
> =A0drivers/md/bcache/request.h =A0 =A0 =A0| =A0 =A00
> =A0drivers/md/bcache/stats.c =A0 =A0 =A0 =A0| =A0 =A00
> =A0drivers/md/bcache/stats.h =A0 =A0 =A0 =A0| =A0 =A00
> =A0drivers/md/bcache/super.c =A0 =A0 =A0 =A0| =A0394 +++++++++-------=
----------------------
> =A0drivers/md/bcache/sysfs.c =A0 =A0 =A0 =A0| =A0 49 -----
> =A0drivers/md/bcache/sysfs.h =A0 =A0 =A0 =A0| =A0 =A00
> =A0drivers/md/bcache/trace.c =A0 =A0 =A0 =A0| =A0 =A00
> =A0drivers/md/bcache/util.c =A0 =A0 =A0 =A0 | =A0 =A02
> =A0drivers/md/bcache/util.h =A0 =A0 =A0 =A0 | =A0 =A03
> =A0drivers/md/bcache/writeback.c =A0 =A0| =A0 =A00
> =A0kernel/lockdep.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A01
> =A030 files changed, 539 insertions(+), 388 deletions(-)
> =A0rename drivers/{block/bcache/Kconfig =3D> md/bcache/Kconfig} (95%)
> =A0rename drivers/{block/bcache/Makefile =3D> md/bcache/Makefile} (77=
%)
> =A0rename drivers/{block/bcache/alloc.c =3D> md/bcache/alloc.c} (100%=
)
> =A0rename drivers/{block/bcache/bcache.h =3D> md/bcache/bcache.h} (94=
%)
> =A0rename drivers/{block/bcache/bset.c =3D> md/bcache/bset.c} (100%)
> =A0rename drivers/{block/bcache/bset.h =3D> md/bcache/bset.h} (100%)
> =A0rename drivers/{block/bcache/btree.c =3D> md/bcache/btree.c} (99%)
> =A0rename drivers/{block/bcache/btree.h =3D> md/bcache/btree.h} (100%=
)
> =A0rename drivers/{block/bcache/debug.c =3D> md/bcache/debug.c} (100%=
)
> =A0rename drivers/{block/bcache/debug.h =3D> md/bcache/debug.h} (100%=
)
> =A0rename drivers/{block/bcache/io.c =3D> md/bcache/io.c} (100%)
> =A0rename drivers/{block/bcache/journal.c =3D> md/bcache/journal.c} (=
100%)
> =A0rename drivers/{block/bcache/journal.h =3D> md/bcache/journal.h} (=
100%)
> =A0create mode 100644 drivers/md/bcache/md.c
> =A0rename drivers/{block/bcache/request.c =3D> md/bcache/request.c} (=
98%)
> =A0rename drivers/{block/bcache/request.h =3D> md/bcache/request.h} (=
100%)
> =A0rename drivers/{block/bcache/stats.c =3D> md/bcache/stats.c} (100%=
)
> =A0rename drivers/{block/bcache/stats.h =3D> md/bcache/stats.h} (100%=
)
> =A0rename drivers/{block/bcache/super.c =3D> md/bcache/super.c} (83%)
> =A0rename drivers/{block/bcache/sysfs.c =3D> md/bcache/sysfs.c} (95%)
> =A0rename drivers/{block/bcache/sysfs.h =3D> md/bcache/sysfs.h} (100%=
)
> =A0rename drivers/{block/bcache/trace.c =3D> md/bcache/trace.c} (100%=
)
> =A0rename drivers/{block/bcache/util.c =3D> md/bcache/util.c} (99%)
> =A0rename drivers/{block/bcache/util.h =3D> md/bcache/util.h} (99%)
> =A0rename drivers/{block/bcache/writeback.c =3D> md/bcache/writeback.=
c} (100%)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

This is very interesting,

I will play around with these this weekend. :)

Joseph.

--=20
=46ounder | Director | VP Research
Orion Virtualisation Solutions=A0|=A0www.orionvm.com.au=A0| Phone: 1300=
 56
99 52 | Mobile: 0428 754 846
