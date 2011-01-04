From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 09/34] FIX: get updated information from metadata
Date: Tue, 04 Jan 2011 15:36:49 +0100
Message-ID: <20110104143649.6697.20310.stgit@gklab-128-013.igk.intel.com>
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

Metadata is not modified by metadata preparation handler.
It has to be read again from array.
There is 2 read required:
1. before 'for' entry to get updated information after reshape_super() call
2. inside 'for' loop to get updated information for every processed array
  (it can happen /i.e. imsm case/ that container operation is a set of array operations
   and information in metadata is changed after every loop).

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 9e0a51d..5d73365 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2083,6 +2083,8 @@ int reshape_container(char *container, int cfd, char *devname,
 		      int quiet)
 {
 	struct mdinfo *cc;
+	struct mdinfo *cc_fresh = NULL;
+
 	if (reshape_super(st, info->component_size, info->new_level,
 			  info->new_layout, info->new_chunk,
 			  info->array.raid_disks + info->delta_disks,
@@ -2091,6 +2093,14 @@ int reshape_container(char *container, int cfd, char *devname,
 
 	sync_metadata(st);
 
+	/* ping monitor to be sure that update is on disk
+	 */
+	ping_monitor(container);
+
+	/* reload metadata to get updated information
+	 */
+	st->ss->load_container(st, cfd, NULL);
+
 	cc = st->ss->container_content(st, NULL);
 
 	if (!cc)
@@ -2106,7 +2116,6 @@ int reshape_container(char *container, int cfd, char *devname,
 	case 0: /* child */
 		break;
 	}
-
 	/* For each member array, we need to perform the reshape */
 	for (; cc; cc = cc->next) {
 		int rv;
@@ -2128,12 +2137,18 @@ int reshape_container(char *container, int cfd, char *devname,
 		if (!adev)
 			adev = cc->text_version;
 
-		rv = reshape_array(container, fd, adev, st, cc, force,
+		sysfs_free(cc_fresh);
+		st->ss->load_container(st, cfd, NULL);
+		cc_fresh = st->ss->container_content(st, subarray);
+		rv = reshape_array(container, fd, adev, st,
+				   cc_fresh, force,
 				   backup_file, quiet, 1);
 		close(fd);
 		if (rv)
 			break;
 	}
+	sysfs_free(cc_fresh);
+	sysfs_free(cc);
 	exit(0);
 }
 

