From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm git pull v2] Intel metadata and mapfile fixes for
	mdadm-3.0.1
Date: Mon, 29 Jun 2009 16:08:34 -0700
Message-ID: <1246316914.3268.19.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Ed Ciechanowski <ed.ciechanowski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The following changes since commit 6e92d480f765dc22a5abaa5658ad603353648c1c:
  NeilBrown (1):
        Release mdadm-3.0

are available in the git repository at:

  git://github.com/djbw/mdadm.git master

Dan Williams (6):
      teach imsm and ddf what st->subarray means at load_super time
      fix RebuildMap() to retrieve 'subarray' info
      fix examine_brief segfault
      imsm: fixup examine_brief to be more descriptive in the container only case
      conditionally update uuids in the map file after Create()
      imsm: fix activate_spare off-by-one

 Create.c      |   32 ++++++++++++++++++++++++++++++++
 Examine.c     |    4 +---
 mapfile.c     |   32 +++++++++++++++++++++++++++++++-
 super-ddf.c   |   31 ++++++++++++++++++++++++++-----
 super-intel.c |   57 ++++++++++++++++++++++++++++++++++++---------------------
 5 files changed, 126 insertions(+), 30 deletions(-)

This is the second take of the pending mapfile and spare activation
fixes for mdadm-3.0 as described previously [1].  I ended up not needing
to re-call ->load_super to perform the mapfile update, instead I updated
->write_init_super to clear the 'current member array' context to allow
a subsequent ->getinfo_super to see the container info again.

This passes 'sh test 0[89]'.

Thanks,
Dan

[1]: http://thread.gmane.org/gmane.linux.raid/23237/focus=23432

commit 30045c3bd6a7a29e7a34d552f733d458126e8b5f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jun 29 15:06:20 2009 -0700

    imsm: fix activate_spare off-by-one
    
    The last sector of an array is calculated by start + size - 1.
    
    Reported-by: Rafal Marszewski <rafal.marszewski@intel.com>
    Reported-by: Jarema Bielanski <jarema.bielanski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a91c6659c0fadb8a6b5d707d80ba476e84232cd7
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jun 29 11:01:37 2009 -0700

    conditionally update uuids in the map file after Create()
    
    The map file needs to be updated after adding the first member array to
    an Intel metadata container.  The uuid for an imsm container uses the
    ->family_num field of the metadata.  This field is static, but is only
    set after the first member array has been created.  Prior to this all
    devices are free floating spares and do not have any information that
    can identify specific container membership.  At Create() time we take
    the uninitialized uuid from ->get_info_super() prior to updating the
    metadata.  So the current result is:
    
    # mdadm --create /dev/md/imsm /dev/sd[b-e] -n 4 -e imsm
    # mdadm --create /dev/md/vol0 /dev/md/imsm -n 4 -l 0
    # cat /var/run/mdadm/map
    md126 /md127/0 3e03aee2:78c3c593:1e8ecaf0:eefb53ed /dev/md/vol0
    md127 imsm 53d6f8b1:7a783f24:f30483c5:705c48c7 /dev/md/imsm
    # mdadm -Ebs
    ARRAY metadata=imsm UUID=589d2d2c:4221a54d:acb63c06:c3907f52
    ARRAY /dev/md/vol0 container=589d2d2c:4221a54d:acb63c06:c3907f52
    	member=0 UUID=57b89b63:5cd0eae1:17dd26b3:51cc78d4
    
    So, before we write out the new metadata check to see if the member
    array uuid has changed as a result of this addition.  If it has, update
    its uuid in the map file and flag its parent container for updating.  In
    support of updating the container uuid the semantics of
    ->write_init_super are changed to clear any metadata specific member
    array cursors (e.g. ddf_super.currentconf or intel_super.current_vol)
    such that a subsequent call to ->getinfo_super returns container
    information.
    
    Reported-by: Ignacy Kasperowicz <ignacy.kasperowicz@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e5a289c96e4a001193c3c2ddad1a8c1a692d302f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jun 29 11:01:25 2009 -0700

    imsm: fixup examine_brief to be more descriptive in the container only case
    
    Prior to creating any arrays in a new container the output from -Ebs for
    a 4-disk imsm array returns:
    
    		spares=4
    
    We should at least display that these are imsm spares:
    
    	ARRAY metadata=imsm
    		spares=4
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d3eddffb74ff723c156494120c2fdc6e4857d9f1
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jun 29 10:51:57 2009 -0700

    fix examine_brief segfault
    
    When performing an "-Ebs -e <metadata type>" we segfault because the
    superblock has been freed too early.  We also leak memory for 'ddf' and
    'imsm' because, unlike super[01], we do not implicitly free when
    ->load_super is called on an already loaded supertype.
    
    So, fix up imsm and ddf to match type 0 and 1 ->load_super() semantics,
    and update Examine to not free the superblock until all usages have been
    exhausted.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ac597e2ec1b6dbe246652bcf00909c29e8c88338
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Jun 27 19:36:41 2009 -0700

    fix RebuildMap() to retrieve 'subarray' info
    
    RebuildMap falsely returns container info for member arrays.  Retrieving
    the subarray and container_dev details prior to ->load_super() changes the
    result from:
    
    md127 imsm 082c6371:74b5ce03:64972e41:6b0860d5 /dev/md/imsm
    md126 imsm 082c6371:74b5ce03:64972e41:6b0860d5 /dev/md/vol0
    
    ...to:
    
    md126 /md127/0 3e03aee2:78c3c593:1e8ecaf0:eefb53ed /dev/md/vol0
    md127 imsm 082c6371:74b5ce03:64972e41:6b0860d5 /dev/md/imsm
    
    Reported-by: Ignacy Kasperowicz <ignacy.kasperowicz@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 938b5a56fecacd4ba55f4c794db09b9489b0b6db
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Jun 27 19:36:36 2009 -0700

    teach imsm and ddf what st->subarray means at load_super time
    
    RebuildMap wants to poll through mdstat and retrieve a (kernel name,
    uuid, user name) tuple for each array.  Teach imsm and ddf to honor
    st->sub_array at ->load_super() time to set their internal subarray
    pointers to the value specified in st->subarray, or return an error if
    st->subarray specifies an invalid array.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/Create.c b/Create.c
