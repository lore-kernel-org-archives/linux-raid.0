From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 03/12] FIX: Array is not run when expansion disks are added
Date: Tue, 07 Feb 2012 15:03:19 +0100
Message-ID: <20120207140319.20627.93540.stgit@gklab-128-013.igk.intel.com>
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

When added disk is disk added by expansion and this is last disk added
to array, assemble_container_content() will not even try to run such array.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index ad4eb9c..13adfc3 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1557,7 +1557,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 				working++;
 		} else if (errno == EEXIST)
 			preexist++;
-	if (working == 0)
+	if (working + expansion == 0)
 		return 1;/* Nothing new, don't try to start */
 
 	map_update(&map, fd2devnum(mdfd),

