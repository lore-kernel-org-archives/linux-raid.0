From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [AUTOREBUILD 3/8] mdadm: added --no-sharing parameter for Monitor
 mode
Date: Fri, 1 Oct 2010 13:37:28 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D171D09955@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From ff3b37c3b4c188334a5f65d279bd6da504567274 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Tue, 28 Sep 2010 05:47:29 +0200
Subject: [AUTOREBUILD 3/8] mdadm: added --no-sharing parameter for Monitor mode

To avoid races we only allow one Monitoring process that will move spares.
By default Monitor will have spare sharing on.
If we just want to monitor --no-sharing parameter must be added to usual
parameters.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 Monitor.c |   33 ++++++++++++++++++++++++++++++++-
 ReadMe.c  |    2 ++
 mdadm.c   |    8 ++++++--
 mdadm.h   |    6 ++++--
 4 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 82ccfb2..2adea36 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -41,7 +41,8 @@ static void alert(char *event, char *dev, char *disc, char *mailaddr, char *mail
 int Monitor(mddev_dev_t devlist,
 	    char *mailaddr, char *alert_cmd,
 	    int period, int daemonise, int scan, int oneshot,
-	    int dosyslog, int test, char* pidfile, int increments)
+	    int dosyslog, int test, char *pidfile, int increments,
+	    int share)
 {
 	/*
 	 * Every few seconds, scan every md device looking for changes
@@ -143,6 +144,36 @@ int Monitor(mddev_dev_t devlist,
 		setsid();
 	}
 
+	if (share) {
+		int pid, rv;
+		FILE *fp;
+		char dir[20];
+		struct stat buf;
+		fp = fopen("/var/run/mdadm/autorebuild.pid", "r");
+		if (fp) {
+			fscanf(fp, "%d", &pid);
+			sprintf(dir, "/proc/%d", pid);
+			rv = stat(dir, &buf);
+			if (rv != -1) {
+				fprintf(stderr, Name ": Only one autorebuild "
+						     "process allowed, "
+						     "aborting\n");
+				fclose(fp);
+				return 1;
+			}
+			fclose(fp);
+		}
+		fp = fopen("/var/run/mdadm/autorebuild.pid", "w");
+		if (!fp) {
+			fprintf(stderr, Name ": Cannot create autorebuild.pid "
+					     "file, aborting\n");
+			return 1;
+		}
+		pid = getpid();
+		fprintf(fp, "%d\n", pid);
+		fclose(fp);
+	}
+
 	if (devlist == NULL) {
 		mddev_ident_t mdlist = conf_get_ident(NULL);
 		for (; mdlist; mdlist=mdlist->next) {
diff --git a/ReadMe.c b/ReadMe.c
index 07abdb7..54a1998 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -185,6 +185,8 @@ struct option long_options[] = {
     {"oneshot",   0, 0, '1'},
     {"pid-file",  1, 0, 'i'},
     {"syslog",    0, 0, 'y'},
+    {"no-sharing", 0, 0, NoSharing},
+
     /* For Grow */
     {"backup-file", 1,0, BackupFile},
     {"array-size", 1, 0, 'Z'},
diff --git a/mdadm.c b/mdadm.c
index cb9921e..c9a172a 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -96,6 +96,7 @@ int main(int argc, char *argv[])
 	int daemonise = 0;
 	char *pidfile = NULL;
 	int oneshot = 0;
+	int spare_sharing = 1;
 	struct supertype *ss = NULL;
 	int writemostly = 0;
 	int re_add = 0;
@@ -228,6 +229,7 @@ int main(int argc, char *argv[])
 				subarray = optarg;
 			}
 		case 'K': if (!mode) newmode = MISC; break;
+		case NoSharing: newmode = MONITOR; break;
 		}
 		if (mode && newmode == mode) {
 			/* everybody happy ! */
@@ -779,7 +781,9 @@ int main(int argc, char *argv[])
 			openlog("mdadm", LOG_PID, SYSLOG_FACILITY);
 			dosyslog = 1;
 			continue;
-
+		case O(MONITOR, NoSharing):
+			spare_sharing = 0;
+			continue;
 			/* now the general management options.  Some are applicable
 			 * to other modes. None have arguments.
 			 */
@@ -1500,7 +1504,7 @@ int main(int argc, char *argv[])
 		}
 		rv= Monitor(devlist, mailaddr, program,
 			    delay?delay:60, daemonise, scan, oneshot,
-			    dosyslog, test, pidfile, increments);
+			    dosyslog, test, pidfile, increments, spare_sharing);
 		break;
 
 	case GROW:
diff --git a/mdadm.h b/mdadm.h
index 0e514ee..56452bb 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -288,7 +288,8 @@ enum special_options {
 	DetailPlatform,
 	KillSubarray,
 	UpdateSubarray, /* 16 */
-	IncrementalPath
+	IncrementalPath,
+	NoSharing
 };
 
 /* structures read from config file */
@@ -924,7 +925,8 @@ extern int Examine(mddev_dev_t devlist, int brief, int export, int scan,
 extern int Monitor(mddev_dev_t devlist,
 		   char *mailaddr, char *alert_cmd,
 		   int period, int daemonise, int scan, int oneshot,
-		   int dosyslog, int test, char *pidfile, int increments);
+		   int dosyslog, int test, char *pidfile, int increments,
+		   int share);
 
 extern int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl);
 extern int Kill_subarray(char *dev, char *subarray, int quiet);
-- 
1.6.4.2

