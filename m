From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 17/21] imsm: FIX: Do not continue reshape when backup exists
Date: Wed, 08 Jun 2011 18:11:50 +0200
Message-ID: <20110608161150.24327.96596.stgit@gklab-128-013.igk.intel.com>
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

When backup exists in copy area reshape cannot be continued.
In such situation, array is in unstable state.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2dd73c0..25e706f 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8745,6 +8745,13 @@ static int imsm_manage_reshape(
 	/* initialize migration record for start condition */
 	if (sra->reshape_progress == 0)
 		init_migr_record_imsm(st, dev, sra);
+	else {
+		if (__le32_to_cpu(migr_rec->rec_status) != UNIT_SRC_NORMAL) {
+			dprintf("imsm: cannot restart migration when data "
+				"are present in copy area.\n");
+			goto abort;
+		}
+	}
 
 	/* size for data */
 	buf_size = __le32_to_cpu(migr_rec->blocks_per_unit) * 512;

