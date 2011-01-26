From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 6/7] FIX: Container can be left frozen
Date: Wed, 26 Jan 2011 16:03:57 +0100
Message-ID: <20110126150357.20454.17796.stgit@gklab-128-013.igk.intel.com>
References: <20110126145632.20454.20432.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110126145632.20454.20432.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When for container operation reshape_super() fails child process
is not started so it cannot unfreeze container.
Grow_reshape() doesn't unfreeze container also.
For fix problem frozen variable can be cleaned when reshape_container()
returns success status only.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 8b9625d..dae1b32 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1554,7 +1554,8 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 */
 		rv = reshape_container(container, fd, devname, st, &info,
 				       force, backup_file, quiet);
-		frozen = 0;
+		if (rv == 0)
+			frozen = 0;
 	} else {
 		/* Impose these changes on a single array.  First
 		 * check that the metadata is OK with the change. */

