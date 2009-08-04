From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm git pull] pending fixes for mdadm 3.0.1
Date: Tue, 04 Aug 2009 12:01:54 -0700
Message-ID: <1249412514.19218.37.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jacek Danecki <jacek.danecki@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Hans de Goede <hdegoede@redhat.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

The following changes since commit fa09d4961e5c72da3c7f78d53a7d64f5196110a3:
  NeilBrown (1):
        Examine: fix --examine --brief --verbose on containers.

are available in the git repository at:

  git://github.com/djbw/mdadm.git master

Dan Williams (10):
      teach imsm and ddf what st->subarray means at load_super time
      fix RebuildMap() to retrieve 'subarray' info
      fix examine_brief segfault
      imsm: fixup examine_brief to be more descriptive in the container only case
      conditionally update uuids in the map file after Create()
      imsm: fix activate_spare off-by-one
      imsm: fix family number handling
      platform: relax rom scanning alignment for ahci platforms
      imsm: fix spare-uuid assignment
      Assemble: fix handling of empty container

 Assemble.c       |    2 +
 Create.c         |   32 ++++++++++++++++
 Examine.c        |    4 +--
 mapfile.c        |   32 ++++++++++++++++-
 mdadm.h          |    1 +
 platform-intel.c |    7 +++-
 probe_roms.c     |   26 +++++++++++---
 probe_roms.h     |    2 +-
 super-ddf.c      |   42 +++++++++++++--------
 super-intel.c    |  104 ++++++++++++++++++++++++++++++++++++++++--------------
 util.c           |   11 ++++++
 11 files changed, 209 insertions(+), 54 deletions(-)

Hi Neil,

This is the same queue that was sent previously [1], but with a few
additions:

1/ Fix family number handling - it turns out that the family_number
field can change.  This approximates homehost functionality in that a
former member array that is rebuilt on another system will have its
family number changed such that if it is returned it will no longer be
considered a member of the original container.  Currently this means
either the original array or the foreign array can be assembled, but not
both.  To resolve this conflict my current thinking is that "update
homehost" functionality will need to be hijacked to update the
orig_family_num field (i.e. the container identifier).

2/ Relax option-rom scanning alignment - any system modern enough to
have Intel(R) Matrix RAID will not have legacy ISA regions.  This allows
us to detect the option-ROM on PCI-3.0-firmware compliant platforms that
allow the option-ROM to be located on 512-byte boundary (as opposed to
2048)

3/ A couple segfault fixups.


Lastly, I notice that there is a regression of sorts since commit
fa09d496 "Examine: fix --examine --brief --verbose on containers".
Changing the order of containers and members confuses mdadm -Asc, or -As
when /etc/mdadm.conf is present.  We now only get the container, and no
members in the multiple container case.  Unintended consequence?

Thanks,
Dan

[1] http://article.gmane.org/gmane.linux.raid/23434

commit af99d9ca67a4dc898e7be1d4a947800deec93c83
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 31 17:08:22 2009 -0700

    teach imsm and ddf what st->subarray means at load_super time
    
    RebuildMap wants to poll through mdstat and retrieve a (kernel name,
    uuid, user name) tuple for each array.  Teach imsm and ddf to honor
    st->sub_array at ->load_super() time to set their internal subarray
    pointers to the value specified in st->subarray, or return an error if
    st->subarray specifies an invalid array.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f98d41ddb4ac543176f33454ceb70983109272d9
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 31 17:11:41 2009 -0700

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

commit 37424f132cb3874fe51021b1b5e04445a3ba1bdb
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 31 17:11:41 2009 -0700

    fix examine_brief segfault
    
    When performing an "-Ebs -e <metadata type>" we segfault because the
    superblock has been freed too early.  We also leak memory for 'ddf' and
    'imsm' because, unlike super[01], we do not implicitly free when
    ->load_super is called on an already loaded supertype.
    
    So, fix up imsm and ddf to match type 0 and 1 ->load_super() semantics,
    and update Examine to not free the superblock until all usages have been
    exhausted.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0d5a423fe7481de5ce20c6174841afeb1aadd255
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 31 17:11:41 2009 -0700

    imsm: fixup examine_brief to be more descriptive in the container only case
    
    Prior to creating any arrays in a new container the output from -Ebs for
    a 4-disk imsm array returns:
    
    		spares=4
    
    We should at least display that these are imsm spares:
    
    	ARRAY metadata=imsm
    		spares=4
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9b1fb67776d63a491df3e7aa13916cd122436e20
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 31 17:11:41 2009 -0700

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

