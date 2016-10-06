From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 48/54] md/raid10: Move a brace for a designated initialiser
Date: Thu, 6 Oct 2016 11:48:02 +0200
Message-ID: <bd395cd3-e651-0968-1ece-307b8082720e@users.sourceforge.net>
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
Date: Wed, 5 Oct 2016 20:03:32 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: that open brace { should be on the previous line

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid10.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 62cd159..5119846 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4676,8 +4676,7 @@ static void raid10_finish_reshape(struct mddev *mddev)
 	mddev->reshape_backwards = 0;
 }
 
-static struct md_personality raid10_personality =
-{
+static struct md_personality raid10_personality = {
 	.name		= "raid10",
 	.level		= 10,
 	.owner		= THIS_MODULE,
-- 
2.10.1

