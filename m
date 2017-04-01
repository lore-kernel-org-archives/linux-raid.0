From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH 4/4] mdadm/Monitor:check the block device when use waitclean parameter
Date: Sat,  1 Apr 2017 20:51:45 +0800
Message-ID: <20170401125145.14440-5-zlliu@suse.com>
References: <20170401125145.14440-1-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170401125145.14440-1-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

WaitClean(): stat2devnm() returns NULL for non block devices.
Check the pointer is valid derefencing it. This would happen
when using --waitclean, such as the 'f' and 'd' file type,
causing a core dump.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---
 Monitor.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Monitor.c b/Monitor.c
index 036a561..101b765 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -1076,6 +1076,8 @@ int WaitClean(char *dev, int sock, int verbose)
 			pr_err("Couldn't open %s: %s\n", dev, strerror(errno));
 		return 1;
 	}
+	if (check_blkdev_via_fstat(fd, dev))
+		return 2;
 
 	strcpy(devnm, fd2devnm(fd));
 	mdi = sysfs_read(fd, devnm, GET_VERSION|GET_LEVEL|GET_SAFEMODE);
-- 
2.10.2

