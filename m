From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 14/34] FIX: change adding disks criteria
Date: Tue, 04 Jan 2011 15:37:28 +0100
Message-ID: <20110104143728.6697.34924.stgit@gklab-128-013.igk.intel.com>
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

Some of disks tried to add are array member already.
New disks should be added only.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index 6dbc3b7..9801a45 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1696,8 +1696,8 @@ static int reshape_array(char *container, int fd, char *devname,
 
 		if (info2)
 			for (d = info2->devs; d; d = d->next) {
-				if (d->disk.state == 0 &&
-				    d->disk.raid_disk >= 0) {
+				if (d->disk.raid_disk >=
+				    reshape.before.raid_disks) {
 					/* This is a spare that wants to
 					 * be part of the array.
 					 */

