From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/24] init: open code do_utimes in do_utime
Date: Tue, 21 Jul 2020 18:28:05 +0200
Message-ID: <20200721162818.197315-12-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200721162818.197315-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

Open code the trivial utimes case in a version that takes proper kernel
pointers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/initramfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 3823d15e5d2619..6135b55286fc35 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -104,13 +104,20 @@ static void __init free_hash(void)
 static long __init do_utime(char *filename, time64_t mtime)
 {
 	struct timespec64 t[2];
+	struct path path;
+	int error;
 
 	t[0].tv_sec = mtime;
 	t[0].tv_nsec = 0;
 	t[1].tv_sec = mtime;
 	t[1].tv_nsec = 0;
 
-	return do_utimes(AT_FDCWD, filename, t, AT_SYMLINK_NOFOLLOW);
+	error = kern_path(filename, 0, &path);
+	if (error)
+		return error;
+	error = vfs_utimes(&path, t);
+	path_put(&path);
+	return error;
 }
 
 static __initdata LIST_HEAD(dir_list);
-- 
2.27.0
