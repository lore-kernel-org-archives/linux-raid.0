From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 04/23] devtmpfs: refactor devtmpfsd()
Date: Tue, 28 Jul 2020 18:33:57 +0200
Message-ID: <20200728163416.556521-5-hch@lst.de>
References: <20200728163416.556521-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200728163416.556521-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Split the main worker loop into a separate function.  This allows
devtmpfsd_setup to be marked __init, which will allows us to call
__init routines for the setup work.  devtmpfѕ itself needs a __ref
marker for that to work, and a comment explaining why it works.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/base/devtmpfs.c | 52 ++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index c9017e0584c003..d697634bc0d48c 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -378,7 +378,30 @@ static int handle(const char *name, umode_t mode, kuid_t uid, kgid_t gid,
 		return handle_remove(name, dev);
 }
 
-static int devtmpfs_setup(void *p)
+static void __noreturn devtmpfs_work_loop(void)
+{
+	while (1) {
+		spin_lock(&req_lock);
+		while (requests) {
+			struct req *req = requests;
+			requests = NULL;
+			spin_unlock(&req_lock);
+			while (req) {
+				struct req *next = req->next;
+				req->err = handle(req->name, req->mode,
+						  req->uid, req->gid, req->dev);
+				complete(&req->done);
+				req = next;
+			}
+			spin_lock(&req_lock);
+		}
+		__set_current_state(TASK_INTERRUPTIBLE);
+		spin_unlock(&req_lock);
+		schedule();
+	}
+}
+
+static int __init devtmpfs_setup(void *p)
 {
 	int err;
 
@@ -396,31 +419,18 @@ static int devtmpfs_setup(void *p)
 	return err;
 }
 
-static int devtmpfsd(void *p)
+/*
+ * The __ref is because devtmpfs_setup needs to be __init for the routines it
+ * calls.  That call is done while devtmpfs_init, which is marked __init,
+ * synchronously waits for it to complete.
+ */
+static int __ref devtmpfsd(void *p)
 {
 	int err = devtmpfs_setup(p);
 
 	if (err)
 		return err;
-	while (1) {
-		spin_lock(&req_lock);
-		while (requests) {
-			struct req *req = requests;
-			requests = NULL;
-			spin_unlock(&req_lock);
-			while (req) {
-				struct req *next = req->next;
-				req->err = handle(req->name, req->mode,
-						  req->uid, req->gid, req->dev);
-				complete(&req->done);
-				req = next;
-			}
-			spin_lock(&req_lock);
-		}
-		__set_current_state(TASK_INTERRUPTIBLE);
-		spin_unlock(&req_lock);
-		schedule();
-	}
+	devtmpfs_work_loop();
 	return 0;
 }
 
-- 
2.27.0
