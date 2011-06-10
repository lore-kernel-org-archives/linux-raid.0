From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] mdadm: Linux 3.x version change
Date: Fri, 10 Jun 2011 23:30:00 +0900
Message-ID: <1307716200-27483-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As Linux 3.x changes its versioning scheme, we have to deal with
the 2-digit version number also.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 util.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/util.c b/util.c
index e92be4f..9db9ee6 100644
--- a/util.c
+++ b/util.c
@@ -154,8 +154,15 @@ int get_linux_version()
 	a = strtoul(cp, &cp, 10);
 	if (*cp != '.') return -1;
 	b = strtoul(cp+1, &cp, 10);
-	if (*cp != '.') return -1;
-	c = strtoul(cp+1, NULL, 10);
+	/* deal with 3.x version change */
+	if (*cp != '.') {
+		if (a >= 3)
+			c = 0;
+		else
+			return -1;
+	} else {
+		c = strtoul(cp+1, NULL, 10);
+	}
 
 	return (a*1000000)+(b*1000)+c;
 }
-- 
1.7.5.2

