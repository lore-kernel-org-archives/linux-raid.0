From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 03/34] FIX: Position calculation in mdstat_by_subdev
Date: Tue, 04 Jan 2011 15:36:02 +0100
Message-ID: <20110104143602.6697.39390.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---

 mdstat.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mdstat.c b/mdstat.c
index bac3742..3d2edad 100644
--- a/mdstat.c
+++ b/mdstat.c
@@ -399,9 +399,9 @@ struct mdstat_ent *mdstat_by_subdev(char *subdev, int container)
 		    strncmp(mdstat->metadata_version, "external:", 9) == 0 &&
 		    strchr("/-", mdstat->metadata_version[9]) != NULL &&
 		    strncmp(mdstat->metadata_version+10, "md", 2) == 0 &&
-		    strtoul(mdstat->metadata_version+11, &pos, 10)
+		    strtoul(mdstat->metadata_version+12, &pos, 10)
 		    == (unsigned)container &&
-		    pos > mdstat->metadata_version+11 &&
+		    pos > mdstat->metadata_version+12 &&
 		    *pos == '/' &&
 		    strcmp(pos+1, subdev) == 0
 			) {

