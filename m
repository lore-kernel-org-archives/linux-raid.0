From: Jes.Sorensen@redhat.com
Subject: [PATCH] Use MDMON_DIR for pid files created in Monitor.c
Date: Thu,  2 Feb 2012 12:45:02 +0100
Message-ID: <1328183102-9377-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Other parts of mdadm/mdmon place .pid/.sock files in MDMON_DIR. This
makes Monitor.c consistent with the rest.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Monitor.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 77f22aa..7ed5282 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -294,8 +294,10 @@ static int check_one_sharer(int scan)
 	int pid, rv;
 	FILE *fp;
 	char dir[20];
+	char path[100];
 	struct stat buf;
-	fp = fopen("/var/run/mdadm/autorebuild.pid", "r");
+	sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
+	fp = fopen(path, "r");
 	if (fp) {
 		if (fscanf(fp, "%d", &pid) != 1)
 			pid = -1;
@@ -317,12 +319,12 @@ static int check_one_sharer(int scan)
 		fclose(fp);
 	}
 	if (scan) {
-		if (mkdir("/var/run/mdadm", S_IRWXU) < 0 &&
+		if (mkdir(MDMON_DIR, S_IRWXU) < 0 &&
 		    errno != EEXIST) {
 			fprintf(stderr, Name ": Can't create "
 				"autorebuild.pid file\n");
 		} else {
-			fp = fopen("/var/run/mdadm/autorebuild.pid", "w");
+			fp = fopen(path, "w");
 			if (!fp)
 				fprintf(stderr, Name ": Cannot create"
 					" autorebuild.pid"
-- 
1.7.4.4

