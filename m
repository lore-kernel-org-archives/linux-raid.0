From: SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] dm cache: remove unused function too_many_discard_blocks
Date: Wed, 26 Mar 2014 13:09:48 +0900
Message-ID: <1395806988-29189-1-git-send-email-sj38.park@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, trivial@kernel.org, snitzer@redhat.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
List-Id: linux-raid.ids

=46ix following trivial build warning:
drivers/md/dm-cache-target.c:2182:13: warning:
=E2=80=98too_many_discard_blocks=E2=80=99 defined but not used [-Wunuse=
d-function]
 static bool too_many_discard_blocks(sector_t discard_block_size,
             ^

It's usage removed by ab1f4c35b7("dm cache: prevent corruption caused b=
y
discard_block_size > cache_block_size") as work-around and the
definition was not removed though it was only one usage. Let's remove
the definition now for clean build result and get back the definition
again after the workarounded problem solved well.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/md/dm-cache-target.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.=
c
index 9f96e7a..2c1d347 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2178,6 +2178,8 @@ static int create_cache_policy(struct cache *cach=
e, struct cache_args *ca,
  */
 #define MAX_DISCARD_BLOCKS (1 << 14)
=20
+#if 0
+/* FIXME: remove if 0 macro after stop-gap workaround solved */
 static bool too_many_discard_blocks(sector_t discard_block_size,
 				    sector_t origin_size)
 {
@@ -2185,6 +2187,7 @@ static bool too_many_discard_blocks(sector_t disc=
ard_block_size,
=20
 	return origin_size > MAX_DISCARD_BLOCKS;
 }
+#endif
=20
 static sector_t calculate_discard_block_size(sector_t cache_block_size=
,
 					     sector_t origin_size)
--=20
1.8.3.2
