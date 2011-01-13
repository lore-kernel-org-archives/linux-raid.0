From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 6/6] raid0->raid10 takeover- allocate memory for added disks
Date: Thu, 13 Jan 2011 16:33:09 +0100
Message-ID: <20110113153308.20266.32688.stgit@gklab-128-111.igk.intel.com>
References: <20110113152722.20266.24174.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110113152722.20266.24174.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Allocate memory necessary to add new dummy disks
in process_update.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 super-intel.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 63bd2d2..a7d7d08 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -6224,6 +6224,24 @@ static void imsm_prepare_update(struct supertype *st,
 	size_t len = 0;
 
 	switch (type) {
+	case update_takeover: {
+		struct imsm_update_takeover *u = (void *)update->buf;
+		if (u->direction == R0_TO_R10) {
+			void **tail = (void**)&update->space_list;
+			void *space;
+			int size = sizeof_imsm_dev(super->devlist->dev, 0) +
+				(TAKEOVER_DISKS * sizeof(__u32));
+			space = malloc(size);
+			if (!space)
+				break;
+			*tail = space;
+			tail = space;
+			*tail = NULL;
+
+			len = disks_to_mpb_size(TAKEOVER_DISKS * 2);
+		}
+		break;
+	}
 	case update_reshape_container_disks: {
 		/* Every raid device in the container is about to
 		 * gain some more devices, and we will enter a

