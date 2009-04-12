From: Dan Williams <dan.j.williams@intel.com>
Subject: [mdadm git pull] Intel metadata updates and some general fixes
Date: Sun, 12 Apr 2009 01:39:17 -0700
Message-ID: <1239525557.7433.49.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

Hi Neil,

This release includes a collection of metadata compatibility updates:
1/ Rounding down the array size at create and assemble.  mdadm will warn
if an array requests a custom size but the md/array_size attribute is
not found.
2/ Refusing to assemble arrays that are in an unsupported migration
state.  Until proper support is ready we need to detect such arrays and
tell the user to finish the migration (raid level change, capacity
expansion, restripe etc...) before trying to assemble the array in
Linux.
3/ Various other fixups to gain better compatibility with the Windows
driver.

According to Jacek the 'MD_METADATA' key from
export_examine_super_imsm() gives anaconda fits when the array is not a
native md array.  I had a patch to remove it, but decided to leave it in
for a few reasons:
1/ I strongly suspect it is an anaconda misunderstanding of how to
handle 'container' devices.
2/ It is a simple hack that if needed can be added to the Fedora local
version of mdadm.
3/ I see no other way for udev to detect imsm members and perform
operations like 'mdadm --detail-platform -e $MD_METADATA' to verify that
raid support is enabled in the BIOS.  At installation time I would think
a user would want the option to ignore raid metadata on the drives if
support is disabled in the BIOS.

The remaining patches are just straightforward fixes.

Please pull.

Thanks,
Dan

The following changes since commit b9d77223eb68a211410131b5b0895c547a6d5734:
  NeilBrown (1):
        Release mdadm-3.0-devel3

are available in the git repository at:

  git://github.com/djbw/mdadm.git master

Dan Williams (14):
      imsm: extract right-most whitespace stripped serial number
      imsm: make uuid separator consistent with ddf
      imsm: support --examine --export
      imsm: ensure mpb buffer is zeroed
      imsm: fix imsm_map.num_domains
      imsm: add 'verify', 'verify with fixup', and 'general' migration types
      imsm: defend against unsupported migrations (temporary)
      imsm: turn off curr_migr_unit updates
      imsm: set array size at Create/Assemble
      imsm: round down array size at Create
      imsm: add the ddf field
      RebuildMap: handle missing disks
      Grow: fix hang when reshape completes too fast
      mdmon: fix resync completion detection

 Grow.c        |    8 +++
 mapfile.c     |    5 +-
 mdadm.h       |    5 ++
 monitor.c     |    6 +-
 super-ddf.c   |    1 +
 super-intel.c |  186 +++++++++++++++++++++++++++++++++++++++++----------------
 sysfs.c       |   34 ++++++++++
 7 files changed, 191 insertions(+), 54 deletions(-)

commit 316e2bf426350bc5f8dec16ad7fc079d9c8ba725
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Apr 8 11:41:51 2009 -0700

    imsm: extract right-most whitespace stripped serial number
    
    According to new documentation the metadata expects that all whitespace
    (characters <= 0x20) are stripped from the incoming serial number.  If
    the length remains longer than MAX_RAID_SERIAL_LEN then only the
    right-most characters are preserved.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/super-intel.c b/super-intel.c
