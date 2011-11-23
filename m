From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [PATCH] imsm: fix, check all volumes state in Grow_continue function
Date: Wed, 23 Nov 2011 15:26:01 +0000
Message-ID: <F9123E44003394499FDD2B17C60621D40604F1@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The Grow_continue grows all volumes in the container that are in container
reshape state, therefore we  need to check blocking bits
of all volumes in container, not just the one that is pointed by the command
line argument.

Signed-off-by: Marcin Labun <marcin.labun@intel.com>
---
 Grow.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Grow.c b/Grow.c
index e7fd7c4..65aa851 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3769,18 +3769,19 @@ int Grow_continue_command(char *devname, int fd,
 			goto Grow_continue_command_exit;
 		}
 
-		cc = st->ss->container_content(st, subarray);
+		cc = st->ss->container_content(st, NULL);
 		for (content = cc; content ; content = content->next) {
 			char *array;
 			int allow_reshape = 1;
 
 			if (content->reshape_active == 0)
 				continue;
-			/* The decision about array or container wide
-			 * reshape is taken in Grow_continue based
-			 * content->reshape_active state, therefore we
-			 * need to check_reshape based on
-			 * reshape_active and subarray name
+			/* The Grow_continue grows all volumes
+			 * in the container that are in container
+			 * reshape state, 
+			 * therefore we  need to check blocking bits
+			 * of all volumes in container, not just the 
+			 * one that is pointed by command line argument.
 			 */
 			if (content->array.state & (1<<MD_SB_BLOCK_VOLUME))
 				allow_reshape = 0;
