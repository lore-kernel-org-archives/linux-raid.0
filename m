From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 7/7] Add information about write-cache superblock to --examine
Date: Wed, 13 May 2015 23:43:56 -0700
Message-ID: <1431585836-4103033-8-git-send-email-songliubraving@fb.com>
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

./mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 261d25c2:7264d13e:670f0307:71441559
           Name : 0
  Creation Time : Wed May 13 11:04:07 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 706560 (345.00 MiB 361.76 MB)
     Array Size : 11720662464 (11177.69 GiB 12001.96 GB)
  Used Dev Size : 7813774976 (3725.90 GiB 4000.65 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=18446744065896483200 sectors
          State : clean
    Device UUID : f89a0182:10bc963c:3e6a2735:16d306fa

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed May 13 11:54:37 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 74417070 - correct
         Events : 2

         Layout : left-symmetric
     Chunk Size : 32K

   Device Role : cache
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

Write Cache Info:
             Magic : 6433c509
Superblock Version : 1
 Stripe Cache Size : 4096
        Block Size : 8 sectors
  Stripe Data Size : 192 sectors
        Chunk Size : 64 sectors
       Stripe Size : 256 sectors
      Total Blocks : 88319 blocks
       First Block : 1
   Last Checkpoint : 58641
       Update Time : Wed May 13 11:54:37 2015

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 Examine.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/Examine.c b/Examine.c
index 953b8ee..f6086a5 100644
--- a/Examine.c
+++ b/Examine.c
@@ -141,7 +141,8 @@ int Examine(struct mddev_dev *devlist,
 			} else
 				st->ss->getinfo_super(st, &ap->info, NULL);
 			if (!have_container &&
-			    !(ap->info.disk.state & (1<<MD_DISK_SYNC)))
+			    !(ap->info.disk.state & (1<<MD_DISK_SYNC)) &&
+			    !(ap->info.disk.state & (1<<MD_DISK_WRITECACHE)))
 				ap->spares++;
 			d = dl_strdup(devlist->devname);
 			dl_add(ap->devs, d);
@@ -152,6 +153,9 @@ int Examine(struct mddev_dev *devlist,
 		} else {
 			printf("%s:\n",devlist->devname);
 			st->ss->examine_super(st, c->homehost);
+			if (st->r5l_sb) {
+				ExamineR5LSuper(st->r5l_sb);
+			}
 			st->ss->free_super(st);
 		}
 	}
@@ -223,3 +227,26 @@ out:
 	}
 	return err;
 }
+
+int ExamineR5LSuper(struct r5l_super_block *sb_blk)
+{
+	time_t atime;
+
+	if (sb_blk == NULL)
+		return 1;
+	printf("\n\nWrite Cache Info:\n");
+	printf("             Magic : %08x\n", __le32_to_cpu(sb_blk->header.magic));
+	printf("Superblock Version : %d\n", sb_blk->version);
+	printf(" Stripe Cache Size : %d\n", sb_blk->stripe_cache_size);
+	printf("        Block Size : %d sectors\n", sb_blk->block_size >> 9);
+	printf("  Stripe Data Size : %d sectors\n", sb_blk->stripe_data_size >> 9);
+	printf("        Chunk Size : %d sectors\n", sb_blk->chunk_size >> 9);
+	printf("       Stripe Size : %d sectors\n", sb_blk->stripe_size >> 9);
+	printf("      Total Blocks : %lld blocks\n", sb_blk->total_blocks);
+	printf("   Last Checkpoint : %lld\n", sb_blk->last_checkpoint);
+
+	atime = __le64_to_cpu(sb_blk->update_time_sec) & 0xFFFFFFFFFFULL;
+	printf("       Update Time : %.24s\n", ctime(&atime));
+
+	return 0;
+}
-- 
1.8.1

