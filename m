From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 16/34] FIX: Use sysfs to change array parameters
Date: Tue, 04 Jan 2011 15:37:44 +0100
Message-ID: <20110104143744.6697.33884.stgit@gklab-128-013.igk.intel.com>
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

For external metadata parameters has to be changed via sysfs.
i.e. change of raid_disks requires handshake mdmon<->md (md_allow_write())

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index c72b89f..dae9bbf 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1896,7 +1896,8 @@ static int reshape_array(char *container, int fd, char *devname,
 	sync_metadata(st);
 
 	if (info->array.chunk_size == info->new_chunk &&
-	    reshape.before.layout == reshape.after.layout) {
+	    reshape.before.layout == reshape.after.layout &&
+	    st->ss->external == 0) {
 		array.raid_disks = reshape.after.raid_disks;
 		if (ioctl(fd, SET_ARRAY_INFO, &array) != 0) {
 			int err = errno;

