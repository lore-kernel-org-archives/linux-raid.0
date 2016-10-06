From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 17/54] md/raid1: Move a brace for a designated initialiser
Date: Thu, 6 Oct 2016 11:14:29 +0200
Message-ID: <431b46c0-06d4-646b-35cc-b0f24c7be4b0@users.sourceforge.net>
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
Date: Tue, 4 Oct 2016 18:25:05 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: that open brace { should be on the previous line

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid1.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 15b9652..958bf41 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3176,8 +3176,7 @@ static void *raid1_takeover(struct mddev *mddev)
 	return ERR_PTR(-EINVAL);
 }
 
-static struct md_personality raid1_personality =
-{
+static struct md_personality raid1_personality = {
 	.name		= "raid1",
 	.level		= 1,
 	.owner		= THIS_MODULE,
-- 
2.10.1

