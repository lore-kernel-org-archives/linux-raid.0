From: "Maxin B. John" <maxin.john@gmail.com>
Subject: [PATCH 3/3][mdadm] Monitor.c: fix compiler error with x32 toolchain
Date: Sat,  6 Feb 2016 00:28:18 +0200
Message-ID: <1454711298-32524-3-git-send-email-maxin.john@gmail.com>
References: <1454711298-32524-1-git-send-email-maxin.john@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1454711298-32524-1-git-send-email-maxin.john@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: "Maxin B. John" <maxin.john@intel.com>
List-Id: linux-raid.ids

From: "Maxin B. John" <maxin.john@intel.com>

With x32 toolchain, this code caused the below listed error:

| Monitor.c: In function 'check_array':
| Monitor.c:545:16: error: comparison between signed and unsigned
integer expressions [-Werror=sign-compare]
|   if (st->utime == array.utime &&

Signed-off-by: Maxin B. John <maxin.john@intel.com>
---
 Monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Monitor.c b/Monitor.c
index f19c2e5..748d61b 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -542,7 +542,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		alert("NewArray", st->devname, NULL, ainfo);
 	}
 
-	if (st->utime == array.utime &&
+	if ((unsigned long)st->utime == array.utime &&
 	    st->failed == array.failed_disks &&
 	    st->working == array.working_disks &&
 	    st->spare == array.spare_disks &&
-- 
2.1.4

