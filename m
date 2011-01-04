From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 30/34] Raid0: execute backward takeover
Date: Tue, 04 Jan 2011 15:39:34 +0100
Message-ID: <20110104143934.6697.81006.stgit@gklab-128-013.igk.intel.com>
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

After raid0 reshape is finished backward takeover has to be executed.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 3814579..c88df1b 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2072,8 +2072,8 @@ static int reshape_array(char *container, int fd, char *devname,
 					sysfs_free(info2);
 				}
 			}
-
-			if (info->new_level != info->array.level) {
+			if ((info->new_level != info->array.level) ||
+			    ((info->new_level == 0) && (orig_level == 0))) {
 				/* We need to wait for the reshape to finish
 				* (which will have happened unless
 				 * odata < ndata) and then set the level

