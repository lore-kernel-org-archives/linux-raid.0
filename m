From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/7] Enable create array with write cache (--write-cache DEVICE).
Date: Wed, 13 May 2015 23:43:51 -0700
Message-ID: <1431585836-4103033-3-git-send-email-songliubraving@fb.com>
References: <1431585836-4103033-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1431585836-4103033-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, dan.j.williams@intel.com, neilb@suse.de, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Specify the write cache device with --write-cache DEVICE

./mdadm --create -f /dev/md0 --assume-clean -c 32 --raid-devices=4 --level=5 /dev/sd[c-f] --write-cache /dev/sdb1
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

Only one cache device is allowed. If multiple --write-cache
are given, mdadm will use the first and ignore others

./mdadm --create -f /dev/md0 --assume-clean -c 32 --raid-devices=4 --level=5 /dev/sd[c-f] --write-cache /dev/sdb1 --write-cache /dev/sdx
mdadm: Please specify only one cache device for the array.
mdadm: Ignoring --write-cache /dev/sdx...
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Create.c | 21 +++++++++++++++------
 ReadMe.c |  1 +
 mdadm.c  | 19 +++++++++++++++++++
 mdadm.h  |  2 ++
 super1.c |  8 ++++++++
 5 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/Create.c b/Create.c
