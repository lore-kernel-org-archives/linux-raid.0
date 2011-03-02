From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 4/9] imsm: FIX: After checkpoint mark array have to be clean
Date: Wed, 02 Mar 2011 14:29:27 +0100
Message-ID: <20110302132927.24771.39913.stgit@gklab-128-013.igk.intel.com>
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

When checkpoint is marked set volume as clean.
Reshape on dirty volume cannot be restarted from checkpoint.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 11972f3..04e32ae 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5218,6 +5218,7 @@ static int imsm_set_array_state(struct active_array *a, int consistent)
 				    __le32_to_cpu(dev->vol.curr_migr_unit)) {
 					dev->vol.curr_migr_unit =
 						__cpu_to_le32(unit);
+					dev->vol.dirty = 0;
 					super->updates_pending++;
 				}
 			}

