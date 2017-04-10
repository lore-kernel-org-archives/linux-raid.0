From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH] mdadm.c:fix compile warning "mdfd is uninitialized"
Date: Mon, 10 Apr 2017 12:49:52 +0800
Message-ID: <1491799792-6974-1-git-send-email-zlliu@suse.com>
References: <016b495a-1361-0f29-0fcb-6af008625565@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <016b495a-1361-0f29-0fcb-6af008625565@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

Initialized the mdfd as -1 to prevent compile error
of some compilers.
For example, gcc version 4.8.5(SUSE Linux).

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 mdadm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdadm.c b/mdadm.c
index 001ff68..41dae1d 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1916,7 +1916,7 @@ static int misc_list(struct mddev_dev *devlist,
 	int rv = 0;
 
 	for (dv = devlist; dv; dv = (rv & 16) ? NULL : dv->next) {
-		int mdfd;
+		int mdfd = -1;
 
 		switch(dv->disposition) {
 		case 'D':
-- 
2.6.6

