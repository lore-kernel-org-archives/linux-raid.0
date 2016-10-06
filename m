From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 32/54] md/raid5: Move a brace for three designated
 initialisers
Date: Thu, 6 Oct 2016 11:32:04 +0200
Message-ID: <8840baf8-f954-0051-c082-26bcca99bb45@users.sourceforge.net>
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
Date: Wed, 5 Oct 2016 10:20:05 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: that open brace { should be on the previous line

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid5.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a37f1f9..f2473fa0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7868,8 +7868,7 @@ static void *raid6_takeover(struct mddev *mddev)
 	return setup_conf(mddev);
 }
 
-static struct md_personality raid6_personality =
-{
+static struct md_personality raid6_personality = {
 	.name		= "raid6",
 	.level		= 6,
 	.owner		= THIS_MODULE,
@@ -7891,8 +7890,7 @@ static struct md_personality raid6_personality =
 	.takeover	= raid6_takeover,
 	.congested	= raid5_congested,
 };
-static struct md_personality raid5_personality =
-{
+static struct md_personality raid5_personality = {
 	.name		= "raid5",
 	.level		= 5,
 	.owner		= THIS_MODULE,
@@ -7914,9 +7912,7 @@ static struct md_personality raid5_personality =
 	.takeover	= raid5_takeover,
 	.congested	= raid5_congested,
 };
-
-static struct md_personality raid4_personality =
-{
+static struct md_personality raid4_personality = {
 	.name		= "raid4",
 	.level		= 4,
 	.owner		= THIS_MODULE,
-- 
2.10.1

