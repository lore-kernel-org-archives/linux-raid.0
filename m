From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 1/7] Show device as cache in --detail
Date: Wed, 13 May 2015 23:43:50 -0700
Message-ID: <1431585836-4103033-2-git-send-email-songliubraving@fb.com>
References: <1431585836-4103033-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1431585836-4103033-1-git-send-email-songliubraving@fb.com>
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

       4       8       17        -      cache   /dev/sdb1

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Detail.c | 3 ++-
 md_p.h   | 2 ++
 super1.c | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Detail.c b/Detail.c
index dd72ede..c93a962 100644
--- a/Detail.c
+++ b/Detail.c
@@ -650,9 +650,10 @@ This is pretty boring
 			}
 			if (disk.state & (1<<MD_DISK_REMOVED)) printf(" removed");
 			if (disk.state & (1<<MD_DISK_WRITEMOSTLY)) printf(" writemostly");
+			if (disk.state & (1<<MD_DISK_WRITECACHE)) printf(" cache");
 			if ((disk.state &
 			     ((1<<MD_DISK_ACTIVE)|(1<<MD_DISK_SYNC)
-			      |(1<<MD_DISK_REMOVED)|(1<<MD_DISK_FAULTY)))
+			      |(1<<MD_DISK_REMOVED)|(1<<MD_DISK_FAULTY)|(1<<MD_DISK_WRITECACHE)))
 			    == 0) {
 				printf(" spare");
 				if (is_26) {
diff --git a/md_p.h b/md_p.h
index c4846ba..f45c4e0 100644
--- a/md_p.h
+++ b/md_p.h
@@ -85,6 +85,8 @@
 				   */
 
 #define MD_DISK_REPLACEMENT	17
+#define MD_DISK_WRITECACHE      18 /* disk is used as the write cache in RAID-5/6 */
+
 
 typedef struct mdp_device_descriptor_s {
 	__u32 number;		/* 0 Device number in the entire set	      */
diff --git a/super1.c b/super1.c
index f0508fe..7af0fd5 100644
--- a/super1.c
+++ b/super1.c
@@ -465,6 +465,8 @@ static void examine_super1(struct supertype *st, char *homehost)
 		role = 0xFFFF;
 	if (role >= 0xFFFE)
 		printf("spare\n");
+	else if (role == 0xFFFD)
+		printf("cache\n");
 	else if (sb->feature_map & __cpu_to_le32(MD_FEATURE_REPLACEMENT))
 		printf("Replacement device %d\n", role);
 	else
-- 
1.8.1

