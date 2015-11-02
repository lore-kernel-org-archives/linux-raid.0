From: Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH] md/raid5: remove redundant check in stripe_add_to_batch_list()
Date: Mon,  2 Nov 2015 13:06:53 +0300
Message-ID: <1446458813-6502-1-git-send-email-klamm@yandex-team.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Roman Gushchin <klamm@yandex-team.ru>, Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The stripe_add_to_batch_list() function is called only if
stripe_can_batch() returned true, so there is no need for double check.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
Cc: Neil Brown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
---
 drivers/md/raid5.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 45933c1..f829ebc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -768,8 +768,6 @@ static void stripe_add_to_batch_list(struct r5conf *conf, struct stripe_head *sh
 	int hash;
 	int dd_idx;
 
-	if (!stripe_can_batch(sh))
-		return;
 	/* Don't cross chunks, so stripe pd_idx/qd_idx is the same */
 	tmp_sec = sh->sector;
 	if (!sector_div(tmp_sec, conf->chunk_sectors))
-- 
2.4.3
