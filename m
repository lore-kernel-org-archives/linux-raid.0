From: ross@jose.lug.udel.edu (Ross Vandegrift)
Subject: [PATCH] syslog support for monitor mode
Date: Mon, 14 Nov 2005 02:00:45 -0500
Message-ID: <20051114070045.GB17105@jose.lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

While adding the text message mode, I saw a FIXME asking for syslog
support in monitor mode.

This patch adds exactly that.

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37


diff -ur mdadm-2.0-ross/Monitor.c mdadm-2.0-syslog/Monitor.c
--- mdadm-2.0-ross/Monitor.c	2005-11-12 17:49:53.000000000 -0500
+++ mdadm-2.0-syslog/Monitor.c	2005-11-14 01:47:52.000000000 -0500
@@ -33,9 +33,10 @@
 #include	<sys/wait.h>
 #include	<sys/signal.h>
 #include	<values.h>
+#include	<syslog.h>
 
 static void alert(char *event, char *dev, char *disc, char *mailaddr, char *cmd,
-		  int textmsg);
+		  int textmsg, int dosyslog);
 
 static char *percentalerts[] = { 
 	"RebuildStarted",
@@ -48,7 +49,7 @@
 int Monitor(mddev_dev_t devlist,
 	    char *mailaddr, char *alert_cmd,
 	    int period, int daemonise, int scan, int oneshot, int textmsg,
-	    char *config, int test, char* pidfile)
+	    int dosyslog, char *config, int test, char* pidfile)
 {
 	/*
 	 * Every few seconds, scan every md device looking for changes
@@ -214,12 +215,12 @@
 
 			if (test)
 				alert("TestMessage", dev, NULL, mailaddr,
-				      alert_cmd, textmsg);
+				      alert_cmd, textmsg, dosyslog);
 			fd = open(dev, O_RDONLY);
 			if (fd < 0) {
 				if (!st->err)
 					alert("DeviceDisappeared", dev, NULL,
-					      mailaddr, alert_cmd, textmsg);
+					      mailaddr, alert_cmd, textmsg, dosyslog);
 /*					fprintf(stderr, Name ": cannot open %s: %s\n",
 						dev, strerror(errno));
 */				st->err=1;
@@ -228,7 +229,7 @@
 			if (ioctl(fd, GET_ARRAY_INFO, &array)<0) {
 				if (!st->err)
 					alert("DeviceDisappeared", dev, NULL,
-					      mailaddr, alert_cmd, textmsg);
+					      mailaddr, alert_cmd, textmsg, dosyslog);
 /*					fprintf(stderr, Name ": cannot get array info for %s: %s\n",
 						dev, strerror(errno));
 */				st->err=1;
@@ -239,7 +240,7 @@
 				array.level != 6 && array.level != 10) {
 				if (!st->err)
 					alert("DeviceDisappeared", dev, "Wrong-Level",
-					      mailaddr, alert_cmd, textmsg);
+					      mailaddr, alert_cmd, textmsg, dosyslog);
 				st->err = 1;
 				close(fd);
 				continue;
@@ -277,30 +278,30 @@
 			    mse->pattern && strchr(mse->pattern, '_') /* degraded */
 				)
 				alert("DegradedArray", dev, NULL, mailaddr,
-				      alert_cmd, textmsg);
+				      alert_cmd, textmsg, dosyslog);
 
 			if (st->utime == 0 && /* new array */
 			    st->expected_spares > 0 && 
 			    array.spare_disks < st->expected_spares) 
 				alert("SparesMissing", dev, NULL, mailaddr,
-				      alert_cmd, textmsg);
+				      alert_cmd, textmsg, dosyslog);
 			if (mse &&
 			    st->percent == -1 && 
 			    mse->percent >= 0)
 				alert("RebuildStarted", dev, NULL, mailaddr,
-				      alert_cmd, textmsg);
+				      alert_cmd, textmsg, dosyslog);
 			if (mse &&
 			    st->percent >= 0 &&
 			    mse->percent >= 0 &&
 			    (mse->percent / 20) > (st->percent / 20))
 				alert(percentalerts[mse->percent/20],
-				      dev, NULL, mailaddr, alert_cmd, textmsg);
+				      dev, NULL, mailaddr, alert_cmd, textmsg, dosyslog);
 
 			if (mse &&
 			    mse->percent == -1 &&
 			    st->percent >= 0)
 				alert("RebuildFinished", dev, NULL, mailaddr,
-				      alert_cmd, textmsg);
+				      alert_cmd, textmsg, dosyslog);
 
 			if (mse)
 				st->percent = mse->percent;