commit 329c82786932b2fbc56cd57ac0bfc185d83a04c9
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 31 17:11:41 2009 -0700

    imsm: fix activate_spare off-by-one
    
    The last sector of an array is calculated by start + size - 1.
    
    Reported-by: Rafal Marszewski <rafal.marszewski@intel.com>
    Reported-by: Jarema Bielanski <jarema.bielanski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 148acb7baaa810b68d55df4c1784d6bd0dfd1b78
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 31 17:11:41 2009 -0700

    imsm: fix family number handling
    
    The family_number field can change.  The option-rom will change the
    family number when it starts a rebuild process (flags a container for
    rebuild).  This was not seen previously as mdadm would usually start the
    rebuild process, preserving the family number.
    
    This is the mechanism that helps to prevent a prodigal array member from
    being returned to its original system and cause a rebuild to go in the
    wrong direction.  With the change we will end up with a container that
    will fail to assemble unless the device with the incompatible family
    number is left out of the assembly.
    
    So, take several actions:
    1/ Convert uuid generation to use orig_family_num, being careful to
       preserve the existing uuid in the case where orig_family_num is not
       set (i.e. previous mdadm created imsm arrays)
    2/ Set orig_family_num at Create.  For arrays created by mdadm prior to
       this release orig_family_num will be zero, so set it to family_num at
       the first metadata write.
    3/ Add checks for orig_family_num to compare_super_imsm
    4/ Update the family number when initiating rebuild
    5/ The option-rom mixes some random data into the family number, add
       this functionality to the mdadm implementation.
    
    Reported-by: Marcin Labun <marcin.labun@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 969c255511a4bd12e6becc11b2a822f24c1fbb76
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 31 17:11:41 2009 -0700

    platform: relax rom scanning alignment for ahci platforms
    
    The PCI-3.0 Firmware specification allows for option-roms to have
    512-byte alignment rather than 2048-byte.  As there does not appear to
    be a reliable method to detect a PCI-3.0 compliant BIOS from userspace
    we allow the imsm platform detection code to presume that a system
    modern enough to have an Intel AHCI controller does not have
    dangerous/legacy ISA regions in the option-ROM memory space.
    
    An environment variable to disable this behaviour, IMSM_SAFE_OROM_SCAN,
    is added in case this presumption is ever proven wrong.
    
    Reported-by: Hans de Goede <hdegoede@redhat.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 7e8545e954dbe0c08277bb8141057c4ae05fada3
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 31 17:11:42 2009 -0700

    imsm: fix spare-uuid assignment
    
    imsm spares do not have container membership by default so we associate
    them with the first container found in the configuration file.  Some
    ARRAY lines do not specify the metadata type so we cannot assume that
    _cst will always be valid.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3ef383aa9616e183cb1eda38fdbe4d7a2ebdfd4c
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Aug 4 10:17:23 2009 -0700

    Assemble: fix handling of empty container
    
    # mdadm --create /dev/md/ddf /dev/sd[b-e] -n 4 -e ddf
    mdadm: container /dev/md/ddf prepared.
    # mdadm -Ss
    mdadm: stopped /dev/md126
    # mdadm -As
    mdadm: Container /dev/md/ddf0 has been assembled with 4 drives
    Segmentation fault
    
    Reported-by: Artur Wojcik <artur.wojcik@intel.com>
    Reported-by: Jacek Danecki <jacek.danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/Assemble.c b/Assemble.c
index 3c3a004..4578906 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -320,6 +320,8 @@ int Assemble(struct supertype *st, char *mddev,
 				content = tmpdev->content;
 			else
 				content = tst->ss->container_content(tst);
+			if (!content)
+				goto loop; /* empty container */
 
 			tmpdev->content = content->next;
 			if (tmpdev->content == NULL)
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
diff --git a/mdadm.h b/mdadm.h
index e564dee..4111eaf 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -848,6 +848,7 @@ extern int open_container(int fd);
 extern int mdmon_running(int devnum);
 extern int signal_mdmon(int devnum);
 extern int check_env(char *name);
+extern __u32 random32(void);
 extern int start_mdmon(int devnum);
 
 extern char *devnum2devname(int num);
diff --git a/platform-intel.c b/platform-intel.c
index 5160227..eaf4c48 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -157,6 +157,7 @@ static int scan(const void *start, const void *end)
 const struct imsm_orom *find_imsm_orom(void)
 {
 	static int populated = 0;
+	unsigned long align;
 
 	/* it's static data so we only need to read it once */
 	if (populated)
@@ -184,7 +185,11 @@ const struct imsm_orom *find_imsm_orom(void)
 		return NULL;
 
 	/* scan option-rom memory looking for an imsm signature */
-	if (probe_roms_init() != 0)
+	if (check_env("IMSM_SAFE_OROM_SCAN"))
+		align = 2048;
+	else
+		align = 512;
+	if (probe_roms_init(align) != 0)
 		return NULL;
 	probe_roms();
 	populated = scan_adapter_roms(scan);
diff --git a/probe_roms.c b/probe_roms.c
index 06ec3f5..a9a8638 100644
--- a/probe_roms.c
+++ b/probe_roms.c
@@ -32,6 +32,8 @@ static void *rom_mem = MAP_FAILED;
 static int rom_fd = -1;
 const static int rom_len = 0xf0000 - 0xc0000; /* option-rom memory region */
 static int _sigbus;
+static unsigned long rom_align;
+
 #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
 
 static void sigbus(int sig)
@@ -76,11 +78,20 @@ void probe_roms_exit(void)
 	}
 }
 
