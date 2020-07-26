From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 05/21] init: initialize ramdisk_execute_command at compile time
Date: Sun, 26 Jul 2020 09:13:40 +0200
Message-ID: <20200726071356.287160-6-hch@lst.de>
References: <20200726071356.287160-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200726071356.287160-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Set ramdisk_execute_command to "/init" at compile time.  The command
line can still override it, but this saves a few instructions and
removes a NULL check.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 init/main.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/init/main.c b/init/main.c
index db0621dfbb0468..c2c9143db96795 100644
--- a/init/main.c
+++ b/init/main.c
@@ -154,7 +154,7 @@ static bool initargs_found;
 #endif
 
 static char *execute_command;
-static char *ramdisk_execute_command;
+static char *ramdisk_execute_command = "/init";
 
 /*
  * Used to generate warnings if static_key manipulation functions are used
@@ -1514,10 +1514,6 @@ static noinline void __init kernel_init_freeable(void)
 	 * check if there is an early userspace init.  If yes, let it do all
 	 * the work
 	 */
-
-	if (!ramdisk_execute_command)
-		ramdisk_execute_command = "/init";
-
 	if (ksys_access((const char __user *)
 			ramdisk_execute_command, 0) != 0) {
 		ramdisk_execute_command = NULL;
-- 
2.27.0
