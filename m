From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] md: do not count journal as spare in GET_ARRAY_INFO
Date: Thu, 11 Aug 2016 17:14:45 -0700
Message-ID: <1470960885-2860586-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: yizhan@redhat.com, Song Liu <songliubraving@fb.com>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

GET_ARRAY_INFO counts journal as spare (spare_disks), which is not
accurate. This patch fixes this.

Reported-by: Yi Zhang <yizhan@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2c3ab6f..df595a8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5851,6 +5851,9 @@ static int get_array_info(struct mddev *mddev, void __user *arg)
 			working++;
 			if (test_bit(In_sync, &rdev->flags))
 				insync++;
+			else if (test_bit(Journal, &rdev->flags))
+				/* TODO: add journal count to md_u.h */
+				;
 			else
 				spare++;
 		}
-- 
2.8.0.rc2

