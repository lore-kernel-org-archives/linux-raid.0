From: Pawel Baldysiak <pawel.baldysiak@intel.com>
Subject: [PATCH 10/12] imsm: always do ppl recovery when starting a rebuilding array
Date: Thu, 28 Sep 2017 14:41:16 +0200
Message-ID: <20170928124118.23361-11-pawel.baldysiak@intel.com>
References: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170928124118.23361-1-pawel.baldysiak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Set resync_start to 0 when starting a rebuilding array to make the
kernel perform ppl recovery before the rebuild.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 super-intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/super-intel.c b/super-intel.c
index 2e8eb0d4..56c60423 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7756,6 +7756,9 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
 						map->blocks_per_strip;
 				info_d->ppl_sector = this->ppl_sector;
 				info_d->ppl_size = this->ppl_size;
+				if (this->consistency_policy == CONSISTENCY_POLICY_PPL &&
+				    recovery_start == 0)
+					this->resync_start = 0;
 			} else {
 				info_d->component_size = blocks_per_member(map);
 			}
-- 
2.13.5

