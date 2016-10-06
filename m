From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 42/54] md/raid10: Delete an error message for a failed memory
 allocation
Date: Thu, 6 Oct 2016 11:42:39 +0200
Message-ID: <06ccc5b5-61e7-aeae-23b4-84dafac8ed05@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, Wolfram Sang <wsa@the-dreams.de>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Oct 2016 16:57:19 +0200

Omit an extra message for a memory allocation failure
(and another corresponding condition check) in this function.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid10.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 04e8f78..1f712f7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3554,9 +3554,6 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	return conf;
 
  out:
-	if (err == -ENOMEM)
-		printk(KERN_ERR "md/raid10:%s: couldn't allocate memory.\n",
-		       mdname(mddev));
 	if (conf) {
 		mempool_destroy(conf->r10bio_pool);
 		kfree(conf->mirrors);
-- 
2.10.1
