From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 9/9] mdadm: 'dump' support
Date: Thu, 25 Aug 2011 19:14:45 -0700
Message-ID: <20110826021445.28015.63357.stgit@localhost6.localdomain6>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

  mdadm -E /dev/sda --dump=foo

Creates a sparse file image of /dev/sda named foo with a copy of the
metadata instance found by -E.

When used in the opposite direction:

  mdadm -E foo --dump=/dev/sda

...can restore metadata to a given block device, assuming it is
identical size to the dump file.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Examine.c  |   42 ++++++++++++++++++++++++++++++++++++++++--
 ReadMe.c   |    1 +
 mdadm.8.in |   13 +++++++++++++
 mdadm.c    |   11 ++++++++++-
 mdadm.h    |    3 ++-
 5 files changed, 66 insertions(+), 4 deletions(-)

diff --git a/Examine.c b/Examine.c
index 5d71e53..ac5f36e 100644
--- a/Examine.c
+++ b/Examine.c
@@ -32,7 +32,7 @@
 #include	"md_p.h"
 int Examine(struct mddev_dev *devlist, int brief, int export, int scan,
 	    int SparcAdjust, struct supertype *forcest,
-	    char *homehost)
+	    char *homehost, char *dump)
 {
 
 	/* Read the raid superblock from a device and
@@ -50,7 +50,8 @@ int Examine(struct mddev_dev *devlist, int brief, int export, int scan,
 	 * If (brief) gather devices for same array and just print a mdadm.conf line including devices=
 	 * if devlist==NULL, use conf_get_devs()
 	 */
-	int fd;
+	unsigned long long size = 0;
+	int fd, dfd;
 	int rv = 0;
 	int err = 0;
 
@@ -107,6 +108,8 @@ int Examine(struct mddev_dev *devlist, int brief, int export, int scan,
 				}
 				err = 1;
 			}
+			if (dump)
+				get_dev_size(fd, devlist->devname, &size);
 			close(fd);
 		}
 		if (err)
@@ -117,6 +120,41 @@ int Examine(struct mddev_dev *devlist, int brief, int export, int scan,
 					     devlist->devname, 0, 0, NULL);
 		/* Ok, its good enough to try, though the checksum could be wrong */
 
+		if (dump && (have_container || !size)) {
+			fprintf(stderr, Name ": cannot get source device size\n");
+			break;
+		}
+
+		if (dump) {
+			struct stat s;
+
+			rv = 1;
+			dfd = open(dump, O_RDWR|O_CREAT|O_EXCL, S_IRUSR|S_IWUSR);
+			if (dfd < 0 && errno == EEXIST) {
+				if (ask("dump file exists, overwrite? "))
+					dfd = open(dump, O_RDWR, S_IRUSR|S_IWUSR);
+			}
+			if (dfd < 0) {
+				fprintf(stderr, Name ": failed to open %s: %s\n",
+					dump, strerror(errno));
+				break;
+			}
+
+			if (fstat(dfd, &s) != -1 && S_ISREG(s.st_mode)) {
+				if (ftruncate(dfd, size) < 0) {
+					fprintf(stderr, Name ": failed to setup dump file %s: %s\n",
+						dump, strerror(errno));
+					break;
+				}
+			}
+
+			rv = st->ss->store_super(st, dfd);
+			if (rv)
+				fprintf(stderr, Name ": failed to store metadata to %s: %s\n",
+					dump, strerror(errno));
+			break;
+		}
+
 		if (brief && st->ss->brief_examine_super == NULL) {
 			if (!scan)
 				fprintf(stderr, Name ": No brief listing for %s on %s\n",
diff --git a/ReadMe.c b/ReadMe.c
index b658841..684fbc9 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -169,6 +169,7 @@ struct option long_options[] = {
 
     /* For Detail/Examine */
     {"brief",	  0, 0, Brief},
+    {"dump",	  1, 0, Dump},
     {"export",	  0, 0, 'Y'},
     {"sparc2.2",  0, 0, Sparc22},
     {"test",      0, 0, 't'},
diff --git a/mdadm.8.in b/mdadm.8.in
index e22fde4..6eb65c3 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1283,6 +1283,19 @@ device (e.g.
 does not report the bitmap for that array.
 
 .TP
+.BR \-\-dump
+Augment 
+.B \-\-examine
+to, instead of printing the contents of the metadata, write the
+metadata image to the specified <file> argument.  The <file> argument
+can be another block device or a regular file.  In the case of a regular
+file the dump file will be created as a sparse file of equal size to the
+source of the metadata image.  Note, this is a raw debug feature no
+attempt is made to check the validity of writing a given metadata image
+to a given block device.  This assumes that only a single device is passed to
+.B \-\-examine.
+
+.TP
 .BR \-R ", " \-\-run
 start a partially assembled array.  If
 .B \-\-assemble
diff --git a/mdadm.c b/mdadm.c
index fb51051..154e116 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -106,6 +106,7 @@ int main(int argc, char *argv[])
 	char *subarray = NULL;
 	char *remove_path = NULL;
 	char *udev_filename = NULL;
+	char *dump_filename = NULL;
 
 	int print_help = 0;
 	FILE *outf;
@@ -160,6 +161,9 @@ int main(int argc, char *argv[])
 		case Brief:
 			brief = 1;
 			continue;
+		case Dump:
+			dump_filename = optarg;
+			continue;
 
 		case 'Y': export++;
 			continue;
@@ -1400,11 +1404,16 @@ int main(int argc, char *argv[])
 				fprintf(stderr, Name ": No devices listed in %s\n", configfile?configfile:DefaultConfFile);
 				exit(1);
 			}
+			if (dump_filename && (devs_found > 1 || scan)) {
+				fprintf(stderr,
+					Name ": Only one device can be specifed with --dump\n");
+				exit(2);
+			}
 			if (brief && verbose)
 				brief = 2;
 			rv = Examine(devlist, scan?(verbose>1?0:verbose+1):brief,
 				     export, scan,
-				     SparcAdjust, ss, homehost);
+				     SparcAdjust, ss, homehost, dump_filename);
 		} else if (devmode == DetailPlatform) {
 			rv = Detail_Platform(ss ? ss->ss : NULL, ss ? scan : 1, verbose);
 		} else {
diff --git a/mdadm.h b/mdadm.h
index 8bd0077..f242223 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -313,6 +313,7 @@ enum special_options {
 	RebuildMapOpt,
 	InvalidBackup,
 	UdevRules,
+	Dump,
 };
 
 /* structures read from config file */
@@ -1049,7 +1050,7 @@ extern int Detail(char *dev, int brief, int export, int test, char *homehost);
 extern int Detail_Platform(struct superswitch *ss, int scan, int verbose);
 extern int Query(char *dev);
 extern int Examine(struct mddev_dev *devlist, int brief, int export, int scan,
-		   int SparcAdjust, struct supertype *forcest, char *homehost);
+		   int SparcAdjust, struct supertype *forcest, char *homehost, char *dump);
 extern int Monitor(struct mddev_dev *devlist,
 		   char *mailaddr, char *alert_cmd,
 		   int period, int daemonise, int scan, int oneshot,

