From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 1/5] FIX: Unfreeze array if reshape_array wasn't succeded
Date: Mon, 24 Jan 2011 15:17:04 +0100
Message-ID: <20110124141704.16405.6081.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

If reshape_array does not success we should not leave
array freezed.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Grow.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index c5f83a8..7c5edae 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1567,7 +1567,10 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		sync_metadata(st);
 		rv = reshape_array(container, cfd, fd, devname,
 				   st, &info, force, backup_file, quiet, 0);
-		frozen = 0;
+		if (rv)
+			frozen = 1;
+		else
+			frozen = 0;
 	}
 release:
 	if (frozen > 0)