-int probe_roms_init(void)
+int probe_roms_init(unsigned long align)
 {
 	int fd;
 	int rc = 0;
 
+	/* valid values are 2048 and 512.  512 is for PCI-3.0 compliant
+	 * systems, or systems that do not have dangerous/legacy ISA
+	 * devices.  2048 should always be safe
+	 */
+	if (align == 512 || align == 2048)
+		rom_align = align;
+	else
+		return -1;
+
 	if (signal(SIGBUS, sigbus) == SIG_ERR)
 		rc = -1;
 	if (rc == 0) {
@@ -208,6 +219,11 @@ int scan_adapter_roms(scan_fn fn)
 	return found;
 }
 
+static unsigned long align(unsigned long addr, unsigned long alignment)
+{
+	return (addr + alignment - 1) & ~(alignment - 1);
+}
+
 void probe_roms(void)
 {
 	const void *rom;
@@ -220,7 +236,7 @@ void probe_roms(void)
 
 	/* video rom */
 	upper = adapter_rom_resources[0].start;
-	for (start = video_rom_resource.start; start < upper; start += 2048) {
+	for (start = video_rom_resource.start; start < upper; start += rom_align) {
 		rom = isa_bus_to_virt(start);
 		if (!romsignature(rom))
 			continue;
@@ -239,7 +255,7 @@ void probe_roms(void)
 		break;
 	}
 
-	start = (video_rom_resource.end + 1 + 2047) & ~2047UL;
+	start = align(video_rom_resource.end + 1, rom_align);
 	if (start < upper)
 		start = upper;
 
@@ -255,7 +271,7 @@ void probe_roms(void)
 	}
 
 	/* check for adapter roms on 2k boundaries */
-	for (i = 0; i < ARRAY_SIZE(adapter_rom_resources) && start < upper; start += 2048) {
+	for (i = 0; i < ARRAY_SIZE(adapter_rom_resources) && start < upper; start += rom_align) {
 		rom = isa_bus_to_virt(start);
 		if (!romsignature(rom))
 			continue;
@@ -273,7 +289,7 @@ void probe_roms(void)
 		adapter_rom_resources[i].start = start;
 		adapter_rom_resources[i].end = start + length - 1;
 
-		start = adapter_rom_resources[i++].end & ~2047UL;
+		start = adapter_rom_resources[i++].end & ~(rom_align - 1);
 	}
 }
 
diff --git a/probe_roms.h b/probe_roms.h
index 557e933..a1e291a 100644
--- a/probe_roms.h
+++ b/probe_roms.h
@@ -18,7 +18,7 @@
  */
 
 void probe_roms_exit(void);
-int probe_roms_init(void);
+int probe_roms_init(unsigned long align);
 typedef int (*scan_fn)(const void *start, const void *end);
 int scan_adapter_roms(scan_fn fn);
 void probe_roms(void);
diff --git a/super-ddf.c b/super-ddf.c
index 5ad89c2..c28d804 100644
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
@@ -1495,17 +1512,6 @@ static int update_super_ddf(struct supertype *st, struct mdinfo *info,
 	return rv;
 }
 
-__u32 random32(void)
-{
-	__u32 rv;
-	int rfd = open("/dev/urandom", O_RDONLY);
-	if (rfd < 0 || read(rfd, &rv, 4) != 4)
-		rv = random();
-	if (rfd >= 0)
-		close(rfd);
-	return rv;
-}
-
 static void make_header_guid(char *guid)
 {
 	__u32 stamp;
@@ -2345,15 +2351,19 @@ static int __write_init_super_ddf(struct supertype *st, int do_close)
 
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
 
@@ -2372,14 +2382,14 @@ static int write_init_super_ddf(struct supertype *st)
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
index 3abaca5..dc0c9c0 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -247,6 +247,7 @@ struct intel_super {
 	int creating_imsm; /* flag to indicate container creation */
 	int current_vol; /* index of raid device undergoing creation */
 	__u32 create_offset; /* common start for 'current_vol' */
+	__u32 random; /* random data for seeding new family numbers */
 	struct intel_dev *devlist;
 	struct dl {
 		struct dl *next;
@@ -714,6 +715,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	printf("          Magic : %s\n", str);
 	snprintf(str, strlen(MPB_VERSION_RAID0), "%s", get_imsm_version(mpb));
 	printf("        Version : %s\n", get_imsm_version(mpb));
+	printf("    Orig Family : %08x\n", __le32_to_cpu(mpb->orig_family_num));
 	printf("         Family : %08x\n", __le32_to_cpu(mpb->family_num));
 	printf("     Generation : %08x\n", __le32_to_cpu(mpb->generation_num));
 	getinfo_super_imsm(st, &info);
@@ -763,8 +765,10 @@ static void brief_examine_super_imsm(struct supertype *st, int verbose)
 	struct intel_super *super = st->sb;
 	int i;
 
-	if (!super->anchor->num_raid_devs)
+	if (!super->anchor->num_raid_devs) {
+		printf("ARRAY metadata=imsm\n");
 		return;
+	}
 
 	getinfo_super_imsm(st, &info);
 	fname_from_uuid(st, &info, nbuf, ':');
@@ -1089,7 +1093,7 @@ static int match_home_imsm(struct supertype *st, char *homehost)
 	/* the imsm metadata format does not specify any host
 	 * identification information.  We return -1 since we can never
 	 * confirm nor deny whether a given array is "meant" for this
-	 * host.  We rely on compare_super and the 'family_num' field to
+	 * host.  We rely on compare_super and the 'family_num' fields to
 	 * exclude member disks that do not belong, and we rely on
 	 * mdadm.conf to specify the arrays that should be assembled.
 	 * Auto-assembly may still pick up "foreign" arrays.
@@ -1117,7 +1121,7 @@ static void uuid_from_super_imsm(struct supertype *st, int uuid[4])
 	 */
 	/* imsm does not track uuid's so we synthesis one using sha1 on
 	 * - The signature (Which is constant for all imsm array, but no matter)
-	 * - the family_num of the container
+	 * - the orig_family_num of the container
 	 * - the index number of the volume
 	 * - the 'serial' number of the volume.
 	 * Hopefully these are all constant.
@@ -1127,10 +1131,18 @@ static void uuid_from_super_imsm(struct supertype *st, int uuid[4])
 	char buf[20];
 	struct sha1_ctx ctx;
 	struct imsm_dev *dev = NULL;
+	__u32 family_num;
 
+	/* some mdadm versions failed to set ->orig_family_num, in which
+	 * case fall back to ->family_num.  orig_family_num will be
+	 * fixed up with the first metadata update.
+	 */
+	family_num = super->anchor->orig_family_num;
+	if (family_num == 0)
+		family_num = super->anchor->family_num;
 	sha1_init_ctx(&ctx);
 	sha1_process_bytes(super->anchor->sig, MPB_SIG_LEN, &ctx);
-	sha1_process_bytes(&super->anchor->family_num, sizeof(__u32), &ctx);
+	sha1_process_bytes(&family_num, sizeof(__u32), &ctx);
 	if (super->current_vol >= 0)
 		dev = get_imsm_dev(super, super->current_vol);
 	if (dev) {
@@ -1256,7 +1268,11 @@ static void fixup_container_spare_uuid(struct mdinfo *inf)
 			struct supertype *_cst; /* container supertype */
 
 			_cst = array_list->st;
-			_sst = _cst->ss->match_metadata_desc(inf->text_version);
+			if (_cst)
+				_sst = _cst->ss->match_metadata_desc(inf->text_version);
+			else
+				_sst = NULL;
+
 			if (_sst) {
 				memcpy(inf->uuid, array_list->uuid, sizeof(int[4]));
 				free(_sst);
@@ -1438,7 +1454,8 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst)
 	 */
 	if (first->anchor->num_raid_devs > 0 &&
 	    sec->anchor->num_raid_devs > 0) {
-		if (first->anchor->family_num != sec->anchor->family_num)
+		if (first->anchor->orig_family_num != sec->anchor->orig_family_num ||
+		    first->anchor->family_num != sec->anchor->family_num)
 			return 3;
 	}
 
@@ -1478,6 +1495,7 @@ static int compare_super_imsm(struct supertype *st, struct supertype *tst)
 			imsm_copy_dev(get_imsm_dev(first, i), get_imsm_dev(sec, i));
 
 		first->anchor->num_raid_devs = sec->anchor->num_raid_devs;
+		first->anchor->orig_family_num = sec->anchor->orig_family_num;
 		first->anchor->family_num = sec->anchor->family_num;
 	}
 
@@ -2167,8 +2185,10 @@ static int load_super_imsm_all(struct supertype *st, int fd, void **sbp,
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
@@ -2193,8 +2213,8 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
 	if (load_super_imsm_all(st, fd, &st->sb, devname, 1) == 0)
 		return 0;
 #endif
-	if (st->subarray[0])
-		return 1; /* FIXME */
+
+	free_super_imsm(st);
 
 	super = alloc_super(0);
 	if (!super) {
@@ -2215,6 +2235,15 @@ static int load_super_imsm(struct supertype *st, int fd, char *devname)
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
@@ -2536,8 +2565,10 @@ static int add_to_super_imsm_volume(struct supertype *st, mdu_disk_info_t *dk,
 
 		*_dev = *dev;
 		*_disk = dl->disk;
-		sum = __gen_imsm_checksum(mpb);
+		sum = random32();
+		sum += __gen_imsm_checksum(mpb);
 		mpb->family_num = __cpu_to_le32(sum);
+		mpb->orig_family_num = mpb->family_num;
 	}
 
 	return 0;
@@ -2634,6 +2665,7 @@ static int write_super_imsm_spares(struct intel_super *super, int doclose)
 		mpb->disk[0] = d->disk;
 		sum = __gen_imsm_checksum(mpb);
 		mpb->family_num = __cpu_to_le32(sum);
+		mpb->orig_family_num = 0;
 		sum = __gen_imsm_checksum(mpb);
 		mpb->check_sum = __cpu_to_le32(sum);
 
@@ -2668,6 +2700,12 @@ static int write_super_imsm(struct intel_super *super, int doclose)
 	generation++;
 	mpb->generation_num = __cpu_to_le32(generation);
 
+	/* fix up cases where previous mdadm releases failed to set
+	 * orig_family_num
+	 */
+	if (mpb->orig_family_num == 0)
+		mpb->orig_family_num = mpb->family_num;
+
 	mpb_size += sizeof(struct imsm_disk) * mpb->num_disks;
 	for (d = super->disks; d; d = d->next) {
 		if (d->index == -1)
@@ -2711,17 +2749,16 @@ static int write_super_imsm(struct intel_super *super, int doclose)
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
@@ -2733,11 +2770,12 @@ static int create_array(struct supertype *st)
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
@@ -2771,21 +2809,26 @@ static int _add_disk(struct supertype *st)
 
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
@@ -3840,14 +3883,13 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
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
@@ -3899,15 +3941,14 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
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
@@ -3921,9 +3962,8 @@ static struct dl *imsm_add_spare(struct intel_super *super, int slot,
 
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
@@ -4025,6 +4065,7 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 		di->data_offset = __le32_to_cpu(map->pba_of_lba0);
 		di->component_size = a->info.component_size;
 		di->container_member = inst;
+		super->random = random32();
 		di->next = rv;
 		rv = di;
 		num_spares++;
@@ -4191,6 +4232,15 @@ static void imsm_process_update(struct supertype *st,
 		set_imsm_ord_tbl_ent(map, u->slot, dl->index);
 		set_imsm_ord_tbl_ent(migr_map, u->slot, dl->index | IMSM_ORD_REBUILD);
 
+		/* update the family_num to mark a new container
+		 * generation, being careful to record the existing
+		 * family_num in orig_family_num to clean up after
+		 * earlier mdadm versions that neglected to set it.
+		 */
+		if (mpb->orig_family_num == 0)
+			mpb->orig_family_num = mpb->family_num;
+		mpb->family_num += super->random;
+
 		/* count arrays using the victim in the metadata */
 		found = 0;
 		for (a = st->arrays; a ; a = a->next) {
diff --git a/util.c b/util.c
index 00bf803..2543971 100644
--- a/util.c
+++ b/util.c
@@ -1298,6 +1298,17 @@ int check_env(char *name)
 	return 0;
 }
 
+__u32 random32(void)
+{
+	__u32 rv;
+	int rfd = open("/dev/urandom", O_RDONLY);
+	if (rfd < 0 || read(rfd, &rv, 4) != 4)
+		rv = random();
+	if (rfd >= 0)
+		close(rfd);
+	return rv;
+}
+
 #ifndef MDASSEMBLE
 int flush_metadata_updates(struct supertype *st)
 {