index 8a73799..c96b319 100644
--- a/Create.c
+++ b/Create.c
@@ -792,7 +792,39 @@ int Create(struct supertype *st, char *mddev,
 			    dv == moved_disk && dnum != insert_point) break;
 		}
 		if (pass == 1) {
+			struct mdinfo info_new;
+			struct map_ent *me = NULL;
+
+			/* check to see if the uuid has changed due to these
+			 * metadata changes, and if so update the member array
+			 * and container uuid.  Note ->write_init_super clears
+			 * the subarray cursor such that ->getinfo_super once
+			 * again returns container info.
+			 */
+			map_lock(&map);
+			st->ss->getinfo_super(st, &info_new);
+			if (st->ss->external && level != LEVEL_CONTAINER &&
+			    !same_uuid(info_new.uuid, info.uuid, 0)) {
+				map_update(&map, fd2devnum(mdfd),
+					   info_new.text_version,
+					   info_new.uuid, chosen_name);
+				me = map_by_devnum(&map, st->container_dev);
+			}
+
 			st->ss->write_init_super(st);
+
+			/* update parent container uuid */
+			if (me) {
+				char *path = strdup(me->path);
+
+				st->ss->getinfo_super(st, &info_new);
+				map_update(&map, st->container_dev,
+					   info_new.text_version,
+					   info_new.uuid, path);
+				free(path);
+			}
+			map_unlock(&map);
+
 			flush_metadata_updates(st);
 		}
 	}
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
index 601c4cc..a3038be 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -297,6 +297,34 @@ struct map_ent *map_by_name(struct map_ent **map, char *name)
 	return NULL;
 }
 
