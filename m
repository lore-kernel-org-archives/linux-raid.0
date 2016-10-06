From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 41/54] md/raid10: Improve another size determination in
 setup_conf()
Date: Thu, 6 Oct 2016 11:41:14 +0200
Message-ID: <f44daa64-b505-5b98-75a7-8c843fe24846@users.sourceforge.net>
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
Date: Wed, 5 Oct 2016 16:51:52 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 17352a9..04e8f78 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3499,7 +3499,7 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	}
 
 	err = -ENOMEM;
-	conf = kzalloc(sizeof(struct r10conf), GFP_KERNEL);
+	conf = kzalloc(sizeof(*conf), GFP_KERNEL);
 	if (!conf)
 		goto out;
 
-- 
2.10.1
