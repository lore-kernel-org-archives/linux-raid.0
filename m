From: Pekka Aleksi Knuutila <zur@edu.lahti.fi>
Subject: raidstart fails if the first disk of an array is unusable
Date: Wed, 21 Aug 2002 19:37:17 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020821163717.GZ14237@edu.lahti.fi>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zYM0uCDKw75PZbzx"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi. I couldn't find out who currently maintains raidtools, hopefully
this patch will find it's way to him/her via this list.

  Following a Debian bug report about raidtools' strange behaviour,
Pontus Fuchs found and fixed the cause for a problem that you possibly
have experienced: raidstart won't start an array if it can't read the
superblock from the disk that is marked first in raidtab. As you know,
starting (for example) a two disk RAID-1 array shouldn't fail if the
first disk is can't be used but the second can.

  The fix is to simply try out all the devices mentioned in raidtab when
starting an array. A patch (mostly by Fuchs) against raidtools-20010914
is attached.

  (Please CC me, I'm not on the list)

--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch

--- raidlib.c.old	Wed Aug 21 18:56:54 2002
+++ raidlib.c	Wed Aug 21 18:56:58 2002
@@ -149,21 +149,10 @@
     return 0;
 }
 static int do_mdstart (int fd, char *dev, dev_t rdev) {
-    int rc;
 
-    if ((rc = ioctl (fd, START_ARRAY, (unsigned long)rdev))) {
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
+    if (ioctl (fd, START_ARRAY, (unsigned long)rdev))
 	    return 1;
-    }
+
     return 0;
 }
 
@@ -396,10 +385,47 @@
       {
 	struct stat s;
 
-	stat (cfg->device_name[0], &s);
+	int level = cfg->array.param.level;
+	int i, lasterr = 0;
 
 	fd = open_or_die(cfg->md_name);
-	if (do_mdstart (fd, cfg->md_name, s.st_rdev)) rc++;
+
+	/* If the array is level 1,4 or 5 and the first disk
+	* is disconnected we should try the next possible disk
+	* in the array until we find one which the kernel-code
+	* can read the superblock from.
+	*/
+
+	rc = 1;
+	if(level == 1 || level == 4 || level == 5) {
+		for(i = 0; rc && i < MD_SB_DISKS; i++) {
+			if(!cfg->device_name[i])
+				continue;
+	
+			stat (cfg->device_name[i], &s);
+			if (do_mdstart (fd, cfg->md_name, s.st_rdev))
+				lasterr = errno;
+			else
+				rc = 0;
+		}
+	} else {
+			stat (cfg->device_name[0], &s);
+			if (do_mdstart (fd, cfg->md_name, s.st_rdev))
+				lasterr = errno;
+			else
+				rc = 0;
+	}
+
+	if(rc) {
+		switch (lasterr) {
+		case EBUSY:
+			fprintf(stderr,"%s: already running\n",cfg->md_name);
+			break;
+		default:
+			perror (cfg->md_name);
+		}
+	}
+
 	break;
       }
 

--zYM0uCDKw75PZbzx--

