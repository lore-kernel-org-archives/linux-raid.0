From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 8/9] FIX: Block array monitoring when assembling reshaped array
Date: Wed, 02 Mar 2011 14:29:59 +0100
Message-ID: <20110302132959.24771.86346.stgit@gklab-128-013.igk.intel.com>
References: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110302132426.24771.99191.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

To allow for array reconfiguration, mdmon cannot push array in to active
state. Assemble should block monitor for external metadata to allow
for reshape configuration and restart.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index e65022c..8b4b037 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1532,6 +1532,11 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		if (sysfs_set_array(content, md_get_version(mdfd)) != 0)
 			return 1;
 		if (content->reshape_active) {
+
+			/* mdmon can activate array, so array has to be blocked
+			 */
+			block_subarray(content);
+
 			/* set 'new' array geometry parameters
 			 * to restart reshape
 			 * ToDo:
@@ -1545,6 +1550,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 					      content->delta_disks);
 		}
 	}
+
 	if (sra)
 		sysfs_free(sra);
 

