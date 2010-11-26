From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 28/53] imsm: Do not indicate resync during reshape
Date: Fri, 26 Nov 2010 09:07:31 +0100
Message-ID: <20101126080731.5221.83421.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

If reshape is started resync is not allowed in parallel. This would break reshape.
If array is in General Migration state do not indicate resync and allow for reshape continuation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 2984685..42219f6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4677,9 +4677,13 @@ static int is_resyncing(struct imsm_dev *dev)
 	    migr_type(dev) == MIGR_REPAIR)
 		return 1;
 
+	if (migr_type(dev) == MIGR_GEN_MIGR)
+		return 0;
+
 	migr_map = get_imsm_map(dev, 1);
 
-	if (migr_map->map_state == IMSM_T_STATE_NORMAL)
+	if ((migr_map->map_state == IMSM_T_STATE_NORMAL) &&
+	    (dev->vol.migr_type != MIGR_GEN_MIGR))
 		return 1;
 	else
 		return 0;

