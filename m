From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 12/54] md/raid1: Use kcalloc() in setup_conf()
Date: Thu, 6 Oct 2016 11:07:45 +0200
Message-ID: <1d9f7914-b224-9329-d132-ae4c07d3b512@users.sourceforge.net>
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
Date: Tue, 4 Oct 2016 15:30:28 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kcalloc".

* Replace the specification of a data structure by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid1.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e75ae87..5969711 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2781,9 +2781,9 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf)
 		goto abort;
 
-	conf->mirrors = kzalloc(sizeof(struct raid1_info)
-				* mddev->raid_disks * 2,
-				 GFP_KERNEL);
+	conf->mirrors = kcalloc(mddev->raid_disks * 2,
+				sizeof(*conf->mirrors),
+				GFP_KERNEL);
 	if (!conf->mirrors)
 		goto abort;
 
-- 
2.10.1
