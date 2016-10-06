From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 08/54] md/raid0: Delete an unnecessary return statement in
 raid0_status()
Date: Thu, 6 Oct 2016 11:01:57 +0200
Message-ID: <ec7f893d-a9bb-6cdd-a5af-11a48fed7c36@users.sourceforge.net>
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
Date: Tue, 4 Oct 2016 14:34:33 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: void function return statements are not generally useful

Thus remove such a statement here.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid0.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 9b76eae..1abe1ee 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -503,7 +503,6 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 static void raid0_status(struct seq_file *seq, struct mddev *mddev)
 {
 	seq_printf(seq, " %dk chunks", mddev->chunk_sectors / 2);
-	return;
 }
 
 static void *raid0_takeover_raid45(struct mddev *mddev)
-- 
2.10.1

