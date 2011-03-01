From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 6/7] Continue reshape after assembling array
Date: Tue, 01 Mar 2011 15:57:31 +0100
Message-ID: <20110301145731.10678.17428.stgit@gklab-128-013.igk.intel.com>
References: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110301144932.10678.20916.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

assemble_container_content() cannot close mdfd handle, as it could be
required by reshape continuation.
mdfd handle is closed outside this function, when it is not longer necessary.
Call to Grow_continue is added for reshape continuation after assembly.

In the nearest future, simple condition:
    if (content->reshape_active)
before Grow_continue() call will be replaced by check function
for support container operation /reshape/.
Additional call to the same check function will be added inside Grow_continue()
after fork command, to find out if reshape pointed by metadata applies to current array
or we should wait for it (another array is under reshape).

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>

Conflicts:

	Assemble.c
---

 Assemble.c    |   32 ++++++++++++++++++++------------
 Incremental.c |    1 +
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 9d17a57..c3d8914 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -696,8 +696,21 @@ int Assemble(struct supertype *st, char *mddev,
 #ifndef MDASSEMBLE
 	if (content != &info) {
 		/* This is a member of a container.  Try starting the array. */
-		return assemble_container_content(st, mdfd, content, runstop,
-					   chosen_name, verbose);
+		int err;
+		err = assemble_container_content(st, mdfd, content, runstop,
+						 chosen_name, verbose);
+		if (!err) {
+			/* check if reshape of external metadata
+			 * is in progress
+			 * and it is need to be monitored by mdadm
+			 */
+			if (content->reshape_active)
+				err = Grow_continue(mdfd, st, content,
+						    backup_file);
+		}
+		close(mdfd);
+
+		return err;
 	}
 #endif
 	/* Ok, no bad inconsistancy, we can try updating etc */
@@ -1518,10 +1531,9 @@ int assemble_container_content(struct supertype *st, int mdfd,
 			 */
 			sysfs_set_num(content, NULL, "sync_max", 0);
 		}
-		if (sysfs_set_array(content, md_get_version(mdfd)) != 0) {
-			close(mdfd);
+		if (sysfs_set_array(content, md_get_version(mdfd)) != 0)
 			return 1;
-		}
+
 		if (content->reshape_active) {
 			/* set the current checkpoint to allow monitoring to
 			 * restart reshape
@@ -1543,11 +1555,9 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		else if (dev->disk.raid_disk >= content->array.raid_disks &&
 			  content->reshape_active)
 			expansion++;
-	if (working == 0) {
-		close(mdfd);
+	if (working == 0)
 		return 1;/* Nothing new, don't try to start */
-	}
-	
+
 	map_update(&map, fd2devnum(mdfd),
 		   content->text_version,
 		   content->uuid, chosen_name);
@@ -1608,8 +1618,7 @@ int assemble_container_content(struct supertype *st, int mdfd,
 		}
 		if (!err)
 			wait_for(chosen_name, mdfd);
-		close(mdfd);
-		return 0;
+		return err;
 		/* FIXME should have an O_EXCL and wait for read-auto */
 	} else {
 		if (verbose >= 0)
@@ -1617,7 +1626,6 @@ int assemble_container_content(struct supertype *st, int mdfd,
 				": %s assembled with %d devices but "
 				"not started\n",
 				chosen_name, working);
-		close(mdfd);
 		return 1;
 	}
 }
diff --git a/Incremental.c b/Incremental.c
index 4c4b0c7..91359f4 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -1556,6 +1556,7 @@ static int Incremental_container(struct supertype *st, char *devname,
 
 		assemble_container_content(st, mdfd, ra, runstop,
 					   chosen_name, verbose);
+		close(mdfd);
 	}
 
 	/* Now move all suitable spares from spare container */

