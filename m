From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 11/22] imsm: Add information about migration record to mdadm
	'-E' option
Date: Thu, 02 Jun 2011 16:49:42 +0200
Message-ID: <20110602144942.27355.43126.stgit@gklab-128-111.igk.intel.com>
References: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602144212.27355.3706.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

From: Adam Kwolek <adam.kwolek@intel.com>

Add ability to display information from migration record in examine
option.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index db2f2b9..c40c02a 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1035,6 +1035,57 @@ static void print_imsm_disk(struct imsm_super *mpb, int index, __u32 reserved)
 	       human_size(sz * 512));
 }
 
+static int is_gen_migration(struct imsm_dev *dev);
+
+void examine_migr_rec_imsm(struct intel_super *super)
+{
+	struct migr_record *migr_rec = super->migr_rec;
+	struct imsm_super *mpb = super->anchor;
+	int i;
+
+	for (i = 0; i < mpb->num_raid_devs; i++) {
+		struct imsm_dev *dev = __get_imsm_dev(mpb, i);
+		if (is_gen_migration(dev) == 0)
+				continue;
+
+		printf("\nMigration Record Information:");
+		if (super->disks->index > 1) {
+			printf(" Empty\n                              ");
+			printf("Examine one of first two disks in array\n");
+			break;
+		}
+		printf("\n                     Status : ");
+		if (__le32_to_cpu(migr_rec->rec_status) == UNIT_SRC_NORMAL)
+			printf("Normal\n");
+		else
+			printf("Contains Data\n");
+		printf("               Current Unit : %u\n",
+		       __le32_to_cpu(migr_rec->curr_migr_unit));
+		printf("                     Family : %u\n",
+		       __le32_to_cpu(migr_rec->family_num));
+		printf("                  Ascending : %u\n",
+		       __le32_to_cpu(migr_rec->ascending_migr));
+		printf("            Blocks Per Unit : %u\n",
+		       __le32_to_cpu(migr_rec->blocks_per_unit));
+		printf("       Dest. Depth Per Unit : %u\n",
+		       __le32_to_cpu(migr_rec->dest_depth_per_unit));
+		printf("        Checkpoint Area pba : %u\n",
+		       __le32_to_cpu(migr_rec->ckpt_area_pba));
+		printf("           First member lba : %u\n",
+		       __le32_to_cpu(migr_rec->dest_1st_member_lba));
+		printf("      Total Number of Units : %u\n",
+		       __le32_to_cpu(migr_rec->num_migr_units));
+		printf("             Size of volume : %u\n",
+		       __le32_to_cpu(migr_rec->post_migr_vol_cap));
+		printf("  Expansion space for LBA64 : %u\n",
+		       __le32_to_cpu(migr_rec->post_migr_vol_cap_hi));
+		printf("       Record was read from : %u\n",
+		       __le32_to_cpu(migr_rec->ckpt_read_disk_num));
+
+		break;
+	}
+}
+
 static void getinfo_super_imsm(struct supertype *st, struct mdinfo *info, char *map);
 
 static void examine_super_imsm(struct supertype *st, char *homehost)
@@ -1114,6 +1165,8 @@ static void examine_super_imsm(struct supertype *st, char *homehost)
 		printf("    Usable Size : %llu%s\n", (unsigned long long)sz,
 		       human_size(sz * 512));
 	}
+
+	examine_migr_rec_imsm(super);
 }
 
 static void brief_examine_super_imsm(struct supertype *st, int verbose)

