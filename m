From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 32/34] Raid0: Run 'next' reshapes without meta update
Date: Tue, 04 Jan 2011 15:39:50 +0100
Message-ID: <20110104143950.6697.45660.stgit@gklab-128-013.igk.intel.com>
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

For metadatas that container operation requires set of arrays operations
for 2nd (and next) arrays in raid0 case reshape_array() is executed before
array is monitored and before metadat update is stored,
because in such case mdmon updates metadata via set_array_state().

for such cases some of parameters (i.e. delta_disks) should be used from input parameters,
instead from metadata.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index c88df1b..4d12eda 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2128,6 +2128,7 @@ int reshape_container(char *container, int cfd, char *devname,
 {
 	struct mdinfo *cc;
 	struct mdinfo *cc_fresh = NULL;
+	int delta_disks = 0;
 
 	if (reshape_super(st, info->component_size, info->new_level,
 			  info->new_layout, info->new_chunk,
@@ -2184,6 +2185,10 @@ int reshape_container(char *container, int cfd, char *devname,
 		sysfs_free(cc_fresh);
 		st->ss->load_container(st, cfd, NULL);
 		cc_fresh = st->ss->container_content(st, subarray);
+		if (delta_disks && cc_fresh->array.level == 0) {
+			cc_fresh->delta_disks = delta_disks;
+		} else
+			delta_disks = cc_fresh->delta_disks;
 		rv = reshape_array(container, fd, adev, st,
 				   cc_fresh, force,
 				   backup_file, quiet, 1);

