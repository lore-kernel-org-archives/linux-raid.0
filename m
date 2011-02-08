From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/6] FIX: compare blocks on all data disks
Date: Tue, 08 Feb 2011 14:31:01 +0100
Message-ID: <20110208133101.8787.581.stgit@gklab-128-013.igk.intel.com>
References: <20110208131046.8787.1777.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110208131046.8787.1777.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

blocks are counted for all data disks.
component_size value is given for one array disk only.
This means we should multiple component_size by data disks number
to get similar (compare able) values.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 6a9e81e..09d7439 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1829,7 +1829,8 @@ started:
 		fprintf(stderr, Name ": Need to backup %luK of critical "
 			"section..\n", blocks/2);
 
-	if (blocks >= sra->component_size) {
+	disks = min(reshape.before.data_disks, reshape.after.data_disks);
+	if (blocks >= sra->component_size * disks) {
 		fprintf(stderr, Name ": %s: Something wrong"
 			" - reshape aborted\n",
 			devname);

