From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 12/13] FIX: parity disks use for redundant levels only
Date: Mon, 10 Jan 2011 12:29:04 +0100
Message-ID: <20110110112904.10776.88816.stgit@gklab-128-013.igk.intel.com>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

For raid0 reshape spares should not be increased by parity disk.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 74ec429..9d31087 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1637,7 +1637,9 @@ static int reshape_array(char *container, int fd, char *devname,
 	}
 	spares_needed = max(reshape.before.data_disks,
 			    reshape.after.data_disks)
-		+ reshape.parity - array.raid_disks;
+			    - array.raid_disks;
+	if (info->array.level != 0)
+		spares_needed += reshape.parity;
 
 	if (!force && spares_needed < info->array.spare_disks) {
 		fprintf(stderr,

