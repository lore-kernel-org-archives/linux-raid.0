From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 11/13] FIX/WORKAROUND: Arrays cannot be opened exclusively
Date: Mon, 10 Jan 2011 12:28:56 +0100
Message-ID: <20110110112856.10776.88392.stgit@gklab-128-013.igk.intel.com>
References: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110110950.10776.75218.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

During container operation arrays cannot be opened exclusively.
Use open_dev() instead.

On mdadm processing begin this is possible but when array_reshape() tries to do it,
it is not possible. I've found that there is no other opens in mdadm so it is caused
/possible/ by mdmon interaction.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index f083ba5..74ec429 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2186,7 +2186,7 @@ int reshape_container(char *container, int cfd, char *devname,
 		if (!content)
 			break;
 
-		fd = open_dev_excl(mdstat->devnum);
+		fd = open_dev(mdstat->devnum);
 		if (fd < 0)
 			break;
 		adev = map_dev(dev2major(mdstat->devnum),

