From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2] md-multipath: Use seq_putc() in multipath_status()
Date: Sat, 13 Jan 2018 09:55:08 +0100
Message-ID: <0b59904d-1be7-7a76-9c32-3f7f9696ff2d@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <4a31d7a7-f70c-12f7-202f-963bd8706066@users.sourceforge.net>
 <6e70a1a7-fd86-914e-84ab-bd5c7facb235@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <6e70a1a7-fd86-914e-84ab-bd5c7facb235@users.sourceforge.net>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 13 Jan 2018 09:49:03 +0100

A single character (closing square bracket) should be put into a sequence.
Thus use the corresponding function "seq_putc".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md-multipath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-multipath.c b/drivers/md/md-multipath.c
index e40065bdbfc8..0a7e99d62c69 100644
--- a/drivers/md/md-multipath.c
+++ b/drivers/md/md-multipath.c
@@ -157,7 +157,7 @@ static void multipath_status(struct seq_file *seq, struct mddev *mddev)
 		seq_printf (seq, "%s", rdev && test_bit(In_sync, &rdev->flags) ? "U" : "_");
 	}
 	rcu_read_unlock();
-	seq_printf (seq, "]");
+	seq_putc(seq, ']');
 }
 
 static int multipath_congested(struct mddev *mddev, int bits)
-- 
2.15.1

