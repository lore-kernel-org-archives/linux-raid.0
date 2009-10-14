From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 06/12] ddf: prevent superblock being zeroed on --update
Date: Tue, 13 Oct 2009 19:10:46 -0700
Message-ID: <20091014021046.31570.66282.stgit@dwillia2-linux.ch.intel.com>
References: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, krzysztof.wojcik@intel.com, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

The full fix would be to support updating ddf metadata, but this minimal
fix just prevents the superblock from being zeroed when someone
inadvertently passes an unsupported --update option during assembly.

Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 super-ddf.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 9bf08c2..06858e2 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1589,13 +1589,8 @@ static int init_super_ddf(struct supertype *st,
 	struct phys_disk *pd;
 	struct virtual_disk *vd;
 
-	if (!info) {
-		st->sb = NULL;
-		return 0;
-	}
 	if (st->sb)
-		return init_super_ddf_bvd(st, info, size, name, homehost,
-					  uuid);
+		return init_super_ddf_bvd(st, info, size, name, homehost, uuid);
 
 	if (posix_memalign((void**)&ddf, 512, sizeof(*ddf)) != 0) {
 		fprintf(stderr, Name ": %s could not allocate superblock\n", __func__);
@@ -1604,6 +1599,12 @@ static int init_super_ddf(struct supertype *st,
 	memset(ddf, 0, sizeof(*ddf));
 	ddf->dlist = NULL; /* no physical disks yet */
 	ddf->conflist = NULL; /* No virtual disks yet */
+	st->sb = ddf;
+
+	if (info == NULL) {
+		/* zeroing superblock */
+		return 0;
+	}
 
 	/* At least 32MB *must* be reserved for the ddf.  So let's just
 	 * start 32MB from the end, and put the primary header there.
@@ -2971,12 +2972,22 @@ static struct mdinfo *container_content_ddf(struct supertype *st)
 	return rest;
 }
 
-static int store_zero_ddf(struct supertype *st, int fd)
+static int store_super_ddf(struct supertype *st, int fd)
 {
+	struct ddf_super *ddf = st->sb;
 	unsigned long long dsize;
 	void *buf;
 	int rc;
 
+	if (!ddf)
+		return 1;
+
+	/* ->dlist and ->conflist will be set for updates, currently not
+	 * supported
+	 */
+	if (ddf->dlist || ddf->conflist)
+		return 1;
+
 	if (!get_dev_size(fd, NULL, &dsize))
 		return 1;
 
@@ -3627,7 +3638,7 @@ struct superswitch super_ddf = {
 
 	.load_super	= load_super_ddf,
 	.init_super	= init_super_ddf,
-	.store_super	= store_zero_ddf,
+	.store_super	= store_super_ddf,
 	.free_super	= free_super_ddf,
 	.match_metadata_desc = match_metadata_desc_ddf,
 	.container_content = container_content_ddf,

