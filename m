From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/24] init: move the prepare_namespace prototype to init/do_mounts.h
Date: Tue, 21 Jul 2020 18:28:02 +0200
Message-ID: <20200721162818.197315-9-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200721162818.197315-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

No need to have this prototype in a global header included by
every driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/init.h | 1 -
 init/do_mounts.h     | 1 +
 init/main.c          | 2 ++
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 212fc9e2f691a1..7de54fcad39431 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -147,7 +147,6 @@ extern unsigned int reset_devices;
 
 /* used by init/main.c */
 void setup_arch(char **);
-void prepare_namespace(void);
 void __init init_rootfs(void);
 extern struct file_system_type rootfs_fs_type;
 
diff --git a/init/do_mounts.h b/init/do_mounts.h
index c855b3f0e06d19..853da3cc4a3586 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -11,6 +11,7 @@
 
 void  mount_block_root(char *name, int flags);
 void  mount_root(void);
+void prepare_namespace(void);
 extern int root_mountflags;
 
 static inline int create_dev(char *name, dev_t dev)
diff --git a/init/main.c b/init/main.c
index c2c9143db96795..b952e4cd685af4 100644
--- a/init/main.c
+++ b/init/main.c
@@ -103,6 +103,8 @@
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
 
+#include "do_mounts.h"
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/initcall.h>
 
-- 
2.27.0
