From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/5] FIX: Allow for takeover
Date: Tue, 08 Mar 2011 14:24:55 +0100
Message-ID: <20110308132455.9578.23227.stgit@gklab-128-013.igk.intel.com>
References: <20110308132228.9578.34611.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110308132228.9578.34611.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Takeover has to occur when md reports different raid level.
Previously it bases on information from metadata.
Now metadata reports 'working' level as array level.
This makes us to check it using information from md.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 88c8ad7..5c5a3a3 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1688,7 +1688,7 @@ static int reshape_array(char *container, int fd, char *devname,
 		goto release;
 	}
 
-	if (reshape.level != info->array.level) {
+	if (reshape.level != array.level) {
 		char *c = map_num(pers, reshape.level);
 		int err;
 		if (c == NULL)
@@ -1708,7 +1708,7 @@ static int reshape_array(char *container, int fd, char *devname,
 		if (!quiet)
 			fprintf(stderr, Name ": level of %s changed to %s\n",
 				devname, c);	
-		orig_level = info->array.level;
+		orig_level = array.level;
 		sysfs_freeze_array(info);
 
 		if (reshape.level > 0 && st->ss->external) {

