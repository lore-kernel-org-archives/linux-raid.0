From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/17] initramfs: remove the populate_initrd_image and clean_rootfs stubs
Date: Thu,  9 Jul 2020 17:18:10 +0200
Message-ID: <20200709151814.110422-14-hch@lst.de>
References: <20200709151814.110422-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200709151814.110422-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

If initrd support is not enable just print the warning directly instead
of hiding the fact that we just failed behind two stub functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/initramfs.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 7a38012e1af742..d10404625c31f0 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -618,13 +618,7 @@ static void __init clean_rootfs(void)
 	ksys_close(fd);
 	kfree(buf);
 }
-#else
-static inline void clean_rootfs(void)
-{
-}
-#endif /* CONFIG_BLK_DEV_RAM */
 
-#ifdef CONFIG_BLK_DEV_RAM
 static void __init populate_initrd_image(char *err)
 {
 	ssize_t written;
@@ -644,11 +638,6 @@ static void __init populate_initrd_image(char *err)
 		       written, initrd_end - initrd_start);
 	ksys_close(fd);
 }
-#else
-static void __init populate_initrd_image(char *err)
-{
-	printk(KERN_EMERG "Initramfs unpacking failed: %s\n", err);
-}
 #endif /* CONFIG_BLK_DEV_RAM */
 
 static int __init populate_rootfs(void)
@@ -668,8 +657,12 @@ static int __init populate_rootfs(void)
 
 	err = unpack_to_rootfs((char *)initrd_start, initrd_end - initrd_start);
 	if (err) {
+#ifdef CONFIG_BLK_DEV_RAM
 		clean_rootfs();
 		populate_initrd_image(err);
+#else
+		printk(KERN_EMERG "Initramfs unpacking failed: %s\n", err);
+#endif
 	}
 
 done:
-- 
2.26.2
