From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 5/5] FIX: Validate input in ping_manager function
Date: Mon, 24 Jan 2011 15:17:37 +0100
Message-ID: <20110124141737.16405.95572.stgit@gklab-128-111.igk.intel.com>
References: <20110124141704.16405.6081.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110124141704.16405.6081.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

For native case we do not have manager running so we have to
return without pinging.
Moreover we have NULL as input parameter. We should to avoid
segmentation fault.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 msg.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/msg.c b/msg.c
index b97ebec..2c770ab 100644
--- a/msg.c
+++ b/msg.c
@@ -432,7 +432,13 @@ void unblock_monitor(char *container, const int unfreeze)
  */
 int ping_manager(char *devname)
 {
-	int sfd = connect_monitor(devname);
+	int sfd;
+
+	if (!devname)
+		return -1;
+
+	sfd = connect_monitor(devname);
+
 	struct metadata_update msg = { .len = -1 };
 	int err = 0;
 

