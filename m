From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/4] FIX: External metadata sometimes is not updated
Date: Thu, 12 Jan 2012 08:12:39 +0100
Message-ID: <20120112071239.5168.24015.stgit@gklab-128-013.igk.intel.com>
References: <20120112070822.5168.97729.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120112070822.5168.97729.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com
List-Id: linux-raid.ids

External metadata sometimes is not updated.
It can be observed during 2 raid0 arrays Capacity Expansion.
New array size is not set, because metadata is not updated and on the reshape
end mdadm doesn't read new array size from metadata.
This happens when mdmon finishes his work (due to takeover to raid0),
before all metadata updates are processed.

Make sure that all updates are flushed to disk before executing takeover.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index f0422d2..061ddf1 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2396,6 +2396,7 @@ started:
 		/* Re-load the metadata as much could have changed */
 		int cfd = open_dev(st->container_dev);
 		if (cfd >= 0) {
+			ping_manager(container);
 			ping_monitor(container);
 			st->ss->free_super(st);
 			st->ss->load_container(st, cfd, container);

