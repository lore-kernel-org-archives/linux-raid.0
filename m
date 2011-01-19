From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 2/6] FIX: Ping manager after level change
Date: Wed, 19 Jan 2011 17:23:16 +0100
Message-ID: <20110119162316.8738.99467.stgit@gklab-128-111.igk.intel.com>
References: <20110119161925.8738.85284.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119161925.8738.85284.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Manager has to be informed about level change to refresh internal
structures.

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 Grow.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 0ce7c17..78d5b0e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1654,6 +1654,7 @@ static int reshape_array(char *container, int cfd, int fd, char *devname,
 	    !mdmon_running(st->container_dev)) {
 		start_mdmon(st->container_dev);
 	}
+	ping_manager(container);
 	ping_monitor(container);
 
 	if (reshape.backup_blocks == 0) {

