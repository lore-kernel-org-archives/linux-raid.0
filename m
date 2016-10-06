From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 37/54] md/raid5: Replace a seq_printf() call by seq_puts() in
 raid5_status()
Date: Thu, 6 Oct 2016 11:37:01 +0200
Message-ID: <92c52f1d-d151-cea6-e9ac-31378e6862d0@users.sourceforge.net>
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
Date: Wed, 5 Oct 2016 14:40:27 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: Prefer seq_puts to seq_printf

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ebcd692..7a825c0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7044,7 +7044,7 @@ static void raid5_status(struct seq_file *seq, struct mddev *mddev)
 			   rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
 	}
 	rcu_read_unlock();
-	seq_printf (seq, "]");
+	seq_puts(seq, "]");
 }
 
 static void print_raid5_conf(struct r5conf *conf)
-- 
2.10.1
