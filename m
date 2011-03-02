From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH] Enable error message in case of lack of spares for grow
Date: Wed, 02 Mar 2011 17:33:01 +0100
Message-ID: <20110302163301.5135.68810.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

When we cannot find spare devices for grow operation we should
print error message.
This patch changes debug error message to 'stderr' print.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 5b09bc5..fde29b8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7112,7 +7112,8 @@ static int imsm_create_metadata_update_for_reshape(
 
 	if (spares == NULL
 	    || delta_disks > spares->array.spare_disks) {
-		dprintf("imsm: ERROR: Cannot get spare devices.\n");
+		fprintf(stderr, Name ": imsm: ERROR: Cannot get spare devices "
+			"for %s.\n", geo->dev_name);
 		goto abort;
 	}
 

