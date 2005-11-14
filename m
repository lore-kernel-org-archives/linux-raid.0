From: ross@jose.lug.udel.edu (Ross Vandegrift)
Subject: [PATCH] add text message mode for terse reports
Date: Mon, 14 Nov 2005 01:59:08 -0500
Message-ID: <20051114065908.GA17105@jose.lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I recently setup mdadm to monitor my md RAIDs and text message my
cellphone in the event of a device failure.  I found that the reports
were too verbose to easily read on my phone.

--textmsg, -T makes the emails mdadm generates shorter to be read on
mobile devices.

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37



diff -ur mdadm-2.0/Monitor.c mdadm-2.0-ross/Monitor.c
--- mdadm-2.0/Monitor.c	2005-07-06 19:19:53.000000000 -0400
+++ mdadm-2.0-ross/Monitor.c	2005-11-12 17:49:53.000000000 -0500
@@ -34,7 +34,8 @@
 #include	<sys/signal.h>
 #include	<values.h>
 
-static void alert(char *event, char *dev, char *disc, char *mailaddr, char *cmd);
+static void alert(char *event, char *dev, char *disc, char *mailaddr, char *cmd,
+		  int textmsg);
 
 static char *percentalerts[] = { 
 	"RebuildStarted",
@@ -46,7 +47,7 @@
 
 int Monitor(mddev_dev_t devlist,
 	    char *mailaddr, char *alert_cmd,
-	    int period, int daemonise, int scan, int oneshot,
+	    int period, int daemonise, int scan, int oneshot, int textmsg,
 	    char *config, int test, char* pidfile)
 {
 	/*
@@ -212,12 +213,13 @@
 			unsigned int i;
 
 			if (test)
-				alert("TestMessage", dev, NULL, mailaddr, alert_cmd);
+				alert("TestMessage", dev, NULL, mailaddr,
+				      alert_cmd, textmsg);
 			fd = open(dev, O_RDONLY);
 			if (fd < 0) {
 				if (!st->err)
 					alert("DeviceDisappeared", dev, NULL,
-					      mailaddr, alert_cmd);
+					      mailaddr, alert_cmd, textmsg);
 /*					fprintf(stderr, Name ": cannot open %s: %s\n",
 						dev, strerror(errno));
 */				st->err=1;
@@ -226,7 +228,7 @@
 			if (ioctl(fd, GET_ARRAY_INFO, &array)<0) {
 				if (!st->err)
 					alert("DeviceDisappeared", dev, NULL,
-					      mailaddr, alert_cmd);
+					      mailaddr, alert_cmd, textmsg);
 /*					fprintf(stderr, Name ": cannot get array info for %s: %s\n",
 						dev, strerror(errno));
 */				st->err=1;
@@ -237,7 +239,7 @@
 				array.level != 6 && array.level != 10) {
 				if (!st->err)
 					alert("DeviceDisappeared", dev, "Wrong-Level",
-					      mailaddr, alert_cmd);
+					      mailaddr, alert_cmd, textmsg);
 				st->err = 1;
 				close(fd);
 				continue;
@@ -274,27 +276,31 @@
 			    mse &&	/* is in /proc/mdstat */
 			    mse->pattern && strchr(mse->pattern, '_') /* degraded */
 				)
-				alert("DegradedArray", dev, NULL, mailaddr, alert_cmd);
+				alert("DegradedArray", dev, NULL, mailaddr,
+				      alert_cmd, textmsg);
 
 			if (st->utime == 0 && /* new array */
 			    st->expected_spares > 0 && 
 			    array.spare_disks < st->expected_spares) 
-				alert("SparesMissing", dev, NULL, mailaddr, alert_cmd);
+				alert("SparesMissing", dev, NULL, mailaddr,
+				      alert_cmd, textmsg);
 			if (mse &&
 			    st->percent == -1 && 
 			    mse->percent >= 0)
