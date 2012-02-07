From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 09/12] imsm: FIX: use md position to reshape restart
Date: Tue, 07 Feb 2012 15:04:07 +0100
Message-ID: <20120207140407.20627.38227.stgit@gklab-128-013.igk.intel.com>
References: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

When reshape is broken it can occur that metadata is not saved properly.
This can cause that reshape process is farther in md than metadata states.

On restart save checkpoint to store current position /probably farther/
that can be read from md.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index f5762d8..5f451f3 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -10067,6 +10067,18 @@ static int imsm_manage_reshape(
 				"are present in copy area.\n");
 			goto abort;
 		}
+		/* Save checkpoint to update migration record for current
+		 * reshape position (in md). It can be farther than current
+		 * reshape position in metadata.
+		 */
+		if (save_checkpoint_imsm(st, sra, UNIT_SRC_NORMAL) == 1) {
+			/* ignore error == 2, this can mean end of reshape here
+			 */
+			dprintf("imsm: Cannot write checkpoint to "
+				"migration record (UNIT_SRC_NORMAL, "
+				"initial save)\n");
+			goto abort;
+		}
 	}
 
 	/* size for data */

