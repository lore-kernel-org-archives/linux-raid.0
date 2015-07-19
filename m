From: Seunguk Shin <seunguk.shin@samsung.com>
Subject: [PATCH] raid0: data corruption when using trim
Date: Sun, 19 Jul 2015 12:28:16 +0900
Message-ID: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-language: ko
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

There was report at Algolia's blog website regarding some problems usin=
g
software raid and trim in SSD.
https://blog.algolia.com/when-solid-state-drives-are-not-that-solid/

It turns out that there is misunderstanding between raid driver and scs=
i/ata
driver.
The raid driver lets split bios share bio vector of source bio.
Usually, there is no problem, because the raid layer ensures
that the source bio is not freed before the split bios.

But, in case of trim, there are some problems.
The scsi/ata needs some payloads that include start address and size of
device to trim.
So, the scsi/ata driver allocates a page and stores that pointer on
bio->bi_io_vec->bv_page.
(sd_setup_discard_cmnd)

Because split bios share the source bio's bi_io_vec,
the pointer to the allocated page in scsi/ata driver is overwritten.
It leads to memory leakage and data corruption
because the overwritten pointer has wrong address and size to trim on
device.

So, we add some codes that make sure not to share bio vector if the sou=
rce
bio is discard.
The linear and raid10 also have same problem
because they're using similar scheme to split the source bio.

This problem exists at the very first time when the trim is enabled on
raid0.
Before the new bio_split() (20d0189b), we can patch more easily
by modifying the condition to split bio vector in bio_split function
from (bi->bi_vec !=3D 0) to ((bi->bi_vec !=3D 0) || (bi->bi_rw & REQ_DI=
SCARD)).

Thank you.
Seunguk Shin.



[=930001-PATCH-raid0-data-corruption-when-using-trim.patch=94]

=46rom ca7dbe01fcd2ef2f8cea1a38de5aca5c866c585d Mon Sep 17 00:00:00 200=
1
=46rom: Seunguk Shin <seunguk.shin@samsung.com>
Date: Sat, 18 Jul 2015 20:13:44 +0900
Subject: [PATCH] [PATCH] raid0: data corruption when using trim

When we are using software raid and tirm, there is data corruption.

The raid driver lets split bios share bio vector of source bio.
The scsi/ata driver allocates a page and stores that pointer on
bio->bi_io_vec->bv_page
(sd_setup_discard_cmnd) because the scsi/ata needs some payloads
that include start address and size of device to trim.
Because split bios share the source bio's bi_io_vec,
the pointer to the allocated page in scsi/ata driver is overwritten.

This patch splits bio vector if bio is discard.
---
block/bio.c=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 6 ------
drivers/md/raid0.c=A0 | 13 +++++++++++++
include/linux/bio.h |=A0 6 ++++++
3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 2a00d34..df7589d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -32,12 +32,6 @@
#include <trace/events/block.h>

=A0/*
- * Test patch to inline a certain number of bi_io_vec's inside the bio
- * itself, to shrink a bio data allocation from two mempool calls to o=
ne
- */
-#define BIO_INLINE_VECS=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 4
-
-/*
=A0 * if you change this list, also change bvec_alloc or things will
=A0 * break badly! cannot be bigger than what you can fit into an
=A0 * unsigned short
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index efb654e..fd1318b 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -529,6 +529,19 @@ static void raid0_make_request(struct mddev *mddev=
,
struct bio *bio)

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (sector=
s < bio_sectors(bio)) {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 split =3D bio_split(bio, sectors, GFP_NOIO,
fs_bio_set);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 if (unlikely(split->bi_rw & REQ_DISCARD)) {
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct bio_vec *bvl =3D=
 NULL;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long idx =3D =
BIO_POOL_NONE;
+
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bvl =3D bvec_alloc(GFP=
_NOIO,
BIO_INLINE_VECS + 1,
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &idx,
fs_bio_set->bvec_pool);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 split->bi_flags |=3D 1=
 <<
BIO_OWNS_VEC;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 split->bi_flags &=3D ~=
(BIO_POOL_NONE
<<
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
BIO_POOL_OFFSET);
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 split->bi_flags |=3D i=
dx <<
BIO_POOL_OFFSET;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 split->bi_max_vecs =3D
BIO_INLINE_VECS + 1;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 split->bi_io_vec =3D b=
vl;
+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 bio_chain(split, bio);
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 split =3D bio;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 5e963a6..8344bb5 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -40,6 +40,12 @@
#define BIO_BUG_ON
#endif

+/*
+ * Test patch to inline a certain number of bi_io_vec's inside the bio
+ * itself, to shrink a bio data allocation from two mempool calls to o=
ne
+ */
+#define BIO_INLINE_VECS=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 4
+
#define BIO_MAX_PAGES=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 256
#define BIO_MAX_SIZE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (BIO_MAX_PAGES=
 << PAGE_CACHE_SHIFT)
#define BIO_MAX_SECTORS=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 (BIO_MAX_SIZE >> 9)
--=20
1.9.1



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
