From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 08/13] FIX/WORKAROUND: added disks are not used by reshape
	process /md/
Date: Mon, 10 Jan 2011 12:28:32 +0100
Message-ID: <20110110112832.10776.61385.stgit@gklab-128-013.igk.intel.com>
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

md runs reshape but added disk is not touched
/proc/mdstat reports that disk is used.

To fix this let md to set slot for reshape.
It is possible that slot verification mechanism has to be added.

Second possibility is to investigate problem in md.
md/raid5 treats disks as spare with disk index == -1 during raid5 reshape_start.
Probably rqaid5 should treat as spare disks when disk index > used disks

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 0efa106..6b2889e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1697,6 +1697,7 @@ static int reshape_array(char *container, int fd, char *devname,
 					/* This is a spare that wants to
 					 * be part of the array.
 					 */
+					d->disk.raid_disk = -1;
 					add_disk(fd, st, info2, d);
 				}
 			}

