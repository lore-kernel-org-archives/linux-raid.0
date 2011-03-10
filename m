From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH] FIX: Unfreeze array on success only
Date: Thu, 10 Mar 2011 08:30:42 +0100
Message-ID: <20110310073041.6824.46696.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Unfreeze array on success only.
rv is initialized by restart variable so we have 2 cases.
1. regular reshape start
	rv == restart == 0
   this means that real error (returned by reshape) can cause leaving container frozen
   If array is not touched by reshape it can be unfrozen
2. During reshape restart even untouched array under reshape is left unfrozen,
   If reshape is started do not unfreeze array on error also.

This allows user for array repair action
(mdmon will not change array state).

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index d596c2d..fa6f50a 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2175,6 +2175,7 @@ int reshape_container(char *container, char *devname,
 		      int quiet, int restart)
 {
 	struct mdinfo *cc = NULL;
+	int rv = restart;
 
 	/* component_size is not meaningful for a container,
 	 * so pass '-1' meaning 'no change'
@@ -2219,7 +2220,6 @@ int reshape_container(char *container, char *devname,
 		 * will take over the reshape.
 		 */
 		struct mdinfo *content;
-		int rv;
 		int fd;
 		struct mdstat_ent *mdstat;
 		char *adev;
@@ -2262,7 +2262,8 @@ int reshape_container(char *container, char *devname,
 		if (rv)
 			break;
 	}
-	unfreeze(st);
+	if (!rv)
+		unfreeze(st);
 	sysfs_free(cc);
 	exit(0);
 }

