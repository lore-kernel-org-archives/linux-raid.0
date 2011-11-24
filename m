From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 03/11] imsm: FIX: Do not end migration when missing drive is
	handled
Date: Thu, 24 Nov 2011 13:17:34 +0100
Message-ID: <20111124121734.5254.7784.stgit@gklab-128-013.igk.intel.com>
References: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111124121516.5254.48774.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

Currently when degradation occurs migration is finalized. This is wrong.
Finalizing migration when it is not finished can lead to data corruption
after next array assembly.

Do not finish migration when degradation occurs.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5828922..7587c8c 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6113,17 +6113,12 @@ static void mark_missing(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
 
 static void handle_missing(struct intel_super *super, struct imsm_dev *dev)
 {
-	__u8 map_state;
 	struct dl *dl;
-	int failed;
 
 	if (!super->missing)
 		return;
-	failed = imsm_count_failed(super, dev);
-	map_state = imsm_check_degraded(super, dev, failed);
 
 	dprintf("imsm: mark missing\n");
-	end_migration(dev, map_state);
 	for (dl = super->missing; dl; dl = dl->next)
 		mark_missing(dev, &dl->disk, dl->index);
 	super->updates_pending++;