index ef28da0..0d2a591 100644
--- a/Create.c
+++ b/Create.c
@@ -87,7 +87,7 @@ int Create(struct supertype *st, char *mddev,
 	unsigned long long minsize=0, maxsize=0;
 	char *mindisc = NULL;
 	char *maxdisc = NULL;
-	int dnum;
+	int dnum, raid_disk_num;
 	struct mddev_dev *dv;
 	int fail=0, warn=0;
 	struct stat stb;
@@ -180,11 +180,11 @@ int Create(struct supertype *st, char *mddev,
 		pr_err("This metadata type does not support spare disks at create time\n");
 		return 1;
 	}
-	if (subdevs > s->raiddisks+s->sparedisks) {
+	if (subdevs > s->raiddisks+s->sparedisks+s->cachedisks) {
 		pr_err("You have listed more devices (%d) than are in the array(%d)!\n", subdevs, s->raiddisks+s->sparedisks);
 		return 1;
 	}
-	if (!have_container && subdevs < s->raiddisks+s->sparedisks) {
+	if (!have_container && subdevs < s->raiddisks+s->sparedisks+s->cachedisks) {
 		pr_err("You haven't given enough devices (real or missing) to create this array\n");
 		return 1;
 	}
@@ -397,6 +397,9 @@ int Create(struct supertype *st, char *mddev,
 			}
 		}
 
+		if (dv->disposition == 'c')
+			continue;  /* skip write cache for size check */
+
 		freesize /= 2; /* convert to K */
 		if (s->chunk && s->chunk != UnSet) {
 			/* round to chunk size */
@@ -834,7 +837,7 @@ int Create(struct supertype *st, char *mddev,
 	for (pass=1; pass <=2 ; pass++) {
 		struct mddev_dev *moved_disk = NULL; /* the disk that was moved out of the insert point */
 
-		for (dnum=0, dv = devlist ; dv ;
+		for (dnum=0, raid_disk_num=0, dv = devlist ; dv ;
 		     dv=(dv->next)?(dv->next):moved_disk, dnum++) {
 			int fd;
 			struct stat stb;
@@ -859,8 +862,13 @@ int Create(struct supertype *st, char *mddev,
 				*inf = info;
 
 				inf->disk.number = dnum;
-				inf->disk.raid_disk = dnum;
-				if (inf->disk.raid_disk < s->raiddisks)
+				inf->disk.raid_disk = raid_disk_num++;
+
+				if (dv->disposition == 'c') {
+					inf->disk.raid_disk = 0xfffd;
+					inf->disk.state = (1<<MD_DISK_WRITECACHE);
+					raid_disk_num--;
+				} else if (inf->disk.raid_disk < s->raiddisks)
 					inf->disk.state = (1<<MD_DISK_ACTIVE) |
 						(1<<MD_DISK_SYNC);
 				else
@@ -909,6 +917,7 @@ int Create(struct supertype *st, char *mddev,
 					inf->disk.major = major(stb.st_rdev);
 					inf->disk.minor = minor(stb.st_rdev);
 				}
+
 				break;
 			case 2:
 				inf->errors = 0;
diff --git a/ReadMe.c b/ReadMe.c
index 87a4916..74f7162 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -140,6 +140,7 @@ struct option long_options[] = {
     {"homehost",  1, 0,  HomeHost},
     {"symlinks",  1, 0,  Symlinks},
     {"data-offset",1, 0, DataOffset},
+    {"write-cache",1, 0, WriteCache},
 
     /* For assemble */
     {"uuid",      1, 0, 'u'},
diff --git a/mdadm.c b/mdadm.c
index 3e8c49b..9a7048b 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -74,6 +74,7 @@ int main(int argc, char *argv[])
 		.require_homehost = 1,
 	};
 	struct shape s = {
+		.cachedisks	= 0,
 		.level		= UnSet,
 		.layout		= UnSet,
 		.bitmap_chunk	= UnSet,
@@ -1137,6 +1138,24 @@ int main(int argc, char *argv[])
 		case O(INCREMENTAL, IncrementalPath):
 			remove_path = optarg;
 			continue;
+		case O(CREATE, WriteCache):
+			if (s.cachedisks) {
+				pr_err("Please specify only one cache device for the array.\n");
+				pr_err("Ignoring --write-cache %s...\n", optarg);
+				continue;
+			}
+			dv = xmalloc(sizeof(*dv));
+			dv->devname = optarg;
+			dv->disposition = 'c';  /* WriteCache */
+			dv->writemostly = writemostly;
+			dv->used = 0;
+			dv->next = NULL;
+			*devlistend = dv;
+			devlistend = &dv->next;
+			devs_found++;
+
+			s.cachedisks = 1;
+			continue;
 		}
 		/* We have now processed all the valid options. Anything else is
 		 * an error
diff --git a/mdadm.h b/mdadm.h
index 141f963..d28caa0 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -344,6 +344,7 @@ enum special_options {
 	Dump,
 	Restore,
 	Action,
+	WriteCache,
 };
 
 enum prefix_standard {
@@ -423,6 +424,7 @@ struct context {
 struct shape {
 	int	raiddisks;
 	int	sparedisks;
+	int	cachedisks;
 	int	level;
 	int	layout;
 	char	*layout_str;
diff --git a/super1.c b/super1.c
index 7af0fd5..f8a55c6 100644
--- a/super1.c
+++ b/super1.c
@@ -977,6 +977,10 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 	case 0xFFFE:
 		info->disk.state = 1; /* faulty */
 		break;
+	case 0xFFFD:
+		info->disk.state = (1 << MD_DISK_WRITECACHE); /* faulty */
+		info->disk.raid_disk = role;
+		break;
 	default:
 		info->disk.state = 6; /* active and in sync */
 		info->disk.raid_disk = role;
@@ -1096,6 +1100,8 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		int want;
 		if (info->disk.state & (1<<MD_DISK_ACTIVE))
 			want = info->disk.raid_disk;
+		else if (info->disk.state & (1<<MD_DISK_WRITECACHE))
+			want = 0xFFFD;
 		else
 			want = 0xFFFF;
 		if (sb->dev_roles[d] != __cpu_to_le16(want)) {
@@ -1422,6 +1428,8 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 		*rp = __cpu_to_le16(dk->raid_disk);
 	else if ((dk->state & ~2) == 0) /* active or idle -> spare */
 		*rp = 0xffff;
+	else if (dk->state & (1<<MD_DISK_WRITECACHE))
+		*rp = 0xfffd;
 	else
 		*rp = 0xfffe;
 
-- 
1.8.1

