From: Adrian Bunk <bunk@stusta.de>
Subject: FYI: [2.6.16 patch] drivers/md/md.c: update START_ARRAY printk
Date: Wed, 8 Nov 2006 08:24:28 +0100
Message-ID: <20061108072428.GQ4729@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: mingo@redhat.com, neilb@cse.unsw.edu.au
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

FYI: I've just committed the patch below in the 2.6.16 tree.

cu
Adrian


commit f919643362f45c65457e01ddd9aed0682497b2f8
Author: Adrian Bunk <bunk@stusta.de>
Date:   Wed Nov 8 08:19:14 2006 +0100

    drivers/md/md.c: update START_ARRAY printk
    
    START_ARRAY will not be removed in 2.6.16, therefore replace the date
    reference with a kernel version reference.
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d05e312..78cca0c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3662,7 +3662,7 @@ static int md_ioctl(struct inode *inode,
 		if (cnt > 0 ) {
 			printk(KERN_WARNING
 			       "md: %s(pid %d) used deprecated START_ARRAY ioctl. "
-			       "This will not be supported beyond July 2006\n",
+			       "START_ARRAY is removed in kernel 2.6.19 and above.\n",
 			       current->comm, current->pid);
 			cnt--;
 		}
