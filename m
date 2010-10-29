From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 08/17] mdadm: added --no-sharing option for Monitor mode
Date: Fri, 29 Oct 2010 15:21:23 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FC4@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

From 1e93c6e87b7d4a88ab5e9d7238fc1900771cf403 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Thu, 28 Oct 2010 12:33:43 +0200
Subject: [PATCH 08/17] mdadm: added --no-sharing option for Monitor mode

--no-sharing option disables moving spares between arrays/containers.
Without the option spares are moved if needed according to config rules.
We only allow one process moving spares started with --scan option.
If there is such process running and another instance of Monitor
is starting without --scan, then we issue a warning but allow it
to continue.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   47 +++++++++++++++++++++++++++++++++++++++++++----
 ReadMe.c  |    2 ++
 mdadm.c   |    8 ++++++--
 mdadm.h   |    6 ++++--
 4 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index f898b2e..a4bfedd 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -59,7 +59,8 @@ static void spare_sharing_in_spare_groups(struct state *statelist, char *mailadd
 int Monitor(mddev_dev_t devlist,
 	    char *mailaddr, char *alert_cmd,
 	    int period, int daemonise, int scan, int oneshot,
-	    int dosyslog, int test, char* pidfile, int increments)
+	    int dosyslog, int test, char *pidfile, int increments,
+	    int share)
 {
 	/*
 	 * Every few seconds, scan every md device looking for changes
@@ -155,6 +156,45 @@ int Monitor(mddev_dev_t devlist,
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
+				if (scan) {
+					fprintf(stderr, Name ": Only one "
+						"autorebuild process allowed"
+						" in scan mode, aborting\n");
+					fclose(fp);
+					return 1;
+				} else {
+					fprintf(stderr, Name ": Warning: One"
+						" autorebuild process already"
+						" running.");
+				}
+			}
+			fclose(fp);
+		}
+		if (scan) {
+			fp = fopen("/var/run/mdadm/autorebuild.pid", "w");
+			if (!fp)
+				fprintf(stderr, Name ": Cannot create"
+					" autorebuild.pid "
+					"file\n");
+			else {
+				pid = getpid();
+				fprintf(fp, "%d\n", pid);
+				fclose(fp);
+			}
+		}
+	}
+
 	if (devlist == NULL) {
 		mddev_ident_t mdlist = conf_get_ident(NULL);
 		for (; mdlist; mdlist=mdlist->next) {
@@ -454,9 +494,8 @@ int Monitor(mddev_dev_t devlist,
 					new_found = 1;
 				}
 		}
-
-		spare_sharing_in_spare_groups(statelist, mailaddr, mailfrom, alert_cmd, dosyslog);
-
+		if (share)
+			spare_sharing_in_spare_groups(statelist, mailaddr, mailfrom, alert_cmd, dosyslog);
 		if (!new_found) {
 			if (oneshot)
 				break;
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
index 758632c..34df28c 100644
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
@@ -1501,7 +1505,7 @@ int main(int argc, char *argv[])
 		}
 		rv= Monitor(devlist, mailaddr, program,
 			    delay?delay:60, daemonise, scan, oneshot,
-			    dosyslog, test, pidfile, increments);
+			    dosyslog, test, pidfile, increments, spare_sharing);
 		break;
 
 	case GROW:
diff --git a/mdadm.h b/mdadm.h
index 66363fb..19194b9 100644
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

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

