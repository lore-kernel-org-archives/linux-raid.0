From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 47/54] md/raid10: Improve another size determination in
 raid10_start_reshape()
Date: Thu, 6 Oct 2016 11:47:01 +0200
Message-ID: <f0fcea7b-2ebb-24c7-981d-91867d4dd350@users.sourceforge.net>
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
Date: Wed, 5 Oct 2016 18:48:17 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9b8d11f..62cd159 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4065,7 +4065,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 	spin_lock_irq(&conf->device_lock);
 	if (conf->mirrors_new) {
 		memcpy(conf->mirrors_new, conf->mirrors,
-		       sizeof(struct raid10_info)*conf->prev.raid_disks);
+		       sizeof(*conf->mirrors_new) * conf->prev.raid_disks);
 		smp_mb();
 		kfree(conf->mirrors_old);
 		conf->mirrors_old = conf->mirrors;
-- 
2.10.1
