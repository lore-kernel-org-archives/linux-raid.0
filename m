From: Florian Schanda <ma1flfs@bath.ac.uk>
Subject: [Small Patch] for raidlib.c in raidtools-1.00.3
Date: Tue, 25 Feb 2003 13:49:57 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302251349.57326.ma1flfs@bath.ac.uk>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_9FAVBKZP8S3NCX8JOMB8"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--------------Boundary-00=_9FAVBKZP8S3NCX8JOMB8
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi all,

I had some problems with raidtools, it gave me a wierd error saying

"/dev/md/0: Invalid argument"

After spending some time to fix it, I figured it would be a good idea to=20
actually load the kernel module. ;)

To save save some trouble, I enhaced the error reporting for that particu=
lar=20
function.


=09- Florian Schanda

--------------Boundary-00=_9FAVBKZP8S3NCX8JOMB8
Content-Type: text/x-diff;
  charset="us-ascii";
  name="error-reporting.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="error-reporting.patch"

--- raidlib.c.orig	Tue Feb 25 13:38:46 2003
+++ raidlib.c	Tue Feb 25 13:44:44 2003
@@ -149,20 +149,26 @@
 	    return 0;
 	}
 
-    if ((rc = ioctl (fd, RUN_ARRAY, (unsigned long)param))) {
-	    save_errno=errno;
-	    switch (save_errno) {
-	      case EBUSY:
-		fprintf(stderr,"%s: already running\n",dev);
-		break;
-		/* fall through */
-	      default:
-		perror (dev);
-	    }
-	    errno=save_errno;
-	    return 1;
-    }
-    return 0;
+	if ((rc = ioctl (fd, RUN_ARRAY, (unsigned long)param))) {
+		save_errno=errno;
+		switch (save_errno) {
+			case EBUSY:
+				fprintf(stderr,"%s: already running\n", dev);
+				break;
+			case EINVAL:
+				fprintf(stderr, "Error: EINVAL\n");
+				fprintf(stderr, "Request or argp is not valid.\n");
+				fprintf(stderr, "Are you *SURE* you compiled raid into the kernel, and loaded it?\n");
+				break;
+			/* fall through */
+			default:
+				perror (dev);
+		}
+		errno=save_errno;
+		return 1;
+	}
+	
+	return 0;
 }
 static int do_mdstart (int fd, char *dev, dev_t rdev) {
     int rc;

--------------Boundary-00=_9FAVBKZP8S3NCX8JOMB8--

