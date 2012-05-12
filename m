From: Jack Wang <jack.wang.usish-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [mdadm PATCH] bcache: add bcache superblock
Date: Sat, 12 May 2012 15:38:03 +0800
Message-ID: <CA+res+QPV1zpJ6maCFhfiGLAtyZYkLgyPmw_Q-Bk4td2+kO1xw@mail.gmail.com>
References: <20120511203835.26301.1937.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120511203835.26301.1937.stgit-p8uTFz9XbKgaePuBGzJMJzMJUdESFZ8XQQ4Iyu8u01E@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Hi Dan,

So this is the alternate interface for bcache tools using mdadm to
manage bcache?
If so, could you give a example of how to using this.

Best regards.

Jack

2012/5/12 Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>:
> This is a hybrid proposal for supporting bcache as a md device.
> Somewhat similar to the v1.x metadata format, where array assembly is
> handled in userspace, but managed in the kernel. =C2=A0In the bcache =
case it
> is an "external" metadata format, but then the expectation is that th=
e
> kernel "bcache" personality takes over runtime maintenance of the
> metadata.
>
> The container id for bcache is the "cache_set". =C2=A0The subvolume i=
s the
> backing device identifier.
>
> This initial version only supports the runtime static portion of the
> superblock, it will need to grow the ability to read the journal to
> report the backing devices associated with a given cache set (i.e. in
> the superblock backing devices know their cache_set container, but ca=
che
> devices need to look elsewhere to find their backing devices).
>
> Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> =C2=A0Assemble.c =C2=A0 =C2=A0 | =C2=A0 =C2=A01
> =C2=A0Makefile =C2=A0 =C2=A0 =C2=A0 | =C2=A0 11 +
> =C2=A0bcache.h =C2=A0 =C2=A0 =C2=A0 | =C2=A0 98 +++++++++
> =C2=A0crc64.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0129 +++++++++++
> =C2=A0maps.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A02
> =C2=A0mdadm.h =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A02
> =C2=A0super-bcache.c | =C2=A0634 ++++++++++++++++++++++++++++++++++++=
++++++++++++++++++++
> =C2=A0util.c =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A02
> =C2=A08 files changed, 873 insertions(+), 6 deletions(-)
> =C2=A0create mode 100644 bcache.h
> =C2=A0create mode 100644 crc64.c
> =C2=A0create mode 100644 super-bcache.c
>
> diff --git a/Assemble.c b/Assemble.c
> index fd94461..267a2ce 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1594,6 +1594,7 @@ int assemble_container_content(struct supertype=
 *st, int mdfd,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else switch(=
content->array.level) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case LEVEL_LIN=
EAR:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case LEVEL_MUL=
TIPATH:
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case LEVEL_BCACHE:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case 0:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0err =3D sysfs_set_str(content, NULL, "array_state",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0"active");
> diff --git a/Makefile b/Makefile
> index b8d363f..7886d13 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -103,8 +103,8 @@ OBJS =3D =C2=A0mdadm.o config.o policy.o mdstat.o=
 =C2=A0ReadMe.o util.o maps.o lib.o \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Create.o Detail.o Examine.o Grow.o Monitor=
=2Eo dlink.o Kill.o Query.o \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Incremental.o \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0mdopen.o super0.o super1.o super-ddf.o sup=
er-intel.o bitmap.o \
> - =C2=A0 =C2=A0 =C2=A0 super-mbr.o super-gpt.o \
> - =C2=A0 =C2=A0 =C2=A0 restripe.o sysfs.o sha1.o mapfile.o crc32.o sg=
_io.o msg.o \
> + =C2=A0 =C2=A0 =C2=A0 super-mbr.o super-gpt.o super-bcache.o \
> + =C2=A0 =C2=A0 =C2=A0 restripe.o sysfs.o sha1.o mapfile.o crc32.o cr=
c64.o sg_io.o msg.o \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0platform-intel.o probe_roms.o
>
> =C2=A0CHECK_OBJS =3D restripe.o sysfs.o maps.o lib.o
> @@ -116,8 +116,8 @@ INCL =3D mdadm.h part.h bitmap.h
> =C2=A0MON_OBJS =3D mdmon.o monitor.o managemon.o util.o maps.o mdstat=
=2Eo sysfs.o \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0config.o policy.o lib.o \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Kill.o sg_io.o dlink.o ReadMe.o super0.o s=
uper1.o super-intel.o \
> - =C2=A0 =C2=A0 =C2=A0 super-mbr.o super-gpt.o \
> - =C2=A0 =C2=A0 =C2=A0 super-ddf.o sha1.o crc32.o msg.o bitmap.o \
> + =C2=A0 =C2=A0 =C2=A0 super-mbr.o super-gpt.o super-bcache.o \
> + =C2=A0 =C2=A0 =C2=A0 super-ddf.o sha1.o crc32.o crc64.o msg.o bitma=
p.o \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0platform-intel.o probe_roms.o
>
> =C2=A0MON_SRCS =3D $(patsubst %.o,%.c,$(MON_OBJS))
> @@ -128,7 +128,8 @@ STATICOBJS =3D pwgr.o
> =C2=A0ASSEMBLE_SRCS :=3D mdassemble.c Assemble.c Manage.c config.c po=
licy.c dlink.c util.c \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0maps.c lib.c \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0super0.c super1.c super-ddf.c super-intel.=
c sha1.c crc32.c sg_io.c mdstat.c \
> - =C2=A0 =C2=A0 =C2=A0 platform-intel.c probe_roms.c sysfs.c super-mb=
r.c super-gpt.c
> + =C2=A0 =C2=A0 =C2=A0 platform-intel.c probe_roms.c sysfs.c super-mb=
r.c super-gpt.c \
> + =C2=A0 =C2=A0 =C2=A0 super-bcache.c crc64.c
> =C2=A0ASSEMBLE_AUTO_SRCS :=3D mdopen.c
> =C2=A0ASSEMBLE_FLAGS:=3D $(CFLAGS) -DMDASSEMBLE
> =C2=A0ifdef MDASSEMBLE_AUTO
> diff --git a/bcache.h b/bcache.h
> new file mode 100644
> index 0000000..765e369
> --- /dev/null
> +++ b/bcache.h
> @@ -0,0 +1,98 @@
> +#ifndef _BCACHE_H
> +#define _BCACHE_H
> +
> +#include <stdint.h>
> +
> +#define BITMASK(name, type, field, offset, size) =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \
> +static inline uint64_t name(const type *k) =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \
> +{ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0\
> + =C2=A0 =C2=A0 =C2=A0 uint64_t field =3D __le64_to_cpu(k->field); =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \
> + =C2=A0 =C2=A0 =C2=A0 return (field >> offset) & ~(((uint64_t) ~0) <=
< size); =C2=A0\
> +} =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0\
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 \
> +static inline void SET_##name(type *k, uint64_t v) =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 \
> +{ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0\
> + =C2=A0 =C2=A0 =C2=A0 uint64_t field =3D __le64_to_cpu(k->field); =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \
> + =C2=A0 =C2=A0 =C2=A0 field &=3D ~(~((uint64_t) ~0 << size) << offse=
t); =C2=A0 =C2=A0 =C2=A0 =C2=A0 \
> + =C2=A0 =C2=A0 =C2=A0 field |=3D v << offset; =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 \
> + =C2=A0 =C2=A0 =C2=A0 k->field =3D __cpu_to_le64(field); =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\
> +}
> +
> +static const char bcache_magic[] =3D {
> + =C2=A0 =C2=A0 =C2=A0 0xc6, 0x85, 0x73, 0xf6, 0x4e, 0x1a, 0x45, 0xca=
,
> + =C2=A0 =C2=A0 =C2=A0 0x82, 0x65, 0xf5, 0x7f, 0x48, 0xba, 0x6d, 0x81=
 };
> +
> +/* Version 1: Backing dev
> + * Version 2: Seed pointer into btree node checksum
> + * Version 3: Backing dev superblock has offset of start of data
> + */
> +
> +#define BCACHE_SB_BDEV_VERSION 3
> +#define BCACHE_SB_MAX_VERSION =C2=A03
> +
> +#define SB_SECTOR =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A08
> +#define SB_SIZE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A016 /* default data_offset in bcache-tool=
s (?) */
> +#define SB_LABEL_SIZE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A032
> +
> +struct cache_sb {
> + =C2=A0 =C2=A0 =C2=A0 uint64_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0csum;
> + =C2=A0 =C2=A0 =C2=A0 uint64_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0offset; /* sector where this sb was written */
> + =C2=A0 =C2=A0 =C2=A0 uint64_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0version;
> +#define CACHE_BACKING_DEV =C2=A0 =C2=A0 =C2=A01
> +
> + =C2=A0 =C2=A0 =C2=A0 uint8_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 magic[16];
> +
> + =C2=A0 =C2=A0 =C2=A0 uint8_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 uuid[16];
> + =C2=A0 =C2=A0 =C2=A0 union {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uint8_t =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 set_uuid[16];
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 uint64_t =C2=A0 =C2=
=A0 =C2=A0 =C2=A0set_magic;
> + =C2=A0 =C2=A0 =C2=A0 };
> + =C2=A0 =C2=A0 =C2=A0 uint8_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 label[SB_LABEL_SIZE];
> +
> + =C2=A0 =C2=A0 =C2=A0 uint64_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0flags;
> + =C2=A0 =C2=A0 =C2=A0 uint64_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0seq;
> + =C2=A0 =C2=A0 =C2=A0 uint64_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0pad[8];
> +
> + =C2=A0 =C2=A0 =C2=A0 uint64_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0nbuckets; =C2=A0 =C2=A0 =C2=A0 /* device size */
> + =C2=A0 =C2=A0 =C2=A0 uint16_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0block_size; =C2=A0 =C2=A0 /* sectors */
> + =C2=A0 =C2=A0 =C2=A0 uint16_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0bucket_size; =C2=A0 =C2=A0/* sectors */
> +
> + =C2=A0 =C2=A0 =C2=A0 uint16_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0nr_in_set;
> + =C2=A0 =C2=A0 =C2=A0 uint16_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0nr_this_dev;
> +
> + =C2=A0 =C2=A0 =C2=A0 uint32_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0last_mount; =C2=A0 =C2=A0 /* time_t */
> +
> + =C2=A0 =C2=A0 =C2=A0 uint16_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0first_bucket;
> + =C2=A0 =C2=A0 =C2=A0 uint16_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0keys; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* number of =
journal buckets */
> + =C2=A0 =C2=A0 =C2=A0 uint64_t =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0d[]; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* journ=
al buckets */
> +};
> +
> +static inline int SB_BDEV(struct cache_sb *c)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return __le64_to_cpu(c->version) =3D=3D CACHE_=
BACKING_DEV;
> +}
> +
> +BITMASK(CACHE_SYNC, =C2=A0 =C2=A0 struct cache_sb, flags, 0, 1);
> +BITMASK(CACHE_DISCARD, struct cache_sb, flags, 1, 1);
> +BITMASK(CACHE_REPLACEMENT, struct cache_sb, flags, 2, 3);
> +
> +BITMASK(BDEV_CACHE_MODE, =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cache_sb,=
 flags, 0, 4);