index b47371e..5413659 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1461,7 +1461,10 @@ static int imsm_read_serial(int fd, char *devname,
 	int rv;
 	int rsp_len;
 	int len;
-	char *c, *rsp_buf;
+	char *dest;
+	char *src;
+	char *rsp_buf;
+	int i;
 
 	memset(scsi_serial, 0, sizeof(scsi_serial));
 
@@ -1481,7 +1484,6 @@ static int imsm_read_serial(int fd, char *devname,
 		return rv;
 	}
 
-	/* trim leading whitespace */
 	rsp_len = scsi_serial[3];
 	if (!rsp_len) {
 		if (devname)
@@ -1491,24 +1493,33 @@ static int imsm_read_serial(int fd, char *devname,
 		return 2;
 	}
 	rsp_buf = (char *) &scsi_serial[4];
-	c = rsp_buf;
-	while (isspace(*c))
-		c++;
 
-	/* truncate len to the end of rsp_buf if necessary */
-	if (c + MAX_RAID_SERIAL_LEN > rsp_buf + rsp_len)
-		len = rsp_len - (c - rsp_buf);
-	else
+	/* trim all whitespace and non-printable characters and convert
+	 * ':' to ';'
+	 */
+	for (i = 0, dest = rsp_buf; i < rsp_len; i++) {
+		src = &rsp_buf[i];
+		if (*src > 0x20) {
+			/* ':' is reserved for use in placeholder serial
+			 * numbers for missing disks
+			 */
+			if (*src == ':')
+				*dest++ = ';';
+			else
+				*dest++ = *src;
+		}
+	}
+	len = dest - rsp_buf;
+	dest = rsp_buf;
+
+	/* truncate leading characters */
+	if (len > MAX_RAID_SERIAL_LEN) {
+		dest += len - MAX_RAID_SERIAL_LEN;
 		len = MAX_RAID_SERIAL_LEN;
+	}
 
-	/* initialize the buffer and copy rsp_buf characters */
 	memset(serial, 0, MAX_RAID_SERIAL_LEN);
-	memcpy(serial, c, len);
-
-	/* trim trailing whitespace starting with the last character copied */
-	c = (char *) &serial[len - 1];
-	while (isspace(*c) || *c == '\0')
-		*c-- = '\0';
+	memcpy(serial, dest, len);
 
 	return 0;
 }

commit ae2bfd4e13575b44ee74e8b60211436633b92a2c
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Apr 11 21:53:25 2009 -0700

    imsm: make uuid separator consistent with ddf
    
    '-' to ':'
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/super-intel.c b/super-intel.c
index 5413659..b47b64b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -679,7 +679,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 	printf("         Family : %08x\n", __le32_to_cpu(mpb->family_num));
 	printf("     Generation : %08x\n", __le32_to_cpu(mpb->generation_num));
 	getinfo_super_imsm(st, &info);
-	fname_from_uuid(st, &info, nbuf,'-');
+	fname_from_uuid(st, &info, nbuf, ':');
 	printf("           UUID : %s\n", nbuf + 5);
 	sum = __le32_to_cpu(mpb->check_sum);
 	printf("       Checksum : %08x %s\n", sum,
@@ -705,7 +705,7 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 
 		super->current_vol = i;
 		getinfo_super_imsm(st, &info);
-		fname_from_uuid(st, &info, nbuf, '-');
+		fname_from_uuid(st, &info, nbuf, ':');
 		print_imsm_dev(dev, nbuf + 5, super->disks->index);
 	}
 	for (i = 0; i < mpb->num_disks; i++) {
@@ -728,14 +728,14 @@ static void brief_examine_super_imsm(struct supertype *st)
 		return;
 
 	getinfo_super_imsm(st, &info);
-	fname_from_uuid(st, &info, nbuf,'-');
+	fname_from_uuid(st, &info, nbuf, ':');
 	printf("ARRAY metadata=imsm auto=md UUID=%s\n", nbuf + 5);
 	for (i = 0; i < super->anchor->num_raid_devs; i++) {
 		struct imsm_dev *dev = get_imsm_dev(super, i);
 
 		super->current_vol = i;
 		getinfo_super_imsm(st, &info);
-		fname_from_uuid(st, &info, nbuf1,'-');
+		fname_from_uuid(st, &info, nbuf1, ':');
 		printf("ARRAY /dev/md/%.16s container=%s\n"
 		       "   member=%d auto=mdp UUID=%s\n",
 		       dev->volume, nbuf + 5, i, nbuf1 + 5);
@@ -748,7 +748,7 @@ static void detail_super_imsm(struct supertype *st, char *homehost)
 	char nbuf[64];
 
 	getinfo_super_imsm(st, &info);
-	fname_from_uuid(st, &info, nbuf,'-');
+	fname_from_uuid(st, &info, nbuf, ':');
 	printf("\n           UUID : %s\n", nbuf + 5);
 }
 
@@ -757,7 +757,7 @@ static void brief_detail_super_imsm(struct supertype *st)
 	struct mdinfo info;
 	char nbuf[64];
 	getinfo_super_imsm(st, &info);
-	fname_from_uuid(st, &info, nbuf,'-');
+	fname_from_uuid(st, &info, nbuf, ':');
 	printf(" UUID=%s", nbuf + 5);
 }
 

commit 9d84c8eac256345126f10628e4f13c07f7eece17
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Apr 11 21:53:25 2009 -0700

    imsm: support --examine --export
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/super-intel.c b/super-intel.c
index b47b64b..328a335 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -742,6 +742,21 @@ static void brief_examine_super_imsm(struct supertype *st)
 	}
 }
 
