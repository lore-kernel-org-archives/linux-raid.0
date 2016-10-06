From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 26/54] md/raid5: Improve another size determination in
 setup_conf()
Date: Thu, 6 Oct 2016 11:25:06 +0200
Message-ID: <75f780d4-0c3a-cacc-fbdf-5329ea7679ca@users.sourceforge.net>
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
Date: Tue, 4 Oct 2016 22:35:06 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9a43006..562138f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6481,7 +6481,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	conf = kzalloc(sizeof(struct r5conf), GFP_KERNEL);
+	conf = kzalloc(sizeof(*conf), GFP_KERNEL);
 	if (conf == NULL)
 		goto abort;
 	/* Don't enable multi-threading by default*/
-- 
2.10.1

