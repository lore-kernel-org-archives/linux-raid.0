From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 50/54] md/raid10: Delete indentation for one jump label
Date: Thu, 6 Oct 2016 11:50:13 +0200
Message-ID: <a54a0472-4141-9704-9402-f596843eeebe@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Oct 2016 21:07:35 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: labels should not be indented

Thus fix the affected source code place.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0f2cb20..2181f53 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4559,7 +4559,7 @@ static int handle_reshape_read_error(struct mddev *mddev,
 			rcu_read_lock();
 			if (success)
 				break;
-		failed:
+failed:
 			slot++;
 			if (slot >= conf->copies)
 				slot = 0;
-- 
2.10.1

