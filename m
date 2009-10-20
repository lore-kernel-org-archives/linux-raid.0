From: Dan Williams <dan.j.williams@intel.com>
Subject: [md PATCH 1/4] md/raid6: kill a gcc-4.0.1 'uninitialized variable'
	warning
Date: Tue, 20 Oct 2009 00:11:23 -0700
Message-ID: <20091020071123.6489.51053.stgit@dwillia2-linux.ch.intel.com>
References: <20091020070627.6489.4006.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091020070627.6489.4006.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/raid5.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dcd9e65..81abefc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -156,16 +156,16 @@ static inline int raid6_next_disk(int disk, int raid_disks)
 static int raid6_idx_to_slot(int idx, struct stripe_head *sh,
 			     int *count, int syndrome_disks)
 {
-	int slot;
+	int slot = *count;
 
 	if (sh->ddf_layout)
-		slot = (*count)++;
+		(*count)++;
 	if (idx == sh->pd_idx)
 		return syndrome_disks;
 	if (idx == sh->qd_idx)
 		return syndrome_disks + 1;
 	if (!sh->ddf_layout)
-		slot = (*count)++;
+		(*count)++;
 	return slot;
 }
 

