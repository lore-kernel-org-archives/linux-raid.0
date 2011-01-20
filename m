From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 3/4] FIX: monitor doesn't handshake with md
Date: Thu, 20 Jan 2011 11:57:38 +0100
Message-ID: <20110120105738.22926.26416.stgit@gklab-128-013.igk.intel.com>
References: <20110120104759.22926.66874.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110120104759.22926.66874.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

when in container are present raid0 and raid5 arrays, and reshape order is:
1. raid0 array
2. raid5 array

mdadm cannot set new raid_disks for raid0 array. For this action md has to have
handshake with mdmon. We have the following conditions:
1. Raid0 is not monitored
2. raid0 has been just takeovered to raid4/5 (it has to be monitored
3. monitor has to start monitor new raid4/5 array
4. monitor is not started (it is started to second raid5 array)
In such situation pig_monitor is required to let know to m monitor about new array
(not in the starting monitor case only)

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 23ef88e..717d087 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1662,8 +1662,8 @@ static int reshape_array(char *container, int fd, char *devname,
 	if (reshape.level > 0 && st->ss->external &&
 	    !mdmon_running(st->container_dev)) {
 		start_mdmon(st->container_dev);
-		ping_monitor(container);
 	}
+	ping_monitor(container);
 
 	/* ->reshape_super might have chosen some spares from the
 	 * container that it wants to be part of the new array.

