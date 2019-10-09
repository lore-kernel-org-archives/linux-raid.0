From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v6 27/43] compat_ioctl: remove last RAID handling code
Date: Wed,  9 Oct 2019 21:10:27 +0200
Message-ID: <20191009191044.308087-27-arnd@arndb.de>
References: <20191009190853.245077-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191009190853.245077-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, y2038@lists.linaro.org, linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-raid@vger.kernel.org, Song Liu <song@kernel.org>
List-Id: linux-raid.ids

Commit aa98aa31987a ("md: move compat_ioctl handling into md.c")
already removed the COMPATIBLE_IOCTL() table entries and added
a complete implementation, but a few lines got left behind and
should also be removed here.

Cc: linux-raid@vger.kernel.org
Cc: Song Liu <song@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/compat_ioctl.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 6070481f2b6a..1ed32cca2176 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -462,19 +462,6 @@ static long do_ioctl_trans(unsigned int cmd,
 #endif
 	}
 
-	/*
-	 * These take an integer instead of a pointer as 'arg',
-	 * so we must not do a compat_ptr() translation.
-	 */
-	switch (cmd) {
-	/* RAID */
-	case HOT_REMOVE_DISK:
-	case HOT_ADD_DISK:
-	case SET_DISK_FAULTY:
-	case SET_BITMAP_FILE:
-		return vfs_ioctl(file, cmd, arg);
-	}
-
 	return -ENOIOCTLCMD;
 }
 
-- 
2.20.0
