From: Michal Zylowski <michal.zylowski@intel.com>
Subject: [PATCH] imsm: More precise message when spanned raid is created
Date: Wed,  8 Nov 2017 15:43:41 +0100
Message-ID: <1510152221-32116-1-git-send-email-michal.zylowski@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, Michal Zylowski <michal.zylowski@intel.com>
List-Id: linux-raid.ids

When RAID is created between VMD and SATA disks, printed message is
"Mixing devices attached to different VMD domains is not allowed". This message
is unclear and misleading because creating spanned containers between different
VMD domains is allowed. Set error message to more precise text.

Signed-off-by: Michal Zylowski <michal.zylowski@intel.com>
---
 super-intel.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index b561fe2..2f912f2 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4500,8 +4500,7 @@ static int find_intel_hba_capability(int fd, struct intel_super *super, char *de
 				hba = hba->next;
 			}
 			fprintf(stderr, ").\n"
-				"    Mixing devices attached to different %s is not allowed.\n",
-				hba_name->type == SYS_DEV_VMD ? "VMD domains" : "controllers");
+				"    Mixing devices attached to different controllers is not allowed.\n");
 		}
 		return 2;
 	}
-- 
2.7.4

