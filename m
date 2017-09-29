From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH 2/2] raid5-ppl: check recovery_offset when performing ppl recovery
Date: Fri, 29 Sep 2017 22:54:19 +0200
Message-ID: <20170929205419.16715-3-artur.paszkiewicz@intel.com>
References: <20170929205419.16715-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170929205419.16715-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

If starting an array that is undergoing rebuild, make ppl recovery honor
the recovery_offset of a member disk and don't read data that is not yet
in-sync.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/md/raid5-ppl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 2c6513777f68..c3e1899d5986 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -758,7 +758,8 @@ static int ppl_recover_entry(struct ppl_log *log, struct ppl_header_entry *e,
 				 (unsigned long long)sector);
 
 			rdev = conf->disks[dd_idx].rdev;
-			if (!rdev) {
+			if (!rdev || (!test_bit(In_sync, &rdev->flags) &&
+				      sector >= rdev->recovery_offset)) {
 				pr_debug("%s:%*s data member disk %d missing\n",
 					 __func__, indent, "", dd_idx);
 				update_parity = false;
-- 
2.14.1

