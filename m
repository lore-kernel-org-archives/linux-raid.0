From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 24/54] md/raid1: Improve another size determination in
 setup_conf()
Date: Thu, 6 Oct 2016 11:22:44 +0200
Message-ID: <9831fce9-d689-89e4-dec8-50cadcd13fdd@users.sourceforge.net>
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
Date: Tue, 4 Oct 2016 21:46:18 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ec6aafb..5e1a427 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2776,7 +2776,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	struct md_rdev *rdev;
 	int err;
 
-	conf = kzalloc(sizeof(struct r1conf), GFP_KERNEL);
+	conf = kzalloc(sizeof(*conf), GFP_KERNEL);
 	if (!conf)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.10.1

