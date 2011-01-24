From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 4/5] FIX: Validate input in ping_monitor function
Date: Mon, 24 Jan 2011 15:17:29 +0100
Message-ID: <20110124141728.16405.6921.stgit@gklab-128-111.igk.intel.com>
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

For native case we do not have monitor running so we have to
return without pinging.
Moreover we have NULL as input parameter. We should to avoid
segmentation fault.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 msg.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/msg.c b/msg.c
index 76e74e7..b97ebec 100644
--- a/msg.c
+++ b/msg.c
@@ -206,8 +206,13 @@ int fping_monitor(int sfd)
 /* give the monitor a chance to update the metadata */
 int ping_monitor(char *devname)
 {
-	int sfd = connect_monitor(devname);
-	int err = fping_monitor(sfd);
+	int sfd, err;
+
+	if (!devname)
+		return -1;
+
+	sfd = connect_monitor(devname);
+	err = fping_monitor(sfd);
 
 	close(sfd);
 	return err;