+/* sets the proper subarray and container_dev according to the metadata
+ * version super_by_fd does this automatically, this routine is meant as
+ * a supplement for guess_super()
+ */
+static void set_member_info(struct supertype *st, struct mdstat_ent *ent)
+{
+	char version[strlen(ent->metadata_version)+1];
+
+	st->subarray[0] = '\0';
+
+	if (strncmp(ent->metadata_version, "external:", 9) != 0)
+		return;
+
+	strcpy(version, ent->metadata_version);
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
@@ -337,8 +365,10 @@ void RebuildMap(void)
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
diff --git a/super-ddf.c b/super-ddf.c
index bcd44d1..167f571 100644
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
@@ -2345,15 +2362,19 @@ static int __write_init_super_ddf(struct supertype *st, int do_close)
 
 static int write_init_super_ddf(struct supertype *st)
 {
+	struct ddf_super *ddf = st->sb;
+	struct vcl *currentconf = ddf->currentconf;
+
+	/* we are done with currentconf reset it to point st at the container */
+	ddf->currentconf = NULL;
 
 	if (st->update_tail) {
 		/* queue the virtual_disk and vd_config as metadata updates */
 		struct virtual_disk *vd;
 		struct vd_config *vc;
-		struct ddf_super *ddf = st->sb;
 		int len;
 
-		if (!ddf->currentconf) {
+		if (!currentconf) {
 			int len = (sizeof(struct phys_disk) +
 				   sizeof(struct phys_disk_entry));
 
@@ -2372,14 +2393,14 @@ static int write_init_super_ddf(struct supertype *st)
 		len = sizeof(struct virtual_disk) + sizeof(struct virtual_entry);
 		vd = malloc(len);
 		*vd = *ddf->virt;
-		vd->entries[0] = ddf->virt->entries[ddf->currentconf->vcnum];
-		vd->populated_vdes = __cpu_to_be16(ddf->currentconf->vcnum);
+		vd->entries[0] = ddf->virt->entries[currentconf->vcnum];
+		vd->populated_vdes = __cpu_to_be16(currentconf->vcnum);
 		append_metadata_update(st, vd, len);
 
 		/* Then the vd_config */
 		len = ddf->conf_rec_len * 512;
 		vc = malloc(len);
-		memcpy(vc, &ddf->currentconf->conf, len);
+		memcpy(vc, &currentconf->conf, len);
 		append_metadata_update(st, vc, len);
 
 		/* FIXME I need to close the fds! */
diff --git a/super-intel.c b/super-intel.c
index 73fe5fa..7170950 100644
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
@@ -2711,17 +2724,16 @@ static int write_super_imsm(struct intel_super *super, int doclose)
 }
 
 
-static int create_array(struct supertype *st)
+static int create_array(struct supertype *st, int dev_idx)
 {
 	size_t len;
 	struct imsm_update_create_array *u;
 	struct intel_super *super = st->sb;
-	struct imsm_dev *dev = get_imsm_dev(super, super->current_vol);
+	struct imsm_dev *dev = get_imsm_dev(super, dev_idx);
 	struct imsm_map *map = get_imsm_map(dev, 0);
 	struct disk_info *inf;
 	struct imsm_disk *disk;
 	int i;
-	int idx;
 
 	len = sizeof(*u) - sizeof(*dev) + sizeof_imsm_dev(dev, 0) +
 	      sizeof(*inf) * map->num_members;
@@ -2733,11 +2745,12 @@ static int create_array(struct supertype *st)
 	}
 
 	u->type = update_create_array;
-	u->dev_idx = super->current_vol;
+	u->dev_idx = dev_idx;
 	imsm_copy_dev(&u->dev, dev);
 	inf = get_disk_info(u);
 	for (i = 0; i < map->num_members; i++) {
-		idx = get_imsm_disk_idx(dev, i);
+		int idx = get_imsm_disk_idx(dev, i);
+
 		disk = get_imsm_disk(super, idx);
 		serialcpy(inf[i].serial, disk->serial);
 	}
@@ -2771,21 +2784,26 @@ static int _add_disk(struct supertype *st)
 
 static int write_init_super_imsm(struct supertype *st)
 {
+	struct intel_super *super = st->sb;
+	int current_vol = super->current_vol;
+
+	/* we are done with current_vol reset it to point st at the container */
+	super->current_vol = -1;
+
 	if (st->update_tail) {
 		/* queue the recently created array / added disk
 		 * as a metadata update */
-		struct intel_super *super = st->sb;
 		struct dl *d;
 		int rv;
 
 		/* determine if we are creating a volume or adding a disk */
-		if (super->current_vol < 0) {
+		if (current_vol < 0) {
 			/* in the add disk case we are running in mdmon
 			 * context, so don't close fd's
 			 */
 			return _add_disk(st);
 		} else
-			rv = create_array(st);
+			rv = create_array(st, current_vol);
 
 		for (d = super->disks; d ; d = d->next) {
 			close(d->fd);
@@ -3840,14 +3858,13 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
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
@@ -3899,15 +3916,14 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
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
@@ -3921,9 +3937,8 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 
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


