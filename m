From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/17] md: remove the kernel version of md_u.h
Date: Thu,  9 Jul 2020 17:18:02 +0200
Message-ID: <20200709151814.110422-6-hch@lst.de>
References: <20200709151814.110422-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200709151814.110422-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

mdp_major can just move to drivers/md/md.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.h           |  1 +
 include/linux/raid/md_u.h | 13 -------------
 2 files changed, 1 insertion(+), 13 deletions(-)
 delete mode 100644 include/linux/raid/md_u.h

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 37315a3f28e97d..6f8fff77ce10a5 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -801,6 +801,7 @@ static inline void mddev_check_write_zeroes(struct mddev *mddev, struct bio *bio
 		mddev->queue->limits.max_write_zeroes_sectors = 0;
 }
 
+extern int mdp_major;
 void md_autostart_arrays(int part);
 
 #endif /* _MD_MD_H */
diff --git a/include/linux/raid/md_u.h b/include/linux/raid/md_u.h
deleted file mode 100644
index 8dfec085a20ee1..00000000000000
--- a/include/linux/raid/md_u.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
-   md_u.h : user <=> kernel API between Linux raidtools and RAID drivers
-          Copyright (C) 1998 Ingo Molnar
-	  
-*/
-#ifndef _MD_U_H
-#define _MD_U_H
-
-#include <uapi/linux/raid/md_u.h>
-
-extern int mdp_major;
-#endif 
-- 
2.26.2
