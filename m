From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 08/15] md-cluster: Improve determination of sizes in
 read_resync_info()
Date: Sat, 1 Oct 2016 16:53:10 +0200
Message-ID: <8319afa1-438c-03c7-3526-be25bc3171dd@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3a03df66-92ce-20fb-17f3-fb79b9d43c8e@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 1 Oct 2016 12:52:58 +0200

Replace the specification of data structures by either a pointer
dereference or a variable name as the parameter for the operator "sizeof"
to make the corresponding size determination a bit safer according to
the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md-cluster.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index e965e78..0918108 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -275,10 +275,10 @@ static struct suspend_info *read_resync_info(struct mddev *mddev, struct dlm_loc
 	sector_t hi = 0;
 
 	dlm_lock_sync(lockres, DLM_LOCK_CR);
-	memcpy(&ri, lockres->lksb.sb_lvbptr, sizeof(struct resync_info));
+	memcpy(&ri, lockres->lksb.sb_lvbptr, sizeof(ri));
 	hi = le64_to_cpu(ri.hi);
 	if (hi > 0) {
-		s = kzalloc(sizeof(struct suspend_info), GFP_KERNEL);
+		s = kzalloc(sizeof(*s), GFP_KERNEL);
 		if (!s)
 			goto out;
 		s->hi = hi;
-- 
2.10.0

