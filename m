From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 07/18] md/raid10: minor code improvement in
 fix_read_error()
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.53844.stgit@noble>
References: <20160602061319.2939.72280.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160602061319.2939.72280.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

rdev already holds conf->mirrors[d].rdev, so no need to load it again.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 588cf6544f07..819c6d5767a4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2262,7 +2262,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		printk(KERN_NOTICE
 		       "md/raid10:%s: %s: Failing raid device\n",
 		       mdname(mddev), b);
-		md_error(mddev, conf->mirrors[d].rdev);
+		md_error(mddev, rdev);
 		r10_bio->devs[r10_bio->read_slot].bio = IO_BLOCKED;
 		return;
 	}