-				alert("RebuildStarted", dev, NULL, mailaddr, alert_cmd);
+				alert("RebuildStarted", dev, NULL, mailaddr,
+				      alert_cmd, textmsg);
 			if (mse &&
 			    st->percent >= 0 &&
 			    mse->percent >= 0 &&
 			    (mse->percent / 20) > (st->percent / 20))
 				alert(percentalerts[mse->percent/20],
-				      dev, NULL, mailaddr, alert_cmd);
+				      dev, NULL, mailaddr, alert_cmd, textmsg);
 
 			if (mse &&
 			    mse->percent == -1 &&
 			    st->percent >= 0)
-				alert("RebuildFinished", dev, NULL, mailaddr, alert_cmd);
+				alert("RebuildFinished", dev, NULL, mailaddr,
+				      alert_cmd, textmsg);
 
 			if (mse)
 				st->percent = mse->percent;
@@ -320,19 +326,19 @@
 					     ((st->devstate[i]&change)&(1<<MD_DISK_ACTIVE)) ||
 					     ((st->devstate[i]&change)&(1<<MD_DISK_SYNC)))
 						)
-						alert("Fail", dev, dv, mailaddr, alert_cmd);
+						alert("Fail", dev, dv, mailaddr, alert_cmd, textmsg);
 					else if (i >= (unsigned)array.raid_disks &&
 						 (disc.major || disc.minor) &&
 						 st->devid[i] == makedev(disc.major, disc.minor) &&
 						 ((newstate&change)&(1<<MD_DISK_FAULTY))
 						)
-						alert("FailSpare", dev, dv, mailaddr, alert_cmd);
+						alert("FailSpare", dev, dv, mailaddr, alert_cmd, textmsg);
 					else if (i < (unsigned)array.raid_disks &&
 						 (((st->devstate[i]&change)&(1<<MD_DISK_FAULTY)) ||
 						  ((newstate&change)&(1<<MD_DISK_ACTIVE)) ||
 						  ((newstate&change)&(1<<MD_DISK_SYNC)))
 						)
-						alert("SpareActive", dev, dv, mailaddr, alert_cmd);
+						alert("SpareActive", dev, dv, mailaddr, alert_cmd, textmsg);
 				}
 				st->devstate[i] = disc.state;
 				st->devid[i] = makedev(disc.major, disc.minor);
@@ -378,7 +384,8 @@
 					st->spare_group = NULL;
 					st->expected_spares = -1;
 					statelist = st;
-					alert("NewArray", st->devname, NULL, mailaddr, alert_cmd);
+					alert("NewArray", st->devname, NULL,
+					      mailaddr, alert_cmd, textmsg);
 					new_found = 1;
 				}
 		}
