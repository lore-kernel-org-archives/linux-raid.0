From: Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 1/6] add macros for MD_DISK_ROLE_(SPARE/FAULTY)
Date: Thu, 8 Oct 2015 22:51:41 -0700
Message-ID: <1444369906-1804157-2-git-send-email-songliubraving@fb.com>
References: <1444369906-1804157-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1444369906-1804157-1-git-send-email-songliubraving@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, shli@fb.com, hch@infradead.org, dan.j.williams@intel.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

Replace special disk roles (0xffff, 0xfffe) with macros:

define MD_DISK_ROLE_SPARE      0xffff
define MD_DISK_ROLE_FAULTY     0xfffe

Will add macro for journal device in next patch:
define MD_DISK_ROLE_JOURNAL    0xfffd

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 md_p.h   |  4 ++++
 super1.c | 30 +++++++++++++++---------------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/md_p.h b/md_p.h
index 9b6b5f8..3a3b8af 100644
--- a/md_p.h
+++ b/md_p.h
@@ -92,6 +92,10 @@
 
 #define MD_DISK_REPLACEMENT	17
 
+#define MD_DISK_ROLE_SPARE	0xffff
+#define MD_DISK_ROLE_FAULTY	0xfffe
+#define MD_DISK_ROLE_MAX	0xff00 /* max value of regular disk role */
+
 typedef struct mdp_device_descriptor_s {
 	__u32 number;		/* 0 Device number in the entire set	      */
 	__u32 major;		/* 1 Device major number		      */
diff --git a/super1.c b/super1.c
index 6f42291..b881eb5 100644
--- a/super1.c
+++ b/super1.c
@@ -465,13 +465,13 @@ static void examine_super1(struct supertype *st, char *homehost)
 	/* This turns out to just be confusing */
 	printf("    Array Slot : %d (", __le32_to_cpu(sb->dev_number));
 	for (i= __le32_to_cpu(sb->max_dev); i> 0 ; i--)
-		if (__le16_to_cpu(sb->dev_roles[i-1]) != 0xffff)
+		if (__le16_to_cpu(sb->dev_roles[i-1]) != MD_DISK_ROLE_SPARE)
 			break;
 	for (d=0; d < i; d++) {
 		int role = __le16_to_cpu(sb->dev_roles[d]);
 		if (d) printf(", ");
-		if (role == 0xffff) printf("empty");
-		else if(role == 0xfffe) printf("failed");
+		if (role == MD_DISK_ROLE_SPARE) printf("empty");
+		else if(role == MD_DISK_ROLE_FAULTY) printf("failed");
 		else printf("%d", role);
 	}
 	printf(")\n");
@@ -481,8 +481,8 @@ static void examine_super1(struct supertype *st, char *homehost)
 	if (d < __le32_to_cpu(sb->max_dev))
 		role = __le16_to_cpu(sb->dev_roles[d]);
 	else
-		role = 0xFFFF;
-	if (role >= 0xFFFE)
+		role = MD_DISK_ROLE_SPARE;
+	if (role >= MD_DISK_ROLE_FAULTY)
 		printf("spare\n");
 	else if (sb->feature_map & __cpu_to_le32(MD_FEATURE_REPLACEMENT))
 		printf("Replacement device %d\n", role);
@@ -512,7 +512,7 @@ static void examine_super1(struct supertype *st, char *homehost)
 	faulty = 0;
 	for (i=0; i< __le32_to_cpu(sb->max_dev); i++) {
 		int role = __le16_to_cpu(sb->dev_roles[i]);
-		if (role == 0xFFFE)
+		if (role == MD_DISK_ROLE_FAULTY)
 			faulty++;
 	}
 	if (faulty) printf(" %d failed", faulty);
@@ -922,7 +922,7 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 	info->disk.number = __le32_to_cpu(sb->dev_number);
 	if (__le32_to_cpu(sb->dev_number) >= __le32_to_cpu(sb->max_dev) ||
 	    __le32_to_cpu(sb->dev_number) >= MAX_DEVS)
-		role = 0xfffe;
+		role = MD_DISK_ROLE_FAULTY;
 	else
 		role = __le16_to_cpu(sb->dev_roles[__le32_to_cpu(sb->dev_number)]);
 
@@ -989,10 +989,10 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 
 	info->disk.raid_disk = -1;
 	switch(role) {
-	case 0xFFFF:
+	case MD_DISK_ROLE_SPARE:
 		info->disk.state = 0; /* spare: not active, not sync, not faulty */
 		break;
-	case 0xFFFE:
+	case MD_DISK_ROLE_FAULTY:
 		info->disk.state = 1; /* faulty */
 		break;
 	default:
@@ -1042,7 +1042,7 @@ static void getinfo_super1(struct supertype *st, struct mdinfo *info, char *map)
 			map[i] = 0;
 	for (i = 0; i < __le32_to_cpu(sb->max_dev); i++) {
 		role = __le16_to_cpu(sb->dev_roles[i]);
-		if (/*role == 0xFFFF || */role < (unsigned) info->array.raid_disks) {
+		if (/*role == MD_DISK_ROLE_SPARE || */role < (unsigned) info->array.raid_disks) {
 			working++;
 			if (map && role < map_disks)
 				map[role] = 1;
@@ -1115,7 +1115,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		if (info->disk.state & (1<<MD_DISK_ACTIVE))
 			want = info->disk.raid_disk;
 		else
-			want = 0xFFFF;
+			want = MD_DISK_ROLE_SPARE;
 		if (sb->dev_roles[d] != __cpu_to_le16(want)) {
 			sb->dev_roles[d] = __cpu_to_le16(want);
 			rv = 1;
@@ -1140,7 +1140,7 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 		unsigned int max = __le32_to_cpu(sb->max_dev);
 
 		for (i=0 ; i < max ; i++)
-			if (__le16_to_cpu(sb->dev_roles[i]) >= 0xfffe)
+			if (__le16_to_cpu(sb->dev_roles[i]) >= MD_DISK_ROLE_FAULTY)
 				break;
 		sb->dev_number = __cpu_to_le32(i);
 		info->disk.number = i;
@@ -1439,9 +1439,9 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
 	if ((dk->state & 6) == 6) /* active, sync */
 		*rp = __cpu_to_le16(dk->raid_disk);
 	else if ((dk->state & ~2) == 0) /* active or idle -> spare */
-		*rp = 0xffff;
+		*rp = MD_DISK_ROLE_SPARE;
 	else
-		*rp = 0xfffe;
+		*rp = MD_DISK_ROLE_FAULTY;
 
 	if (dk->number >= (int)__le32_to_cpu(sb->max_dev) &&
 	    __le32_to_cpu(sb->max_dev) < MAX_DEVS)
@@ -2445,7 +2445,7 @@ void *super1_make_v0(struct supertype *st, struct mdinfo *info, mdp_super_t *sb0
 
 	for (i = 0; i < MD_SB_DISKS; i++) {
 		int state = sb0->disks[i].state;
-		sb->dev_roles[i] = 0xFFFF;
+		sb->dev_roles[i] = MD_DISK_ROLE_SPARE;
 		if ((state & (1<<MD_DISK_SYNC)) &&
 		    !(state & (1<<MD_DISK_FAULTY)))
 			sb->dev_roles[i] = __cpu_to_le16(sb0->disks[i].raid_disk);
-- 
2.4.6