@@ -326,19 +327,19 @@
 					     ((st->devstate[i]&change)&(1<<MD_DISK_ACTIVE)) ||
 					     ((st->devstate[i]&change)&(1<<MD_DISK_SYNC)))
 						)
-						alert("Fail", dev, dv, mailaddr, alert_cmd, textmsg);
+						alert("Fail", dev, dv, mailaddr, alert_cmd, textmsg, dosyslog);
 					else if (i >= (unsigned)array.raid_disks &&
 						 (disc.major || disc.minor) &&
 						 st->devid[i] == makedev(disc.major, disc.minor) &&
 						 ((newstate&change)&(1<<MD_DISK_FAULTY))
 						)
-						alert("FailSpare", dev, dv, mailaddr, alert_cmd, textmsg);
+						alert("FailSpare", dev, dv, mailaddr, alert_cmd, textmsg, dosyslog);
 					else if (i < (unsigned)array.raid_disks &&
 						 (((st->devstate[i]&change)&(1<<MD_DISK_FAULTY)) ||
 						  ((newstate&change)&(1<<MD_DISK_ACTIVE)) ||
 						  ((newstate&change)&(1<<MD_DISK_SYNC)))
 						)
-						alert("SpareActive", dev, dv, mailaddr, alert_cmd, textmsg);
+						alert("SpareActive", dev, dv, mailaddr, alert_cmd, textmsg, dosyslog);
 				}
 				st->devstate[i] = disc.state;
 				st->devid[i] = makedev(disc.major, disc.minor);
@@ -385,7 +386,7 @@
 					st->expected_spares = -1;
 					statelist = st;
 					alert("NewArray", st->devname, NULL,
-					      mailaddr, alert_cmd, textmsg);
+					      mailaddr, alert_cmd, textmsg, dosyslog);
 					new_found = 1;
 				}
 		}
@@ -426,7 +427,7 @@
 								  (unsigned long)dev) == 0) {
 								if (ioctl(fd1, HOT_ADD_DISK,
 									  (unsigned long)dev) == 0) {
-									alert("MoveSpare", st->devname, st2->devname, mailaddr, alert_cmd, textmsg);
+									alert("MoveSpare", st->devname, st2->devname, mailaddr, alert_cmd, textmsg, dosyslog);
 									close(fd1);
 									close(fd2);
 									break;
@@ -453,8 +454,10 @@
 
 
 static void alert(char *event, char *dev, char *disc, char *mailaddr, char *cmd,
-		  int textmsg)
+		  int textmsg, int dosyslog)
 {
+	int priority;
+
 	if (!cmd && !mailaddr) {
 		time_t now = time(0);
 	       
@@ -507,5 +510,27 @@
 		}
 
 	}
-	/* FIXME log the event to syslog maybe */
+
+	/* log the event to syslog maybe */
+	if (dosyslog) {
+		/* Log at a different severity depending on the event.
+		 *
+		 * These are the critical events:  */
+		if (strncmp(event, "Fail", 4)==0 ||
+		    strncmp(event, "Degrade", 7)==0 ||
+		    strncmp(event, "DeviceDisappeared", 17)==0)
+			priority = LOG_CRIT;
+		/* Good to know about, but are not failures: */
+		else if (strncmp(event, "Rebuild", 7)==0 ||
+			 strncmp(event, "MoveSpare", 9)==0)
+			priority = LOG_WARNING;
+		/* Everything else: */
+		else 
+			priority = LOG_INFO;	
+
+		if (disc)
+			syslog(priority, "%s event detected on md device %s, component device %s", event, dev, disc);
+		else
+			syslog(priority, "%s event detected on md device %s", event, dev);
+	}
 }
