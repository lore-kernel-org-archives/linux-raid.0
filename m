From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: reshape_active flag is always set for external metadata
Date: Thu, 20 Jan 2011 16:52:31 +0100
Message-ID: <20110120155231.9026.34311.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

For external metadata based on reshape_active flag is taken decision about reshape
when it is equal to 1. At this momenta mdadm cannot give up when this flag is set
for external metadata.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index c9f4b9c..f220f50 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1870,7 +1870,7 @@ started:
 
 	sra->new_chunk = info->new_chunk;
 	
-	if (info->reshape_active)
+	if ((info->reshape_active) && (st->ss->external == 0))
 		/* nothing needed here */;
 	else if (info->array.chunk_size == info->new_chunk &&
 	    reshape.before.layout == reshape.after.layout &&

