From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 11/34] FIX: Arrays cannot be opened exclusively
Date: Tue, 04 Jan 2011 15:37:05 +0100
Message-ID: <20110104143705.6697.92373.stgit@gklab-128-013.igk.intel.com>
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

During container operation arrays cannot be opened exclusively.
Use open_dev() instead.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 5d73365..c568a55 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2128,7 +2128,7 @@ int reshape_container(char *container, int cfd, char *devname,
 
 		if (!mdstat)
 			continue;
-		fd = open_dev_excl(mdstat->devnum);
+		fd = open_dev(mdstat->devnum);
 		if (fd < 0)
 			break;
 		adev = map_dev(dev2major(mdstat->devnum),

