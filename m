From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: [PATCH 22/35] mdadm: added --no-sharing parameter for Monitor mode
Date: Mon, 16 Aug 2010 10:57:14 +0100
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F0101E8F9FF@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

From f16f795c3cc17bb7b567c302b504b0da569c8845 Mon Sep 17 00:00:00 2001
From: Anna Czarnowska <anna.czarnowska@intel.com>
Date: Fri, 23 Jul 2010 21:58:19 +0200
Subject: [PATCH 22/35] mdadm: added --no-sharing parameter for Monitor mode

To avoid races we only allow one Monitoring process that will move spares.
By default Monitor will have spare sharing on.
If we just want to monitor --no-sharing parameter must be added to usual
parameters.

Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
---
 Monitor.c |   32 +++++++++++++++++++++++++++++++-
 ReadMe.c  |    2 ++
 mdadm.c   |    8 ++++++--
 mdadm.h   |    3 ++-
 4 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 5a2cae1..088d511 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -41,7 +41,7 @@ static void alert(char *event, char *dev, char *disc, char *mailaddr, char *mail
 int Monitor(mddev_dev_t devlist,
 	    char *mailaddr, char *alert_cmd,
 	    int period, int daemonise, int scan, int oneshot,
-	    int dosyslog, int test, char* pidfile, int increments)
+	    int dosyslog, int test, char* pidfile, int increments, int share)
 {
 	/*
 	 * Every few seconds, scan every md device looking for changes
@@ -143,6 +143,36 @@ int Monitor(mddev_dev_t devlist,
 		setsid();
 	}
 
+	if (share) {
+		int pid, rv;
+		FILE *fp;
+		char dir[20];
+		struct stat buf;
+		fp = fopen("/var/run/mdadm/autorebuild.pid", "r");
+		if (fp) {
+			fscanf(fp,"%d", &pid);
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
+		fprintf(fp,"%d\n", pid);
+		fclose(fp);
+	}
+
 	if (devlist == NULL) {
 		mddev_ident_t mdlist = conf_get_ident(NULL);
 		for (; mdlist; mdlist=mdlist->next) {
diff --git a/ReadMe.c b/ReadMe.c
index 5b59369..3f36e70 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -184,6 +184,8 @@ struct option long_options[] = {
     {"oneshot",   0, 0, '1'},
     {"pid-file",  1, 0, 'i'},
     {"syslog",    0, 0, 'y'},
+    {"no-sharing",0, 0, NoSharing},
+
     /* For Grow */
     {"backup-file", 1,0, BackupFile},
     {"array-size", 1, 0, 'Z'},
diff --git a/mdadm.c b/mdadm.c
index a111b47..bab0ad3 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -97,6 +97,7 @@ int main(int argc, char *argv[])
 	int daemonise = 0;
 	char *pidfile = NULL;
 	int oneshot = 0;
+	int spare_sharing = 1;
 	struct supertype *ss = NULL;
 	int writemostly = 0;
 	int re_add = 0;
@@ -218,6 +219,7 @@ int main(int argc, char *argv[])
 		case Waitclean:
 		case DetailPlatform:
 		case 'K': if (!mode) newmode = MISC; break;
+		case NoSharing: newmode = MONITOR; break;
 		}
 		if (mode && newmode == mode) {
 			/* everybody happy ! */
@@ -757,7 +759,9 @@ int main(int argc, char *argv[])
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
@@ -1448,7 +1452,7 @@ int main(int argc, char *argv[])
 		}
 		rv= Monitor(devlist, mailaddr, program,
 			    delay?delay:60, daemonise, scan, oneshot,
-			    dosyslog, test, pidfile, increments);
+			    dosyslog, test, pidfile, increments, spare_sharing);
 		break;
 
 	case GROW:
diff --git a/mdadm.h b/mdadm.h
index 69eb04a..ffb4634 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -275,6 +275,7 @@ enum special_options {
 	AutoDetect,
 	Waitclean,
 	DetailPlatform,
+	NoSharing,
 };
 
 enum domain_actions {
@@ -884,7 +885,7 @@ extern int Examine(mddev_dev_t devlist, int brief, int export, int scan,
 extern int Monitor(mddev_dev_t devlist,
 		   char *mailaddr, char *alert_cmd,
 		   int period, int daemonise, int scan, int oneshot,
-		   int dosyslog, int test, char *pidfile, int increments);
+		   int dosyslog, int test, char *pidfile, int increments, int share);
 
 extern int Kill(char *dev, struct supertype *st, int force, int quiet, int noexcl);
 extern int Wait(char *dev);
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

