From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 12/12] FIX: Do not try to (continue) reshape using inactive
	array
Date: Tue, 07 Feb 2012 15:04:31 +0100
Message-ID: <20120207140430.20627.67474.stgit@gklab-128-013.igk.intel.com>
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

When one of arrays is inactive, do not try to continue reshape
on this array. Just skip it.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 553a49e..e295a5f 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2626,6 +2626,13 @@ int reshape_container(char *container, char *devname,
 						  devname2devnum(container));
 			if (!mdstat)
 				continue;
+			if (mdstat->active == 0) {
+				fprintf(stderr, Name ": Skipping inactive "
+					"array md%i.\n", mdstat->devnum);
+				free_mdstat(mdstat);
+				mdstat = NULL;
+				continue;
+			}
 			break;
 		}
 		if (!content)
@@ -3922,6 +3929,13 @@ int Grow_continue_command(char *devname, int fd,
 			mdstat = mdstat_by_subdev(array, container_dev);
 			if (!mdstat)
 				continue;
+			if (mdstat->active == 0) {
+				fprintf(stderr, Name ": Skipping inactive "
+					"array md%i.\n", mdstat->devnum);
+				free_mdstat(mdstat);
+				mdstat = NULL;
+				continue;
+			}
 			break;
 		}
 		if (!content) {

