From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH resend 1/2] bcache: Use %zi to format size_t
Date: Mon,  3 Feb 2014 14:49:46 +0100
Message-ID: <1391435387-13062-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-raid.ids

drivers/md/bcache/extents.c: In function =E2=80=98btree_ptr_bad_expensi=
ve=E2=80=99:
drivers/md/bcache/extents.c:196: warning: format =E2=80=98%li=E2=80=99 =
expects type =E2=80=98long int=E2=80=99, but argument 4 has type =E2=80=
=98size_t=E2=80=99

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Issue has migrated from linux-next to Linus' tree

 drivers/md/bcache/extents.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index c3ead586dc27..416d1a3e028e 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -194,7 +194,7 @@ err:
 	mutex_unlock(&b->c->bucket_lock);
 	bch_extent_to_text(buf, sizeof(buf), k);
 	btree_bug(b,
-"inconsistent btree pointer %s: bucket %li pin %i prio %i gen %i last_=
gc %i mark %llu gc_gen %i",
+"inconsistent btree pointer %s: bucket %zi pin %i prio %i gen %i last_=
gc %i mark %llu gc_gen %i",
 		  buf, PTR_BUCKET_NR(b->c, k, i), atomic_read(&g->pin),
 		  g->prio, g->gen, g->last_gc, GC_MARK(g), g->gc_gen);
 	return true;
--=20
1.7.9.5
