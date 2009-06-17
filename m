From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm git pull] Intel metadata and mapfile fixes for mdadm-3.0.1
Date: Tue, 16 Jun 2009 18:46:43 -0700
Message-ID: <1245203203.3668.13.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Ed Ciechanowski <ed.ciechanowski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

The following changes since commit 6e92d480f765dc22a5abaa5658ad603353648c1c:
  NeilBrown (1):
        Release mdadm-3.0

are available in the git repository at:

  git://github.com/djbw/mdadm.git master

Dan Williams (6):
      fix RebuildMap() to retrieve 'subarray' info
      teach imsm and ddf what st->subarray means at load_super time
      fix examine_brief segfault
      imsm: fixup examine_brief to be more descriptive in the container only case
      fixup map file after Create
      imsm: fix activate_spare off-by-one

 Create.c      |    5 +++++
 Examine.c     |    4 +---
 mapfile.c     |   45 +++++++++++++++++++++++++++++++++++++++++++--
 super-ddf.c   |   17 +++++++++++++++++
 super-intel.c |   36 +++++++++++++++++++++++-------------
 5 files changed, 89 insertions(+), 18 deletions(-)

The validation team discovered some problems with the mapfile and
rebuild handling.  The content of the mapfile for Intel metadata arrays
is invalid until an array is added to a container, this is due to the
fact that spares do not have any container association.  This requires
that the map be rebuilt after a Create().  However, RebuildMap() did not
understand how to identify member arrays, so that also required a small
collection of fixes.

The rebuild problem was a silly off-by-one bug such that activate_spare
would sometimes fail to assimilate valid spare disks.

Please review/pull.

Thanks,
Dan

commit b2d43c5555ff93bb52b5e4cbf41eda9fdaa6df64
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jun 8 11:12:38 2009 -0700

    fix RebuildMap() to retrieve 'subarray' info
    
    RebuildMap falsely returns container info for member arrays.  Retrieving
    the subarray and container_dev details prior to ->load_super() changes the
    result from:
    
    md127 imsm 082c6371:74b5ce03:64972e41:6b0860d5 /dev/md/imsm
    md126 imsm 082c6371:74b5ce03:64972e41:6b0860d5 /dev/md/vol0
    
    ...to:
    
    md126 /md127/0 3e03aee2:78c3c593:1e8ecaf0:eefb53ed /dev/md/vol0
    md127 imsm 082c6371:74b5ce03:64972e41:6b0860d5 /dev/md/imsm
    
    For imsm we need an additional fixup to force local naming otherwise
    RebuildMap() will always choose foreign names.
    
    Reported-by: Ignacy Kasperowicz <ignacy.kasperowicz@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9108d44c7416d6ba9183c6cbec23bc0c7a04e3b6
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jun 8 15:13:35 2009 -0700

    teach imsm and ddf what st->subarray means at load_super time
    
    RebuildMap wants to poll through mdstat and retrieve a (kernel name,
    uuid, user name) tuple for each array.  Teach imsm and ddf to honor
    st->sub_array at ->load_super() time to set their internal subarray
    pointers to the value specified in st->subarray, or return an error if
    st->subarray specifies an invalid array.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1ce1332cc7b18d15bafdb28eb7e6a9f6382444e2
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jun 12 15:46:04 2009 -0700

    fix examine_brief segfault
    
    When performing an "-Ebs -e <metadata type>" we segfault because the
    superblock has been freed too early.  We also leak memory for 'ddf' and
    'imsm' because, unlike super[01], we do not implicitly free when
    ->load_super is called on an already loaded supertype.
    
    So, fix up imsm and ddf to match type 0 and 1 ->load_super() semantics,
    and update Examine to not free the superblock until all usages have been
    exhausted.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2aa294394f9144bc8468b8506ec49906036e3267
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jun 12 15:46:05 2009 -0700

    imsm: fixup examine_brief to be more descriptive in the container only case
    
    Prior to creating any arrays in a new container the output from -Ebs for
    a 4-disk imsm array returns:
    
    		spares=4
    
    We should at least display that these are imsm spares:
    
    	ARRAY metadata=imsm
    		spares=4
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 00a372cc9a1ac3ab38f9b54190812470dac4e2d2
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jun 8 15:39:49 2009 -0700

    fixup map file after Create
    
    When creating an array in an imsm container there is a window where the
    container and member do not have valid uuids.  Rebuild the map file
    after each create.
    
    Reported-by: Ignacy Kasperowicz <ignacy.kasperowicz@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c60013a5824b5f41a8c71e6b08a273596299fe52
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jun 12 15:35:15 2009 -0700

    imsm: fix activate_spare off-by-one
    
    The last sector of an array is calculated by start + size - 1.
    
    Reported-by: Rafal Marszewski <rafal.marszewski@intel.com>
    Reported-by: Jarema Bielanski <jarema.bielanski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/Create.c b/Create.c
