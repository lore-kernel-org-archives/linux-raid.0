From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 3/4] mdadm:triggers core dump when stat2devnm return NULL
Date: Wed,  8 Mar 2017 15:52:21 +0800
Message-ID: <20170308075221.24965-1-zlliu@suse.com>
References: <20170308074831.24683-1-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170308074831.24683-1-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

ensure that the device should be a block device when uses
--wait parameter, such as the 'f' and 'd' type file would
be triggered core dumped.
./mdadm --wait /dev/md/, happened core dump.

Signed-off-by: Zhilong Liu <zlliu@suse.com>

diff --git a/Monitor.c b/Monitor.c
index 802a9d9..1900db3 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -1002,6 +1002,10 @@ int Wait(char *dev)
 			strerror(errno));
 		return 2;
 	}
+	if ((S_IFMT & stb.st_mode) != S_IFBLK) {
+		pr_err("%s is not a block device.\n", dev);
+		return 2;
+	}
 	strcpy(devnm, stat2devnm(&stb));
 
 	while(1) {
diff --git a/lib.c b/lib.c
index b640634..7116298 100644
--- a/lib.c
+++ b/lib.c
@@ -89,9 +89,6 @@ char *devid2kname(int devid)
 
 char *stat2kname(struct stat *st)
 {
-	if ((S_IFMT & st->st_mode) != S_IFBLK)
-		return NULL;
-
 	return devid2kname(st->st_rdev);
 }
 
-- 
2.10.2