@@ -419,7 +426,7 @@
 								  (unsigned long)dev) == 0) {
 								if (ioctl(fd1, HOT_ADD_DISK,
 									  (unsigned long)dev) == 0) {
-									alert("MoveSpare", st->devname, st2->devname, mailaddr, alert_cmd);
+									alert("MoveSpare", st->devname, st2->devname, mailaddr, alert_cmd, textmsg);
 									close(fd1);
 									close(fd2);
 									break;
@@ -445,7 +452,8 @@
 }
 
 
-static void alert(char *event, char *dev, char *disc, char *mailaddr, char *cmd)
+static void alert(char *event, char *dev, char *disc, char *mailaddr, char *cmd,
+		  int textmsg)
 {
 	if (!cmd && !mailaddr) {
 		time_t now = time(0);
@@ -478,16 +486,24 @@
 			fprintf(mp, "To: %s\n", mailaddr);
 			fprintf(mp, "Subject: %s event on %s:%s\n\n", event, dev, hname);
 
-			fprintf(mp, "This is an automatically generated mail message from " Name "\n");
-			fprintf(mp, "running on %s\n\n", hname);
+			if (!textmsg) {
+				fprintf(mp, "This is an automatically generated mail message from " Name "\n");
+				fprintf(mp, "running on %s\n\n", hname);
 
-			fprintf(mp, "A %s event had been detected on md device %s.\n\n", event, dev);
+				fprintf(mp, "A %s event had been detected on md device %s.\n\n", event, dev);
 
-			if (disc)
-				fprintf(mp, "It could be related to component device %s.\n\n", disc);
+				if (disc)
+					fprintf(mp, "It could be related to component device %s.\n\n", disc);
 
-			fprintf(mp, "Faithfully yours, etc.\n");
-			fclose(mp);
+				fprintf(mp, "Faithfully yours, etc.\n");
+				fclose(mp);
+			}
+			else {
+				fprintf(mp, "%s event from %s", event, dev);
+				if (disc)
+					fprintf(mp, " on %s", disc);
+				fprintf(mp, ".\n\n");
+			}
 		}
 
 	}
diff -ur mdadm-2.0/ReadMe.c mdadm-2.0-ross/ReadMe.c
--- mdadm-2.0/ReadMe.c	2005-08-25 03:17:08.000000000 -0400
+++ mdadm-2.0-ross/ReadMe.c	2005-11-12 17:51:49.000000000 -0500
@@ -91,7 +91,7 @@
  *     At the time if writing, there is only minimal support.
  */
 
-char short_options[]="-ABCDEFGQhVXvqb::c:i:l:p:m:n:x:u:c:d:z:U:sa::rfRSow1te:";
+char short_options[]="-ABCDEFGQhVXvqb::c:i:l:p:m:n:x:u:c:d:z:U:sa::rfRSow1tTe:";
 struct option long_options[] = {
     {"manage",    0, 0, '@'},
     {"misc",      0, 0, '#'},
@@ -169,6 +169,7 @@
     {"daemonize", 0, 0, 'f'},
     {"oneshot",   0, 0, '1'},
     {"pid-file",  1, 0, 'i'},
+    {"textmsg",   0, 0, 'T'},
     
     {0, 0, 0, 0}
 };
@@ -453,6 +454,7 @@
 "  --pid-file=   -i   : In daemon mode write pid to specified file instead of stdout\n"
 "  --oneshot     -1   : Check for degraded arrays, then exit\n"
 "  --test        -t   : Generate a TestMessage event against each array at startup\n"
+"  --textmsg     -T   : Keep emails terse, for text messaging mobile devices\n"
 ;
 
 char Help_grow[] =
diff -ur mdadm-2.0/mdadm.c mdadm-2.0-ross/mdadm.c
--- mdadm-2.0/mdadm.c	2005-08-16 01:42:21.000000000 -0400
+++ mdadm-2.0-ross/mdadm.c	2005-11-12 17:31:42.000000000 -0500
@@ -93,6 +93,7 @@
 	struct supertype *ss = NULL;
 	int writemostly = 0;
 	int re_add = 0;
+	int textmsg = 0;
 
 	int copies;
 
@@ -664,6 +665,9 @@
 		case O(MONITOR,'t'): /* test */
 			test = 1;
 			continue;
+		case O(MONITOR,'T'): /* text message mode for mobile devices */
+			textmsg = 1;
+			continue;
 
 			/* now the general management options.  Some are applicable
 			 * to other modes. None have arguments.
@@ -1104,7 +1108,8 @@
 			break;
 		}
 		rv= Monitor(devlist, mailaddr, program,
-			    delay?delay:60, daemonise, scan, oneshot, configfile, test, pidfile);
+			    delay?delay:60, daemonise, scan, oneshot, textmsg,
+			    configfile, test, pidfile);
 		break;
 
 	case GROW:
diff -ur mdadm-2.0/mdadm.h mdadm-2.0-ross/mdadm.h
--- mdadm-2.0/mdadm.h	2005-08-26 00:49:24.000000000 -0400
+++ mdadm-2.0-ross/mdadm.h	2005-11-12 17:31:25.000000000 -0500
@@ -257,7 +257,7 @@
 		   struct supertype *forcest);
 extern int Monitor(mddev_dev_t devlist,
 		   char *mailaddr, char *alert_cmd,
-		   int period, int daemonise, int scan, int oneshot,
+		   int period, int daemonise, int scan, int oneshot, int textmsg,
 		   char *config, int test, char *pidfile);
 
 extern int Kill(char *dev, int force);
