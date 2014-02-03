From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v2 2/2] bcache: Drop L-suffix when comparing ssize_t with 0
Date: Mon,  3 Feb 2014 14:49:47 +0100
Message-ID: <1391435387-13062-2-git-send-email-geert@linux-m68k.org>
References: <1391435387-13062-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1391435387-13062-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-raid.ids

drivers/md/bcache/btree.c: In function =E2=80=98insert_u64s_remaining=E2=
=80=99:
drivers/md/bcache/btree.c:1816: warning: comparison of distinct pointer=
 types lacks a cast

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Issue has migrated from linux-next to Linus' tree

v2: Drop L-suffix instead of using max_t(ssize_t, ...), as suggested by=
 Joe
    Perches

 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 98cc0a810a36..f08e48f12291 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(struct btree =
*b)
 	if (b->keys.ops->is_extents)
 		ret -=3D KEY_MAX_U64S;
=20
-	return max(ret, 0L);
+	return max(ret, 0);
 }
=20
 static bool bch_btree_insert_keys(struct btree *b, struct btree_op *op=
,
--=20
1.7.9.5
