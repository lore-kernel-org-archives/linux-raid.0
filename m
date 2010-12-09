From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 16/29] Enable reshape for subarrays
Date: Thu, 09 Dec 2010 16:20:52 +0100
Message-ID: <20101209152052.26876.81590.stgit@gklab-170-024.igk.intel.com>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Reshape for subarrays is blocked in Grow.c due to lack of implementation.
This patch allows for subarray processing.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index dce7912..101eb8f 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1518,7 +1518,9 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		 * layout/chunksize/raid_disks can be changed
 		 * though the kernel may not support it all.
 		 */
-		if (subarray) {
+		if ((subarray) &&
+		    !(st->ss->external &&
+		      st->ss->reshape_super && st->ss->manage_reshape)) {
 			fprintf(stderr, Name ": Cannot reshape subarrays yet\n");
 			break;
 		}

