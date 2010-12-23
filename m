From: Przemyslaw Czarnowski
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: [PATCH 4/5] Validate size of potential spare disk for external
	metadata (with containers)
Date: Thu, 23 Dec 2010 17:04:12 +0100
Message-ID: <20101223160412.5562.38031.stgit@gklab-170-211.igk.intel.com>
References: <20101223155614.5562.4773.stgit@gklab-170-211.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101223155614.5562.4773.stgit@gklab-170-211.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

mdinfo read with sysfs_read do not contain information about the space
needed to store data of all volumes created in that container, so that
spare can be used as replacement for existing subarrays in the future.
---
 Incremental.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 8d9f825..e022506 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -890,6 +890,7 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 		struct domainlist *dl = NULL;
 		struct mdinfo *sra;
 		unsigned long long devsize;
+		unsigned long long component_size;
 
 		if (is_subarray(mp->metadata))
 			continue;
@@ -948,7 +949,23 @@ static int array_try_spare(char *devname, int *dfdp, struct dev_policy *pol,
 			sra->array.failed_disks = container_members_max_degradation(map, mp);
 
 		get_dev_size(dfd, NULL, &devsize);
-		if (st2->ss->avail_size(st2, devsize) < sra->component_size) {
+		if (sra->component_size == 0) {
+			/* true for containers, here we must read superblock
+			 * to obtain minimum spare size */
+			struct supertype *st3 = dup_super(st2);
+			int mdfd = open_dev(mp->devnum);
+			if (!mdfd)
+				goto next;
+			if (st3->ss->load_container &&
+			    !st3->ss->load_container(st3, mdfd, mp->path)) {
+				component_size = st3->ss->min_acceptable_spare_size(st3);
+				st3->ss->free_super(st3);
+			}
+			free(st3);
+			close(mdfd);
+		}
+		if ((sra->component_size > 0 && st2->ss->avail_size(st2, devsize) < sra->component_size) ||
+		    (sra->component_size == 0 && devsize < component_size)) {
 			if (verbose > 1)
 				fprintf(stderr, Name ": not adding %s to %s as it is too small\n",
 					devname, mp->path);

