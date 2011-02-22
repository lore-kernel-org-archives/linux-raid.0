From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/3] FIX: Assemble device in reshape state with new disks
	number
Date: Tue, 22 Feb 2011 15:13:39 +0100
Message-ID: <20110222141339.7582.32666.stgit@gklab-128-013.igk.intel.com>
References: <20110222135440.7582.87319.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110222135440.7582.87319.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When expansion was interrupted, assembly should include all disks
in to new array. To do this delta_disks has to be added
to raid disks number.

When metadata reports all disks in content->array.raid_disks
then delta_disks should be equal to 0 (it is included in raid_disks already).

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Assemble.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 317be8b..8d89dbe 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1508,6 +1508,8 @@ int assemble_container_content(struct supertype *st, int mdfd,
 
 	sysfs_init(content, mdfd, 0);
 
+	if (content->reshape_active)
+		content->array.raid_disks += content->delta_disks;
 	sra = sysfs_read(mdfd, 0, GET_VERSION);
 	if (sra == NULL || strcmp(sra->text_version, content->text_version) != 0)
 		if (sysfs_set_array(content, md_get_version(mdfd)) != 0) {

