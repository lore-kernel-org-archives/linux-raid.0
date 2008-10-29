From: Doug Ledford <dledford@redhat.com>
Subject: [Patch mdadm-2.6.7.1 1/3] Fix bad metadata formatting
Date: Wed, 29 Oct 2008 15:05:35 -0400
Message-ID: <c82952743d7177261512b107adcb101ecd035a21.1225306892.git.dledford@redhat.com>
References: <cover.1225306892.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.6.5"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1225306892.git.dledford@redhat.com>
In-Reply-To: <cover.1225306892.git.dledford@redhat.com>
References: <cover.1225306892.git.dledford@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------1.5.6.5
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


Certain operations (Detail.c mainly) would print out the metadata of
an array in a format that the scan operation in super0.c and super1.c
would later reject as unknown when it was found in the mdadm.conf file.
Use a consistent format, but also modify the super0 and super1 match
methods to accept the other format without complaint.

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 Detail.c |    6 +++---
 super0.c |    5 ++++-
 super1.c |    3 +++
 3 files changed, 10 insertions(+), 4 deletions(-)
--------------1.5.6.5
Content-Type: text/x-patch; name="c82952743d7177261512b107adcb101ecd035a21.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="c82952743d7177261512b107adcb101ecd035a21.diff"

diff --git a/Detail.c b/Detail.c
index 2fb59a3..715d4d0 100644
--- a/Detail.c
+++ b/Detail.c
@@ -138,7 +138,7 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 		if (sra && sra->array.major_version < 0)
 			printf("MD_METADATA=%s\n", sra->text_version);
 		else
-			printf("MD_METADATA=%02d.%02d\n",
+			printf("MD_METADATA=%d.%02d\n",
 			       array.major_version, array.minor_version);
 
 		if (st && st->sb)
@@ -153,7 +153,7 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 		if (sra && sra->array.major_version < 0)
 			printf(" metadata=%s", sra->text_version);
 		else
-			printf(" metadata=%02d.%02d",
+			printf(" metadata=%d.%02d",
 			       array.major_version, array.minor_version);
 	} else {
 		mdu_bitmap_file_t bmf;
@@ -175,7 +175,7 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 		if (sra && sra->array.major_version < 0)
 			printf("        Version : %s\n", sra->text_version);
 		else
-			printf("        Version : %02d.%02d\n",
+			printf("        Version : %d.%02d\n",
 			       array.major_version, array.minor_version);
 
 		atime = array.ctime;
diff --git a/super0.c b/super0.c
index 7e81482..42d8659 100644
--- a/super0.c
+++ b/super0.c
@@ -93,7 +93,7 @@ static void examine_super0(struct supertype *st, char *homehost)
 	char *c;
 
 	printf("          Magic : %08x\n", sb->md_magic);
-	printf("        Version : %02d.%02d.%02d\n", sb->major_version, sb->minor_version,
+	printf("        Version : %d.%02d.%02d\n", sb->major_version, sb->minor_version,
 	       sb->patch_version);
 	if (sb->minor_version >= 90) {
 		printf("           UUID : %08x:%08x:%08x:%08x", sb->set_uuid0, sb->set_uuid1,
@@ -847,6 +847,9 @@ static struct supertype *match_metadata_desc0(char *arg)
 	st->minor_version = 90;
 	st->max_devs = MD_SB_DISKS;
 	st->sb = NULL;
+	/* Eliminate pointless leading 0 from some versions of mdadm -D */
+	if (strncmp(arg, "00.", 3) == 0)
+		arg++;
 	if (strcmp(arg, "0") == 0 ||
 	    strcmp(arg, "0.90") == 0 ||
 	    strcmp(arg, "0.91") == 0 ||
diff --git a/super1.c b/super1.c
index e1d0219..a81ee6f 100644
--- a/super1.c
+++ b/super1.c
@@ -1186,6 +1186,9 @@ static struct supertype *match_metadata_desc1(char *arg)
 	st->ss = &super1;
 	st->max_devs = 384;
 	st->sb = NULL;
+	/* Eliminate pointless leading 0 from some versions of mdadm -D */
+	if (strncmp(arg, "01.", 3) == 0)
+		arg++;
 	if (strcmp(arg, "1.0") == 0) {
 		st->minor_version = 0;
 		return st;

--------------1.5.6.5--


