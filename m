From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: [PATCH] md: add a newline when printing parameter 'start_ro' by sysfs
Date: Mon, 11 May 2020 16:23:25 +0800
Message-ID: <1589185405-39519-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, wangxiongfeng2@huawei.com
List-Id: linux-raid.ids

Add a missing newline when printing module parameter 'start_ro' by
sysfs.

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 271e8a5..acffcc0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9785,7 +9785,7 @@ static __exit void md_exit(void)
 
 static int get_ro(char *buffer, const struct kernel_param *kp)
 {
-	return sprintf(buffer, "%d", start_readonly);
+	return sprintf(buffer, "%d\n", start_readonly);
 }
 static int set_ro(const char *val, const struct kernel_param *kp)
 {
-- 
1.7.12.4
