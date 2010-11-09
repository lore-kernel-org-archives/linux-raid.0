From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 20/31] Compute backup blocks in function.
Date: Tue, 9 Nov 2010 17:01:19 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CAAA@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

number of backup blocks evaluation is put in to function for code reuse.

In manage_reshape(), child_grow() function from Grow.c will be reused.
To prepare parameters for this function, code from Grow.c can be reused also.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm/mdadm/Grow.c  |   44 +++++++++++++++++++++++++++-----------------
 mdadm/mdadm/mdadm.h |    4 +++-
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/mdadm/mdadm/Grow.c b/mdadm/mdadm/Grow.c index 93f091a..60be6a9 100644
--- a/mdadm/mdadm/Grow.c
+++ b/mdadm/mdadm/Grow.c
@@ -795,6 +795,31 @@ release:
 	return d;
 }
 
+unsigned long compute_backup_blocks(int nchunk, int ochunk,
+				    unsigned int ndata, unsigned int odata) {
+	unsigned long a, b, blocks;
+	/* So how much do we need to backup.
+	 * We need an amount of data which is both a whole number of
+	 * old stripes and a whole number of new stripes.
+	 * So LCM for (chunksize*datadisks).
+	 */
+	a = (ochunk/512) * odata;
+	b = (nchunk/512) * ndata;
+	/* Find GCD */
+	while (a != b) {
+		if (a < b)
+			b -= a;
+		if (b < a)
+			a -= b;
+	}
+	/* LCM == product / GCD */
+	blocks = (ochunk/512) * (nchunk/512) * odata * ndata / a;
+
+	return blocks;
+}
+
+
 int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 long long size,
 		 int level, char *layout_str, int chunksize, int raid_disks) @@ -833,7 +858,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 	int nrdisks;
 	int err;
 	int frozen;
-	unsigned long a,b, blocks, stripes;
+	unsigned long blocks, stripes;
 	unsigned long cache;
 	unsigned long long array_size;
 	int changed = 0;
@@ -1474,22 +1499,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 			break;
 		}
 
-		/* So how much do we need to backup.
-		 * We need an amount of data which is both a whole number of
-		 * old stripes and a whole number of new stripes.
-		 * So LCM for (chunksize*datadisks).
-		 */
-		a = (ochunk/512) * odata;
-		b = (nchunk/512) * ndata;
-		/* Find GCD */
-		while (a != b) {
-			if (a < b)
-				b -= a;
-			if (b < a)
-				a -= b;
-		}
-		/* LCM == product / GCD */
-		blocks = (ochunk/512) * (nchunk/512) * odata * ndata / a;
+		blocks = compute_backup_blocks(nchunk, ochunk, ndata, odata);
 
 		sysfs_free(sra);
 		sra = sysfs_read(fd, 0,
diff --git a/mdadm/mdadm/mdadm.h b/mdadm/mdadm/mdadm.h index 3b5553a..43baf9f 100644
--- a/mdadm/mdadm/mdadm.h
+++ b/mdadm/mdadm/mdadm.h
@@ -461,7 +461,8 @@ extern int reshape_prepare_fdlist(char *devname,  extern void reshape_free_fdlist(int **fdlist_in,
 				unsigned long long **offsets_in,
 				int size);
-
+extern unsigned long compute_backup_blocks(int nchunk, int ochunk,
+					   unsigned int ndata, unsigned int odata);
 
 extern int save_stripes(int *source, unsigned long long *offsets,
 			int raid_disks, int chunk_size, int level, int layout, @@ -473,6 +474,7 @@ extern int restore_stripes(int *dest, unsigned long long *offsets,
 			   int source, unsigned long long read_offset,
 			   unsigned long long start, unsigned long long length);
 
+
 #ifndef Sendmail
 #define Sendmail "/usr/lib/sendmail -t"
 #endif

