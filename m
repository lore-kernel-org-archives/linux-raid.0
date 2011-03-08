From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH 13/14] imsm: introduce SAS controller support in imsm
 metadata handler
Date: Tue, 8 Mar 2011 15:21:33 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A8AEC96@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From fecaa447a0a7a6ca8309a1b48708c6a16dfd45a8 Mon Sep 17 00:00:00 2001
From: Marcin Labun <marcin.labun@intel.com>
Date: Mon, 7 Mar 2011 16:10:05 +0100
Subject: [PATCH 13/14] imsm: introduce SAS controller support in imsm metadata handler

OROM/EFI capabilities are retrieved based on disk's controller type.
1/ alloc_super no longer retrieves OROM capabilities
2/ find_imsm_capability replaces find_imsm_orom
3/ new function find_intel_hba_capability gets disk's HBA and relevant
capability

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 super-intel.c |   91 +++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 69 insertions(+), 22 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 141ebc5..50e1cc5 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -476,6 +476,8 @@ static struct sys_dev* find_disk_attached_hba(int fd, const char *devname)
 #endif /* MDASSEMBLE */
 
 
+static int find_intel_hba_capability(int fd, struct intel_super *super, int verbose);
+
 static struct supertype *match_metadata_desc_imsm(char *arg)
 {
 	struct supertype *st;
@@ -2625,7 +2627,7 @@ struct bbm_log *__get_imsm_bbm_log(struct imsm_super *mpb)
 static void __free_imsm(struct intel_super *super, int free_disks);
 
 /* load_imsm_mpb - read matrix metadata
- * allocates super->mpb to be freed by free_super
+ * allocates super->mpb to be freed by free_imsm
  */
 static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 {
@@ -2677,6 +2679,10 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 	}
 
 	__free_imsm(super, 0);
+	/*  reload capability and hba */
+
+	/* capability and hba must be updated with new super allocation */
+	find_intel_hba_capability(fd, super, 0); 
 	super->len = ROUND_UP(anchor->mpb_size, 512);
 	if (posix_memalign(&super->buf, 512, super->len) != 0) {
 		if (devname)
@@ -2800,6 +2806,8 @@ static void __free_imsm(struct intel_super *super, int free_disks)
 		free(super->buf);
 		super->buf = NULL;
 	}
+	/* unlink capability description */
+	super->orom = NULL;
 	if (free_disks)
 		free_imsm_disks(super);
 	free_devlist(super);
@@ -2839,14 +2847,10 @@ static struct intel_super *alloc_super(void)
 		memset(super, 0, sizeof(*super));
 		super->current_vol = -1;
 		super->create_offset = ~((__u32 ) 0);
-		if (!check_env("IMSM_NO_PLATFORM"))
-			super->orom = find_imsm_orom();
 	}
-
 	return super;
 }
 
-
 /*
  * find and allocate hba and OROM/EFI based on valid fd of RAID component device
  */
@@ -2856,6 +2860,7 @@ static int find_intel_hba_capability(int fd, struct intel_super *super, int verb
 	int rv = 0;
 
 	if ((fd < 0) || check_env("IMSM_NO_PLATFORM")) {
+		super->orom = NULL;
 		super->hba = NULL;
 		return 0;
 	}
@@ -2884,7 +2889,7 @@ static int find_intel_hba_capability(int fd, struct intel_super *super, int verb
 				hba_name->path,
 				hba_name->pci_id ? : "Err!",
 				get_sys_dev_type(hba_name->type));
-			
+
 			struct intel_hba *hba = super->hba;
 			while (hba) {
 				fprintf(stderr, "%s", hba->pci_id ? : "Err!");
@@ -2900,11 +2905,13 @@ static int find_intel_hba_capability(int fd, struct intel_super *super, int verb
 		free_sys_dev(&hba_name);
 		return 2;
 	}
+	super->orom = find_imsm_capability(hba_name->type);
 	free_sys_dev(&hba_name);
+	if (!super->orom)
+		return 3;
 	return 0;
 }
 
-
 #ifndef MDASSEMBLE
 /* find_missing - helper routine for load_super_imsm_all that identifies
  * disks that have disappeared from the system.  This routine relies on
@@ -3285,6 +3292,7 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 		struct intel_super *s = alloc_super();
 		char nm[32];
 		int dfd;
+		int rv;
 
 		err = 1;
 		if (!s)
@@ -3297,6 +3305,11 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 		dfd = dev_open(nm, O_RDWR);
 		if (dfd < 0)
 			goto error;
+                
+		rv = find_intel_hba_capability(dfd, s, 1);
+		/* no orom/efi or non-intel hba of the disk */
+		if (rv != 0)
+			goto error;
 
 		err = load_and_parse_mpb(dfd, s, NULL, 1);
 
@@ -3372,6 +3385,15 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 			sizeof(*super));
 		return 1;
 	}