index 8a73799..0bb40b6 100644
--- a/Create.c
+++ b/Create.c
@@ -808,6 +808,11 @@ int Create(struct supertype *st, char *mddev,
 		wait_for(chosen_name, mdfd);
 	} else if (runstop == 1 || subdevs >= raiddisks) {
 		if (st->ss->external) {
+			/* Some external metadata format map details
+			 * change after a member array has been added
+			 */
+			RebuildMap();
+
 			switch(level) {
 			case LEVEL_LINEAR:
 			case LEVEL_MULTIPATH:
diff --git a/Examine.c b/Examine.c
index f0e98f9..3d0ea8a 100644
--- a/Examine.c
+++ b/Examine.c
@@ -114,10 +114,8 @@ int Examine(mddev_dev_t devlist, int brief, int export, int scan,
 				ap->st = st;
 				arrays = ap;
 				st->ss->getinfo_super(st, &ap->info);
-			} else {
+			} else
 				st->ss->getinfo_super(st, &ap->info);
-				st->ss->free_super(st);
-			}
 			if (!(ap->info.disk.state & (1<<MD_DISK_SYNC)))
 				ap->spares++;
 			d = dl_strdup(devlist->devname);
diff --git a/mapfile.c b/mapfile.c
index 601c4cc..197ae9b 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -297,6 +297,35 @@ struct map_ent *map_by_name(struct map_ent **map, char *name)
 	return NULL;
 }
 
+/* sets the proper subarray and container_dev according to the metadata
+ * version super_by_fd does this automatically, this routine is meant as
+ * a supplement for guess_super()
+ */
+static void set_member_info(struct supertype *st, struct mdstat_ent *ent)
+{
+	char version[sizeof(ent->metadata_version)];
+	st->subarray[0] = '\0';
+
+	strcpy(version, ent->metadata_version);
+
+	if (version == NULL)
+		return;
+	if (strncmp(version, "external:", 9) != 0)
+		return;
+
+	if (is_subarray(&version[9])) {
+		char *subarray = strrchr(version, '/');
+		char *name = &version[10];
+
+		if (!subarray)
+			return;
+		*subarray++ = '\0';
+
+		st->container_dev = devname2devnum(name);
+		strncpy(st->subarray, subarray, sizeof(st->subarray));
+	}
+}
+
 void RebuildMap(void)
 {
 	struct mdstat_ent *mdstat = mdstat_read(0, 0);
@@ -337,8 +366,10 @@ void RebuildMap(void)
 			st = guess_super(dfd);
 			if ( st == NULL)
 				ok = -1;
-			else
+			else {
+				set_member_info(st, md);
 				ok = st->ss->load_super(st, dfd, NULL);
+			}
 			close(dfd);
 			if (ok != 0)
 				continue;
@@ -353,7 +384,7 @@ void RebuildMap(void)
 				 * an MD_DEVNAME for udev.
 				 * The name needs to be unique both in /dev/md/
 				 * and in this mapfile.
-				 * It needs to match watch -I or -As would come
+				 * It needs to match what -I or -As would come
 				 * up with.
 				 * That means:
 				 *   Check if array is in mdadm.conf 
@@ -386,6 +417,16 @@ void RebuildMap(void)
 					else
 						/* allow name to be used as-is if no conflict */
 						unum = -1;
+
+					/* fixup unum in case the metadata has
+					 * no concept of homehost, i.e.,
+					 * default to local naming (if there is
+					 * no configuration file conflict)
+					 */
+					if (unum == 0 &&
+					    st->ss->match_home(st, "any") == -1 &&
+					    conf_name_is_free(info.name))
+						unum = -1;
 					name = info.name;
 					if (!*name) {
 						name = st->ss->name;
diff --git a/super-ddf.c b/super-ddf.c
index bcd44d1..e84f476 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -762,6 +762,9 @@ static int load_ddf_local(int fd, struct ddf_super *super,
 static int load_super_ddf_all(struct supertype *st, int fd,
 			      void **sbp, char *devname, int keep_fd);
 #endif
+
+static void free_super_ddf(struct supertype *st);
+
 static int load_super_ddf(struct supertype *st, int fd,
 			  char *devname)
 {
@@ -798,6 +801,8 @@ static int load_super_ddf(struct supertype *st, int fd,
 		return 1;
 	}
 
+	free_super_ddf(st);
+
 	if (posix_memalign((void**)&super, 512, sizeof(*super))!= 0) {
 		fprintf(stderr, Name ": malloc of %zu failed.\n",
 			sizeof(*super));
@@ -835,6 +840,18 @@ static int load_super_ddf(struct supertype *st, int fd,
 		return rv;
 	}
 
+	if (st->subarray[0]) {
+		struct vcl *v;
+
+		for (v = super->conflist; v; v = v->next)
+			if (v->vcnum == atoi(st->subarray))
+				super->currentconf = v;
+		if (!super->currentconf) {
+			free(super);
+			return 1;
+		}
+	}
+
 	/* Should possibly check the sections .... */
 
 	st->sb = super;
diff --git a/super-intel.c b/super-intel.c
index 73fe5fa..21188df 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -763,8 +763,10 @@ static void brief_examine_super_imsm(struct supertype *st, int verbose)
 	struct intel_super *super = st->sb;
 	int i;
 
-	if (!super->anchor->num_raid_devs)
+	if (!super->anchor->num_raid_devs) {
+		printf("ARRAY metadata=imsm\n");
 		return;
+	}
 
 	getinfo_super_imsm(st, &info);
 	fname_from_uuid(st, &info, nbuf, ':');
@@ -2167,8 +2169,10 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
 	if (st->subarray[0]) {
 		if (atoi(st->subarray) <= super->anchor->num_raid_devs)
 			super->current_vol = atoi(st->subarray);
-		else
+		else {
+			free_imsm(super);
 			return 1;
+		}
 	}
 
 	*sbp = super;
@@ -2193,8 +2197,8 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 	if (load_super_imsm_all(st, fd, &st->sb, devname, 1) == 0)
 		return 0;
 #endif
-	if (st->subarray[0])
-		return 1; /* FIXME */
+
+	free_super_imsm(st);
 
 	super = alloc_super(0);
 	if (!super) {
@@ -2215,6 +2219,15 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 		return rv;
 	}
 
+	if (st->subarray[0]) {
+		if (atoi(st->subarray) <= super->anchor->num_raid_devs)
+			super->current_vol = atoi(st->subarray);
+		else {
+			free_imsm(super);
+			return 1;
+		}
+	}
+
 	st->sb = super;
 	if (st->ss == NULL) {
 		st->ss = &super_imsm;
@@ -3840,14 +3853,13 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 	int idx = get_imsm_disk_idx(dev, slot);
 	struct imsm_super *mpb = super->anchor;
 	struct imsm_map *map;
-	unsigned long long esize;
 	unsigned long long pos;
 	struct mdinfo *d;
 	struct extent *ex;
 	int i, j;
 	int found;
 	__u32 array_start;
-	__u32 blocks;
+	__u32 array_end;
 	struct dl *dl;
 
 	for (dl = super->disks; dl; dl = dl->next) {
@@ -3899,15 +3911,14 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 			j = 0;
 			pos = 0;
 			array_start = __le32_to_cpu(map->pba_of_lba0);
-			blocks = __le32_to_cpu(map->blocks_per_member);
+			array_end = array_start +
+				    __le32_to_cpu(map->blocks_per_member) - 1;
 
 			do {
 				/* check that we can start at pba_of_lba0 with
 				 * blocks_per_member of space
 				 */
-				esize = ex[j].start - pos;
-				if (array_start >= pos &&
-				    array_start + blocks < ex[j].start) {
+				if (array_start >= pos && array_end < ex[j].start) {
 					found = 1;
 					break;
 				}
@@ -3921,9 +3932,8 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 
 		free(ex);
 		if (i < mpb->num_raid_devs) {
-			dprintf("%x:%x does not have %u at %u\n",
-				dl->major, dl->minor,
-				blocks, array_start);
+			dprintf("%x:%x does not have %u to %u available\n",
+				dl->major, dl->minor, array_start, array_end);
 			/* No room */
 			continue;
 		}


