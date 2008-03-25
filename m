From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 5/8] Fix typo in array_state comment.
Date: Tue, 25 Mar 2008 22:00:53 +0100
Message-ID: <S1752358AbYGGIdw/20080707083352Z+1940@vger.kernel.org>
References: <20080707075532.GA32617@skl-net.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080707075532.GA32617@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 857af03..cdc381f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2512,7 +2512,7 @@ __ATTR(resync_start, S_IRUGO|S_IWUSR, resync_start_show, resync_start_store);
  *     When written, doesn't tear down array, but just stops it
  * suspended (not supported yet)
  *     All IO requests will block. The array can be reconfigured.
- *     Writing this, if accepted, will block until array is quiessent
+ *     Writing this, if accepted, will block until array is quiescent
  * readonly
  *     no resync can happen.  no superblocks get written.
  *     write requests fail
-- 
1.5.3.8