+static void export_examine_super_imsm(struct supertype *st)
+{
+	struct intel_super *super = st->sb;
+	struct imsm_super *mpb = super->anchor;
+	struct mdinfo info;
+	char nbuf[64];
+
+	getinfo_super_imsm(st, &info);
+	fname_from_uuid(st, &info, nbuf, ':');
+	printf("MD_METADATA=imsm\n");
+	printf("MD_LEVEL=container\n");
+	printf("MD_UUID=%s\n", nbuf+5);
+	printf("MD_DEVICES=%u\n", mpb->num_disks);
+}
+
 static void detail_super_imsm(struct supertype *st, char *homehost)
 {
 	struct mdinfo info;
@@ -4429,6 +4444,7 @@ struct superswitch super_imsm = {
 #ifndef	MDASSEMBLE
 	.examine_super	= examine_super_imsm,
 	.brief_examine_super = brief_examine_super_imsm,
+	.export_examine_super = export_examine_super_imsm,
 	.detail_super	= detail_super_imsm,
 	.brief_detail_super = brief_detail_super_imsm,
 	.write_init_super = write_init_super_imsm,

commit 1f45a8ad2083d6b9de6e37ae46e8ac957694d0f8
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun Apr 12 00:58:27 2009 -0700

    imsm: ensure mpb buffer is zeroed
    
    Don't leak unitialized data into the mpb.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/super-intel.c b/super-intel.c
index 328a335..4754b25 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1746,7 +1746,8 @@ static int parse_raid_devices(struct intel_super *super)
 		if (posix_memalign(&buf, 512, len) != 0)
 			return 1;
 
-		memcpy(buf, super->buf, len);
+		memcpy(buf, super->buf, super->len);
+		memset(buf + super->len, 0, len - super->len);
 		free(super->buf);
 		super->buf = buf;
 		super->len = len;
@@ -4382,7 +4383,9 @@ static void imsm_prepare_update(struct supertype *st,
 			free(super->next_buf);
 
 		super->next_len = buf_len;
-		if (posix_memalign(&super->next_buf, 512, buf_len) != 0)
+		if (posix_memalign(&super->next_buf, 512, buf_len) == 0)
+			memset(super->next_buf, 0, buf_len);
+		else
 			super->next_buf = NULL;
 	}
 }

commit ff5963088d487e6b7f16fb7cb260bf9cac60bf4a
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun Apr 12 00:58:27 2009 -0700

    imsm: fix imsm_map.num_domains
    
    'num_domains' is the number of parity domains.  I.e. 2 in the raid10
    case (2-mirrors), while raid0 through raid5 have 1 parity domain (even
    though raid0 does not have parity).
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/super-intel.c b/super-intel.c
index 4754b25..9b8cea2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -2191,13 +2191,12 @@ static __u16 info_to_blocks_per_strip(mdu_array_info_t *info)
 	return info->chunk_size >> 9;
 }
 
-static __u32 info_to_num_data_stripes(mdu_array_info_t *info)
+static __u32 info_to_num_data_stripes(mdu_array_info_t *info, int num_domains)
 {
 	__u32 num_stripes;
 
 	num_stripes = (info->size * 2) / info_to_blocks_per_strip(info);
-	if (info->level == 1)
-		num_stripes /= 2;
+	num_stripes /= num_domains;
 
 	return num_stripes;
 }
@@ -2274,6 +2273,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	int i;
 	unsigned long long array_blocks;
 	size_t size_old, size_new;
