From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: PATCH - MD - Remove get_spare declaration and associated warning
Date: Wed, 24 Jul 2002 22:41:08 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15678.41060.865956.301053@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


get_spare recently became static and no-one told md_k.h


 ----------- Diffstat output ------------
 ./include/linux/raid/md_k.h |    1 -
 1 files changed, 1 deletion(-)

--- ./include/linux/raid/md_k.h	2002/07/24 12:22:08	1.1
+++ ./include/linux/raid/md_k.h	2002/07/24 12:22:25	1.2
@@ -249,7 +249,6 @@ static inline kdev_t mddev_to_kdev(mddev
 }
 
 extern mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr);
-extern mdk_rdev_t *get_spare(mddev_t *mddev);
 
 /*
  * iterates through some rdev ringlist. It's safe to remove the
