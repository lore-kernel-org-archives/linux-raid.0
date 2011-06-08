From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 08/21] imsm: FIX: Calculate backup location based on metadata
	information
Date: Wed, 08 Jun 2011 18:10:38 +0200
Message-ID: <20110608161038.24327.55588.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Use metadata information to calculate backup write offset.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index fea7a3a..0d46132 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7850,7 +7850,7 @@ int recover_backup_imsm(struct supertype *st, struct mdinfo *info)
 
 	write_offset = ((unsigned long long)
 			__le32_to_cpu(migr_rec->dest_1st_member_lba) +
-			info->data_offset) * 512;
+			__le32_to_cpu(map_dest->pba_of_lba0)) * 512;
 
 	unit_len = __le32_to_cpu(migr_rec->dest_depth_per_unit) * 512;
 	if (posix_memalign((void **)&buf, 512, unit_len) != 0)

