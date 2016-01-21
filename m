From: Gayatri Kammela <gayatri.kammela@intel.com>
Subject: [PATCH] raid6/algos.c : bug fix : Add the missing definitions to the pq.h file
Date: Thu, 21 Jan 2016 14:02:39 -0800
Message-ID: <1453413759-16064-1-git-send-email-gayatri.kammela@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gayatri Kammela <gayatri.kammela@intel.com>, NeilBrown <neilb@suse.com>, Anton Blanchard <anton@samba.org>, Fenghua Yu <fenghua.yu@intel.com>
List-Id: linux-raid.ids

Adding these pr_info and pr_err definitions so as to allow code to be
compiled successfully for testing in userspace, since the printk has
been replaced by pr_info and pr_err in algos.c

Absence of these definitions result in the compilation errors
such as ' undefined reference to `pr_info' ' ' undefined reference to
`pr_err' '

Cc: NeilBrown <neilb@suse.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
---
 include/linux/raid/pq.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index a7a06d1dcf9c..a0118d5929a9 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -152,6 +152,8 @@ void raid6_dual_recov(int disks, size_t bytes, int faila, int failb,
 
 # define jiffies	raid6_jiffies()
 # define printk 	printf
+# define pr_err(format, ...) fprintf(stderr, format, ## __VA_ARGS__)
+# define pr_info(format, ...) fprintf(stdout, format, ## __VA_ARGS__)
 # define GFP_KERNEL	0
 # define __get_free_pages(x, y)	((unsigned long)mmap(NULL, PAGE_SIZE << (y), \
 						     PROT_READ|PROT_WRITE,   \
-- 
1.9.1

