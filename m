From: Chao Yu <chao2.yu@samsung.com>
Subject: [PATCH] md: avoid potential long delay under pers_lock
Date: Thu, 25 Sep 2014 15:28:34 +0800
Message-ID: <002801cfd892$696e39d0$3c4aad70$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

printk may cause long time lapse if value of printk_delay in sysctl is
configured large by user. If register_md_personality takes long time to print in
spinlock pers_lock, we may encounter high CPU usage rate when there are other
pers_lock competitors who may be blocked to spin.
We can avoid this condition by moving printk out of coverage of pers_lock
spinlock.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e02de05..5fcf215 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7200,9 +7200,10 @@ static const struct file_operations md_seq_fops = {
 
 int register_md_personality(struct md_personality *p)
 {
+	printk(KERN_INFO "md: %s personality registered for level %d\n",
+						p->name, p->level);
 	spin_lock(&pers_lock);
 	list_add_tail(&p->list, &pers_list);
-	printk(KERN_INFO "md: %s personality registered for level %d\n", p->name, p->level);
 	spin_unlock(&pers_lock);
 	return 0;
 }
-- 
2.0.1.474.g72c7794