> +#define CACHE_MODE_WRITETHROUGH 0U
> +#define CACHE_MODE_WRITEBACK =C2=A0 =C2=A01U
> +#define CACHE_MODE_WRITEAROUND =C2=A02U
> +#define CACHE_MODE_NONE =C2=A0 =C2=A0 =C2=A0 =C2=A0 3U
> +BITMASK(BDEV_STATE, =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct=
 cache_sb, flags, 61, 2);
> +#define BDEV_STATE_NONE =C2=A0 =C2=A0 =C2=A0 =C2=A0 0U
> +#define BDEV_STATE_CLEAN =C2=A0 =C2=A0 =C2=A0 =C2=A01U
> +#define BDEV_STATE_DIRTY =C2=A0 =C2=A0 =C2=A0 =C2=A02U
> +#define BDEV_STATE_STALE =C2=A0 =C2=A0 =C2=A0 =C2=A03U
> +
> +inline uint64_t crc64(const void *_data, size_t len);
> +
> +#define node(i, j) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((void =
*) ((i)->d + (j)))
> +#define end(i) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 node(i, (i)->keys)
> +
> +#define csum_set(i) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\
> + =C2=A0 =C2=A0 =C2=A0 crc64(((void *) (i)) + 8, ((void *) end(i)) - =
(((void *) (i)) + 8))
> +
> +#endif
> diff --git a/crc64.c b/crc64.c
> new file mode 100644
> index 0000000..8f37445
> --- /dev/null
> +++ b/crc64.c
> @@ -0,0 +1,129 @@
> +#define _GNU_SOURCE
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdint.h>
> +#include <unistd.h>
> +
> +/*
> + * Portions Copyright (c) 1996-2001, PostgreSQL Global Development G=
roup (Any
> + * use permitted, subject to terms of PostgreSQL license; see.)
> +
> + * If we have a 64-bit integer type, then a 64-bit CRC looks just li=
ke the
> + * usual sort of implementation. (See Ross Williams' excellent intro=
duction
> + * A PAINLESS GUIDE TO CRC ERROR DETECTION ALGORITHMS, available fro=
m
> + * ftp://ftp.rocksoft.com/papers/crc_v3.txt or several other net sit=
es.)
> + * If we have no working 64-bit type, then fake it with two 32-bit r=
egisters.
> + *
> + * The present implementation is a normal (not "reflected", in Willi=
ams'
> + * terms) 64-bit CRC, using initial all-ones register contents and a=
 final
> + * bit inversion. The chosen polynomial is borrowed from the DLT1 sp=
ec
> + * (ECMA-182, available from http://www.ecma.ch/ecma1/STAND/ECMA-182=
=2EHTM):
> + *
> + * x^64 + x^62 + x^57 + x^55 + x^54 + x^53 + x^52 + x^47 + x^46 + x^=
45 +
> + * x^40 + x^39 + x^38 + x^37 + x^35 + x^33 + x^32 + x^31 + x^29 + x^=
27 +
> + * x^24 + x^23 + x^22 + x^21 + x^19 + x^17 + x^13 + x^12 + x^10 + x^=
9 +
> + * x^7 + x^4 + x + 1
> +*/
> +
> +static const uint64_t crc_table[256] =3D {
> + =C2=A0 =C2=A0 =C2=A0 0x0000000000000000ULL, 0x42F0E1EBA9EA3693ULL, =
0x85E1C3D753D46D26ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xC711223CFA3E5BB5ULL, 0x493366450E42ECDFULL, =
0x0BC387AEA7A8DA4CULL,
> + =C2=A0 =C2=A0 =C2=A0 0xCCD2A5925D9681F9ULL, 0x8E224479F47CB76AULL, =
0x9266CC8A1C85D9BEULL,
> + =C2=A0 =C2=A0 =C2=A0 0xD0962D61B56FEF2DULL, 0x17870F5D4F51B498ULL, =
0x5577EEB6E6BB820BULL,
> + =C2=A0 =C2=A0 =C2=A0 0xDB55AACF12C73561ULL, 0x99A54B24BB2D03F2ULL, =
0x5EB4691841135847ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x1C4488F3E8F96ED4ULL, 0x663D78FF90E185EFULL, =
0x24CD9914390BB37CULL,
> + =C2=A0 =C2=A0 =C2=A0 0xE3DCBB28C335E8C9ULL, 0xA12C5AC36ADFDE5AULL, =
0x2F0E1EBA9EA36930ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x6DFEFF5137495FA3ULL, 0xAAEFDD6DCD770416ULL, =
0xE81F3C86649D3285ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xF45BB4758C645C51ULL, 0xB6AB559E258E6AC2ULL, =
0x71BA77A2DFB03177ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x334A9649765A07E4ULL, 0xBD68D2308226B08EULL, =
0xFF9833DB2BCC861DULL,
> + =C2=A0 =C2=A0 =C2=A0 0x388911E7D1F2DDA8ULL, 0x7A79F00C7818EB3BULL, =
0xCC7AF1FF21C30BDEULL,
> + =C2=A0 =C2=A0 =C2=A0 0x8E8A101488293D4DULL, 0x499B3228721766F8ULL, =
0x0B6BD3C3DBFD506BULL,
> + =C2=A0 =C2=A0 =C2=A0 0x854997BA2F81E701ULL, 0xC7B97651866BD192ULL, =
0x00A8546D7C558A27ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x4258B586D5BFBCB4ULL, 0x5E1C3D753D46D260ULL, =
0x1CECDC9E94ACE4F3ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xDBFDFEA26E92BF46ULL, 0x990D1F49C77889D5ULL, =
0x172F5B3033043EBFULL,
> + =C2=A0 =C2=A0 =C2=A0 0x55DFBADB9AEE082CULL, 0x92CE98E760D05399ULL, =
0xD03E790CC93A650AULL,
> + =C2=A0 =C2=A0 =C2=A0 0xAA478900B1228E31ULL, 0xE8B768EB18C8B8A2ULL, =
0x2FA64AD7E2F6E317ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x6D56AB3C4B1CD584ULL, 0xE374EF45BF6062EEULL, =
0xA1840EAE168A547DULL,
> + =C2=A0 =C2=A0 =C2=A0 0x66952C92ECB40FC8ULL, 0x2465CD79455E395BULL, =
0x3821458AADA7578FULL,
> + =C2=A0 =C2=A0 =C2=A0 0x7AD1A461044D611CULL, 0xBDC0865DFE733AA9ULL, =
0xFF3067B657990C3AULL,
> + =C2=A0 =C2=A0 =C2=A0 0x711223CFA3E5BB50ULL, 0x33E2C2240A0F8DC3ULL, =
0xF4F3E018F031D676ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xB60301F359DBE0E5ULL, 0xDA050215EA6C212FULL, =
0x98F5E3FE438617BCULL,
> + =C2=A0 =C2=A0 =C2=A0 0x5FE4C1C2B9B84C09ULL, 0x1D14202910527A9AULL, =
0x93366450E42ECDF0ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xD1C685BB4DC4FB63ULL, 0x16D7A787B7FAA0D6ULL, =
0x5427466C1E109645ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x4863CE9FF6E9F891ULL, 0x0A932F745F03CE02ULL, =
0xCD820D48A53D95B7ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x8F72ECA30CD7A324ULL, 0x0150A8DAF8AB144EULL, =
0x43A04931514122DDULL,
> + =C2=A0 =C2=A0 =C2=A0 0x84B16B0DAB7F7968ULL, 0xC6418AE602954FFBULL, =
0xBC387AEA7A8DA4C0ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xFEC89B01D3679253ULL, 0x39D9B93D2959C9E6ULL, =
0x7B2958D680B3FF75ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xF50B1CAF74CF481FULL, 0xB7FBFD44DD257E8CULL, =
0x70EADF78271B2539ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x321A3E938EF113AAULL, 0x2E5EB66066087D7EULL, =
0x6CAE578BCFE24BEDULL,
> + =C2=A0 =C2=A0 =C2=A0 0xABBF75B735DC1058ULL, 0xE94F945C9C3626CBULL, =
0x676DD025684A91A1ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x259D31CEC1A0A732ULL, 0xE28C13F23B9EFC87ULL, =
0xA07CF2199274CA14ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x167FF3EACBAF2AF1ULL, 0x548F120162451C62ULL, =
0x939E303D987B47D7ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xD16ED1D631917144ULL, 0x5F4C95AFC5EDC62EULL, =
0x1DBC74446C07F0BDULL,
> + =C2=A0 =C2=A0 =C2=A0 0xDAAD56789639AB08ULL, 0x985DB7933FD39D9BULL, =
0x84193F60D72AF34FULL,
> + =C2=A0 =C2=A0 =C2=A0 0xC6E9DE8B7EC0C5DCULL, 0x01F8FCB784FE9E69ULL, =
0x43081D5C2D14A8FAULL,
> + =C2=A0 =C2=A0 =C2=A0 0xCD2A5925D9681F90ULL, 0x8FDAB8CE70822903ULL, =
0x48CB9AF28ABC72B6ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x0A3B7B1923564425ULL, 0x70428B155B4EAF1EULL, =
0x32B26AFEF2A4998DULL,
> + =C2=A0 =C2=A0 =C2=A0 0xF5A348C2089AC238ULL, 0xB753A929A170F4ABULL, =
0x3971ED50550C43C1ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x7B810CBBFCE67552ULL, 0xBC902E8706D82EE7ULL, =
0xFE60CF6CAF321874ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xE224479F47CB76A0ULL, 0xA0D4A674EE214033ULL, =
0x67C58448141F1B86ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x253565A3BDF52D15ULL, 0xAB1721DA49899A7FULL, =
0xE9E7C031E063ACECULL,
> + =C2=A0 =C2=A0 =C2=A0 0x2EF6E20D1A5DF759ULL, 0x6C0603E6B3B7C1CAULL, =
0xF6FAE5C07D3274CDULL,
> + =C2=A0 =C2=A0 =C2=A0 0xB40A042BD4D8425EULL, 0x731B26172EE619EBULL, =
0x31EBC7FC870C2F78ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xBFC9838573709812ULL, 0xFD39626EDA9AAE81ULL, =
0x3A28405220A4F534ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x78D8A1B9894EC3A7ULL, 0x649C294A61B7AD73ULL, =
0x266CC8A1C85D9BE0ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xE17DEA9D3263C055ULL, 0xA38D0B769B89F6C6ULL, =
0x2DAF4F0F6FF541ACULL,
> + =C2=A0 =C2=A0 =C2=A0 0x6F5FAEE4C61F773FULL, 0xA84E8CD83C212C8AULL, =
0xEABE6D3395CB1A19ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x90C79D3FEDD3F122ULL, 0xD2377CD44439C7B1ULL, =
0x15265EE8BE079C04ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x57D6BF0317EDAA97ULL, 0xD9F4FB7AE3911DFDULL, =
0x9B041A914A7B2B6EULL,
> + =C2=A0 =C2=A0 =C2=A0 0x5C1538ADB04570DBULL, 0x1EE5D94619AF4648ULL, =
0x02A151B5F156289CULL,
> + =C2=A0 =C2=A0 =C2=A0 0x4051B05E58BC1E0FULL, 0x87409262A28245BAULL, =
0xC5B073890B687329ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x4B9237F0FF14C443ULL, 0x0962D61B56FEF2D0ULL, =
0xCE73F427ACC0A965ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x8C8315CC052A9FF6ULL, 0x3A80143F5CF17F13ULL, =
0x7870F5D4F51B4980ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xBF61D7E80F251235ULL, 0xFD913603A6CF24A6ULL, =
0x73B3727A52B393CCULL,
> + =C2=A0 =C2=A0 =C2=A0 0x31439391FB59A55FULL, 0xF652B1AD0167FEEAULL, =
0xB4A25046A88DC879ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xA8E6D8B54074A6ADULL, 0xEA16395EE99E903EULL, =
0x2D071B6213A0CB8BULL,
> + =C2=A0 =C2=A0 =C2=A0 0x6FF7FA89BA4AFD18ULL, 0xE1D5BEF04E364A72ULL, =
0xA3255F1BE7DC7CE1ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x64347D271DE22754ULL, 0x26C49CCCB40811C7ULL, =
0x5CBD6CC0CC10FAFCULL,
> + =C2=A0 =C2=A0 =C2=A0 0x1E4D8D2B65FACC6FULL, 0xD95CAF179FC497DAULL, =
0x9BAC4EFC362EA149ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x158E0A85C2521623ULL, 0x577EEB6E6BB820B0ULL, =
0x906FC95291867B05ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xD29F28B9386C4D96ULL, 0xCEDBA04AD0952342ULL, =
0x8C2B41A1797F15D1ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x4B3A639D83414E64ULL, 0x09CA82762AAB78F7ULL, =
0x87E8C60FDED7CF9DULL,
> + =C2=A0 =C2=A0 =C2=A0 0xC51827E4773DF90EULL, 0x020905D88D03A2BBULL, =
0x40F9E43324E99428ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x2CFFE7D5975E55E2ULL, 0x6E0F063E3EB46371ULL, =
0xA91E2402C48A38C4ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xEBEEC5E96D600E57ULL, 0x65CC8190991CB93DULL, =
0x273C607B30F68FAEULL,
> + =C2=A0 =C2=A0 =C2=A0 0xE02D4247CAC8D41BULL, 0xA2DDA3AC6322E288ULL, =
0xBE992B5F8BDB8C5CULL,
> + =C2=A0 =C2=A0 =C2=A0 0xFC69CAB42231BACFULL, 0x3B78E888D80FE17AULL, =
0x7988096371E5D7E9ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xF7AA4D1A85996083ULL, 0xB55AACF12C735610ULL, =
0x724B8ECDD64D0DA5ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x30BB6F267FA73B36ULL, 0x4AC29F2A07BFD00DULL, =
0x08327EC1AE55E69EULL,
> + =C2=A0 =C2=A0 =C2=A0 0xCF235CFD546BBD2BULL, 0x8DD3BD16FD818BB8ULL, =
0x03F1F96F09FD3CD2ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x41011884A0170A41ULL, 0x86103AB85A2951F4ULL, =
0xC4E0DB53F3C36767ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xD8A453A01B3A09B3ULL, 0x9A54B24BB2D03F20ULL, =
0x5D45907748EE6495ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x1FB5719CE1045206ULL, 0x919735E51578E56CULL, =
0xD367D40EBC92D3FFULL,
> + =C2=A0 =C2=A0 =C2=A0 0x1476F63246AC884AULL, 0x568617D9EF46BED9ULL, =
0xE085162AB69D5E3CULL,
> + =C2=A0 =C2=A0 =C2=A0 0xA275F7C11F7768AFULL, 0x6564D5FDE549331AULL, =
0x279434164CA30589ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xA9B6706FB8DFB2E3ULL, 0xEB46918411358470ULL, =
0x2C57B3B8EB0BDFC5ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x6EA7525342E1E956ULL, 0x72E3DAA0AA188782ULL, =
0x30133B4B03F2B111ULL,
> + =C2=A0 =C2=A0 =C2=A0 0xF7021977F9CCEAA4ULL, 0xB5F2F89C5026DC37ULL, =
0x3BD0BCE5A45A6B5DULL,
> + =C2=A0 =C2=A0 =C2=A0 0x79205D0E0DB05DCEULL, 0xBE317F32F78E067BULL, =
0xFCC19ED95E6430E8ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x86B86ED5267CDBD3ULL, 0xC4488F3E8F96ED40ULL, =
0x0359AD0275A8B6F5ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x41A94CE9DC428066ULL, 0xCF8B0890283E370CULL, =
0x8D7BE97B81D4019FULL,
> + =C2=A0 =C2=A0 =C2=A0 0x4A6ACB477BEA5A2AULL, 0x089A2AACD2006CB9ULL, =
0x14DEA25F3AF9026DULL,
> + =C2=A0 =C2=A0 =C2=A0 0x562E43B4931334FEULL, 0x913F6188692D6F4BULL, =
0xD3CF8063C0C759D8ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x5DEDC41A34BBEEB2ULL, 0x1F1D25F19D51D821ULL, =
0xD80C07CD676F8394ULL,
> + =C2=A0 =C2=A0 =C2=A0 0x9AFCE626CE85B507ULL
> +};
> +
> +inline uint64_t crc64(const void *_data, size_t len)
> +{
> + =C2=A0 =C2=A0 =C2=A0 uint64_t crc =3D 0xFFFFFFFFFFFFFFFFULL;
> + =C2=A0 =C2=A0 =C2=A0 const unsigned char *data =3D _data;
> +
> + =C2=A0 =C2=A0 =C2=A0 while (len--) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int i =3D ((int) (=
crc >> 56) ^ *data++) & 0xFF;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 crc =3D crc_table[=
i] ^ (crc << 8);
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 return crc ^ 0xFFFFFFFFFFFFFFFFULL;
> +}
> diff --git a/maps.c b/maps.c
> index f2ba9a7..cedf548 100644
> --- a/maps.c
> +++ b/maps.c
> @@ -94,6 +94,8 @@ mapping_t pers[] =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "10", 10},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "faulty", LEVEL_FAULTY},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ "container", LEVEL_CONTAINER},
> + =C2=A0 =C2=A0 =C2=A0 { "bcache", LEVEL_BCACHE},
> + =C2=A0 =C2=A0 =C2=A0 { "11", LEVEL_BCACHE},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ NULL, 0}
> =C2=A0};
>
> diff --git a/mdadm.h b/mdadm.h
> index 3bcd052..a0ccff6 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -816,6 +816,7 @@ extern struct superswitch {
> =C2=A0extern struct superswitch super0, super1;
> =C2=A0extern struct superswitch super_imsm, super_ddf;
> =C2=A0extern struct superswitch mbr, gpt;
> +extern struct superswitch super_bcache;
>
> =C2=A0struct metadata_update {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int =C2=A0 =C2=A0 len;
> @@ -1296,6 +1297,7 @@ static inline int xasprintf(char **strp, const =
char *fmt, ...) {
> =C2=A0#define =C2=A0 =C2=A0 =C2=A0 =C2=A0LEVEL_MULTIPATH =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 (-4)
> =C2=A0#define =C2=A0 =C2=A0 =C2=A0 =C2=A0LEVEL_LINEAR =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0(-1)
> =C2=A0#define =C2=A0 =C2=A0 =C2=A0 =C2=A0LEVEL_FAULTY =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0(-5)
> +#define LEVEL_BCACHE =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (0xb)
>
> =C2=A0/* kernel module doesn't know about these */
> =C2=A0#define LEVEL_CONTAINER =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0(-100)
> diff --git a/super-bcache.c b/super-bcache.c
> new file mode 100644
> index 0000000..ec8f3db
> --- /dev/null
> +++ b/super-bcache.c
> @@ -0,0 +1,634 @@
> +/*
> + * mdadm - bcache support
> + *
> + * Copyright (C) 2012 Intel Corporation
> + *
> + * bcache definitions copied from bcache-tools:
> + * git://evilpiepirate.org/~kent/bcache-tools.git
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WI=
THOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILIT=
Y or
> + * FITNESS FOR A PARTICULAR PURPOSE. =C2=A0See the GNU General Publi=
c License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License=
 along with
> + * this program; if not, write to the Free Software Foundation, Inc.=
,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +#define HAVE_STDINT_H 1
> +#include "mdadm.h"
> +#include "bcache.h"
> +
> +struct bcache_super {
> + =C2=A0 =C2=A0 =C2=A0 union {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cache_sb *s=
b;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 void *buf;
> + =C2=A0 =C2=A0 =C2=A0 };
> + =C2=A0 =C2=A0 =C2=A0 struct dl {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int major, minor;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 char *devname;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int fd;
> + =C2=A0 =C2=A0 =C2=A0 } *disk;
> + =C2=A0 =C2=A0 =C2=A0 int vol;
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *next;
> +};
> +
> +enum {
> + =C2=A0 =C2=A0 =C2=A0 /* FIXME this is a function of the bucket size=
 */
> + =C2=A0 =C2=A0 =C2=A0 BCACHE_MAX_DEVICES =3D 2,
> +};
> +
> +static int load_cache_sb(struct bcache_super *super, int keep_fd)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct dl *d =3D super->disk;
> + =C2=A0 =C2=A0 =C2=A0 int rc, fd =3D d->fd;
> + =C2=A0 =C2=A0 =C2=A0 struct cache_sb *c;
> + =C2=A0 =C2=A0 =C2=A0 struct stat s;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!keep_fd)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 d->fd =3D -1;
> +
> + =C2=A0 =C2=A0 =C2=A0 rc =3D fstat(fd, &s);
> + =C2=A0 =C2=A0 =C2=A0 if (rc)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> + =C2=A0 =C2=A0 =C2=A0 d->major =3D major(s.st_rdev);
> + =C2=A0 =C2=A0 =C2=A0 d->minor =3D minor(s.st_rdev);
> +
> + =C2=A0 =C2=A0 =C2=A0 rc =3D posix_memalign(&super->buf, 4096, 4096)=
;
> + =C2=A0 =C2=A0 =C2=A0 if (rc)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> + =C2=A0 =C2=A0 =C2=A0 c =3D super->sb;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (pread(fd, c, 4096, SB_SECTOR << 9) !=3D 40=
96)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return errno;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (csum_set(c) !=3D __le64_to_cpu(c->csum))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ENODEV;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (memcmp(c->magic, bcache_magic, sizeof(bcac=
he_magic)) !=3D 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ENODEV;
> +
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +static void __free_bcache(struct bcache_super *super)
> +{
> + =C2=A0 =C2=A0 =C2=A0 if (!super)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 while (super) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct bcache_supe=
r *next =3D super->next;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dl *d =3D s=
uper->disk;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 d =3D super->disk;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (d->fd >=3D 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 close(d->fd);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(d->devname);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(d);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(super->sb);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(super);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 super =3D next;
> + =C2=A0 =C2=A0 =C2=A0 }
> +}
> +
> +static void free_bcache(struct supertype *st)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *super =3D st->sb;
> +
> + =C2=A0 =C2=A0 =C2=A0 __free_bcache(super);
> + =C2=A0 =C2=A0 =C2=A0 st->sb =3D NULL;
> +}
> +
> +#ifndef MDASSEMBLE
> +static void examine_bcache(struct supertype *st, char *homehost)
> +{
> + =C2=A0 =C2=A0 =C2=A0 const char *const cache_policies[] =3D { "lru"=
, "fifo", "random", "" };
> + =C2=A0 =C2=A0 =C2=A0 const char *const bdev_states[] =3D { "none", =
"clean", "dirty", "stale" };
> + =C2=A0 =C2=A0 =C2=A0 const char *const bdev_modes[16] =3D { "writet=
hrough", "writeback", "writearound", "none" };
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *super =3D st->sb;
> + =C2=A0 =C2=A0 =C2=A0 uint16_t first_bucket, bucket_size;
> + =C2=A0 =C2=A0 =C2=A0 struct cache_sb *c =3D super->sb;
> + =C2=A0 =C2=A0 =C2=A0 uint64_t nbuckets, csum;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long long sz;
> + =C2=A0 =C2=A0 =C2=A0 char nbuf[64];
> +
> + =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0 =C2=A0 =C2=A0 Magic : %s\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memcmp(bcache_magic=
, c->magic, 16) ? "<unknown>" : "<bcache>");
> + =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0 =C2=A0 Version : %d\n", (int) =
c->version);
> + =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0 =C2=A0 =C2=A0 =C2=A0Role : %s\=
n", SB_BDEV(c) ? "backing-device" : "cache");
> + =C2=A0 =C2=A0 =C2=A0 __fname_from_uuid((int *) c->set_uuid, 0, nbuf=
, ':');
> + =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0 =C2=A0Set UUID : %s\n", nbuf +=
 5);
