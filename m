From: Phil Kauffman <kauffman@cs.uchicago.edu>
Subject: mdadm patch Monitor.c
Date: Tue, 02 Sep 2014 13:12:05 -0500
Message-ID: <54060875.3070403@cs.uchicago.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070305070600030404050100"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070305070600030404050100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Neil,

Hopefully, you are still the maintainer of mdadm.
I would like to request the following trivial patch... pretty please!

--- Monitor.c	2014-08-21 05:16:56.000000000 -0500
+++ Monitor.c.new	2014-09-02 13:03:45.106590425 -0500
@@ -402,14 +402,12 @@
  			if (disc && disc[0] == ' ')
  				fprintf(mp, "Extra information:%s.\n\n", disc);

-			fprintf(mp, "Faithfully yours, etc.\n");
-
  			mdstat = fopen("/proc/mdstat", "r");
  			if (mdstat) {
  				char buf[8192];
  				int n;
  				fprintf(mp,
-					"\nP.S. The /proc/mdstat file"
+					"\nThe /proc/mdstat file"
  					" currently contains the following:\n\n");
  				while ( (n=fread(buf, 1, sizeof(buf), mdstat)) > 0)
  					n=fwrite(buf, 1, n, mp);


The words removed above are superfluous and add no value to the message. 
In addition, they imply that the message is from a person, which is 
obviously not the case.

Cheers,

Phil


-- 
Phil Kauffman
Systems Admin
Dept. of Computer Science
University of Chicago
kauffman@cs.uchicago.edu
773-702-3913

--------------070305070600030404050100
Content-Type: text/x-patch;
 name="Monitor.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Monitor.c.patch"

--- Monitor.c	2014-08-21 05:16:56.000000000 -0500
+++ Monitor.c.new	2014-09-02 13:03:45.106590425 -0500
@@ -402,14 +402,12 @@
 			if (disc && disc[0] == ' ')
 				fprintf(mp, "Extra information:%s.\n\n", disc);
 
-			fprintf(mp, "Faithfully yours, etc.\n");
-
 			mdstat = fopen("/proc/mdstat", "r");
 			if (mdstat) {
 				char buf[8192];
 				int n;
 				fprintf(mp,
-					"\nP.S. The /proc/mdstat file"
+					"\nThe /proc/mdstat file"
 					" currently contains the following:\n\n");
 				while ( (n=fread(buf, 1, sizeof(buf), mdstat)) > 0)
 					n=fwrite(buf, 1, n, mp);

--------------070305070600030404050100--
