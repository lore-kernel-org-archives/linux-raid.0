From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 23/54] md/raid1: Replace a seq_printf() call by seq_puts() in
 raid1_status()
Date: Thu, 6 Oct 2016 11:21:47 +0200
Message-ID: <d40af4d5-8f1e-87d5-2d22-79d4875751c6@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 4 Oct 2016 21:16:13 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: Prefer seq_puts to seq_printf

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 95f6098..ec6aafb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1417,7 +1417,7 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
 			   rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
 	}
 	rcu_read_unlock();
-	seq_printf(seq, "]");
+	seq_puts(seq, "]");
 }
 
 static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
-- 
2.10.1
