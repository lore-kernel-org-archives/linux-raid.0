From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 07/54] md/raid0: Move two misplaced braces
Date: Thu, 6 Oct 2016 11:00:16 +0200
Message-ID: <ee219dfd-1176-b67b-ff87-4f25a6f2cd30@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 4 Oct 2016 14:25:01 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: that open brace { should be on the previous line

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid0.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 06cb172..9b76eae 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -222,8 +222,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	curr_zone_end = zone->zone_end;
 
 	/* now do the other zones */
-	for (i = 1; i < conf->nr_strip_zones; i++)
-	{
+	for (i = 1; i < conf->nr_strip_zones; i++) {
 		int j;
 
 		zone = conf->strip_zone + i;
@@ -665,8 +664,7 @@ static void raid0_quiesce(struct mddev *mddev, int state)
 {
 }
 
-static struct md_personality raid0_personality=
-{
+static struct md_personality raid0_personality = {
 	.name		= "raid0",
 	.level		= 0,
 	.owner		= THIS_MODULE,
-- 
2.10.1

