From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 10/27] imsm: Do not indicate resync during reshape
Date: Mon, 06 Dec 2010 14:22:04 +0100
Message-ID: <20101206132204.21125.12958.stgit@gklab-170-024.igk.intel.com>
References: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
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
index b78baa0..62c4245 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4702,9 +4702,13 @@ static int is_resyncing(struct imsm_dev *dev)
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

