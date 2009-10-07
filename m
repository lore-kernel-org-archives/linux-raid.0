From: Joe Perches <joe@perches.com>
Subject: [PATCH 4/8] drivers/md/md.c: Use %pU to print UUIDs
Date: Tue,  6 Oct 2009 21:45:37 -0700
Message-ID: <47d15eff89a462386ad2899489552d92f96d1ee6.1254884776.git.joe@perches.com>
References: <1254890742-28245-1-git-send-email-joe@perches.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1254890742-28245-1-git-send-email-joe@perches.com>
In-Reply-To: <cover.1254884776.git.joe@perches.com>
References: <cover.1254884776.git.joe@perches.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/md/md.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 26ba42a..68b52d7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1813,15 +1813,11 @@ static void print_sb_1(struct mdp_superblock_1 *sb)
 
 	uuid = sb->set_uuid;
 	printk(KERN_INFO
-	       "md:  SB: (V:%u) (F:0x%08x) Array-ID:<%02x%02x%02x%02x"
-	       ":%02x%02x:%02x%02x:%02x%02x:%02x%02x%02x%02x%02x%02x>\n"
+	       "md:  SB: (V:%u) (F:0x%08x) Array-ID:<%pU>\n"
 	       "md:    Name: \"%s\" CT:%llu\n",
 		le32_to_cpu(sb->major_version),
 		le32_to_cpu(sb->feature_map),
-		uuid[0], uuid[1], uuid[2], uuid[3],
-		uuid[4], uuid[5], uuid[6], uuid[7],
-		uuid[8], uuid[9], uuid[10], uuid[11],
-		uuid[12], uuid[13], uuid[14], uuid[15],
+		uuid,
 		sb->set_name,
 		(unsigned long long)le64_to_cpu(sb->ctime)
 		       & MD_SUPERBLOCK_1_TIME_SEC_MASK);
@@ -1830,8 +1826,7 @@ static void print_sb_1(struct mdp_superblock_1 *sb)
 	printk(KERN_INFO
 	       "md:       L%u SZ%llu RD:%u LO:%u CS:%u DO:%llu DS:%llu SO:%llu"
 			" RO:%llu\n"
-	       "md:     Dev:%08x UUID: %02x%02x%02x%02x:%02x%02x:%02x%02x:%02x%02x"
-	                ":%02x%02x%02x%02x%02x%02x\n"
+	       "md:     Dev:%08x UUID: %pU\n"
 	       "md:       (F:0x%08x) UT:%llu Events:%llu ResyncOffset:%llu CSUM:0x%08x\n"
 	       "md:         (MaxDev:%u) \n",
 		le32_to_cpu(sb->level),
@@ -1844,10 +1839,7 @@ static void print_sb_1(struct mdp_superblock_1 *sb)
 		(unsigned long long)le64_to_cpu(sb->super_offset),
 		(unsigned long long)le64_to_cpu(sb->recovery_offset),
 		le32_to_cpu(sb->dev_number),
-		uuid[0], uuid[1], uuid[2], uuid[3],
-		uuid[4], uuid[5], uuid[6], uuid[7],
-		uuid[8], uuid[9], uuid[10], uuid[11],
-		uuid[12], uuid[13], uuid[14], uuid[15],
+		uuid,
 		sb->devflags,
 		(unsigned long long)le64_to_cpu(sb->utime) & MD_SUPERBLOCK_1_TIME_SEC_MASK,
 		(unsigned long long)le64_to_cpu(sb->events),
-- 
1.6.3.1.10.g659a0.dirty