+	rv = find_intel_hba_capability(fd, super, 1);
+	/* no orom/efi or non-intel hba of the disk */
+	if (rv != 0) {
+		if (devname)
+			fprintf(stderr,
+				Name ": No OROM/EFI properties for %s\n", devname);
+		free_imsm(super);
+		return 2;
+	}
 
 	rv = load_and_parse_mpb(fd, super, devname, 0);
 
@@ -3766,7 +3788,7 @@ static int add_to_super_imsm(struct supertype *st, mdu_disk_info_t *dk,
 	 * they shall be already tested when container was created/assembled.
 	 */
 	rv = find_intel_hba_capability(fd, super, 1);
-	/* no intel hba of the disk */
+	/* no orom/efi or non-intel hba of the disk */
 	if (rv != 0) {
 		dprintf("capability: %p fd: %d ret: %d\n",
 			super->orom, fd, rv);
@@ -4102,25 +4124,14 @@ static int validate_geometry_imsm_container(struct supertype *st, int level,
 {
 	int fd;
 	unsigned long long ldsize;
-	const struct imsm_orom *orom;
+	struct intel_super *super=NULL; 
+	int rv = 0;
 
 	if (level != LEVEL_CONTAINER)
 		return 0;
 	if (!dev)
 		return 1;
 
-	if (check_env("IMSM_NO_PLATFORM"))
-		orom = NULL;
-	else
-		orom = find_imsm_orom();
-	if (orom && raiddisks > orom->tds) {
-		if (verbose)
-			fprintf(stderr, Name ": %d exceeds maximum number of"
-				" platform supported disks: %d\n",
-				raiddisks, orom->tds);
-		return 0;
-	}
-
 	fd = open(dev, O_RDONLY|O_EXCL, 0);
 	if (fd < 0) {
 		if (verbose)
@@ -4132,9 +4143,45 @@ static int validate_geometry_imsm_container(struct supertype *st, int level,
 		close(fd);
 		return 0;
 	}
+
+	/* capabilities retrive could be possible 
+	 * note that there is no fd for the disks in array.
+	 */
+	super = alloc_super();
+	if (!super) {
+		fprintf(stderr,
+			Name ": malloc of %u failed.\n",
+			sizeof(*super));
+		close(fd);
+		return 0;
+	}
+
+	rv = find_intel_hba_capability(fd, super, verbose);
+	if (rv != 0) {
+#if DEBUG
+		char str[256];
+		fd2devname(fd, str);
+		dprintf("validate_geometry_imsm_container: fd: %d %s orom: %p rv: %d raiddisk: %d\n",
+			fd, str, super->orom, rv, raiddisks);
+#endif
+		/* no orom/efi or non-intel hba of the disk */
+		close(fd);
+		free_imsm(super);
+		return 0;
+	}
 	close(fd);
+	if (super->orom && raiddisks > super->orom->tds) {
+		if (verbose)
+			fprintf(stderr, Name ": %d exceeds maximum number of"
+				" platform supported disks: %d\n",
+				raiddisks, super->orom->tds);
+
+		free_imsm(super);
+		return 0;
+	}
 
-	*freesize = avail_size_imsm(st, ldsize >> 9);
+	*freesize = avail_size_imsm(st, ldsize >> 9);	  
+	free_imsm(super);
 
 	return 1;
 }
-- 
1.6.4.2

