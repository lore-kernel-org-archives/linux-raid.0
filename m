From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 12/15] md-cluster: Rename a jump label in area_resyncing()
Date: Sat, 1 Oct 2016 16:57:28 +0200
Message-ID: <49a4ee61-0bbe-fa70-dba5-de1e1c08bbe0@users.sourceforge.net>
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
Date: Sat, 1 Oct 2016 14:38:12 +0200

Adjust a jump label according to the Linux coding style convention

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/md-cluster.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 7f82c6b..e1ebcc4 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1085,13 +1085,13 @@ static int area_resyncing(struct mddev *mddev, int direction,
 
 	spin_lock_irq(&cinfo->suspend_lock);
 	if (list_empty(&cinfo->suspend_list))
-		goto out;
+		goto unlock;
 	list_for_each_entry(s, &cinfo->suspend_list, list)
 		if (hi > s->lo && lo < s->hi) {
 			ret = 1;
 			break;
 		}
-out:
+unlock:
 	spin_unlock_irq(&cinfo->suspend_lock);
 	return ret;
 }
-- 
2.10.0

