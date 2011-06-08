From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 02/21] imsm: FIX: Opened handle is not closed
Date: Wed, 08 Jun 2011 18:09:49 +0200
Message-ID: <20110608160949.24327.29778.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Opened file handle should be closed before function exit.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 super-intel.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/super-intel.c b/super-intel.c
index 471dbd2..01ffcc8 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -8550,8 +8550,10 @@ int wait_for_reshape_imsm(struct mdinfo *sra, unsigned long long to_complete,
 		sysfs_set_str(sra, NULL, "sync_max", "max");
 		to_complete = MaxSector;
 	} else {
-		if (completed > to_complete)
+		if (completed > to_complete) {
+			close(fd);
 			return -1;
+		}
 		if (sysfs_set_num(sra, NULL, "sync_max",
 				  to_complete / ndata) != 0) {
 			close(fd);