> + =C2=A0 =C2=A0 =C2=A0 __fname_from_uuid((int *) c->uuid, 0, nbuf, ':=
');
> + =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0Cache Devs : %u\n", c->nr_in_se=
t);
> + =C2=A0 =C2=A0 =C2=A0 /* FIXME: list all cache dev uuids in the load=
_container case */
> + =C2=A0 =C2=A0 =C2=A0 printf(" Device UUID : %s\n", nbuf + 5);
> + =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0 =C2=A0 =C2=A0 Flags :%s%s\n", =
CACHE_DISCARD(c) ? " discard" : "",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CACHE_SY=
NC(c) ? " sync" : "");
> + =C2=A0 =C2=A0 =C2=A0 if (SB_BDEV(c)) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0 =C2=
=A0 =C2=A0 State : %s\n", bdev_states[BDEV_STATE(c)]);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0 =C2=
=A0 =C2=A0 =C2=A0Mode : %s\n", bdev_modes[BDEV_CACHE_MODE(c)]);
> + =C2=A0 =C2=A0 =C2=A0 } else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0 =C2=
=A0 =C2=A0Policy : %s\n", cache_policies[CACHE_REPLACEMENT(c)]);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* FIXME: add repo=
rting of backing device uuids in the cache caase */
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0 =C2=A0 =C2=A0 Label : %.32s\n"=
, c->label);
> + =C2=A0 =C2=A0 =C2=A0 csum =3D __le64_to_cpu(c->csum);
> + =C2=A0 =C2=A0 =C2=A0 nbuckets =3D __le64_to_cpu(c->nbuckets);
> + =C2=A0 =C2=A0 =C2=A0 bucket_size =3D __le16_to_cpu(c->bucket_size);
> + =C2=A0 =C2=A0 =C2=A0 first_bucket =3D __le16_to_cpu(c->first_bucket=
);
> + =C2=A0 =C2=A0 =C2=A0 sz =3D (nbuckets - first_bucket) * bucket_size=
;
> + =C2=A0 =C2=A0 =C2=A0 printf(" Device Size : %llu%s\n", sz, human_si=
ze(sz * 512));
> + =C2=A0 =C2=A0 =C2=A0 printf(" Bucket Size : %u\n", bucket_size);
> + =C2=A0 =C2=A0 =C2=A0 printf(" Num Buckets : %llu\n", (unsigned long=
 long) nbuckets);
