From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 8/13] md/multipath: Replace a seq_printf() call by seq_puts()
 in multipath_status()
Date: Sun, 2 Oct 2016 14:04:16 +0200
Message-ID: <6e70a1a7-fd86-914e-84ab-bd5c7facb235@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Jens Axboe <axboe@fb.com>, NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 2 Oct 2016 10:00:15 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: Prefer seq_puts to seq_printf

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/multipath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index cb5141f..0e8939f 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -157,7 +157,7 @@ static void multipath_status(struct seq_file *seq, struct mddev *mddev)
 			   rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
 	}
 	rcu_read_unlock();
-	seq_printf (seq, "]");
+	seq_puts(seq, "]");
 }
 
 static int multipath_congested(struct mddev *mddev, int bits)
-- 
2.10.0

