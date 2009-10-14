From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm PATCH 07/12] imsm: add --update=uuid support
Date: Tue, 13 Oct 2009 19:10:51 -0700
Message-ID: <20091014021051.31570.54396.stgit@dwillia2-linux.ch.intel.com>
References: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091014020739.31570.36408.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, krzysztof.wojcik@intel.com, ed.ciechanowski@intel.com, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

When disks have conflicting container memberships (same container ids
but incompatible member arrays) --update=uuid can be used to move
offenders to a new container id by changing 'orig_family_num'.

Note that this only supports random updates of the uuid as the actual
uuid is synthesized.  We also need to communicate the new
'orig_family_num' value to all disks involved in the update.  A new
field 'update_private' is added to struct mdinfo to allow this
information to be transmitted.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Assemble.c    |    3 +++
 mdadm.h       |    5 +++++
 super-intel.c |   51 +++++++++++++++++++++++++++++++++++++++------------
 3 files changed, 47 insertions(+), 12 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 4578906..7da0905 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -565,6 +565,7 @@ int Assemble(struct supertype *st, char *mddev,
 #endif
 	/* Ok, no bad inconsistancy, we can try updating etc */
 	bitmap_done = 0;
+	content->update_private = NULL;
 	for (tmpdev = devlist; tmpdev; tmpdev=tmpdev->next) if (tmpdev->used == 1) {
 		char *devname = tmpdev->devname;
 		struct stat stb;
@@ -717,6 +718,8 @@ int Assemble(struct supertype *st, char *mddev,
 		}
 		devcnt++;
 	}
+	free(content->update_private);
+	content->update_private = NULL;
 
 	if (devcnt == 0) {
 		fprintf(stderr, Name ": no devices found for %s\n",
diff --git a/mdadm.h b/mdadm.h
index 91ba624..04b87b8 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -153,6 +153,11 @@ struct mdinfo {
 	int			cache_size; /* size of raid456 stripe cache*/
 	int			mismatch_cnt;
 	char			text_version[50];
+	void 			*update_private; /* for passing metadata-format
+						  * specific update data
+						  * between successive calls to
+						  * update_super()
+						  */
 
 	int container_member; /* for assembling external-metatdata arrays
 			       * This is to be used internally by metadata
diff --git a/super-intel.c b/super-intel.c
index eaf5b0b..110c4a8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1378,8 +1378,6 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 			     char *update, char *devname, int verbose,
 			     int uuid_set, char *homehost)
 {
-	/* FIXME */
-
 	/* For 'assemble' and 'force' we need to return non-zero if any
 	 * change was made.  For others, the return value is ignored.
 	 * Update options are:
@@ -1395,26 +1393,55 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
 	 *		linear only
 	 *  resync: mark as dirty so a resync will happen.
 	 *  name:  update the name - preserving the homehost
+	 *  uuid:  Change the uuid of the array to match watch is given
 	 *
 	 * Following are not relevant for this imsm:
 	 *  sparc2.2 : update from old dodgey metadata
 	 *  super-minor: change the preferred_minor number
 	 *  summaries:  update redundant counters.
-	 *  uuid:  Change the uuid of the array to match watch is given
 	 *  homehost:  update the recorded homehost
 	 *  _reshape_progress: record new reshape_progress position.
 	 */
-	int rv = 0;
-	//struct intel_super *super = st->sb;
-	//struct imsm_super *mpb = super->mpb;
+	int rv = 1;
+	struct intel_super *super = st->sb;
+	struct imsm_super *mpb;
 
-	if (strcmp(update, "grow") == 0) {
-	}
-	if (strcmp(update, "resync") == 0) {
-		/* dev->vol.dirty = 1; */
-	}
+	/* we can only update container info */
+	if (!super || super->current_vol >= 0 || !super->anchor)
+		return 1;
+
+	mpb = super->anchor;
+
+	if (strcmp(update, "uuid") == 0 && uuid_set && !info->update_private)
+		fprintf(stderr,
+			Name ": '--uuid' not supported for imsm metadata\n");
+	else if (strcmp(update, "uuid") == 0 && uuid_set && info->update_private) {
+		mpb->orig_family_num = *((__u32 *) info->update_private);
+		rv = 0;
+	} else if (strcmp(update, "uuid") == 0) {
+		__u32 *new_family = malloc(sizeof(*new_family));
+
+		/* update orig_family_number with the incoming random
+		 * data, report the new effective uuid, and store the
+		 * new orig_family_num for future updates.
+		 */
+		if (new_family) {
+			memcpy(&mpb->orig_family_num, info->uuid, sizeof(__u32));
+			uuid_from_super_imsm(st, info->uuid);
+			*new_family = mpb->orig_family_num;
+			info->update_private = new_family;
+			rv = 0;
+		}
+	} else if (strcmp(update, "assemble") == 0)
+		rv = 0;
+	else
+		fprintf(stderr,
+			Name ": '--update=%s' not supported for imsm metadata\n",
+			update);
 
-	/* IMSM has no concept of UUID or homehost */
+	/* successful update? recompute checksum */
+	if (rv == 0)
+		mpb->check_sum = __le32_to_cpu(__gen_imsm_checksum(mpb));
 
 	return rv;
 }

