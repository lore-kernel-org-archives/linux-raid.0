From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH 2/2] Monitor: add new event BadBlocks
Date: Tue, 24 Jan 2017 13:03:39 +0100
Message-ID: <1485259419-2308-3-git-send-email-tomasz.majchrzak@intel.com>
References: <1485259419-2308-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485259419-2308-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Jes.Sorensen@redhat.com, jes.sorensen@gmail.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

Add new event BadBlocks to notify the user when bad blocks are found on a
disk. Send an email (if configured) and write it to syslog as a warning.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 Monitor.c  | 14 +++++++++-----
 md_p.h     |  1 +
 mdadm.8.in | 10 ++++++++--
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 802a9d9..cb92a23 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -363,10 +363,11 @@ static void alert(char *event, char *dev, char *disc, struct alert_info *info)
 		}
 	}
 	if (info->mailaddr &&
-	    (strncmp(event, "Fail", 4)==0 ||
-	     strncmp(event, "Test", 4)==0 ||
-	     strncmp(event, "Spares", 6)==0 ||
-	     strncmp(event, "Degrade", 7)==0)) {
+	    (strncmp(event, "Fail", 4) == 0 ||
+	     strncmp(event, "Test", 4) == 0 ||
+	     strncmp(event, "Spares", 6) == 0 ||
+	     strncmp(event, "Degrade", 7) == 0 ||
+	     strncmp(event, "BadBlocks", 9) == 0)) {
 		FILE *mp = popen(Sendmail, "w");
 		if (mp) {
 			FILE *mdstat;
@@ -422,7 +423,8 @@ static void alert(char *event, char *dev, char *disc, struct alert_info *info)
 		/* Good to know about, but are not failures: */
 		else if (strncmp(event, "Rebuild", 7)==0 ||
 			 strncmp(event, "MoveSpare", 9)==0 ||
-			 strncmp(event, "Spares", 6) != 0)
+			 strncmp(event, "Spares", 6) != 0 ||
+			 strncmp(event, "BadBlocks", 9) != 0)
 			priority = LOG_WARNING;
 		/* Everything else: */
 		else
@@ -668,6 +670,8 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 				alert("FailSpare", dev, dv, ainfo);
 			else if ((newstate&change)&(1<<MD_DISK_SYNC))
 				alert("SpareActive", dev, dv, ainfo);
+			else if ((newstate&change)&(1<<MD_DISK_BB_PRESENT))
+				alert("BadBlocks", dev, dv, ainfo);
 		}
 		st->devstate[i] = newstate;
 		st->devid[i] = makedev(disc.major, disc.minor);
diff --git a/md_p.h b/md_p.h
index dc9fec1..39884be 100644
--- a/md_p.h
+++ b/md_p.h
@@ -90,6 +90,7 @@
 				   * dire need
 				   */
 #define	MD_DISK_FAILFAST	10 /* Fewer retries, more failures */
+#define MD_DISK_BB_PRESENT	11 /* disk has bad blocks */
 
 #define MD_DISK_REPLACEMENT	17
 #define MD_DISK_JOURNAL		18 /* disk is used as the write journal in RAID-5/6 */
diff --git a/mdadm.8.in b/mdadm.8.in
index 1e4f91d..7b89a8a 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2552,6 +2552,10 @@ message.
 (syslog priority: Warning)
 
 .TP
+.B BadBlocks
+Bad blocks have been found on the device. (syslog priority: Warning)
+
+.TP
 .B TestMessage
 An array was found at startup, and the
 .B \-\-test
@@ -2563,7 +2567,8 @@ Only
 .B Fail,
 .B FailSpare,
 .B DegradedArray,
-.B SparesMissing
+.B SparesMissing,
+.B BadBlocks
 and
 .B TestMessage
 cause Email to be sent.  All events cause the program to be run.
@@ -2575,8 +2580,9 @@ Each event has an associated array device (e.g.
 and possibly a second device.  For
 .BR Fail ,
 .BR FailSpare ,
+.BR SpareActive
 and
-.B SpareActive
+.BR BadBlocks
 the second device is the relevant component device.
 For
 .B MoveSpare
-- 
1.8.3.1

