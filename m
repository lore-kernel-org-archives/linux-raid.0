From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 11/12] FIX: restart reshape when reshape process is stopped
	just between 2 reshapes
Date: Tue, 07 Feb 2012 15:04:23 +0100
Message-ID: <20120207140422.20627.53423.stgit@gklab-128-013.igk.intel.com>
References: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120207135940.20627.33309.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, marcin.labun@intel.com, dan.j.williams@intel.com, lukasz.dorau@intel.com
List-Id: linux-raid.ids

When reshape is restarted from '0', very begin of array
it is possible that for external metadata reshape and array
configuration doesn't happen.
Check if md has the same opinion, and reshape is restarted
from 0. If so, this is regular reshape start after reshape
switch in metadata to next array only.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 0668a16..553a49e 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1980,6 +1980,18 @@ static int reshape_array(char *container, int fd, char *devname,
 		goto release;
 	}
 
+	if (st->ss->external && restart && (info->reshape_progress == 0)) {
+		/* When reshape is restarted from '0', very begin of array
+		 * it is possible that for external metadata reshape and array
+		 * configuration doesn't happen.
+		 * Check if md has the same opinion, and reshape is restarted
+		 * from 0. If so, this is regular reshape start after reshape
+		 * switch in metadata to next array only.
+		 */
+		if ((verify_reshape_position(info, reshape.level) >= 0) &&
+		    (info->reshape_progress == 0))
+			restart = 0;
+	}
 	if (restart) {
 		/* reshape already started. just skip to monitoring the reshape */
 		if (reshape.backup_blocks == 0)

