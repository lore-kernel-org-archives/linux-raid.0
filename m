From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 1/5] FIX: Spelling error in dprintf output
Date: Mon, 28 Feb 2011 16:07:03 +0100
Message-ID: <20110228150703.14670.18752.stgit@gklab-128-013.igk.intel.com>
References: <20110228145815.14670.56597.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110228145815.14670.56597.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index 424d489..e4fa196 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1648,7 +1648,7 @@ static int reshape_array(char *container, int fd, char *devname,
 		goto release;
 	}
 	if (ioctl(fd, GET_ARRAY_INFO, &array) != 0) {
-		dprintf("Canot get array information.\n");
+		dprintf("Cannot get array information.\n");
 		goto release;
 	}
 

