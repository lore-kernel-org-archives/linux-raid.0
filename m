From: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Subject: [PATCH 6/6] Add MD_ARRAY_SIZE for --examine --export
Date: Wed, 26 Sep 2012 13:44:22 +0200
Message-ID: <20120926114422.328.64275.stgit@gklab-128-174.igk.intel.com>
References: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120926114202.328.71156.stgit@gklab-128-174.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

An additional pair of key=value for --examine --export.

Signed-off-by: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
---
 super1.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/super1.c b/super1.c
index b04945f..0df5bee 100644
--- a/super1.c
+++ b/super1.c
@@ -495,6 +495,7 @@ static void export_examine_super1(struct supertype *st)
 	struct mdp_superblock_1 *sb = st->sb;
 	int i;
 	int len = 32;
+	int layout;
 
 	printf("MD_LEVEL=%s\n", map_num(pers, __le32_to_cpu(sb->level)));
 	printf("MD_DEVICES=%d\n", __le32_to_cpu(sb->raid_disks));
@@ -506,6 +507,24 @@ static void export_examine_super1(struct supertype *st)
 		}
 	if (len)
 		printf("MD_NAME=%.*s\n", len, sb->set_name);
+	if (__le32_to_cpu(sb->level) > 0) {
+		int ddsks = 0, ddsks_denom = 1;
+		switch(__le32_to_cpu(sb->level)) {
+			case 1: ddsks=1;break;
+			case 4:
+			case 5: ddsks = __le32_to_cpu(sb->raid_disks)-1; break;
+			case 6: ddsks = __le32_to_cpu(sb->raid_disks)-2; break;
+			case 10:
+				layout = __le32_to_cpu(sb->layout);
+				ddsks = __le32_to_cpu(sb->raid_disks);
+				ddsks_denom = (layout&255) * ((layout>>8)&255);
+			}
+		if (ddsks) {
+			long long asize = __le64_to_cpu(sb->size);
+			asize = (asize << 9) * ddsks / ddsks_denom;
+			printf("MD_ARRAY_SIZE=%s\n",human_size_brief(asize,JEDEC));
+		}
+	}
 	printf("MD_UUID=");
 	for (i=0; i<16; i++) {
 		if ((i&3)==0 && i != 0) printf(":");