> + =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0 =C2=A0this dev : %u\n", __le16=
_to_cpu(c->nr_this_dev));
> + =C2=A0 =C2=A0 =C2=A0 printf("First Bucket : %u\n", first_bucket);
> + =C2=A0 =C2=A0 =C2=A0 printf(" =C2=A0 =C2=A0Checksum : %llx %s\n", (=
unsigned long long) csum,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0csum =3D=3D csum_se=
t(c) ? "correct" : "incorrect");
> +}
> +
> +static void brief_examine_bcache(struct supertype *st, int verbose)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *super =3D st->sb;
> + =C2=A0 =C2=A0 =C2=A0 struct cache_sb *c =3D super->sb;
> + =C2=A0 =C2=A0 =C2=A0 char nbuf[64];
> +
> + =C2=A0 =C2=A0 =C2=A0 __fname_from_uuid((int *) c->set_uuid, 0, nbuf=
, ':');
> + =C2=A0 =C2=A0 =C2=A0 printf("ARRAY metadata=3Dbcache UUID=3D%s\n", =
nbuf + 5);
> +}
> +
> +static void brief_examine_subarrays_bcache(struct supertype *st, int=
 verbose)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *super =3D st->sb;
> + =C2=A0 =C2=A0 =C2=A0 struct cache_sb *c =3D super->sb;
> + =C2=A0 =C2=A0 =C2=A0 char nbuf[64], nbuf1[64];
> +
> + =C2=A0 =C2=A0 =C2=A0 /* FIXME this needs to parse the cache device =
journal to find
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* and report the backing dev uuid list
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 if (!SB_BDEV(c))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> +
> + =C2=A0 =C2=A0 =C2=A0 __fname_from_uuid((int *) c->set_uuid, 0, nbuf=
, ':');
> + =C2=A0 =C2=A0 =C2=A0 __fname_from_uuid((int *) c->uuid, 0, nbuf1, '=
:');
> +
> + =C2=A0 =C2=A0 =C2=A0 printf("ARRAY container=3D%s UUID=3D%s\n", nbu=
f + 5, nbuf1 + 5);
> +}
> +
> +static void export_examine_bcache(struct supertype *st)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *super =3D st->sb;
> + =C2=A0 =C2=A0 =C2=A0 struct cache_sb *c =3D super->sb;
> + =C2=A0 =C2=A0 =C2=A0 char nbuf[64];
> +
> + =C2=A0 =C2=A0 =C2=A0 __fname_from_uuid((int *) c->set_uuid, 0, nbuf=
, ':');
> + =C2=A0 =C2=A0 =C2=A0 printf("MD_METADATA=3Dbcache\n");
> + =C2=A0 =C2=A0 =C2=A0 printf("MD_LEVEL=3Dcontainer\n");
> + =C2=A0 =C2=A0 =C2=A0 printf("MD_UUID=3D%s\n", nbuf+5);
> + =C2=A0 =C2=A0 =C2=A0 printf("MD_DEVICES=3D%d\n", __le16_to_cpu(c->n=
r_in_set) + 1);
> +}
> +
> +static void detail_bcache(struct supertype *st, char *homehost)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *super =3D st->sb;
> + =C2=A0 =C2=A0 =C2=A0 struct cache_sb *c =3D super->sb;
> + =C2=A0 =C2=A0 =C2=A0 char nbuf[64];
> +
> + =C2=A0 =C2=A0 =C2=A0 __fname_from_uuid((int *) c->set_uuid, 0, nbuf=
, ':');
> + =C2=A0 =C2=A0 =C2=A0 printf("\n =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
UUID : %s\n", nbuf + 5);
> +}
> +
> +static void brief_detail_bcache(struct supertype *st)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *super =3D st->sb;
> + =C2=A0 =C2=A0 =C2=A0 struct cache_sb *c =3D super->sb;
> + =C2=A0 =C2=A0 =C2=A0 char nbuf[64];
> +
> + =C2=A0 =C2=A0 =C2=A0 __fname_from_uuid((int *) c->set_uuid, 0, nbuf=
, ':');
> + =C2=A0 =C2=A0 =C2=A0 printf(" UUID=3D%s", nbuf + 5);
> +}
> +
> +static struct bcache_super *alloc_super(const char *func)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *super =3D calloc(1, sizeo=
f(*super));
> + =C2=A0 =C2=A0 =C2=A0 struct dl *d =3D calloc(1, sizeof(*d));
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!super || !d) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, Na=
me "%s: %s failed\n", func, __func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(super);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(d);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 super->vol =3D -1;
> + =C2=A0 =C2=A0 =C2=A0 super->disk =3D d;
> +
> + =C2=A0 =C2=A0 =C2=A0 return super;
> +}
> +
> +static int load_container_bcache(struct supertype *st, int fd, char =
*devname)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *list =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 int rc, i, cdev =3D 0, bdev =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 int devnum =3D fd2devnum(fd);
> + =C2=A0 =C2=A0 =C2=A0 struct mdinfo *sra, *sd;
> +
> + =C2=A0 =C2=A0 =C2=A0 sra =3D sysfs_read(fd, 0, GET_LEVEL|GET_VERSIO=
N|GET_DEVS|GET_STATE);
> + =C2=A0 =C2=A0 =C2=A0 if (!sra)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (sra->array.major_version !=3D -1 ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sra->array.minor_version !=3D -2=
 ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strcmp(sra->text_version, "bcach=
e") !=3D 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto error;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 for (sd =3D sra->devs, i =3D 0; sd; sd =3D sd-=
>next, i++) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct bcache_supe=
r *super =3D alloc_super(__func__);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cache_sb *c=
;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 char nm[32];
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int fd;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!super)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto error;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 super->next =3D li=
st;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list =3D super;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D 2;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sprintf(nm, "%d:%d=
", sd->disk.major, sd->disk.minor);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fd =3D dev_open(nm=
, O_RDWR);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (fd < 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto error;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 super->disk->fd =3D=
 fd;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D load_cache_=
sb(super, 1);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto error;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 c =3D super->sb;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (SB_BDEV(c))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 bdev++;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cdev++;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 rc =3D 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* FIXME disambiguate multiple bdevs per set, =
support multiple
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* cache devices
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 if (bdev > 1) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, Na=
me ": %d backing devices detected\n", bdev);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D 3;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 if (cdev > 1) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, Na=
me ": %d cache devices detected\n", cdev);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D 3;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 if (rc)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto error;
> + =C2=A0 =C2=A0 =C2=A0 st->sb =3D list;
> + =C2=A0 =C2=A0 =C2=A0 list =3D NULL;
> +
> +error:
> + =C2=A0 =C2=A0 =C2=A0 if (list)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __free_bcache(list=
);
> + =C2=A0 =C2=A0 =C2=A0 sysfs_free(sra);
> +
> + =C2=A0 =C2=A0 =C2=A0 st->container_dev =3D devnum;
> + =C2=A0 =C2=A0 =C2=A0 if (rc =3D=3D 0 && st->ss =3D=3D NULL) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 st->ss =3D &super_=
bcache;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 st->minor_version =
=3D 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 st->max_devs =3D B=
CACHE_MAX_DEVICES;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 return rc;
> +}
> +#endif
> +
> +static int load_bcache(struct supertype *st, int fd, char *devname)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *super;
> + =C2=A0 =C2=A0 =C2=A0 struct dl *d;
> + =C2=A0 =C2=A0 =C2=A0 int rc;
> +
> + =C2=A0 =C2=A0 =C2=A0 free_bcache(st);
> +
> + =C2=A0 =C2=A0 =C2=A0 super =3D alloc_super(__func__);
> + =C2=A0 =C2=A0 =C2=A0 if (!super)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;
> +
> + =C2=A0 =C2=A0 =C2=A0 st->sb =3D super;
> + =C2=A0 =C2=A0 =C2=A0 d =3D super->disk;
> + =C2=A0 =C2=A0 =C2=A0 d->devname =3D devname ? strdup(devname) : NUL=
L;
> + =C2=A0 =C2=A0 =C2=A0 d->fd =3D fd;
> + =C2=A0 =C2=A0 =C2=A0 rc =3D load_cache_sb(super, 0);
> + =C2=A0 =C2=A0 =C2=A0 if (rc) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free_bcache(st);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!devname)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 return rc;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, Na=
me ": %s failed on %s (%s)\n", __func__,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 devname, strerror(rc));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (st->ss =3D=3D NULL) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 st->ss =3D &super_=
bcache;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 st->minor_version =
=3D 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 st->max_devs =3D B=
CACHE_MAX_DEVICES;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +static int store_bcache(struct supertype *st, int fd)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *super =3D st->sb;
> + =C2=A0 =C2=A0 =C2=A0 struct cache_sb *c =3D super->sb;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!c)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (pwrite(fd, c, sizeof(*c), SB_SECTOR << 9) =
!=3D sizeof(*c))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;
> +
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +static int compare_bcache(struct supertype *st, struct supertype *ts=
t)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *a =3D st->sb;
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *b =3D tst->sb;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!st->sb) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0st->sb =3D t=
st->sb;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tst->sb =3D =
NULL;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> +
> + =C2=A0 =C2=A0 =C2=A0 if (memcmp(a->sb->set_uuid, b->sb->set_uuid, s=
izeof(b->sb->set_uuid)) !=3D 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 2;
> +
> + =C2=A0 =C2=A0 =C2=A0 return 0;
> +}
> +
> +static __u64 avail_size_bcache(struct supertype *st, __u64 devsize)
> +{
> + =C2=A0 =C2=A0 =C2=A0 /* 4k from start, 8k min data offset */
> + =C2=A0 =C2=A0 =C2=A0 const uint32_t reserved_sectors =3D (4+8) * 2;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (devsize < reserved_sectors)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 return devsize - reserved_sectors;
> +}
> +
> +static struct supertype *match_metadata_desc_bcache(char *arg)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct supertype *st;
> +
> + =C2=A0 =C2=A0 =C2=A0 if (strcmp(arg, "bcache") !=3D 0 &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strcmp(arg, "default") !=3D 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> +
> + =C2=A0 =C2=A0 =C2=A0 st =3D calloc(1, sizeof(*st));
> + =C2=A0 =C2=A0 =C2=A0 if (!st)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> + =C2=A0 =C2=A0 =C2=A0 st->container_dev =3D NoMdDev;
> + =C2=A0 =C2=A0 =C2=A0 st->ss =3D &super_bcache;
> + =C2=A0 =C2=A0 =C2=A0 st->max_devs =3D BCACHE_MAX_DEVICES;
> + =C2=A0 =C2=A0 =C2=A0 st->minor_version =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 st->sb =3D NULL;
> +
> + =C2=A0 =C2=A0 =C2=A0 return st;
> +}
> +
> +static int match_home_bcache(struct supertype *st, char *homehost)
> +{
> + =C2=A0 =C2=A0 =C2=A0 /* the bcache superblock does not specify any =
host
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* identification information. =C2=A0mayb=
e it should...
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> +
> + =C2=A0 =C2=A0 =C2=A0 return -1;
> +}
> +
> +static void uuid_from_bcache(struct supertype *st, int uuid[4])
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *super =3D st->sb;
> + =C2=A0 =C2=A0 =C2=A0 struct cache_sb *c =3D super->sb;
> +
> + =C2=A0 =C2=A0 =C2=A0 memcpy(uuid, c->set_uuid, sizeof(c->set_uuid))=
;
> +}
> +
> +static void getinfo_bcache_volume(struct supertype *st, struct mdinf=
o *info, int map_disks, char *dmap)
> +{
> + =C2=A0 =C2=A0 =C2=A0 char *name =3D devnum2devname(st->container_de=
v);
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *super =3D st->sb;
> + =C2=A0 =C2=A0 =C2=A0 uint16_t bucket_size, first_bucket;
> + =C2=A0 =C2=A0 =C2=A0 struct cache_sb *c =3D super->sb;
> + =C2=A0 =C2=A0 =C2=A0 unsigned long long sz;
> + =C2=A0 =C2=A0 =C2=A0 uint64_t nbuckets;
> +
> + =C2=A0 =C2=A0 =C2=A0 nbuckets =3D __le64_to_cpu(c->nbuckets);
> + =C2=A0 =C2=A0 =C2=A0 bucket_size =3D __le16_to_cpu(c->bucket_size);
> + =C2=A0 =C2=A0 =C2=A0 first_bucket =3D __le16_to_cpu(c->first_bucket=
);
> + =C2=A0 =C2=A0 =C2=A0 sz =3D (nbuckets - first_bucket) * bucket_size=
;
> +
> + =C2=A0 =C2=A0 =C2=A0 info->container_member =C2=A0 =C2=A0=3D super-=
>vol;
> + =C2=A0 =C2=A0 =C2=A0 info->custom_array_size =C2=A0 =3D sz;
> + =C2=A0 =C2=A0 =C2=A0 info->component_size =C2=A0 =C2=A0 =C2=A0=3D s=
z;
> + =C2=A0 =C2=A0 =C2=A0 info->recovery_start =C2=A0 =C2=A0 =C2=A0=3D M=
axSector;
> + =C2=A0 =C2=A0 =C2=A0 info->data_offset =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=3D SB_SECTOR + SB_SIZE;
> + =C2=A0 =C2=A0 =C2=A0 sprintf(info->text_version, "/%s/%d", name, su=
per->vol);
> + =C2=A0 =C2=A0 =C2=A0 snprintf(info->name, sizeof(info->name), "%s",=
 c->label);
> + =C2=A0 =C2=A0 =C2=A0 memcpy(info->uuid, c->uuid, sizeof(c->uuid));
> +
> + =C2=A0 =C2=A0 =C2=A0 info->array.raid_disks =C2=A0 =C2=A0=3D __le16=
_to_cpu(c->nr_in_set) + 1;
> + =C2=A0 =C2=A0 =C2=A0 info->array.level =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=3D LEVEL_BCACHE;
> + =C2=A0 =C2=A0 =C2=A0 info->array.layout =C2=A0 =C2=A0 =C2=A0 =C2=A0=
=3D 0;
> + =C2=A0 =C2=A0 =C2=A0 info->array.md_minor =C2=A0 =C2=A0 =C2=A0=3D -=
1;
> + =C2=A0 =C2=A0 =C2=A0 info->array.ctime =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=3D 0;
> + =C2=A0 =C2=A0 =C2=A0 info->array.utime =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=3D 0;
> + =C2=A0 =C2=A0 =C2=A0 info->array.chunk_size =C2=A0 =C2=A0=3D bucket=
_size * 512;
> + =C2=A0 =C2=A0 =C2=A0 info->array.major_version =3D -1;
> + =C2=A0 =C2=A0 =C2=A0 info->array.minor_version =3D -2;
> +
> + =C2=A0 =C2=A0 =C2=A0 info->disk.major =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 info->disk.minor =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 info->disk.raid_disk =3D SB_BDEV(c);
> + =C2=A0 =C2=A0 =C2=A0 info->disk.number =3D SB_BDEV(c);
> + =C2=A0 =C2=A0 =C2=A0 info->disk.state =3D 1 << MD_DISK_ACTIVE | 1 <=
< MD_DISK_SYNC;
> +}
> +
> +static void getinfo_bcache(struct supertype *st, struct mdinfo *info=
, char *dmap)
> +{
> + =C2=A0 =C2=A0 =C2=A0 int i, cset, bdev, map_disks =3D info->array.r=
aid_disks;
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *super =3D st->sb;
> + =C2=A0 =C2=A0 =C2=A0 struct cache_sb *c =3D super->sb;
> +
> + =C2=A0 =C2=A0 =C2=A0 memset(info, 0, sizeof(*info));
> +
> + =C2=A0 =C2=A0 =C2=A0 if (super->vol >=3D 0)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return getinfo_bca=
che_volume(st, info, map_disks, dmap);
> +
> + =C2=A0 =C2=A0 =C2=A0 /* make Assemble choose the cache target */
> + =C2=A0 =C2=A0 =C2=A0 info->events =3D SB_BDEV(c);
> + =C2=A0 =C2=A0 =C2=A0 info->recovery_start =3D MaxSector;
> + =C2=A0 =C2=A0 =C2=A0 info->data_offset =3D SB_SECTOR;
> + =C2=A0 =C2=A0 =C2=A0 info->component_size =3D SB_SIZE;
> + =C2=A0 =C2=A0 =C2=A0 strcpy(info->text_version, "bcache");
> + =C2=A0 =C2=A0 =C2=A0 memcpy(info->uuid, c->set_uuid, sizeof(c->set_=
uuid));
> +
> + =C2=A0 =C2=A0 =C2=A0 info->array.raid_disks =C2=A0 =C2=A0=3D __le16=
_to_cpu(c->nr_in_set) + 1;
> + =C2=A0 =C2=A0 =C2=A0 info->array.level =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=3D LEVEL_CONTAINER;
> + =C2=A0 =C2=A0 =C2=A0 info->array.layout =C2=A0 =C2=A0 =C2=A0 =C2=A0=
=3D 0;
> + =C2=A0 =C2=A0 =C2=A0 info->array.md_minor =C2=A0 =C2=A0 =C2=A0=3D -=
1;
> + =C2=A0 =C2=A0 =C2=A0 info->array.ctime =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=3D 0;
> + =C2=A0 =C2=A0 =C2=A0 info->array.utime =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=3D 0;
> + =C2=A0 =C2=A0 =C2=A0 info->array.chunk_size =C2=A0 =C2=A0=3D __le16=
_to_cpu(c->bucket_size) * 512;
> + =C2=A0 =C2=A0 =C2=A0 info->array.major_version =3D -1;
> + =C2=A0 =C2=A0 =C2=A0 info->array.minor_version =3D -2;
> +
> + =C2=A0 =C2=A0 =C2=A0 info->disk.major =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 info->disk.minor =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 info->disk.raid_disk =3D SB_BDEV(c);
> + =C2=A0 =C2=A0 =C2=A0 info->disk.number =3D SB_BDEV(c);
> + =C2=A0 =C2=A0 =C2=A0 /* FIXME: need bcache superblock to identify f=
ailed devices */
> + =C2=A0 =C2=A0 =C2=A0 info->disk.state =3D 1 << MD_DISK_ACTIVE | 1 <=
< MD_DISK_SYNC;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* FIXME need to parse the journal uuid_bucket=
 to understand
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0* which cache devs are consistent with t=
he set
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; dmap && i < map_disks; i++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dmap[i] =3D 1;
> +
> + =C2=A0 =C2=A0 =C2=A0 cset =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 bdev =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 while (super) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 c =3D super->sb;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* FIXME filter ou=
t-of-sync devices */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (SB_BDEV(c))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 bdev++;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cset++;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 super =3D super->n=
ext;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 if (cset + bdev =3D=3D __le16_to_cpu(c->nr_in_=
set) + 1)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 info->container_en=
ough =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 info->container_en=
ough =3D -1;
> +}
> +
> +static int update_bcache(struct supertype *st, struct mdinfo *i, cha=
r *update,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0char *devname, int verbose, int uuid_set, char *homehost)
> +{
> + =C2=A0 =C2=A0 =C2=A0 /* FIXME */
> + =C2=A0 =C2=A0 =C2=A0 if (strcmp(update, "grow") =3D=3D 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 } else if (strcmp(update, "resync") =3D=3D 0) =
{
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 } else if (strcmp(update, "homehost") =3D=3D 0=
) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> + =C2=A0 =C2=A0 =C2=A0 } else if (strcmp(update, "name") =3D=3D 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> + =C2=A0 =C2=A0 =C2=A0 } else if (strcmp(update, "_reshape_progress")=
 =3D=3D 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 } else if (strcmp(update, "assemble") =3D=3D 0=
 ) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> + =C2=A0 =C2=A0 =C2=A0 } else {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;
> + =C2=A0 =C2=A0 =C2=A0 }
> +}
> +
> +static struct mdinfo *container_content_bcache(struct supertype *st,=
 char *subarray)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct bcache_super *super =3D st->sb;
