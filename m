From: NeilBrown <neilb@suse.de>
Subject: [PATCH 4/7] md/raid5: avoid reading parity blocks for full-stripe
 write to degraded array
Date: Fri, 08 May 2015 18:56:11 +1000
Message-ID: <20150508085611.19179.50945.stgit@notabene.brown>
References: <20150508085345.19179.8866.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150508085345.19179.8866.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: linux-nfs@vger.kernel.org
List-Id: linux-raid.ids

When performing a reconstruct write, we need to read all blocks
that are not being over-written .. except the parity (P and Q) blocks.

The code currently reads these (as they are not being over-written!)
unnecessarily.

Signed-off-by: NeilBrown <neilb@suse.de>
Fixes: ea664c8245f3 ("md/raid5: need_this_block: tidy/fix last condition.")
---
 drivers/md/raid5.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 415cac6d89bd..85dc0e67fb88 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3282,7 +3282,9 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
 		/* reconstruct-write isn't being forced */
 		return 0;
 	for (i = 0; i < s->failed; i++) {
-		if (!test_bit(R5_UPTODATE, &fdev[i]->flags) &&
+		if (s->failed_num[i] != sh->pd_idx &&
+		    s->failed_num[i] != sh->qd_idx &&
+		    !test_bit(R5_UPTODATE, &fdev[i]->flags) &&
 		    !test_bit(R5_OVERWRITE, &fdev[i]->flags))
 			return 1;
 	}


