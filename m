From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [BUG] raidtools-1.00.3 - BLKGETSIZE ioctl call wrong
Date: Thu, 8 Jan 2004 14:42:14 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401081442.14339.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_EEB6VCM0M8BZX5MZGQUK"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--------------Boundary-00=_EEB6VCM0M8BZX5MZGQUK
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

there is a bug in raidtools 1.00.3:
when issueing the BLKGETSIZE ioctl, the raidtools expect the return value
in a __u32 bit variable called nr_blocks. Since the BLKGETSIZE ioctl writ=
es
the result into an unsigned long, this doesn't fit on 64 bit architecture=
s and
therefore has some strange effects (at least on big endian machines). Ple=
ase
apply the attached patch.

Thanks,
Heiko

--------------Boundary-00=_EEB6VCM0M8BZX5MZGQUK
Content-Type: text/x-diff;
  charset="us-ascii";
  name="raid1.00.3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="raid1.00.3.diff"

--- raidtools-1.00.3/raid_io.c	2003-01-15 09:58:25.000000000 +0100
+++ raidtools-1.00.3-fix/raid_io.c	2004-01-08 14:34:20.136485704 +0100
@@ -363,7 +363,7 @@
 	md_raid_info_t *array;
 	mdu_disk_info_t *disk;
 	struct stat stat_buf;
-	__u32 nr_blocks;
+	unsigned long nr_blocks;
 
 	if (!cfg)
 		return 1;
@@ -454,14 +454,14 @@
 			}
 			nr_blocks >>= 1;
 			if (nr_blocks < MD_RESERVED_BLOCKS * 2) {
-				fprintf(stderr, "%s: device too small (%dkB)\n", cfg->device_name[i], nr_blocks);
+				fprintf(stderr, "%s: device too small (%ldkB)\n", cfg->device_name[i], nr_blocks);
 				close(fd);
 				return 1;
 			}
 
                 	cfg->sb_block_offset[i] = MD_NEW_SIZE_BLOCKS(nr_blocks);
 			if (!cfg->array.param.not_persistent) {
-                		printf("disk %d: %s, %ukB, raid superblock at %dkB\n", i, cfg->device_name[i], nr_blocks, cfg->sb_block_offset[i]);
+                		printf("disk %d: %s, %lukB, raid superblock at %dkB\n", i, cfg->device_name[i], nr_blocks, cfg->sb_block_offset[i]);
 	                	if (sanity_checks(cfg->device_name[i], fd,
 					 	cfg->sb_block_offset[i], forceSanity,
 					 	upgradeArray, cfg, 0)) {
@@ -495,7 +495,7 @@
 			}
 			nr_blocks >>= 1;
 			if (nr_blocks < MD_RESERVED_BLOCKS * 2) {
-				fprintf(stderr, "%s: device too small (%dkB)\n", cfg->device_name[i], nr_blocks);
+				fprintf(stderr, "%s: device too small (%ldkB)\n", cfg->device_name[i], nr_blocks);
 				close(fd);
 				return 1;
 			}

--------------Boundary-00=_EEB6VCM0M8BZX5MZGQUK--