> + =C2=A0 =C2=A0 =C2=A0 struct mdinfo *info, *disk =3D NULL;
> + =C2=A0 =C2=A0 =C2=A0 char *ep;
> +
> + =C2=A0 =C2=A0 =C2=A0 info =3D calloc(1, sizeof(*info));
> + =C2=A0 =C2=A0 =C2=A0 if (!info) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fprintf(stderr, Na=
me ": failed to allocate %zu bytes\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 sizeof(*info));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 /* don't support multiple backing disks per ca=
che set */
> + =C2=A0 =C2=A0 =C2=A0 if (subarray && (strtoul(subarray, &ep, 10) > =
0 || *ep !=3D '\0'))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto error;
> +
> + =C2=A0 =C2=A0 =C2=A0 super->vol =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 getinfo_bcache(st, info, NULL);
> +
> + =C2=A0 =C2=A0 =C2=A0 for (; super; super =3D super->next) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dl *d =3D s=
uper->disk;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cache_sb *c=
 =3D super->sb;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 disk =3D calloc(1,=
 sizeof(*disk));
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!disk) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 fprintf(stderr, Name ": failed to allocate disk\n");
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto error;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 disk->next =3D inf=
o->devs;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 info->devs =3D dis=
k;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 disk->disk.number =
=3D SB_BDEV(c);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 disk->disk.raid_di=
sk =3D SB_BDEV(c);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 disk->disk.major =3D=
 d->major;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 disk->disk.minor =3D=
 d->minor;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 disk->recovery_sta=