Only in mdadm-2.0-syslog/: Monitor.c~
diff -ur mdadm-2.0-ross/ReadMe.c mdadm-2.0-syslog/ReadMe.c
--- mdadm-2.0-ross/ReadMe.c	2005-11-12 17:51:49.000000000 -0500
+++ mdadm-2.0-syslog/ReadMe.c	2005-11-14 01:47:14.000000000 -0500
@@ -91,7 +91,7 @@
  *     At the time if writing, there is only minimal support.
  */
 
-char short_options[]="-ABCDEFGQhVXvqb::c:i:l:p:m:n:x:u:c:d:z:U:sa::rfRSow1tTe:";
+char short_options[]="-ABCDEFGQhVXvqb::c:i:l:p:m:n:x:u:c:d:z:U:sa::rfRSow1tTye:";
 struct option long_options[] = {
     {"manage",    0, 0, '@'},
     {"misc",      0, 0, '#'},
@@ -170,6 +170,7 @@
     {"oneshot",   0, 0, '1'},
     {"pid-file",  1, 0, 'i'},
     {"textmsg",   0, 0, 'T'},
+    {"syslog",    0, 0, 'y'},
     
     {0, 0, 0, 0}
 };
@@ -455,6 +456,7 @@
 "  --oneshot     -1   : Check for degraded arrays, then exit\n"
 "  --test        -t   : Generate a TestMessage event against each array at startup\n"
 "  --textmsg     -T   : Keep emails terse, for text messaging mobile devices\n"
+"  --syslog      -y   : Log all events to syslog\n"
 ;
 
 char Help_grow[] =
diff -ur mdadm-2.0-ross/mdadm.c mdadm-2.0-syslog/mdadm.c
--- mdadm-2.0-ross/mdadm.c	2005-11-12 17:31:42.000000000 -0500
+++ mdadm-2.0-syslog/mdadm.c	2005-11-14 01:45:11.000000000 -0500
@@ -94,6 +94,7 @@
 	int writemostly = 0;
 	int re_add = 0;
 	int textmsg = 0;
+	int dosyslog = 0;
 
 	int copies;
 
@@ -668,6 +669,10 @@
 		case O(MONITOR,'T'): /* text message mode for mobile devices */
 			textmsg = 1;
 			continue;
+		case O(MONITOR,'y'): /* log messages to syslog */
+			openlog("mdadm", 0, SYSLOG_FACILITY);
+			dosyslog = 1;
+			continue;
 
 			/* now the general management options.  Some are applicable
 			 * to other modes. None have arguments.
@@ -1109,7 +1114,7 @@
 		}
 		rv= Monitor(devlist, mailaddr, program,
 			    delay?delay:60, daemonise, scan, oneshot, textmsg,
-			    configfile, test, pidfile);
+			    dosyslog, configfile, test, pidfile);
 		break;
 
 	case GROW:
diff -ur mdadm-2.0-ross/mdadm.h mdadm-2.0-syslog/mdadm.h
--- mdadm-2.0-ross/mdadm.h	2005-11-12 17:31:25.000000000 -0500
+++ mdadm-2.0-syslog/mdadm.h	2005-11-12 18:54:03.000000000 -0500
@@ -43,6 +43,7 @@
 #include	<stdio.h>
 #include	<errno.h>
 #include	<string.h>
+#include	<syslog.h>
 #ifdef __dietlibc__NONO
 int strncmp(const char *s1, const char *s2, size_t n) __THROW __pure__;
 char *strncpy(char *dest, const char *src, size_t n) __THROW;
@@ -166,6 +167,8 @@
 #define Sendmail "/usr/lib/sendmail -t"
 #endif
 
+#define SYSLOG_FACILITY LOG_DAEMON
+
 extern char *map_num(mapping_t *map, int num);
 extern int map_name(mapping_t *map, char *name);
 extern mapping_t r5layout[], pers[], modes[], faultylayout[];
@@ -258,7 +261,7 @@
 extern int Monitor(mddev_dev_t devlist,
 		   char *mailaddr, char *alert_cmd,
 		   int period, int daemonise, int scan, int oneshot, int textmsg,
-		   char *config, int test, char *pidfile);
+		   int dosyslog, char *config, int test, char *pidfile);
 
 extern int Kill(char *dev, int force);
 
