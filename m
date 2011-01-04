From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 15/34] FIX: added disks are not used by reshape process /md/
Date: Tue, 04 Jan 2011 15:37:36 +0100
Message-ID: <20110104143736.6697.38260.stgit@gklab-128-013.igk.intel.com>
References: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110104143240.6697.52355.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

md runs reshape but added disk is not touched
/proc/mdstat reports that disk is used.

To fix this let md to set slot for reshape.
It is possible that slot verification mechanism has to be added.
Second possibility is to investigate problem in md

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 9801a45..c72b89f 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1701,6 +1701,7 @@ static int reshape_array(char *container, int fd, char *devname,
 					/* This is a spare that wants to
 					 * be part of the array.
 					 */
+					d->disk.raid_disk = -1;
 					add_disk(fd, st, info2, d);
 				}
 			}