rt =3D MaxSector;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 disk->disk.state =3D=
 1 << MD_DISK_ACTIVE;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 disk->data_offset =
=3D info->data_offset;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 disk->component_si=
ze =3D info->component_size;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 info->array.workin=
g_disks++;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 return info;
> +
> + error:
> + =C2=A0 =C2=A0 =C2=A0 disk =3D info->devs;
> + =C2=A0 =C2=A0 =C2=A0 while (disk) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct mdinfo *nex=
t =3D disk->next;
> +
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(disk);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 disk =3D next;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 free(info);
> + =C2=A0 =C2=A0 =C2=A0 return NULL;
> +}
> +
> +
> +struct superswitch super_bcache =3D {
> +#ifndef =C2=A0 =C2=A0 =C2=A0 =C2=A0MDASSEMBLE
> + =C2=A0 =C2=A0 =C2=A0 .examine_super =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =3D examine_bcache,
> + =C2=A0 =C2=A0 =C2=A0 .brief_examine_super =C2=A0 =C2=A0 =3D brief_e=
xamine_bcache,
> + =C2=A0 =C2=A0 =C2=A0 .brief_examine_subarrays =3D brief_examine_sub=
arrays_bcache,
> + =C2=A0 =C2=A0 =C2=A0 .export_examine_super =C2=A0 =C2=A0=3D export_=
examine_bcache,
> + =C2=A0 =C2=A0 =C2=A0 .detail_super =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0=3D detail_bcache,
> + =C2=A0 =C2=A0 =C2=A0 .brief_detail_super =C2=A0 =C2=A0 =C2=A0=3D br=
ief_detail_bcache,
> + =C2=A0 =C2=A0 =C2=A0 .load_container =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0=3D load_container_bcache,
> +#endif
> + =C2=A0 =C2=A0 =C2=A0 .match_home =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0=3D match_home_bcache,
> + =C2=A0 =C2=A0 =C2=A0 .uuid_from_super =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=
 uuid_from_bcache,
> + =C2=A0 =C2=A0 =C2=A0 .getinfo_super =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =3D getinfo_bcache,
> + =C2=A0 =C2=A0 =C2=A0 .update_super =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0=3D update_bcache,
> +
> + =C2=A0 =C2=A0 =C2=A0 .avail_size =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0=3D avail_size_bcache,
> +
> + =C2=A0 =C2=A0 =C2=A0 .compare_super =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =3D compare_bcache,
> +
> + =C2=A0 =C2=A0 =C2=A0 .load_super =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0=3D load_bcache,
> + =C2=A0 =C2=A0 =C2=A0 .store_super =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =3D store_bcache,
> + =C2=A0 =C2=A0 =C2=A0 .free_super =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0=3D free_bcache,
> + =C2=A0 =C2=A0 =C2=A0 .match_metadata_desc =C2=A0 =C2=A0 =3D match_m=
etadata_desc_bcache,
> + =C2=A0 =C2=A0 =C2=A0 .container_content =C2=A0 =C2=A0 =C2=A0 =3D co=
ntainer_content_bcache,
> +
> + =C2=A0 =C2=A0 =C2=A0 .external =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0=3D 1,
> + =C2=A0 =C2=A0 =C2=A0 .name =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D "bcache",
> +};
> diff --git a/util.c b/util.c
> index 6985a70..d9e49cf 100644
> --- a/util.c
> +++ b/util.c
> @@ -919,7 +919,7 @@ struct superswitch *superlist[] =3D
> =C2=A0{
> =C2=A0 =C2=A0 =C2=A0 =C2=A0&super0, &super1,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0&super_ddf, &super_imsm,
> - =C2=A0 =C2=A0 =C2=A0 &mbr, &gpt,
> + =C2=A0 =C2=A0 =C2=A0 &mbr, &gpt, &super_bcache,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0NULL };
>
> =C2=A0#if !defined(MDASSEMBLE) || defined(MDASSEMBLE) && defined(MDAS=
SEMBLE_AUTO)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcach=
e" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
