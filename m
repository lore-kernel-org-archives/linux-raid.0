From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 8/9] FIX: container has to be frozen during reshape
Date: Tue, 11 Jan 2011 15:04:52 +0100
Message-ID: <20110111140451.13862.24555.stgit@gklab-128-013.igk.intel.com>
References: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111135227.13862.88465.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Parent process unfreezes container when reshape was forked.
Container has to be frozen during entire reshape for container case.
Based on reshape flag "next array" reshape decision is taken also.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 6238eb3..29a78a6 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1579,6 +1579,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 */
 		rv = reshape_container(container, fd, devname, st, &info,
 				       force, backup_file, quiet);
+		frozen = rv;
 	} else {
 		/* Impose these changes on a single array.  First
 		 * check that the metadata is OK with the change. */
@@ -2201,6 +2202,9 @@ int reshape_container(char *container, int cfd, char *devname,
 			break;
 	}
 	sysfs_free(cc);
+
+	unfreeze(st, 1);
+
 	exit(0);
 }
 