+	__u32 num_data_stripes;
 
 	if (super->orom && mpb->num_raid_devs >= super->orom->vpa) {
 		fprintf(stderr, Name": This imsm-container already has the "
@@ -2349,7 +2349,6 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	map->pba_of_lba0 = __cpu_to_le32(super->create_offset);
 	map->blocks_per_member = __cpu_to_le32(info_to_blocks_per_member(info));
 	map->blocks_per_strip = __cpu_to_le16(info_to_blocks_per_strip(info));
-	map->num_data_stripes = __cpu_to_le32(info_to_num_data_stripes(info));
 	map->failed_disk_num = ~0;
 	map->map_state = info->level ? IMSM_T_STATE_UNINITIALIZED :
 				       IMSM_T_STATE_NORMAL;
@@ -2364,8 +2363,10 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 		map->num_domains = info->raid_disks / 2;
 	} else {
 		map->raid_level = info->level;
-		map->num_domains = !!map->raid_level;
+		map->num_domains = 1;
 	}
+	num_data_stripes = info_to_num_data_stripes(info, map->num_domains);
+	map->num_data_stripes = __cpu_to_le32(num_data_stripes);
 
 	map->num_members = info->raid_disks;
 	for (i = 0; i < map->num_members; i++) {

commit 1484e727976ef1352f5e8b48889efd22b209b737
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun Apr 12 00:58:27 2009 -0700

    imsm: add 'verify', 'verify with fixup', and 'general' migration types
    
    imsm distinguishes parity initialization from parity checking in the
    metadata. Older option roms marked the repair operation with the
    'verify' type and a 'with fixup' flag in the raid device 'status' field.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/super-intel.c b/super-intel.c
index 9b8cea2..266d734 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -105,6 +105,7 @@ struct imsm_vol {
 #define MIGR_VERIFY 2 /* analagous to echo check > sync_action */
 #define MIGR_GEN_MIGR 3
 #define MIGR_STATE_CHANGE 4
+#define MIGR_REPAIR 5
 	__u8  migr_type;	/* Initializing, Rebuilding, ... */
 	__u8  dirty;
 	__u8  fs_state;		/* fast-sync state for CnG (0xff == disabled) */
@@ -193,6 +194,29 @@ struct bbm_log {
 static char *map_state_str[] = { "normal", "uninitialized", "degraded", "failed" };
 #endif
 
+static __u8 migr_type(struct imsm_dev *dev)
+{
+	if (dev->vol.migr_type == MIGR_VERIFY &&
+	    dev->status & DEV_VERIFY_AND_FIX)
+		return MIGR_REPAIR;
+	else
+		return dev->vol.migr_type;
+}
+
+static void set_migr_type(struct imsm_dev *dev, __u8 migr_type)
+{
+	/* for compatibility with older oroms convert MIGR_REPAIR, into
+	 * MIGR_VERIFY w/ DEV_VERIFY_AND_FIX status
+	 */
+	if (migr_type == MIGR_REPAIR) {
+		dev->vol.migr_type = MIGR_VERIFY;
+		dev->status |= DEV_VERIFY_AND_FIX;
+	} else {
+		dev->vol.migr_type = migr_type;
+		dev->status &= ~DEV_VERIFY_AND_FIX;
+	}
+}
+
 static unsigned int sector_count(__u32 bytes)
 {
 	return ((bytes + (512-1)) & (~(512-1))) / 512;
@@ -621,10 +645,23 @@ static void print_imsm_dev(struct imsm_dev *dev, char *uuid, int disk_idx)
 	printf("     Chunk Size : %u KiB\n",
 		__le16_to_cpu(map->blocks_per_strip) / 2);
 	printf("       Reserved : %d\n", __le32_to_cpu(dev->reserved_blocks));
-	printf("  Migrate State : %s", dev->vol.migr_state ? "migrating" : "idle");
-	if (dev->vol.migr_state)
-		printf(": %s", dev->vol.migr_type ? "rebuilding" : "initializing");
-	printf("\n");
+	printf("  Migrate State : %s", dev->vol.migr_state ? "migrating" : "idle\n");
+	if (dev->vol.migr_state) {
+		if (migr_type(dev) == MIGR_INIT)
+			printf(": initializing\n");
+		else if (migr_type(dev) == MIGR_REBUILD)
+			printf(": rebuilding\n");
+		else if (migr_type(dev) == MIGR_VERIFY)
+			printf(": check\n");
+		else if (migr_type(dev) == MIGR_GEN_MIGR)
+			printf(": general migration\n");
+		else if (migr_type(dev) == MIGR_STATE_CHANGE)
+			printf(": state change\n");
+		else if (migr_type(dev) == MIGR_REPAIR)
+			printf(": repair\n");
+		else
+			printf(": <unknown:%d>\n", migr_type(dev));
+	}
 	printf("      Map State : %s", map_state_str[map->map_state]);
 	if (dev->vol.migr_state) {
 		struct imsm_map *map = get_imsm_map(dev, 1);
@@ -1653,7 +1690,7 @@ load_imsm_disk(int fd, struct intel_super *super, char *devname, int keep_fd)
  * 1/ Idle (migr_state=0 map0state=normal||unitialized||degraded||failed)
  * 2/ Initialize (migr_state=1 migr_type=MIGR_INIT map0state=normal
  *    map1state=unitialized)
- * 3/ Verify (Resync) (migr_state=1 migr_type=MIGR_REBUILD map0state=normal
+ * 3/ Repair (Resync) (migr_state=1 migr_type=MIGR_REPAIR  map0state=normal
  *    map1state=normal)
  * 4/ Rebuild (migr_state=1 migr_type=MIGR_REBUILD map0state=normal
  *    map1state=degraded)
@@ -1664,7 +1701,7 @@ static void migrate(struct imsm_dev *dev, __u8 to_state, int migr_type)
 	struct imsm_map *src = get_imsm_map(dev, 0);
 
 	dev->vol.migr_state = 1;
-	dev->vol.migr_type = migr_type;
+	set_migr_type(dev, migr_type);
 	dev->vol.curr_migr_unit = 0;
 	dest = get_imsm_map(dev, 1);
 
@@ -2342,7 +2379,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	dev->reserved_blocks = __cpu_to_le32(0);
 	vol = &dev->vol;
 	vol->migr_state = 0;
-	vol->migr_type = MIGR_INIT;
+	set_migr_type(dev, MIGR_INIT);
 	vol->dirty = 0;
 	vol->curr_migr_unit = 0;
 	map = get_imsm_map(dev, 0);
@@ -3518,7 +3555,8 @@ static int is_resyncing(struct imsm_dev *dev)
 	if (!dev->vol.migr_state)
 		return 0;
 
-	if (dev->vol.migr_type == MIGR_INIT)
+	if (migr_type(dev) == MIGR_INIT ||
+	    migr_type(dev) == MIGR_REPAIR)
 		return 1;
 
 	migr_map = get_imsm_map(dev, 1);
@@ -3536,7 +3574,7 @@ static int is_rebuilding(struct imsm_dev *dev)
 	if (!dev->vol.migr_state)
 		return 0;
 
-	if (dev->vol.migr_type != MIGR_REBUILD)
+	if (migr_type(dev) != MIGR_REBUILD)
 		return 0;
 
 	migr_map = get_imsm_map(dev, 1);
@@ -3627,10 +3665,10 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 	} else if (!is_resyncing(dev) && !failed) {
 		/* mark the start of the init process if nothing is failed */
 		dprintf("imsm: mark resync start (%llu)\n", a->resync_start);
-		if (map->map_state == IMSM_T_STATE_NORMAL)
-			migrate(dev, IMSM_T_STATE_NORMAL, MIGR_REBUILD);
-		else
+		if (map->map_state == IMSM_T_STATE_UNINITIALIZED)
 			migrate(dev, IMSM_T_STATE_NORMAL, MIGR_INIT);
+		else
+			migrate(dev, IMSM_T_STATE_NORMAL, MIGR_REPAIR);
 		super->updates_pending++;
 	}
 

commit 1ce0101c9a16ab5ffa148a0b8f5c9ac0d7b81684
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun Apr 12 00:58:28 2009 -0700

    imsm: defend against unsupported migrations (temporary)
    
    Until support for higher order migrations (online capacity expansion,
    raid level migration, chunk size migration...) are implemented do not
    allow arrays in these states to be assembled.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/super-intel.c b/super-intel.c
index 266d734..41e9168 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3355,6 +3355,18 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 		struct mdinfo *this;
 		int slot;
 
+		/* do not publish arrays that are in the middle of an
+		 * unsupported migration
+		 */
+		if (dev->vol.migr_state &&
+		    (migr_type(dev) == MIGR_GEN_MIGR ||
+		     migr_type(dev) == MIGR_STATE_CHANGE)) {
+			fprintf(stderr, Name ": cannot assemble volume '%.16s':"
+				" unsupported migration in progress\n",
+				dev->volume);
+			continue;
+		}
+
 		this = malloc(sizeof(*this));
 		memset(this, 0, sizeof(*this));
 		this->next = rest;
@@ -3401,7 +3413,7 @@ static struct mdinfo *container_content_imsm(struct supertype *st)
 			info_d = malloc(sizeof(*info_d));
 			if (!info_d) {
 				fprintf(stderr, Name ": failed to allocate disk"
-					" for volume %s\n", (char *) dev->volume);
+					" for volume %.16s\n", dev->volume);
 				free(this);
 				this = rest;
 				break;

commit da1887895404506708387fa3781bf0df0a2664ff
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun Apr 12 00:58:28 2009 -0700

    imsm: turn off curr_migr_unit updates
    
    New documentation shows that this field is not equivalent to
    md/resync_start.  Disable updates until full support can be developed.
    
    Writing '0' when a migration starts/re-starts remains correct.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/super-intel.c b/super-intel.c
index 41e9168..3befc3d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1218,7 +1218,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	if (map->map_state == IMSM_T_STATE_UNINITIALIZED || dev->vol.dirty)
 		info->resync_start = 0;
 	else if (dev->vol.migr_state)
-		info->resync_start = __le32_to_cpu(dev->vol.curr_migr_unit);
+		/* FIXME add curr_migr_unit to resync_start conversion */
+		info->resync_start = 0;
 	else
 		info->resync_start = ~0ULL;
 
@@ -3684,13 +3685,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 		super->updates_pending++;
 	}
 
-	/* check if we can update the migration checkpoint */
-	if (dev->vol.migr_state &&
-	    __le32_to_cpu(dev->vol.curr_migr_unit) != a->resync_start) {
-		dprintf("imsm: checkpoint migration (%llu)\n", a->resync_start);
-		dev->vol.curr_migr_unit = __cpu_to_le32(a->resync_start);
-		super->updates_pending++;
-	}
+	 /* FIXME check if we can update curr_migr_unit from resync_start */
 
 	/* mark dirty / clean */
 	if (dev->vol.dirty != !consistent) {

commit da9b4a62af80edbbcc96196ab5d887308516ba70
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun Apr 12 00:58:28 2009 -0700

    imsm: set array size at Create/Assemble
    
    imsm arrays round down the effective array size to the closest 1
    megabyte boundary so teach get_info_super_imsm and sysfs_set_array to
    set 'md/array_size' if available (and make sure ddf uses the default
    size).
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/mdadm.h b/mdadm.h
index f580e3e..c33ec24 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -146,6 +146,9 @@ struct mdinfo {
 	unsigned long long	component_size; /* same as array.size, except in
 						 * sectors and up to 64bits.
 						 */
+	unsigned long long	custom_array_size; /* size for non-default sized
+						    * arrays (in sectors)
+						    */
 	int			reshape_active;
 	unsigned long long	reshape_progress;
 	unsigned long long	resync_start;
diff --git a/super-ddf.c b/super-ddf.c
index 6455dee..6a87055 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1374,6 +1374,7 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info)
 		__be32_to_cpu(*(__u32*)(vc->conf.guid+16));
 	info->array.utime	  = DECADE + __be32_to_cpu(vc->conf.timestamp);
 	info->array.chunk_size	  = 512 << vc->conf.chunk_shift;
+	info->custom_array_size	  = 0;
 
 	if (cd >= 0 && cd < ddf->mppe) {
 		info->data_offset	  = __be64_to_cpu(vc->lba_offset[cd]);
diff --git a/super-intel.c b/super-intel.c
index 3befc3d..b41ab3b 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1203,6 +1203,9 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info)
 	info->array.utime	  = 0;
 	info->array.chunk_size	  = __le16_to_cpu(map->blocks_per_strip) << 9;
 	info->array.state	  = !dev->vol.dirty;
+	info->custom_array_size   = __le32_to_cpu(dev->size_high);
+	info->custom_array_size   <<= 32;
+	info->custom_array_size   |= __le32_to_cpu(dev->size_low);
 
 	info->disk.major = 0;
 	info->disk.minor = 0;
diff --git a/sysfs.c b/sysfs.c
index 2dad7d3..48d1f54 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -506,6 +506,20 @@ int sysfs_set_array(struct mdinfo *info, int vers)
 	rv |= sysfs_set_num(info, NULL, "chunk_size", info->array.chunk_size);
 	rv |= sysfs_set_num(info, NULL, "layout", info->array.layout);
 	rv |= sysfs_set_num(info, NULL, "component_size", info->component_size/2);
+	if (info->custom_array_size) {
+		int rc;
+
+		rc = sysfs_set_num(info, NULL, "array_size",
+				   info->custom_array_size/2);
+		if (rc && errno == ENOENT) {
+			fprintf(stderr, Name ": This kernel does not "
+				"have the md/array_size attribute, "
+				"the array may be larger than expected\n");
+			rc = 0;
+		}
+		rv |= rc;
+	}
+
 	if (info->array.level > 0)
 		rv |= sysfs_set_num(info, NULL, "resync_start", info->resync_start);
 	return rv;

commit 979d38be50e84b70e0809249a6b05864049fb97d
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun Apr 12 00:58:28 2009 -0700

    imsm: round down array size at Create
    
    Store the 1MB rounded down size of the array at create time.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/super-intel.c b/super-intel.c
index b41ab3b..3415da4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -53,6 +53,7 @@
 
 #define MPB_SECTOR_CNT 418
 #define IMSM_RESERVED_SECTORS 4096
+#define SECT_PER_MB_SHIFT 11
 
 /* Disk configuration info. */
 #define IMSM_MAX_DEVICES 255
@@ -2377,6 +2378,9 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 		array_blocks = calc_array_size(info->level, info->raid_disks,
 					       info->layout, info->chunk_size,
 					       info->size*2);
+	/* round array size down to closest MB */
+	array_blocks = (array_blocks >> SECT_PER_MB_SHIFT) << SECT_PER_MB_SHIFT;
+
 	dev->size_low = __cpu_to_le32((__u32) array_blocks);
 	dev->size_high = __cpu_to_le32((__u32) (array_blocks >> 32));
 	dev->status = __cpu_to_le32(0);

commit 252d23c018cefb2e42c494b1789f5e4945063ee3
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun Apr 12 00:58:28 2009 -0700

    imsm: add the ddf field
    
    This field is always one in arrays created by the Windows driver / OROM,
    not sure why...
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/super-intel.c b/super-intel.c
index 3415da4..300c7b8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -89,7 +89,7 @@ struct imsm_map {
 	__u8  num_members;	/* number of member disks */
 	__u8  num_domains;	/* number of parity domains */
 	__u8  failed_disk_num;  /* valid only when state is degraded */
-	__u8  reserved[1];
+	__u8  ddf;
 	__u32 filler[7];	/* expansion area */
 #define IMSM_ORD_REBUILD (1 << 24)
 	__u32 disk_ord_tbl[1];	/* disk_ord_tbl[num_members],
@@ -2397,6 +2397,7 @@ static int init_super_imsm_volume(struct supertype *st, mdu_array_info_t *info,
 	map->failed_disk_num = ~0;
 	map->map_state = info->level ? IMSM_T_STATE_UNINITIALIZED :
 				       IMSM_T_STATE_NORMAL;
+	map->ddf = 1;
 
 	if (info->level == 1 && info->raid_disks > 2) {
 		fprintf(stderr, Name": imsm does not support more than 2 disks"

commit 506ffd1e0bd08cc74f5177d4f4db7c66d7724f6a
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun Apr 12 00:58:28 2009 -0700

    RebuildMap: handle missing disks
    
    When rebuilding the map file tolerate missing/offline disks, otherwise
    we will segfault on the NULL return from sysfs_read.
    
    Reported-by: Jacek Danecki <jacek.danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/mapfile.c b/mapfile.c
index ca7072e..f276232 100644
--- a/mapfile.c
+++ b/mapfile.c
@@ -294,9 +294,12 @@ void RebuildMap(void)
 	int mdp = get_mdp_major();
 
 	for (md = mdstat ; md ; md = md->next) {
-		struct mdinfo *sra = sysfs_read(-1, md->devnum, GET_DEVS);
+		struct mdinfo *sra = sysfs_read(-1, md->devnum, GET_DEVS|SKIP_GONE_DEVS);
 		struct mdinfo *sd;
 
+		if (!sra)
+			continue;
+
 		for (sd = sra->devs ; sd ; sd = sd->next) {
 			char dn[30];
 			int dfd;

commit 48924014b02dd0e8046f58a4c6c9a2903a9b1dbd
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun Apr 12 00:58:28 2009 -0700

    Grow: fix hang when reshape completes too fast
    
    For short reshapes the kernel may be done before mdadm can check that
    progress has passed the critical section.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/Grow.c b/Grow.c
index 14e48f5..7083c18 100644
--- a/Grow.c
+++ b/Grow.c
@@ -809,12 +809,20 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		/* wait for reshape to pass the critical region */
 		while(1) {
 			unsigned long long comp;
+			char a[20];
+
 			if (sysfs_get_ll(sra, NULL, "sync_completed", &comp)<0) {
 				sleep(5);
 				break;
 			}
 			if (comp >= nstripe)
 				break;
+
+			/* perhaps the entire reshape has completed */
+			if (comp == 0 &&
+			    sysfs_get_str(sra, NULL, "sync_action", a, sizeof(a)) == 0 &&
+			    strncmp(a, "idle", 4) == 0)
+				break;
 			sleep(1);
 		}
 
diff --git a/mdadm.h b/mdadm.h
index c33ec24..82c7ded 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -372,6 +372,8 @@ extern int sysfs_set_num(struct mdinfo *sra, struct mdinfo *dev,
 extern int sysfs_uevent(struct mdinfo *sra, char *event);
 extern int sysfs_get_ll(struct mdinfo *sra, struct mdinfo *dev,
 			char *name, unsigned long long *val);
+extern int sysfs_get_str(struct mdinfo *sra, struct mdinfo *dev,
+			 char *name, char *buf, int buf_len);
 extern int sysfs_set_safemode(struct mdinfo *sra, unsigned long ms);
 extern int sysfs_set_array(struct mdinfo *info, int vers);
 extern int sysfs_add_disk(struct mdinfo *sra, struct mdinfo *sd);
diff --git a/sysfs.c b/sysfs.c
index 48d1f54..31c92f7 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -466,6 +466,26 @@ int sysfs_get_ll(struct mdinfo *sra, struct mdinfo *dev,
 	return 0;
 }
 
+int sysfs_get_str(struct mdinfo *sra, struct mdinfo *dev,
+		  char *name, char *buf, int buf_len)
+{
+	char fname[50];
+	int n;
+	int fd;
+
+	sprintf(fname, "/sys/block/%s/md/%s/%s",
+		sra->sys_name, dev?dev->sys_name:"", name);
+	fd = open(fname, O_RDONLY);
+	if (fd < 0)
+		return -1;
+	n = read(fd, buf, buf_len);
+	close(fd);
+	if (n <= 0)
+		return -1;
+	buf[n] = 0;
+	return 0;
+}
+
 int sysfs_set_safemode(struct mdinfo *sra, unsigned long ms)
 {
 	unsigned long sec;

commit 7e7fffc4022114c491587755998395ef4766fcc2
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun Apr 12 00:58:28 2009 -0700

    mdmon: fix resync completion detection
    
    Starting with 2.6.30 the md/resync_start attribute will no longer return
    a non-sensical number when resync is complete, instead it now returns
    'none'.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/monitor.c b/monitor.c
index 62261d9..3388d31 100644
--- a/monitor.c
+++ b/monitor.c
@@ -74,8 +74,10 @@ int get_resync_start(struct active_array *a)
 	n = read_attr(buf, 30, a->resync_start_fd);
 	if (n <= 0)
 		return n;
-
-	a->resync_start = strtoull(buf, NULL, 10);
+	if (strncmp(buf, "none", 4) == 0)
+		a->resync_start = ~0ULL;
+	else
+		a->resync_start = strtoull(buf, NULL, 10);
 
 	return 1;
 }


