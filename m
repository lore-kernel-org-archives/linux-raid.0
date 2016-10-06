From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 11/54] md/raid1: Use kcalloc() in raid1_reshape()
Date: Thu, 6 Oct 2016 11:06:37 +0200
Message-ID: <ef063d2f-ec84-a475-9541-b777bd68baba@users.sourceforge.net>
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
Date: Tue, 4 Oct 2016 15:17:13 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kcalloc".

* Replace the specification of a data structure by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d2759f8..e75ae87 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3081,8 +3081,8 @@ static int raid1_reshape(struct mddev *mddev)
 		kfree(newpoolinfo);
 		return -ENOMEM;
 	}
-	newmirrors = kzalloc(sizeof(struct raid1_info) * raid_disks * 2,
-			     GFP_KERNEL);
+
+	newmirrors = kcalloc(raid_disks * 2, sizeof(*newmirrors), GFP_KERNEL);
 	if (!newmirrors) {
 		kfree(newpoolinfo);
 		mempool_destroy(newpool);
-- 
2.10.1

