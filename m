From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/6] Show device as journal in --detail --examine
Date: Fri, 28 Aug 2015 16:27:02 -0700
Message-ID: <1440804426-1461372-3-git-send-email-songliubraving@fb.com>
References: <1440804426-1461372-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1440804426-1461372-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, dan.j.williams@intel.com, neilb@suse.de, hch@infradead.org, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Example output:

./mdadm --detail /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Wed May 13 17:01:12 2015
     Raid Level : raid5
     Array Size : 11720662464 (11177.69 GiB 12001.96 GB)
  Used Dev Size : 3906887488 (3725.90 GiB 4000.65 GB)
   Raid Devices : 4
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed May 13 17:01:12 2015
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 32K

           Name : 0
           UUID : 8fb9ee05:3831d52f:e5c23825:28cd6881
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sdc
       1       8       48        1      active sync   /dev/sdd
       2       8       64        2      active sync   /dev/sde
       3       8       80        3      active sync   /dev/sdf

       4       8       17        -      journal   /dev/sdb1

./mdadm -E /dev/sdb2
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x201
     Array UUID : 562b2334:35b9bcc1:add50892:1f30c4bd
           Name : 0
  Creation Time : Thu Aug 27 12:55:26 2015
     Raid Level : raid5
   Raid Devices : 15

 Avail Dev Size : 249796608 (119.11 GiB 127.90 GB)
     Array Size : 54696423936 (52162.57 GiB 56009.14 GB)
  Used Dev Size : 7813774848 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : active
    Device UUID : 5015e522:d39ba566:5909cf3c:9c51f2ff

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Aug 27 13:16:55 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 4e6fd76d - correct
         Events : 262

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Journal
   Array State : AAAAAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

Signed-off-by: Shaohua Li <shli@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Detail.c |  3 ++-
 md_p.h   |  2 ++
 super1.c | 18 ++++++++++++++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Detail.c b/Detail.c
index dd72ede..200f65f 100644
--- a/Detail.c
+++ b/Detail.c
@@ -650,9 +650,10 @@ This is pretty boring
 			}
 			if (disk.state & (1<<MD_DISK_REMOVED)) printf(" removed");
 			if (disk.state & (1<<MD_DISK_WRITEMOSTLY)) printf(" writemostly");
+			if (disk.state & (1<<MD_DISK_JOURNAL)) printf(" journal");
 			if ((disk.state &
 			     ((1<<MD_DISK_ACTIVE)|(1<<MD_DISK_SYNC)
-			      |(1<<MD_DISK_REMOVED)|(1<<MD_DISK_FAULTY)))
+			      |(1<<MD_DISK_REMOVED)|(1<<MD_DISK_FAULTY)|(1<<MD_DISK_JOURNAL)))
 			    == 0) {
 				printf(" spare");
 				if (is_26) {
diff --git a/md_p.h b/md_p.h
index 3a3b8af..fae73ba 100644
--- a/md_p.h
+++ b/md_p.h
@@ -91,9 +91,11 @@
 				   */
 
 #define MD_DISK_REPLACEMENT	17
+#define MD_DISK_JOURNAL		18 /* disk is used as the write journal in RAID-5/6 */
 
 #define MD_DISK_ROLE_SPARE	0xffff
 #define MD_DISK_ROLE_FAULTY	0xfffe
+#define MD_DISK_ROLE_JOURNAL	0xfffd
 #define MD_DISK_ROLE_MAX	0xff00 /* max value of regular disk role */
 
 typedef struct mdp_device_descriptor_s {
diff --git a/super1.c b/super1.c
index 981b308..4558783 100644
--- a/super1.c
+++ b/super1.c
@@ -125,6 +125,7 @@ struct misc_dev_info {
 					    * backwards anyway.
 					    */
 #define	MD_FEATURE_NEW_OFFSET		64 /* new_offset must be honoured */
+#define	MD_FEATURE_JOURNAL		512 /* support write journal */
 #define	MD_FEATURE_ALL			(MD_FEATURE_BITMAP_OFFSET	\
 					|MD_FEATURE_RECOVERY_OFFSET	\
 					|MD_FEATURE_RESHAPE_ACTIVE	\
@@ -132,6 +133,7 @@ struct misc_dev_info {
 					|MD_FEATURE_REPLACEMENT		\
 					|MD_FEATURE_RESHAPE_BACKWARDS	\
 					|MD_FEATURE_NEW_OFFSET		\
+					|MD_FEATURE_JOURNAL		\
 					)
 
 /* return how many bytes are needed for bitmap, for cluster-md each node
@@ -482,6 +484,8 @@ static void examine_super1(struct supertype *st, char *homehost)
 		role = MD_DISK_ROLE_SPARE;
 	if (role >= MD_DISK_ROLE_FAULTY)
 		printf("spare\n");
+	else if (role == MD_DISK_ROLE_JOURNAL)
+		printf("Journal\n");
 	else if (sb->feature_map & __cpu_to_le32(MD_FEATURE_REPLACEMENT))
 		printf("Replacement device %d\n", role);
 	else
@@ -993,6 +997,11 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 	case MD_DISK_ROLE_FAULTY:
 		info->disk.state = 1; /* faulty */
 		break;
+	case MD_DISK_ROLE_JOURNAL:
+		info->disk.state = (1 << MD_DISK_JOURNAL);
+		info->disk.raid_disk = role;
+		info->space_after = (misc->device_size - info->data_offset) % 8; /* journal uses all 4kB blocks*/
+		break;
 	default:
 		info->disk.state = 6; /* active and in sync */
 		info->disk.raid_disk = role;
@@ -1112,6 +1121,8 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		int want;
 		if (info->disk.state & (1<<MD_DISK_ACTIVE))
 			want = info->disk.raid_disk;
+		else if (info->disk.state & (1<<MD_DISK_JOURNAL))
+			want = MD_DISK_ROLE_JOURNAL;
 		else
 			want = MD_DISK_ROLE_SPARE;
 		if (sb->dev_roles[d] != __cpu_to_le16(want)) {
@@ -1438,6 +1449,8 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 		*rp = __cpu_to_le16(dk->raid_disk);
 	else if ((dk->state & ~2) == 0) /* active or idle -> spare */
 		*rp = MD_DISK_ROLE_SPARE;
+	else if (dk->state & (1<<MD_DISK_JOURNAL))
+		*rp = MD_DISK_ROLE_JOURNAL;
 	else
 		*rp = MD_DISK_ROLE_FAULTY;
 
@@ -1569,6 +1582,11 @@ static int write_init_super1(struct supertype *st)
 	unsigned long long data_offset;
 
 	for (di = st->info; di; di = di->next) {
+		if (di->disk.state & (1 << MD_DISK_JOURNAL))
+			sb->feature_map |= MD_FEATURE_JOURNAL;
+	}
+
+	for (di = st->info; di; di = di->next) {
 		if (di->disk.state & (1 << MD_DISK_FAULTY))
 			continue;
 		if (di->fd < 0)
-- 
1.8.1

