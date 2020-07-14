From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/23] init: open code setting up stdin/stdout/stderr
Date: Tue, 14 Jul 2020 21:04:22 +0200
Message-ID: <20200714190427.4332-19-hch@lst.de>
References: <20200714190427.4332-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200714190427.4332-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Don't rely on the implicit set_fs(KERNEL_DS) for ksys_open to work, but
instead open a struct file for /dev/console and then install it as FD
0/1/2 manually.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/main.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/init/main.c b/init/main.c
index 0ead83e86b5aa2..db0621dfbb0468 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1457,15 +1457,19 @@ static int __ref kernel_init(void *unused)
 	      "See Linux Documentation/admin-guide/init.rst for guidance.");
 }
 
+/* Open /dev/console, for stdin/stdout/stderr, this should never fail */
 void console_on_rootfs(void)
 {
-	/* Open the /dev/console as stdin, this should never fail */
-	if (ksys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
-		pr_err("Warning: unable to open an initial console.\n");
+	struct file *file = filp_open("/dev/console", O_RDWR, 0);
 
-	/* create stdout/stderr */
-	(void) ksys_dup(0);
-	(void) ksys_dup(0);
+	if (IS_ERR(file)) {
+		pr_err("Warning: unable to open an initial console.\n");
+		return;
+	}
+	get_file_rcu_many(file, 2);
+	fd_install(get_unused_fd_flags(0), file);
+	fd_install(get_unused_fd_flags(0), file);
+	fd_install(get_unused_fd_flags(0), file);
 }
 
 static noinline void __init kernel_init_freeable(void)
-- 
2.27.0
