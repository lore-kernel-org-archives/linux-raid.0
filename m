From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 3/4] Monitor: fix writing autorebuild.pid
Date: Fri, 26 Nov 2010 18:26:58 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010C009E3F@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

From b51326776e526d301d0efb92151a9ee73c1419b9 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 26 Nov 2010 15:29:53 +0100
Subject: [PATCH 3/4] Monitor: fix writing autorebuild.pid
Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>

If /var/run/mdadm doesn't exist we can never succeed writing
so we should try to create it first. When we make sure it is there we
write pid file as before.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index cacd2fe..b78a66b 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -296,21 +296,27 @@ static int check_one_sharer(int scan)
 			} else {
 				fprintf(stderr, Name ": Warning: One"
 					" autorebuild process already"
-					" running.");
+					" running.\n");
 			}
 		}
 		fclose(fp);
 	}
 	if (scan) {
-		fp = fopen("/var/run/mdadm/autorebuild.pid", "w");
-		if (!fp)
-			fprintf(stderr, Name ": Cannot create"
-				" autorebuild.pid "
-				"file\n");
-		else {
-			pid = getpid();
-			fprintf(fp, "%d\n", pid);
-			fclose(fp);
+		if (mkdir("/var/run/mdadm", S_IRWXU) < 0 &&
+		    errno != EEXIST) {
+			fprintf(stderr, Name ": Can't create "
+				"autorebuild.pid file\n");
+		} else {
+			fp = fopen("/var/run/mdadm/autorebuild.pid", "w");
+			if (!fp)
+				fprintf(stderr, Name ": Cannot create"
+					" autorebuild.pid"
+					"file\n");
+			else {
+				pid = getpid();
+				fprintf(fp, "%d\n", pid);
+				fclose(fp);
+			}
 		}
 	}
 	return 0;
-- 
1.7.1

